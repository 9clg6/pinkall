import AppIntents
import CallKit
import Flutter
import PushKit
import UIKit
import UniformTypeIdentifiers

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    application.shortcutItems = [
      UIApplicationShortcutItem(
        type: RecordingImportCoordinator.shortcutType,
        localizedTitle: "Importer un appel",
        localizedSubtitle: "Analyser un enregistrement dans Pinkall",
        icon: UIApplicationShortcutIcon(systemImageName: "waveform.badge.plus"),
        userInfo: nil
      )
    ]
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    guard
      let registrar = engineBridge.pluginRegistry.registrar(
        forPlugin: "PinkallRecordingImport"
      )
    else {
      return
    }
    RecordingImportCoordinator.shared.register(messenger: registrar.messenger())
    IncomingCallCoordinator.shared.register(messenger: registrar.messenger())
  }
}

/// Gated native foundation for PushKit wake-up and CallKit actions.
final class IncomingCallCoordinator: NSObject,
  PKPushRegistryDelegate,
  CXProviderDelegate,
  FlutterStreamHandler
{
  static let shared = IncomingCallCoordinator()

  private static let methodChannelName = "com.pinkall.incoming_calls/methods"
  private static let eventChannelName = "com.pinkall.incoming_calls/events"
  private static let featureFlagKey = "PinkallIncomingCallsEnabled"
  private static let tokenDefaultsKey = "pinkall.apns_voip_token"

  private var methodChannel: FlutterMethodChannel?
  private var eventChannel: FlutterEventChannel?
  private var eventSink: FlutterEventSink?
  private var pendingEvents: [[String: Any]] = []
  private var pushRegistry: PKPushRegistry?
  private var callProvider: CXProvider?
  private var callIdsByUUID: [UUID: String] = [:]

  private override init() {
    super.init()
  }

  func register(messenger: FlutterBinaryMessenger) {
    guard methodChannel == nil else { return }
    let methods = FlutterMethodChannel(
      name: Self.methodChannelName,
      binaryMessenger: messenger
    )
    methods.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
    let events = FlutterEventChannel(
      name: Self.eventChannelName,
      binaryMessenger: messenger
    )
    events.setStreamHandler(self)
    methodChannel = methods
    eventChannel = events
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initialize":
      initializeIfConfigured()
      result(capability())
    case "getCapability":
      result(capability())
    case "getNotificationToken":
      result(UserDefaults.standard.string(forKey: Self.tokenDefaultsKey))
    case "dispose":
      eventSink = nil
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func initializeIfConfigured() {
    guard featureEnabled, canAttemptPushRegistration else { return }
    if callProvider == nil {
      let configuration = CXProviderConfiguration(localizedName: "Pinkall")
      configuration.supportsVideo = false
      configuration.maximumCallGroups = 1
      configuration.maximumCallsPerCallGroup = 1
      configuration.supportedHandleTypes = [.phoneNumber, .generic]
      let provider = CXProvider(configuration: configuration)
      provider.setDelegate(self, queue: .main)
      callProvider = provider
    }
    if pushRegistry == nil {
      let registry = PKPushRegistry(queue: .main)
      registry.delegate = self
      registry.desiredPushTypes = [.voIP]
      pushRegistry = registry
    }
  }

  private var featureEnabled: Bool {
    Bundle.main.object(forInfoDictionaryKey: Self.featureFlagKey) as? Bool ?? false
  }

  private var canAttemptPushRegistration: Bool {
    #if targetEnvironment(simulator)
      return false
    #else
      return true
    #endif
  }

  private func capability() -> [String: Any] {
    guard featureEnabled else {
      return capabilityMap(
        status: "disabled",
        tokenAvailable: false,
        backgroundReady: false,
        nativeUIReady: false,
        missing: ["ios_feature_flag_disabled"],
        detail: "Enable only after APNS VoIP and Telnyx credentials exist."
      )
    }
    guard canAttemptPushRegistration else {
      return capabilityMap(
        status: "configurationRequired",
        tokenAvailable: false,
        backgroundReady: false,
        nativeUIReady: false,
        missing: ["physical_ios_device"],
        detail: "PushKit registration requires a signed build on a physical iOS device."
      )
    }
    let tokenAvailable = UserDefaults.standard.string(
      forKey: Self.tokenDefaultsKey
    )?.isEmpty == false
    let nativeUIReady = callProvider != nil
    return capabilityMap(
      status: tokenAvailable && nativeUIReady ? "ready" : "registering",
      tokenAvailable: tokenAvailable,
      backgroundReady: tokenAvailable,
      nativeUIReady: nativeUIReady,
      missing: tokenAvailable
        ? []
        : ["apns_voip_token_or_push_entitlement_pending"],
      detail: tokenAvailable
        ? nil
        : "PushKit registration is waiting for APNS to issue a VoIP token."
    )
  }

  private func capabilityMap(
    status: String,
    tokenAvailable: Bool,
    backgroundReady: Bool,
    nativeUIReady: Bool,
    missing: [String],
    detail: String?
  ) -> [String: Any] {
    var values: [String: Any] = [
      "status": status,
      "platform": "ios",
      "transport": "apnsVoip",
      "token_available": tokenAvailable,
      "background_delivery_ready": backgroundReady,
      "native_call_ui_ready": nativeUIReady,
      "missing_requirements": missing,
    ]
    if let detail { values["detail"] = detail }
    return values
  }

  func pushRegistry(
    _ registry: PKPushRegistry,
    didUpdate credentials: PKPushCredentials,
    for type: PKPushType
  ) {
    guard type == .voIP else { return }
    let token = credentials.token.map { String(format: "%02x", $0) }.joined()
    UserDefaults.standard.set(token, forKey: Self.tokenDefaultsKey)
    emit(["type": "tokenUpdated"])
  }

  func pushRegistry(
    _ registry: PKPushRegistry,
    didInvalidatePushTokenFor type: PKPushType
  ) {
    guard type == .voIP else { return }
    UserDefaults.standard.removeObject(forKey: Self.tokenDefaultsKey)
    emit(["type": "tokenInvalidated"])
  }

  func pushRegistry(
    _ registry: PKPushRegistry,
    didReceiveIncomingPushWith payload: PKPushPayload,
    for type: PKPushType,
    completion: @escaping () -> Void
  ) {
    guard featureEnabled, type == .voIP, let provider = callProvider else {
      completion()
      return
    }
    guard
      let metadata = payload.dictionaryPayload["metadata"] as? [String: Any],
      let callID = metadata["call_id"] as? String,
      !callID.isEmpty
    else {
      completion()
      return
    }

    let callerName = (metadata["caller_name"] as? String)?.trimmingCharacters(
      in: .whitespacesAndNewlines
    )
    let callerNumber = (metadata["caller_number"] as? String)?.trimmingCharacters(
      in: .whitespacesAndNewlines
    )
    let uuid = UUID()
    callIdsByUUID[uuid] = callID
    let update = CXCallUpdate()
    update.localizedCallerName = callerName?.isEmpty == false
      ? callerName
      : callerNumber
    if let callerNumber, !callerNumber.isEmpty {
      update.remoteHandle = CXHandle(type: .phoneNumber, value: callerNumber)
    } else {
      update.remoteHandle = CXHandle(type: .generic, value: "Pinkall")
    }
    update.hasVideo = false
    provider.reportNewIncomingCall(with: uuid, update: update) { [weak self] error in
      defer { completion() }
      guard error == nil else {
        self?.callIdsByUUID.removeValue(forKey: uuid)
        return
      }
      self?.emit(
        self?.event(
          type: "incomingCall",
          callID: callID,
          callerName: callerName,
          callerNumber: callerNumber,
          voiceSdkID: metadata["voice_sdk_id"] as? String
        ) ?? ["type": "incomingCall", "call_id": callID]
      )
    }
  }

  func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
    guard let callID = callIdsByUUID[action.callUUID] else {
      action.fail()
      return
    }
    emit(event(type: "answerRequested", callID: callID))
    action.fulfill()
  }

  func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
    guard let callID = callIdsByUUID.removeValue(forKey: action.callUUID) else {
      action.fail()
      return
    }
    emit(event(type: "declineRequested", callID: callID))
    action.fulfill()
  }

  func providerDidReset(_ provider: CXProvider) {
    callIdsByUUID.removeAll()
  }

  func onListen(
    withArguments arguments: Any?,
    eventSink events: @escaping FlutterEventSink
  ) -> FlutterError? {
    eventSink = events
    let queued = pendingEvents
    pendingEvents.removeAll()
    queued.forEach(events)
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }

  private func event(
    type: String,
    callID: String,
    callerName: String? = nil,
    callerNumber: String? = nil,
    voiceSdkID: String? = nil
  ) -> [String: Any] {
    var values: [String: Any] = ["type": type, "call_id": callID]
    if let callerName, !callerName.isEmpty { values["caller_name"] = callerName }
    if let callerNumber, !callerNumber.isEmpty {
      values["caller_number"] = callerNumber
    }
    if let voiceSdkID, !voiceSdkID.isEmpty { values["voice_sdk_id"] = voiceSdkID }
    return values
  }

  private func emit(_ event: [String: Any]) {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      if let eventSink {
        eventSink(event)
      } else {
        pendingEvents.append(event)
      }
    }
  }
}

/// Process-wide handoff between iOS open-in/shortcuts and Flutter.
final class RecordingImportCoordinator: NSObject, UIDocumentPickerDelegate {
  static let shared = RecordingImportCoordinator()
  static let shortcutType = "com.pinkall.import_recording"

  private static let channelName = "com.pinkall.recording_import/methods"
  private static let pickerDefaultsKey = "pinkall.pending_recording_picker"
  private static let maximumBytes: Int64 = 200 * 1024 * 1024
  private static let importDirectoryName = "pinkall-recording-imports"
  private static let acceptedExtensions: Set<String> = [
    "aac", "flac", "m4a", "mp3", "mp4", "oga", "ogg", "opus", "wav", "webm",
  ]

  private var channel: FlutterMethodChannel?
  private var pendingAction: [String: Any]?
  private var pendingFailure: FlutterError?
  private var pendingResults: [FlutterResult] = []
  private var pickerResult: FlutterResult?
  private var isImporting = false

  private override init() {
    super.init()
  }

  func register(messenger: FlutterBinaryMessenger) {
    guard channel == nil else { return }
    let methodChannel = FlutterMethodChannel(
      name: Self.channelName,
      binaryMessenger: messenger
    )
    methodChannel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
    channel = methodChannel
  }

  @discardableResult
  func handle(shortcutItem: UIApplicationShortcutItem) -> Bool {
    guard shortcutItem.type == Self.shortcutType else { return false }
    requestPicker()
    return true
  }

  @discardableResult
  func handle(url: URL) -> Bool {
    guard url.isFileURL else { return false }
    beginImport(url)
    return true
  }

  func requestPicker() {
    UserDefaults.standard.set(true, forKey: Self.pickerDefaultsKey)
    pendingAction = ["kind": "pick_recording"]
    pendingFailure = nil
    completePendingResultsIfPossible()
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "consumePendingAction":
      consumePendingAction(result: result)
    case "pickRecording":
      presentRecordingPicker(result: result)
    case "discardImport":
      discardImport(arguments: call.arguments, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func presentRecordingPicker(result: @escaping FlutterResult) {
    guard pickerResult == nil, !isImporting else {
      result(
        FlutterError(
          code: "import_io_failure",
          message: "Another recording import is already in progress.",
          details: nil
        )
      )
      return
    }
    guard let presenter = Self.topViewController() else {
      result(
        FlutterError(
          code: "import_io_failure",
          message: "The recording picker could not be opened.",
          details: nil
        )
      )
      return
    }
    let picker: UIDocumentPickerViewController
    if #available(iOS 14.0, *) {
      picker = UIDocumentPickerViewController(
        forOpeningContentTypes: [.audio],
        asCopy: false
      )
    } else {
      picker = UIDocumentPickerViewController(
        documentTypes: ["public.audio"],
        in: .open
      )
    }
    picker.allowsMultipleSelection = false
    picker.delegate = self
    pickerResult = result
    presenter.present(picker, animated: true)
  }

  func documentPicker(
    _ controller: UIDocumentPickerViewController,
    didPickDocumentsAt urls: [URL]
  ) {
    guard let result = pickerResult else { return }
    pickerResult = nil
    guard let url = urls.first else {
      result(nil)
      return
    }
    beginImport(url, directResult: result)
  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    let result = pickerResult
    pickerResult = nil
    result?(nil)
  }

  private func consumePendingAction(result: @escaping FlutterResult) {
    if pendingAction == nil,
      UserDefaults.standard.bool(forKey: Self.pickerDefaultsKey)
    {
      pendingAction = ["kind": "pick_recording"]
    }
    if let failure = pendingFailure {
      pendingFailure = nil
      result(failure)
      return
    }
    if let action = pendingAction {
      pendingAction = nil
      UserDefaults.standard.removeObject(forKey: Self.pickerDefaultsKey)
      result(action)
      return
    }
    if isImporting {
      pendingResults.append(result)
      return
    }
    result(nil)
  }

  private func beginImport(_ sourceURL: URL, directResult: FlutterResult? = nil) {
    guard !isImporting else {
      let failure = FlutterError(
        code: "import_io_failure",
        message: "Another recording import is already being prepared.",
        details: nil
      )
      if let directResult {
        directResult(failure)
      } else {
        pendingFailure = failure
      }
      return
    }
    isImporting = true
    pendingAction = nil
    pendingFailure = nil
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self else { return }
      do {
        let action = try self.copyAudioIntoTemporaryStorage(sourceURL)
        DispatchQueue.main.async {
          self.isImporting = false
          if let directResult {
            directResult(action)
          } else {
            self.pendingAction = action
            self.completePendingResultsIfPossible()
          }
        }
      } catch let error as RecordingImportNativeError {
        DispatchQueue.main.async {
          self.isImporting = false
          if let directResult {
            directResult(error.flutterError)
          } else {
            self.pendingFailure = error.flutterError
            self.completePendingResultsIfPossible()
          }
        }
      } catch {
        DispatchQueue.main.async {
          self.isImporting = false
          let failure = FlutterError(
            code: "import_io_failure",
            message: "The recording could not be copied into Pinkall.",
            details: nil
          )
          if let directResult {
            directResult(failure)
          } else {
            self.pendingFailure = failure
            self.completePendingResultsIfPossible()
          }
        }
      }
    }
  }

  private func copyAudioIntoTemporaryStorage(_ sourceURL: URL) throws -> [String: Any] {
    let didAccess = sourceURL.startAccessingSecurityScopedResource()
    defer {
      if didAccess { sourceURL.stopAccessingSecurityScopedResource() }
    }
    let metadata = try audioMetadata(for: sourceURL)
    guard metadata.sizeBytes <= Self.maximumBytes else {
      throw RecordingImportNativeError.tooLarge
    }
    let identifier = UUID().uuidString.replacingOccurrences(of: "-", with: "")
    let directory = FileManager.default.temporaryDirectory.appendingPathComponent(
      Self.importDirectoryName,
      isDirectory: true
    )
    try FileManager.default.createDirectory(
      at: directory,
      withIntermediateDirectories: true
    )
    let destination = directory.appendingPathComponent(
      "\(identifier)_\(metadata.safeName)",
      isDirectory: false
    )
    try FileManager.default.copyItem(at: sourceURL, to: destination)
    let copiedSize = try destination.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0
    guard copiedSize > 0, Int64(copiedSize) == metadata.sizeBytes else {
      try? FileManager.default.removeItem(at: destination)
      throw RecordingImportNativeError.ioFailure
    }
    return [
      "kind": "audio_file",
      "id": identifier,
      "name": metadata.safeName,
      "mime_type": metadata.mimeType,
      "path": destination.path,
      "size_bytes": copiedSize,
    ]
  }

  private func audioMetadata(for url: URL) throws -> (
    safeName: String,
    mimeType: String,
    sizeBytes: Int64
  ) {
    let fileName = sanitizedFileName(url.lastPathComponent)
    let fileExtension = url.pathExtension.lowercased()
    guard Self.acceptedExtensions.contains(fileExtension) else {
      throw RecordingImportNativeError.unsupportedAudio
    }
    let basicValues = try url.resourceValues(forKeys: [.fileSizeKey, .isRegularFileKey])
    guard basicValues.isRegularFile == true,
      let fileSize = basicValues.fileSize,
      fileSize > 0
    else {
      throw RecordingImportNativeError.ioFailure
    }
    var mimeType = Self.mimeType(forExtension: fileExtension)
    if #available(iOS 14.0, *) {
      let typedValues = try url.resourceValues(forKeys: [.contentTypeKey])
      guard let contentType = typedValues.contentType,
        contentType.conforms(to: .audio)
          || contentType.conforms(to: .mpeg4Movie)
      else {
        throw RecordingImportNativeError.unsupportedAudio
      }
      mimeType = contentType.preferredMIMEType ?? mimeType
    }
    guard mimeType.hasPrefix("audio/") else {
      throw RecordingImportNativeError.unsupportedAudio
    }
    return (fileName, mimeType, Int64(fileSize))
  }

  private func discardImport(arguments: Any?, result: @escaping FlutterResult) {
    guard
      let values = arguments as? [String: Any],
      let identifier = values["id"] as? String,
      identifier.range(of: "^[A-Za-z0-9_-]{8,80}$", options: .regularExpression) != nil
    else {
      result(
        FlutterError(
          code: "invalid_arguments",
          message: "A valid temporary recording identifier is required.",
          details: nil
        )
      )
      return
    }
    let directory = FileManager.default.temporaryDirectory.appendingPathComponent(
      Self.importDirectoryName,
      isDirectory: true
    )
    DispatchQueue.global(qos: .utility).async {
      do {
        let files = try FileManager.default.contentsOfDirectory(
          at: directory,
          includingPropertiesForKeys: nil,
          options: [.skipsHiddenFiles]
        )
        for file in files where file.lastPathComponent.hasPrefix("\(identifier)_") {
          try FileManager.default.removeItem(at: file)
        }
        DispatchQueue.main.async { result(nil) }
      } catch let error as CocoaError where error.code == .fileReadNoSuchFile {
        DispatchQueue.main.async { result(nil) }
      } catch {
        DispatchQueue.main.async {
          result(
            FlutterError(
              code: "import_io_failure",
              message: "The temporary recording could not be removed.",
              details: nil
            )
          )
        }
      }
    }
  }

  private func completePendingResultsIfPossible() {
    guard !isImporting, !pendingResults.isEmpty else { return }
    let results = pendingResults
    pendingResults.removeAll()
    if let failure = pendingFailure {
      pendingFailure = nil
      results.first?(failure)
      for result in results.dropFirst() { result(nil) }
      return
    }
    if let action = pendingAction {
      pendingAction = nil
      UserDefaults.standard.removeObject(forKey: Self.pickerDefaultsKey)
      results.first?(action)
      for result in results.dropFirst() { result(nil) }
      return
    }
    for result in results { result(nil) }
  }

  private func sanitizedFileName(_ value: String) -> String {
    let base = (value as NSString).lastPathComponent
      .replacingOccurrences(of: "/", with: "-")
      .replacingOccurrences(of: "\\", with: "-")
      .replacingOccurrences(of: "\n", with: " ")
      .replacingOccurrences(of: "\r", with: " ")
      .trimmingCharacters(in: .whitespacesAndNewlines)
    if base.isEmpty { return "enregistrement.m4a" }
    return String(base.prefix(180))
  }

  private static func mimeType(forExtension value: String) -> String {
    switch value {
    case "aac": return "audio/aac"
    case "flac": return "audio/flac"
    case "m4a", "mp4": return "audio/mp4"
    case "mp3": return "audio/mpeg"
    case "oga", "ogg": return "audio/ogg"
    case "opus": return "audio/opus"
    case "wav": return "audio/wav"
    case "webm": return "audio/webm"
    default: return "application/octet-stream"
    }
  }

  private static func topViewController() -> UIViewController? {
    let activeScene = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .first { $0.activationState == .foregroundActive }
    var controller = activeScene?.windows
      .first(where: { $0.isKeyWindow })?
      .rootViewController
    while let presented = controller?.presentedViewController {
      controller = presented
    }
    return controller
  }
}

private enum RecordingImportNativeError: Error {
  case unsupportedAudio
  case tooLarge
  case ioFailure

  var flutterError: FlutterError {
    switch self {
    case .unsupportedAudio:
      return FlutterError(
        code: "unsupported_audio",
        message: "Choose a supported audio recording.",
        details: nil
      )
    case .tooLarge:
      return FlutterError(
        code: "recording_too_large",
        message: "The recording exceeds the 200 MiB import limit.",
        details: nil
      )
    case .ioFailure:
      return FlutterError(
        code: "import_io_failure",
        message: "The recording could not be copied into Pinkall.",
        details: nil
      )
    }
  }
}

@available(iOS 16.0, *)
struct ImportCallRecordingIntent: AppIntent {
  static var title: LocalizedStringResource = "Importer un appel dans Pinkall"
  static var description = IntentDescription(
    "Ouvre Pinkall pour choisir et analyser un enregistrement existant."
  )
  static var openAppWhenRun: Bool = true

  func perform() async throws -> some IntentResult {
    await MainActor.run {
      RecordingImportCoordinator.shared.requestPicker()
    }
    return .result()
  }
}
