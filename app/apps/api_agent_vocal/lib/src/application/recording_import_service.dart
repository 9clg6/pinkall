import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:api_agent_vocal/src/application/post_call_service.dart';
import 'package:api_agent_vocal/src/application/session_service.dart';
import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/post_call_models.dart';
import 'package:api_agent_vocal/src/domain/recording_transcription_contracts.dart';
import 'package:api_agent_vocal/src/domain/store_contract.dart';

/// Public lifecycle of a prerecorded call import.
enum RecordingImportStatus {
  awaitingConsent('awaiting_consent'),
  awaitingUpload('awaiting_upload'),
  uploading('uploading'),
  transcribing('transcribing'),
  awaitingSpeakerAssignment('awaiting_speaker_assignment'),
  finalizing('finalizing'),
  finalized('finalized'),
  failed('failed');

  const RecordingImportStatus(this.wireName);

  final String wireName;
}

/// Final-analysis state after the user has assigned their own voice.
enum RecordingImportDebriefStatus { pending, completed, failed, unavailable }

/// One role-free segment returned to the client before speaker assignment.
final class ProvisionalRecordingSegment {
  const ProvisionalRecordingSegment({
    required this.id,
    required this.voice,
    required this.text,
    required this.startSeconds,
    required this.endSeconds,
    required this.confidence,
  });

  final String id;
  final String voice;
  final String text;
  final double startSeconds;
  final double endSeconds;
  final double? confidence;

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'voice': voice,
    'text': text,
    'start_seconds': startSeconds,
    'end_seconds': endSeconds,
    'confidence': confidence,
  };
}

/// Safe retry information exposed for one failed import stage.
final class RecordingImportFailure {
  const RecordingImportFailure({
    required this.code,
    required this.message,
    required this.retryable,
  });

  final String code;
  final String message;
  final bool retryable;

  Map<String, Object?> toJson() => <String, Object?>{
    'code': code,
    'message': message,
    'retryable': retryable,
  };
}

/// Immutable client-safe recording import snapshot.
final class RecordingImportSnapshot {
  const RecordingImportSnapshot({
    required this.id,
    required this.sessionId,
    required this.status,
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
    required this.title,
    required this.locale,
    required this.createdAt,
    required this.updatedAt,
    required this.durationSeconds,
    required this.language,
    required this.voices,
    required this.provisionalSegments,
    required this.userVoice,
    required this.failure,
    required this.debriefStatus,
    required this.finalTranscript,
    required this.debrief,
  });

  final String id;
  final String sessionId;
  final RecordingImportStatus status;
  final String fileName;
  final String mimeType;
  final int sizeBytes;
  final String? title;
  final String locale;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? durationSeconds;
  final String? language;
  final List<String> voices;
  final List<ProvisionalRecordingSegment> provisionalSegments;
  final String? userVoice;
  final RecordingImportFailure? failure;
  final RecordingImportDebriefStatus debriefStatus;
  final List<TranscriptSegment>? finalTranscript;
  final PostCallDebrief? debrief;

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'session_id': sessionId,
    'status': status.wireName,
    'file_name': fileName,
    'mime_type': mimeType,
    'size_bytes': sizeBytes,
    'title': title,
    'locale': locale,
    'created_at': createdAt.toUtc().toIso8601String(),
    'updated_at': updatedAt.toUtc().toIso8601String(),
    'duration_seconds': durationSeconds,
    'language': language,
    'voices': voices,
    'provisional_segments': provisionalSegments
        .map((ProvisionalRecordingSegment item) => item.toJson())
        .toList(growable: false),
    'user_voice': userVoice,
    'failure': failure?.toJson(),
    'debrief_status': debriefStatus.name,
    'final_transcript': finalTranscript
        ?.map((TranscriptSegment item) => item.toJson())
        .toList(growable: false),
    'debrief': debrief?.toJson(),
  };
}

/// Application error carrying a stable code without uploaded/transcript data.
final class RecordingImportException implements Exception {
  const RecordingImportException({
    required this.code,
    required this.message,
    required this.retryable,
  });

  final String code;
  final String message;
  final bool retryable;

  @override
  String toString() => 'RecordingImportException($code)';
}

/// Orchestrates transient upload, diarization, explicit role assignment and
/// final OpenAI analysis for prerecorded calls.
final class RecordingImportService {
  RecordingImportService({
    required this.store,
    required this.sessions,
    required this.postCalls,
    required this.transcriptionProvider,
    Directory? stagingRoot,
    this.maxConcurrentTranscriptions = 2,
    this.maxStartsPerMinute = 10,
    this.maxReceivedBytesPerMinute = 400 * 1024 * 1024,
  }) : _stagingRoot =
           stagingRoot ??
           Directory(
             '${Directory.systemTemp.path}'
             '${Platform.pathSeparator}pinkall_recording_imports'
             '${Platform.pathSeparator}${pid}_${_randomId('runtime')}',
           );

  static const int maxSizeBytes = 200 * 1024 * 1024;
  static const double maxDurationSeconds = 3 * 60 * 60;
  static const double maxEncodedBitrateBitsPerSecond = 10 * 1000 * 1000;
  static const List<String> acceptedMimeTypes = <String>[
    'audio/wav',
    'audio/mpeg',
    'audio/mp4',
    'audio/aac',
    'audio/flac',
    'audio/ogg',
    'audio/webm',
  ];

  static const Map<String, String> _mimeAliases = <String, String>{
    'audio/wav': 'audio/wav',
    'audio/x-wav': 'audio/wav',
    'audio/wave': 'audio/wav',
    'audio/mpeg': 'audio/mpeg',
    'audio/mp3': 'audio/mpeg',
    'audio/mp4': 'audio/mp4',
    'audio/m4a': 'audio/mp4',
    'audio/x-m4a': 'audio/mp4',
    'audio/aac': 'audio/aac',
    'audio/x-aac': 'audio/aac',
    'audio/flac': 'audio/flac',
    'audio/x-flac': 'audio/flac',
    'audio/ogg': 'audio/ogg',
    'audio/opus': 'audio/ogg',
    'audio/webm': 'audio/webm',
  };
  static const Map<String, Set<String>> _extensionMimeTypes =
      <String, Set<String>>{
        'wav': <String>{'audio/wav'},
        'mp3': <String>{'audio/mpeg'},
        'm4a': <String>{'audio/mp4'},
        'mp4': <String>{'audio/mp4'},
        'aac': <String>{'audio/aac'},
        'flac': <String>{'audio/flac'},
        'ogg': <String>{'audio/ogg'},
        'oga': <String>{'audio/ogg'},
        'opus': <String>{'audio/ogg'},
        'webm': <String>{'audio/webm'},
      };

  final PinkallStore store;
  final SessionService sessions;
  final PostCallService postCalls;
  final RecordedCallTranscriptionProvider transcriptionProvider;
  final int maxConcurrentTranscriptions;
  final int maxStartsPerMinute;
  final int maxReceivedBytesPerMinute;
  final Directory _stagingRoot;
  final Map<String, _RecordingImportState> _imports =
      <String, _RecordingImportState>{};
  final List<DateTime> _starts = <DateTime>[];
  final List<_ReceivedByteSample> _receivedByteSamples =
      <_ReceivedByteSample>[];
  int _receivedBytesInWindow = 0;
  int _activeTranscriptions = 0;
  bool _disposed = false;

  bool get isConfigured => transcriptionProvider.isConfigured;

  /// Every process-local session currently owned by the import workflow.
  Set<String> get privacySessionIds => Set<String>.unmodifiable(
    _imports.values.map((_RecordingImportState state) => state.sessionId),
  );

  /// Sessions whose import pipeline can still mutate the durable store.
  Set<String> get privacyBlockingSessionIds => Set<String>.unmodifiable(
    _imports.values
        .where(_isPrivacyBlockingImport)
        .map((_RecordingImportState state) => state.sessionId),
  );

  /// Drops idle transient metadata whose durable session was removed.
  ///
  /// This is called synchronously immediately after retention mutates the
  /// store. In-flight imports are rejected by the privacy barrier beforehand.
  void pruneOrphanedPrivacyState() {
    if (privacyBlockingSessionIds.isNotEmpty) {
      throw StateError(
        'Recording import state cannot be pruned while work is active.',
      );
    }
    _imports.removeWhere(
      (String _, _RecordingImportState state) =>
          store.session(state.sessionId) == null,
    );
  }

  /// Removes all idle transient import metadata after workspace deletion.
  void clearPrivacyState() {
    if (privacyBlockingSessionIds.isNotEmpty) {
      throw StateError(
        'Recording import state cannot be cleared while work is active.',
      );
    }
    for (final _RecordingImportState state in _imports.values) {
      final CallSessionSnapshot? session = store.session(state.sessionId);
      if (session != null &&
          session.status != SessionStatus.stopped &&
          session.status != SessionStatus.finalized &&
          session.status != SessionStatus.failed) {
        store.failSession(state.sessionId, 'privacy_workspace_deleted');
      }
    }
    _imports.clear();
  }

  Future<void> initialize() async {
    if (await _stagingRoot.exists()) {
      await _stagingRoot.delete(recursive: true);
    }
    await _stagingRoot.create(recursive: true);
  }

  /// Creates metadata and a normal consent-gated Pinkall session.
  Future<RecordingImportSnapshot> create({
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    required String? title,
    required String locale,
    required String? preparationMarkdown,
  }) async {
    _ensureAvailable();
    final String canonicalMimeType = normalizeMimeType(mimeType);
    _validateFileMetadata(
      fileName: fileName,
      mimeType: canonicalMimeType,
      sizeBytes: sizeBytes,
    );
    final CallSessionSnapshot session = sessions.createRecordingImportSession(
      title: title,
      preparationMarkdown: preparationMarkdown,
    );
    final DateTime now = DateTime.now().toUtc();
    final _RecordingImportState state = _RecordingImportState(
      id: _randomId('imp'),
      sessionId: session.id,
      fileName: fileName,
      mimeType: canonicalMimeType,
      sizeBytes: sizeBytes,
      title: title,
      locale: locale,
      createdAt: now,
      updatedAt: now,
    );
    _imports[state.id] = state;
    await store.flush();
    return _snapshot(state);
  }

  /// Returns the latest state and reflects consent acknowledged elsewhere.
  RecordingImportSnapshot get(String importId) {
    final _RecordingImportState state = _requiredImport(importId);
    _refreshConsentStatus(state);
    return _snapshot(state);
  }

  /// Stages one bounded raw upload and starts provider work asynchronously.
  Future<RecordingImportSnapshot> upload({
    required String importId,
    required String mimeType,
    required int? contentLength,
    required Stream<List<int>> bytes,
  }) async {
    _ensureAvailable();
    final _RecordingImportState state = _requiredImport(importId);
    _refreshConsentStatus(state);
    if (!store.session(state.sessionId)!.transcriptionAllowed) {
      throw const RecordingImportException(
        code: 'consent_required',
        message: 'Transcription consent must be acknowledged before upload.',
        retryable: true,
      );
    }
    final bool canRetryUpload =
        state.status == RecordingImportStatus.failed &&
        state.provisionalSegments.isEmpty &&
        state.failure?.retryable == true &&
        store.finalTranscript(state.sessionId) == null;
    if (state.status != RecordingImportStatus.awaitingUpload &&
        !canRetryUpload) {
      throw const RecordingImportException(
        code: 'invalid_import_state',
        message: 'The recording import is not ready for an upload.',
        retryable: true,
      );
    }
    final String canonicalMimeType = normalizeMimeType(mimeType);
    if (canonicalMimeType != state.mimeType) {
      throw const RecordingImportException(
        code: 'mime_type_mismatch',
        message: 'Upload Content-Type does not match the import metadata.',
        retryable: true,
      );
    }
    if (contentLength != null && contentLength != state.sizeBytes) {
      throw const RecordingImportException(
        code: 'size_mismatch',
        message: 'Upload Content-Length does not match size_bytes.',
        retryable: true,
      );
    }
    _acquireTranscriptionPermit(DateTime.now().toUtc());
    state
      ..status = RecordingImportStatus.uploading
      ..failure = null
      ..provisionalSegments = const <ProvisionalRecordingSegment>[]
      ..voices = const <String>[]
      ..durationSeconds = null
      ..language = null
      ..provider = null
      ..updatedAt = DateTime.now().toUtc();
    final Directory importDirectory = Directory(
      '${_stagingRoot.path}${Platform.pathSeparator}${state.id}',
    );
    final File stagedFile = File(
      '${importDirectory.path}${Platform.pathSeparator}recording.bin',
    );
    try {
      await importDirectory.create(recursive: true);
      final IOSink sink = stagedFile.openWrite(mode: FileMode.writeOnly);
      int receivedBytes = 0;
      try {
        await for (final List<int> chunk in bytes) {
          receivedBytes += chunk.length;
          if (receivedBytes > maxSizeBytes || receivedBytes > state.sizeBytes) {
            throw const RecordingImportException(
              code: 'payload_too_large',
              message: 'The uploaded recording exceeds its allowed size.',
              retryable: false,
            );
          }
          _consumeReceivedBytes(chunk.length, DateTime.now().toUtc());
          sink.add(chunk);
        }
      } finally {
        await sink.close();
      }
      if (receivedBytes != state.sizeBytes) {
        throw const RecordingImportException(
          code: 'size_mismatch',
          message: 'The received byte count does not match size_bytes.',
          retryable: true,
        );
      }
      state
        ..status = RecordingImportStatus.transcribing
        ..updatedAt = DateTime.now().toUtc();
      final Future<void> job = _transcribe(
        state,
        stagedFile: stagedFile,
        importDirectory: importDirectory,
      );
      state.transcriptionJob = job;
      unawaited(job);
      return _snapshot(state);
    } on RecordingImportException catch (error) {
      _setFailure(
        state,
        code: error.code,
        message: error.message,
        retryable: error.retryable,
      );
      _releaseTranscriptionPermit();
      await _deleteTransientDirectory(importDirectory);
      rethrow;
    } on Object {
      _setFailure(
        state,
        code: 'upload_failed',
        message: 'The recording upload could not be staged.',
        retryable: true,
      );
      _releaseTranscriptionPermit();
      await _deleteTransientDirectory(importDirectory);
      throw const RecordingImportException(
        code: 'upload_failed',
        message: 'The recording upload could not be staged.',
        retryable: true,
      );
    }
  }

  /// Assigns the user's real voice before creating roles and final analysis.
  Future<RecordingImportSnapshot> assignUserVoice({
    required String importId,
    required String userVoice,
  }) {
    final _RecordingImportState state = _requiredImport(importId);
    final String normalizedVoice = userVoice.trim().toUpperCase();
    if (store.finalTranscript(state.sessionId) != null &&
        state.userVoice != null &&
        state.userVoice != normalizedVoice) {
      throw const RecordingImportException(
        code: 'speaker_assignment_conflict',
        message: 'This import was finalized with another user voice.',
        retryable: false,
      );
    }
    if (state.status == RecordingImportStatus.finalized) {
      if (state.userVoice != normalizedVoice) {
        throw const RecordingImportException(
          code: 'speaker_assignment_conflict',
          message: 'This import was finalized with another user voice.',
          retryable: false,
        );
      }
      return Future<RecordingImportSnapshot>.value(_snapshot(state));
    }
    final Future<RecordingImportSnapshot>? existing = state.assignmentJob;
    if (existing != null) {
      if (state.userVoice != normalizedVoice) {
        throw const RecordingImportException(
          code: 'speaker_assignment_conflict',
          message: 'Another speaker assignment is already being finalized.',
          retryable: true,
        );
      }
      return existing;
    }
    final bool canAssign =
        state.status == RecordingImportStatus.awaitingSpeakerAssignment ||
        (state.status == RecordingImportStatus.failed &&
            state.provisionalSegments.isNotEmpty);
    if (!canAssign) {
      throw const RecordingImportException(
        code: 'invalid_import_state',
        message: 'Diarization must finish before speaker assignment.',
        retryable: true,
      );
    }
    if (!state.voices.contains(normalizedVoice)) {
      throw const RecordingImportException(
        code: 'unknown_user_voice',
        message: 'user_voice must identify a detected provisional voice.',
        retryable: true,
      );
    }
    state
      ..userVoice = normalizedVoice
      ..status = RecordingImportStatus.finalizing
      ..failure = null
      ..debriefStatus = RecordingImportDebriefStatus.pending
      ..updatedAt = DateTime.now().toUtc();
    late final Future<RecordingImportSnapshot> job;
    job = _finalizeAssignedImport(state).whenComplete(() {
      if (identical(state.assignmentJob, job)) {
        state.assignmentJob = null;
      }
    });
    state.assignmentJob = job;
    return job;
  }

  Future<void> _transcribe(
    _RecordingImportState state, {
    required File stagedFile,
    required Directory importDirectory,
  }) async {
    String? failureCode;
    String? failureMessage;
    bool failureRetryable = false;
    try {
      final DiarizedRecordingTranscript result = await transcriptionProvider
          .transcribe(
            audio: RecordedAudioInput(
              fileName: state.fileName,
              mimeType: state.mimeType,
              sizeBytes: state.sizeBytes,
              openRead: stagedFile.openRead,
            ),
            locale: state.locale,
          );
      _validateProviderResult(state, result);
      final List<ProvisionalRecordingSegment> provisional =
          _normalizeProviderVoices(result.segments);
      state
        ..durationSeconds = result.durationSeconds
        ..language = result.language
        ..provider = result.provider
        ..provisionalSegments = provisional
        ..voices = List<String>.unmodifiable(<String>{
          for (final ProvisionalRecordingSegment segment in provisional)
            segment.voice,
        })
        ..failure = null
        ..updatedAt = DateTime.now().toUtc();
    } on RecordedTranscriptionException catch (error) {
      failureCode = error.code;
      failureMessage = error.message;
      failureRetryable = error.retryable;
    } on RecordingImportException catch (error) {
      failureCode = error.code;
      failureMessage = error.message;
      failureRetryable = error.retryable;
    } on Object {
      failureCode = 'transcription_failed';
      failureMessage = 'Prerecorded transcription failed.';
      failureRetryable = true;
    } finally {
      _releaseTranscriptionPermit();
      await _deleteTransientDirectory(importDirectory);
      if (failureCode case final String code) {
        _setFailure(
          state,
          code: code,
          message: failureMessage!,
          retryable: failureRetryable,
        );
      } else {
        state
          ..status = RecordingImportStatus.awaitingSpeakerAssignment
          ..updatedAt = DateTime.now().toUtc();
      }
      state.transcriptionJob = null;
    }
  }

  Future<RecordingImportSnapshot> _finalizeAssignedImport(
    _RecordingImportState state,
  ) async {
    try {
      final List<DiarizedRecordingSegment> diarized = state.provisionalSegments
          .map(
            (ProvisionalRecordingSegment segment) => DiarizedRecordingSegment(
              voiceId: segment.voice,
              text: segment.text,
              startSeconds: segment.startSeconds,
              endSeconds: segment.endSeconds,
              confidence: segment.confidence,
            ),
          )
          .toList(growable: false);
      await sessions.finalizeRecordingImportTranscript(
        sessionId: state.sessionId,
        segments: diarized,
        userVoiceId: state.userVoice!,
        provider: state.provider ?? transcriptionProvider.name,
      );
      if (!postCalls.isConfigured) {
        state.debriefStatus = RecordingImportDebriefStatus.unavailable;
      } else {
        try {
          await postCalls.generate(state.sessionId);
          state.debriefStatus = RecordingImportDebriefStatus.completed;
        } on Object {
          state.debriefStatus = RecordingImportDebriefStatus.failed;
        }
      }
      state
        ..status = RecordingImportStatus.finalized
        ..failure = null
        ..updatedAt = DateTime.now().toUtc();
      return _snapshot(state);
    } on Object {
      _setFailure(
        state,
        code: 'finalization_failed',
        message: 'The assigned transcript could not be finalized.',
        retryable: true,
      );
      return _snapshot(state);
    }
  }

  void _validateProviderResult(
    _RecordingImportState state,
    DiarizedRecordingTranscript result,
  ) {
    if (!result.durationSeconds.isFinite || result.durationSeconds <= 0) {
      throw const RecordingImportException(
        code: 'invalid_audio_duration',
        message: 'The recording duration is invalid.',
        retryable: false,
      );
    }
    if (result.durationSeconds > maxDurationSeconds) {
      throw const RecordingImportException(
        code: 'duration_exceeded',
        message: 'The recording exceeds the three-hour duration limit.',
        retryable: false,
      );
    }
    final double encodedBitrate =
        (state.sizeBytes * 8) / result.durationSeconds;
    if (encodedBitrate > maxEncodedBitrateBitsPerSecond) {
      throw const RecordingImportException(
        code: 'encoded_bitrate_exceeded',
        message: 'The recording bitrate exceeds 10 Mbps.',
        retryable: false,
      );
    }
    if (result.segments.isEmpty) {
      throw const RecordingImportException(
        code: 'no_speech',
        message: 'No diarized speech was detected.',
        retryable: false,
      );
    }
  }

  List<ProvisionalRecordingSegment> _normalizeProviderVoices(
    List<DiarizedRecordingSegment> input,
  ) {
    final List<DiarizedRecordingSegment> ordered =
        input
            .where(
              (DiarizedRecordingSegment item) =>
                  item.voiceId.trim().isNotEmpty &&
                  item.text.trim().isNotEmpty &&
                  item.startSeconds.isFinite &&
                  item.endSeconds.isFinite &&
                  item.startSeconds >= 0 &&
                  item.endSeconds >= item.startSeconds,
            )
            .toList(growable: false)
          ..sort(
            (DiarizedRecordingSegment left, DiarizedRecordingSegment right) =>
                left.startSeconds.compareTo(right.startSeconds),
          );
    if (ordered.length != input.length || ordered.isEmpty) {
      throw const RecordingImportException(
        code: 'invalid_diarization',
        message: 'The diarized transcript is invalid.',
        retryable: true,
      );
    }
    final Map<String, String> labels = <String, String>{};
    return List<ProvisionalRecordingSegment>.unmodifiable(
      ordered.map((DiarizedRecordingSegment segment) {
        final String label = labels.putIfAbsent(
          segment.voiceId,
          () => _voiceLabel(labels.length),
        );
        return ProvisionalRecordingSegment(
          id: _randomId('provisional'),
          voice: label,
          text: segment.text.trim(),
          startSeconds: segment.startSeconds,
          endSeconds: segment.endSeconds,
          confidence: segment.confidence,
        );
      }),
    );
  }

  RecordingImportSnapshot _snapshot(_RecordingImportState state) {
    _refreshConsentStatus(state);
    return RecordingImportSnapshot(
      id: state.id,
      sessionId: state.sessionId,
      status: state.status,
      fileName: state.fileName,
      mimeType: state.mimeType,
      sizeBytes: state.sizeBytes,
      title: state.title,
      locale: state.locale,
      createdAt: state.createdAt,
      updatedAt: state.updatedAt,
      durationSeconds: state.durationSeconds,
      language: state.language,
      voices: List<String>.unmodifiable(state.voices),
      provisionalSegments: List<ProvisionalRecordingSegment>.unmodifiable(
        state.provisionalSegments,
      ),
      userVoice: state.userVoice,
      failure: state.failure,
      debriefStatus: state.debriefStatus,
      finalTranscript: store.finalTranscript(state.sessionId),
      debrief: store.postCallDebrief(state.sessionId),
    );
  }

  void _refreshConsentStatus(_RecordingImportState state) {
    if (state.status == RecordingImportStatus.awaitingConsent &&
        store.session(state.sessionId)?.transcriptionAllowed == true) {
      state
        ..status = RecordingImportStatus.awaitingUpload
        ..updatedAt = DateTime.now().toUtc();
    }
  }

  void _validateFileMetadata({
    required String fileName,
    required String mimeType,
    required int sizeBytes,
  }) {
    final String normalizedName = fileName.trim();
    if (normalizedName.isEmpty ||
        normalizedName.runes.length > 255 ||
        normalizedName.contains('/') ||
        normalizedName.contains(r'\')) {
      throw const RecordingImportException(
        code: 'invalid_file_name',
        message: 'file_name must be a safe basename of at most 255 characters.',
        retryable: false,
      );
    }
    if (sizeBytes <= 0) {
      throw const RecordingImportException(
        code: 'empty_audio',
        message: 'size_bytes must be positive.',
        retryable: false,
      );
    }
    if (sizeBytes > maxSizeBytes) {
      throw const RecordingImportException(
        code: 'payload_too_large',
        message: 'The recording exceeds the 200 MiB size limit.',
        retryable: false,
      );
    }
    final int extensionSeparator = normalizedName.lastIndexOf('.');
    final String extension = extensionSeparator < 0
        ? ''
        : normalizedName.substring(extensionSeparator + 1).toLowerCase();
    if (!(_extensionMimeTypes[extension]?.contains(mimeType) ?? false)) {
      throw const RecordingImportException(
        code: 'unsupported_media',
        message: 'The file extension and MIME type are not supported.',
        retryable: false,
      );
    }
  }

  /// Canonicalizes supported MIME aliases used by Apple and browsers.
  String normalizeMimeType(String value) {
    final String base = value.split(';').first.trim().toLowerCase();
    final String? canonical = _mimeAliases[base];
    if (canonical == null) {
      throw const RecordingImportException(
        code: 'unsupported_media',
        message: 'This audio MIME type is not supported.',
        retryable: false,
      );
    }
    return canonical;
  }

  void _ensureAvailable() {
    if (_disposed) {
      throw const RecordingImportException(
        code: 'service_unavailable',
        message: 'Recording imports are shutting down.',
        retryable: true,
      );
    }
    if (!transcriptionProvider.isConfigured) {
      throw const RecordingImportException(
        code: 'provider_unavailable',
        message: 'Deepgram prerecorded transcription is not configured.',
        retryable: true,
      );
    }
  }

  void _acquireTranscriptionPermit(DateTime now) {
    _starts.removeWhere(
      (DateTime startedAt) =>
          now.difference(startedAt) >= const Duration(minutes: 1),
    );
    if (_activeTranscriptions >= maxConcurrentTranscriptions ||
        _starts.length >= maxStartsPerMinute) {
      throw const RecordingImportException(
        code: 'rate_limited',
        message: 'Recording transcription capacity is temporarily full.',
        retryable: true,
      );
    }
    _starts.add(now);
    _activeTranscriptions += 1;
  }

  void _releaseTranscriptionPermit() {
    if (_activeTranscriptions > 0) {
      _activeTranscriptions -= 1;
    }
  }

  void _consumeReceivedBytes(int bytes, DateTime now) {
    final DateTime threshold = now.subtract(const Duration(minutes: 1));
    while (_receivedByteSamples.isNotEmpty &&
        !_receivedByteSamples.first.at.isAfter(threshold)) {
      _receivedBytesInWindow -= _receivedByteSamples.removeAt(0).bytes;
    }
    if (_receivedBytesInWindow + bytes > maxReceivedBytesPerMinute) {
      throw const RecordingImportException(
        code: 'upload_rate_limited',
        message: 'The recording upload byte quota is temporarily exceeded.',
        retryable: true,
      );
    }
    _receivedByteSamples.add(_ReceivedByteSample(at: now, bytes: bytes));
    _receivedBytesInWindow += bytes;
  }

  _RecordingImportState _requiredImport(String importId) {
    return _imports[importId] ??
        (throw RecordingImportException(
          code: 'not_found',
          message: 'Recording import not found: $importId',
          retryable: false,
        ));
  }

  void _setFailure(
    _RecordingImportState state, {
    required String code,
    required String message,
    required bool retryable,
  }) {
    state
      ..status = RecordingImportStatus.failed
      ..failure = RecordingImportFailure(
        code: code,
        message: message,
        retryable: retryable,
      )
      ..updatedAt = DateTime.now().toUtc();
  }

  static Future<void> _deleteTransientDirectory(Directory directory) async {
    try {
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    } on FileSystemException {
      // A best-effort second pass handles antivirus/indexer races on desktop.
      await Future<void>.delayed(const Duration(milliseconds: 25));
      try {
        if (await directory.exists()) {
          await directory.delete(recursive: true);
        }
      } on FileSystemException {
        // The unique runtime root is deleted again during graceful shutdown.
      }
    }
  }

  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    await transcriptionProvider.dispose();
    final List<Future<void>> jobs = _imports.values
        .map((_RecordingImportState state) => state.transcriptionJob)
        .whereType<Future<void>>()
        .toList(growable: false);
    try {
      await Future.wait(jobs).timeout(const Duration(seconds: 2));
    } on Object {
      // Provider disposal aborts outstanding HTTP work; cleanup continues.
    }
    await _deleteTransientDirectory(_stagingRoot);
    _imports.clear();
  }

  static String _voiceLabel(int index) {
    int value = index;
    final StringBuffer label = StringBuffer();
    do {
      label.writeCharCode(65 + (value % 26));
      value = (value ~/ 26) - 1;
    } while (value >= 0);
    return label.toString().split('').reversed.join();
  }

  static bool _isPrivacyBlockingImport(_RecordingImportState state) {
    return state.transcriptionJob != null ||
        state.assignmentJob != null ||
        state.status == RecordingImportStatus.uploading ||
        state.status == RecordingImportStatus.transcribing ||
        state.status == RecordingImportStatus.finalizing;
  }

  static String _randomId(String prefix) {
    final Random random = Random.secure();
    final List<int> bytes = List<int>.generate(
      24,
      (_) => random.nextInt(256),
      growable: false,
    );
    return '${prefix}_${base64UrlEncode(bytes).replaceAll('=', '')}';
  }
}

final class _RecordingImportState {
  _RecordingImportState({
    required this.id,
    required this.sessionId,
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
    required this.title,
    required this.locale,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String sessionId;
  final String fileName;
  final String mimeType;
  final int sizeBytes;
  final String? title;
  final String locale;
  final DateTime createdAt;
  DateTime updatedAt;
  RecordingImportStatus status = RecordingImportStatus.awaitingConsent;
  double? durationSeconds;
  String? language;
  String? provider;
  List<String> voices = const <String>[];
  List<ProvisionalRecordingSegment> provisionalSegments =
      const <ProvisionalRecordingSegment>[];
  String? userVoice;
  RecordingImportFailure? failure;
  RecordingImportDebriefStatus debriefStatus =
      RecordingImportDebriefStatus.pending;
  Future<void>? transcriptionJob;
  Future<RecordingImportSnapshot>? assignmentJob;
}

final class _ReceivedByteSample {
  const _ReceivedByteSample({required this.at, required this.bytes});

  final DateTime at;
  final int bytes;
}
