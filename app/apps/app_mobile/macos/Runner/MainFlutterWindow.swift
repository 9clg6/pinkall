import AVFoundation
import Cocoa
import CoreMedia
import FlutterMacOS
import ScreenCaptureKit

class MainFlutterWindow: NSWindow {
  private var callAudioCapturePlugin: PinkallCallAudioCapturePlugin?

  override func awakeFromNib() {
    PinkallKeychainBootstrap.bootstrap()

    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    let callAudioCapturePlugin = PinkallCallAudioCapturePlugin(
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    callAudioCapturePlugin.register()
    self.callAudioCapturePlugin = callAudioCapturePlugin

    super.awakeFromNib()
  }
}

/// Flutter bridge for separate memory-only system and microphone PCM streams.
private final class PinkallCallAudioCapturePlugin: NSObject {
  private static let methodChannelName = "com.pinkall.call_audio_capture/methods"
  private static let systemAudioChannelName =
    "com.pinkall.call_audio_capture/system_audio"
  private static let microphoneAudioChannelName =
    "com.pinkall.call_audio_capture/microphone_audio"

  private let methodChannel: FlutterMethodChannel
  private let systemAudioChannel: FlutterEventChannel
  private let microphoneAudioChannel: FlutterEventChannel
  private let systemAudioEvents = PinkallAudioEventStreamHandler()
  private let microphoneAudioEvents = PinkallAudioEventStreamHandler()
  private var pendingStartToken: UUID?
  private var activeSession: AnyObject?

  init(binaryMessenger: FlutterBinaryMessenger) {
    methodChannel = FlutterMethodChannel(
      name: Self.methodChannelName,
      binaryMessenger: binaryMessenger
    )
    systemAudioChannel = FlutterEventChannel(
      name: Self.systemAudioChannelName,
      binaryMessenger: binaryMessenger
    )
    microphoneAudioChannel = FlutterEventChannel(
      name: Self.microphoneAudioChannelName,
      binaryMessenger: binaryMessenger
    )
    super.init()
  }

  func register() {
    systemAudioChannel.setStreamHandler(systemAudioEvents)
    microphoneAudioChannel.setStreamHandler(microphoneAudioEvents)
    methodChannel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "start":
      start(call.arguments, result: result)
    case "stop":
      stop(result: result)
    case "cancel":
      cancel(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func start(_ arguments: Any?, result: @escaping FlutterResult) {
    guard #available(macOS 15.0, *) else {
      result(
        FlutterError(
          code: "unsupported_os",
          message: "Separate ScreenCaptureKit microphone capture requires macOS 15 or later.",
          details: nil
        )
      )
      return
    }
    guard activeSession == nil, pendingStartToken == nil else {
      result(
        FlutterError(
          code: "capture_already_running",
          message: "A call-audio capture session is already active.",
          details: nil
        )
      )
      return
    }
    guard
      let values = arguments as? [String: Any],
      let sampleRate = values["sampleRate"] as? Int,
      PinkallPcm16Converter.supportedSampleRates.contains(sampleRate)
    else {
      result(
        FlutterError(
          code: "invalid_arguments",
          message: "sampleRate must be a supported integer speech sample rate.",
          details: nil
        )
      )
      return
    }

    let token = UUID()
    pendingStartToken = token
    Task { @MainActor [weak self] in
      guard let self else { return }
      do {
        try await PinkallCapturePermissions.request()
        guard self.pendingStartToken == token else {
          throw PinkallCallAudioCaptureError.startCancelled
        }

        let sessionID = UUID()
        let session = PinkallScreenCaptureAudioSession(
          id: sessionID,
          targetSampleRate: Double(sampleRate),
          systemAudioEvents: self.systemAudioEvents,
          microphoneAudioEvents: self.microphoneAudioEvents,
          onUnexpectedStop: { [weak self] id, error in
            DispatchQueue.main.async {
              self?.handleUnexpectedStop(sessionID: id, error: error)
            }
          }
        )
        try await session.start()
        guard self.pendingStartToken == token else {
          await session.cancel()
          throw PinkallCallAudioCaptureError.startCancelled
        }

        self.pendingStartToken = nil
        self.activeSession = session
        result(nil)
      } catch {
        if self.pendingStartToken == token {
          self.pendingStartToken = nil
        }
        result(PinkallCallAudioCaptureError.flutterError(from: error))
      }
    }
  }

  private func stop(result: @escaping FlutterResult) {
    guard #available(macOS 15.0, *) else {
      result(PinkallCallAudioCaptureError.unsupportedOS.flutterError)
      return
    }
    guard let session = activeSession as? PinkallScreenCaptureAudioSession else {
      result(
        FlutterError(
          code: "capture_not_running",
          message: "No call-audio capture session is active.",
          details: nil
        )
      )
      return
    }
    activeSession = nil
    Task { @MainActor in
      do {
        try await session.stop()
        result(nil)
      } catch {
        result(PinkallCallAudioCaptureError.flutterError(from: error))
      }
    }
  }

  private func cancel(result: @escaping FlutterResult) {
    pendingStartToken = nil
    guard #available(macOS 15.0, *) else {
      activeSession = nil
      result(nil)
      return
    }
    guard let session = activeSession as? PinkallScreenCaptureAudioSession else {
      activeSession = nil
      result(nil)
      return
    }
    activeSession = nil
    Task { @MainActor in
      await session.cancel()
      result(nil)
    }
  }

  private func handleUnexpectedStop(sessionID: UUID, error: Error) {
    guard #available(macOS 15.0, *) else { return }
    guard
      let session = activeSession as? PinkallScreenCaptureAudioSession,
      session.id == sessionID
    else {
      return
    }
    activeSession = nil
    let flutterError = FlutterError(
      code: "capture_stopped",
      message: "ScreenCaptureKit stopped call-audio capture unexpectedly.",
      details: String(describing: type(of: error))
    )
    systemAudioEvents.emit(error: flutterError)
    microphoneAudioEvents.emit(error: flutterError)
  }
}

/// Keeps EventChannel access on the main queue while capture runs elsewhere.
private final class PinkallAudioEventStreamHandler: NSObject, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?

  func onListen(
    withArguments arguments: Any?,
    eventSink events: @escaping FlutterEventSink
  ) -> FlutterError? {
    eventSink = events
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }

  func emit(bytes: Data) {
    guard !bytes.isEmpty else { return }
    DispatchQueue.main.async { [weak self] in
      self?.eventSink?(FlutterStandardTypedData(bytes: bytes))
    }
  }

  func emit(error: FlutterError) {
    DispatchQueue.main.async { [weak self] in
      self?.eventSink?(error)
    }
  }
}

/// TCC permission checks with stable errors for Flutter presentation code.
private enum PinkallCapturePermissions {
  @available(macOS 15.0, *)
  static func request() async throws {
    if !CGPreflightScreenCaptureAccess(), !CGRequestScreenCaptureAccess() {
      throw PinkallCallAudioCaptureError.screenCapturePermissionDenied
    }

    switch AVCaptureDevice.authorizationStatus(for: .audio) {
    case .authorized:
      return
    case .notDetermined:
      let granted = await AVCaptureDevice.requestAccess(for: .audio)
      if !granted {
        throw PinkallCallAudioCaptureError.microphonePermissionDenied
      }
    case .denied, .restricted:
      throw PinkallCallAudioCaptureError.microphonePermissionDenied
    @unknown default:
      throw PinkallCallAudioCaptureError.microphonePermissionDenied
    }
  }
}

private enum PinkallCallAudioCaptureError: Error {
  case unsupportedOS
  case screenCapturePermissionDenied
  case microphonePermissionDenied
  case noDisplayAvailable
  case startCancelled
  case invalidAudioFormat
  case audioConversionFailed(String)
  case captureStartFailed(String)
  case captureStopFailed(String)

  var flutterError: FlutterError {
    switch self {
    case .unsupportedOS:
      return FlutterError(
        code: "unsupported_os",
        message: "Separate ScreenCaptureKit microphone capture requires macOS 15 or later.",
        details: nil
      )
    case .screenCapturePermissionDenied:
      return FlutterError(
        code: "screen_capture_permission_denied",
        message: "Allow Pinkall in System Settings > Privacy & Security > Screen Recording.",
        details: nil
      )
    case .microphonePermissionDenied:
      return FlutterError(
        code: "microphone_permission_denied",
        message: "Allow Pinkall in System Settings > Privacy & Security > Microphone.",
        details: nil
      )
    case .noDisplayAvailable:
      return FlutterError(
        code: "capture_start_failed",
        message: "No display is available for system-audio capture.",
        details: nil
      )
    case .startCancelled:
      return FlutterError(
        code: "capture_cancelled",
        message: "Call-audio capture was cancelled before it started.",
        details: nil
      )
    case .invalidAudioFormat:
      return FlutterError(
        code: "invalid_audio_event",
        message: "ScreenCaptureKit returned an unsupported audio format.",
        details: nil
      )
    case .audioConversionFailed(let detail):
      return FlutterError(
        code: "audio_conversion_failed",
        message: "Native audio could not be converted to PCM16.",
        details: detail
      )
    case .captureStartFailed(let detail):
      return FlutterError(
        code: "capture_start_failed",
        message: "Native call-audio capture could not start.",
        details: detail
      )
    case .captureStopFailed(let detail):
      return FlutterError(
        code: "capture_stop_failed",
        message: "Native call-audio capture could not stop cleanly.",
        details: detail
      )
    }
  }

  static func flutterError(from error: Error) -> FlutterError {
    if let captureError = error as? PinkallCallAudioCaptureError {
      return captureError.flutterError
    }
    return PinkallCallAudioCaptureError.captureStartFailed(
      String(describing: type(of: error))
    ).flutterError
  }
}

/// One ScreenCaptureKit stream with distinct system and microphone outputs.
@available(macOS 15.0, *)
private final class PinkallScreenCaptureAudioSession: NSObject,
  SCStreamDelegate, SCStreamOutput
{
  let id: UUID

  private let targetSampleRate: Double
  private let systemAudioEvents: PinkallAudioEventStreamHandler
  private let microphoneAudioEvents: PinkallAudioEventStreamHandler
  private let onUnexpectedStop: (UUID, Error) -> Void
  private let systemQueue = DispatchQueue(
    label: "com.pinkall.call_audio_capture.system",
    qos: .userInitiated
  )
  private let microphoneQueue = DispatchQueue(
    label: "com.pinkall.call_audio_capture.microphone",
    qos: .userInitiated
  )
  private let stateLock = NSLock()
  private var stream: SCStream?
  private var intentionalStop = false
  private var systemConverter: PinkallPcm16Converter
  private var microphoneConverter: PinkallPcm16Converter
  private var reportedSystemConversionError = false
  private var reportedMicrophoneConversionError = false

  init(
    id: UUID,
    targetSampleRate: Double,
    systemAudioEvents: PinkallAudioEventStreamHandler,
    microphoneAudioEvents: PinkallAudioEventStreamHandler,
    onUnexpectedStop: @escaping (UUID, Error) -> Void
  ) {
    self.id = id
    self.targetSampleRate = targetSampleRate
    self.systemAudioEvents = systemAudioEvents
    self.microphoneAudioEvents = microphoneAudioEvents
    self.onUnexpectedStop = onUnexpectedStop
    systemConverter = PinkallPcm16Converter(targetSampleRate: targetSampleRate)
    microphoneConverter = PinkallPcm16Converter(targetSampleRate: targetSampleRate)
    super.init()
  }

  func start() async throws {
    let content: SCShareableContent
    do {
      content = try await SCShareableContent.excludingDesktopWindows(
        false,
        onScreenWindowsOnly: true
      )
    } catch {
      throw PinkallCallAudioCaptureError.captureStartFailed(
        String(describing: type(of: error))
      )
    }
    guard let display = preferredDisplay(from: content.displays) else {
      throw PinkallCallAudioCaptureError.noDisplayAvailable
    }

    let filter = SCContentFilter(
      display: display,
      excludingApplications: [],
      exceptingWindows: []
    )
    let configuration = SCStreamConfiguration()
    configuration.capturesAudio = true
    configuration.captureMicrophone = true
    // Never feed Pinkall's own sounds back into the prospect track.
    configuration.excludesCurrentProcessAudio = true
    // ScreenCaptureKit's system mix is most reliable at the native 48 kHz.
    // Both outputs are independently downsampled before crossing to Flutter.
    configuration.sampleRate = 48000
    configuration.channelCount = 1
    configuration.width = 2
    configuration.height = 2
    configuration.queueDepth = 3
    configuration.minimumFrameInterval = CMTime(value: 1, timescale: 1)

    let stream = SCStream(
      filter: filter,
      configuration: configuration,
      delegate: self
    )
    do {
      try stream.addStreamOutput(
        self,
        type: .audio,
        sampleHandlerQueue: systemQueue
      )
      try stream.addStreamOutput(
        self,
        type: .microphone,
        sampleHandlerQueue: microphoneQueue
      )
      self.stream = stream
      try await stream.startCapture()
    } catch {
      self.stream = nil
      throw PinkallCallAudioCaptureError.captureStartFailed(
        String(describing: type(of: error))
      )
    }
  }

  func stop() async throws {
    guard let stream else {
      throw PinkallCallAudioCaptureError.captureStopFailed("inactive_session")
    }
    markIntentionalStop()
    do {
      try await stream.stopCapture()
      try? stream.removeStreamOutput(self, type: .audio)
      try? stream.removeStreamOutput(self, type: .microphone)
      self.stream = nil
      resetConverters()
    } catch {
      self.stream = nil
      resetConverters()
      throw PinkallCallAudioCaptureError.captureStopFailed(
        String(describing: type(of: error))
      )
    }
  }

  func cancel() async {
    markIntentionalStop()
    if let stream {
      try? await stream.stopCapture()
      try? stream.removeStreamOutput(self, type: .audio)
      try? stream.removeStreamOutput(self, type: .microphone)
    }
    stream = nil
    resetConverters()
  }

  func stream(
    _ stream: SCStream,
    didOutputSampleBuffer sampleBuffer: CMSampleBuffer,
    of outputType: SCStreamOutputType
  ) {
    guard CMSampleBufferDataIsReady(sampleBuffer) else { return }
    switch outputType {
    case .audio:
      emit(
        sampleBuffer,
        converter: &systemConverter,
        events: systemAudioEvents,
        didReportError: &reportedSystemConversionError
      )
    case .microphone:
      emit(
        sampleBuffer,
        converter: &microphoneConverter,
        events: microphoneAudioEvents,
        didReportError: &reportedMicrophoneConversionError
      )
    default:
      return
    }
  }

  func stream(_ stream: SCStream, didStopWithError error: Error) {
    stateLock.lock()
    let shouldReport = !intentionalStop
    stateLock.unlock()
    if shouldReport {
      onUnexpectedStop(id, error)
    }
  }

  private func emit(
    _ sampleBuffer: CMSampleBuffer,
    converter: inout PinkallPcm16Converter,
    events: PinkallAudioEventStreamHandler,
    didReportError: inout Bool
  ) {
    do {
      if let bytes = try converter.convert(sampleBuffer) {
        events.emit(bytes: bytes)
      }
    } catch {
      if !didReportError {
        didReportError = true
        events.emit(
          error: PinkallCallAudioCaptureError.audioConversionFailed(
            String(describing: type(of: error))
          ).flutterError
        )
      }
    }
  }

  private func preferredDisplay(from displays: [SCDisplay]) -> SCDisplay? {
    let screenNumber = NSScreen.main?.deviceDescription[
      NSDeviceDescriptionKey("NSScreenNumber")
    ] as? NSNumber
    if let displayID = screenNumber?.uint32Value,
      let matching = displays.first(where: { $0.displayID == displayID })
    {
      return matching
    }
    return displays.first
  }

  private func markIntentionalStop() {
    stateLock.lock()
    intentionalStop = true
    stateLock.unlock()
  }

  private func resetConverters() {
    systemConverter = PinkallPcm16Converter(
      targetSampleRate: targetSampleRate
    )
    microphoneConverter = PinkallPcm16Converter(
      targetSampleRate: targetSampleRate
    )
  }
}

/// Stateful converter from ScreenCaptureKit PCM to mono little-endian PCM16.
private struct PinkallPcm16Converter {
  static let supportedSampleRates: Set<Int> = [
    8000, 16000, 24000, 32000, 44100, 48000,
  ]

  private let targetFormat: AVAudioFormat
  private var sourceSignature: PinkallAudioFormatSignature?
  private var converter: AVAudioConverter?

  init(targetSampleRate: Double) {
    targetFormat = AVAudioFormat(
      commonFormat: .pcmFormatInt16,
      sampleRate: targetSampleRate,
      channels: 1,
      interleaved: false
    )!
  }

  mutating func convert(_ sampleBuffer: CMSampleBuffer) throws -> Data? {
    guard
      let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer),
      let streamDescription = CMAudioFormatDescriptionGetStreamBasicDescription(
        formatDescription
      ),
      let sourceFormat = AVAudioFormat(streamDescription: streamDescription)
    else {
      throw PinkallCallAudioCaptureError.invalidAudioFormat
    }

    let frameCount = AVAudioFrameCount(CMSampleBufferGetNumSamples(sampleBuffer))
    guard frameCount > 0,
      let sourceBuffer = AVAudioPCMBuffer(
        pcmFormat: sourceFormat,
        frameCapacity: frameCount
      )
    else {
      return nil
    }
    sourceBuffer.frameLength = frameCount
    let copyStatus = CMSampleBufferCopyPCMDataIntoAudioBufferList(
      sampleBuffer,
      at: 0,
      frameCount: Int32(frameCount),
      into: sourceBuffer.mutableAudioBufferList
    )
    guard copyStatus == noErr else {
      throw PinkallCallAudioCaptureError.audioConversionFailed(
        "core_media_status_\(copyStatus)"
      )
    }

    let signature = PinkallAudioFormatSignature(sourceFormat)
    if converter == nil || sourceSignature != signature {
      guard let nextConverter = AVAudioConverter(
        from: sourceFormat,
        to: targetFormat
      ) else {
        throw PinkallCallAudioCaptureError.invalidAudioFormat
      }
      nextConverter.primeMethod = .none
      converter = nextConverter
      sourceSignature = signature
    }
    guard let converter else {
      throw PinkallCallAudioCaptureError.invalidAudioFormat
    }

    let ratio = targetFormat.sampleRate / sourceFormat.sampleRate
    let outputCapacity = AVAudioFrameCount(
      max(1, ceil(Double(frameCount) * ratio) + 32)
    )
    guard let outputBuffer = AVAudioPCMBuffer(
      pcmFormat: targetFormat,
      frameCapacity: outputCapacity
    ) else {
      throw PinkallCallAudioCaptureError.invalidAudioFormat
    }

    var suppliedInput = false
    var conversionError: NSError?
    let status = converter.convert(
      to: outputBuffer,
      error: &conversionError
    ) { _, inputStatus in
      if suppliedInput {
        inputStatus.pointee = .noDataNow
        return nil
      }
      suppliedInput = true
      inputStatus.pointee = .haveData
      return sourceBuffer
    }
    if status == .error {
      throw PinkallCallAudioCaptureError.audioConversionFailed(
        conversionError.map { String(describing: type(of: $0)) }
          ?? "unknown_converter_error"
      )
    }
    guard outputBuffer.frameLength > 0,
      let samples = outputBuffer.int16ChannelData?[0]
    else {
      return nil
    }
    return Data(
      bytes: samples,
      count: Int(outputBuffer.frameLength) * MemoryLayout<Int16>.size
    )
  }
}

private struct PinkallAudioFormatSignature: Equatable {
  let sampleRate: Double
  let channelCount: AVAudioChannelCount
  let commonFormat: AVAudioCommonFormat
  let isInterleaved: Bool

  init(_ format: AVAudioFormat) {
    sampleRate = format.sampleRate
    channelCount = format.channelCount
    commonFormat = format.commonFormat
    isInterleaved = format.isInterleaved
  }
}
