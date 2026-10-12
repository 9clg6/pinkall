import 'package:core_data/model/remote/telnyx_call.remote.model.dart';
import 'package:rxdart/rxdart.dart';

/// Replaying in-memory state channels owned by the Telnyx SDK adapter.
final class TelnyxCallStateStore {
  final Map<String, TelnyxCallRemoteModel> _snapshots =
      <String, TelnyxCallRemoteModel>{};
  final Map<String, BehaviorSubject<TelnyxCallRemoteModel>> _subjects =
      <String, BehaviorSubject<TelnyxCallRemoteModel>>{};
  bool _disposed = false;

  /// Returns whether a snapshot currently exists for [callId].
  bool contains(String callId) => _snapshots.containsKey(callId);

  /// Returns a stable copy of all latest call snapshots.
  List<TelnyxCallRemoteModel> get snapshots =>
      List<TelnyxCallRemoteModel>.unmodifiable(_snapshots.values);

  /// Returns the latest snapshot for [callId].
  TelnyxCallRemoteModel requireSnapshot(String callId) {
    return _snapshots[callId] ??
        (throw StateError('No Telnyx call state found for $callId'));
  }

  /// Replays the latest snapshot, then emits subsequent accepted transitions.
  Stream<TelnyxCallRemoteModel> watch(String callId) {
    _ensureAvailable();
    if (callId.trim().isEmpty) {
      throw ArgumentError.value(
        callId,
        'callId',
        'A call identifier is required',
      );
    }
    return _subjects
        .putIfAbsent(callId, BehaviorSubject<TelnyxCallRemoteModel>.new)
        .stream;
  }

  /// Stores [snapshot] unless it is a duplicate or follows a terminal state.
  bool add(TelnyxCallRemoteModel snapshot) {
    _ensureAvailable();
    final TelnyxCallRemoteModel? previous = _snapshots[snapshot.callId];
    if (previous != null && _isTerminal(previous.status)) {
      return false;
    }
    if (previous == snapshot) {
      return false;
    }

    _snapshots[snapshot.callId] = snapshot;
    final BehaviorSubject<TelnyxCallRemoteModel>? existingSubject =
        _subjects[snapshot.callId];
    if (existingSubject == null) {
      _subjects[snapshot.callId] =
          BehaviorSubject<TelnyxCallRemoteModel>.seeded(snapshot);
    } else if (!existingSubject.isClosed) {
      existingSubject.add(snapshot);
    }
    return true;
  }

  /// Closes all per-call subjects and clears their snapshots.
  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    await Future.wait<void>(
      _subjects.values.map(
        (BehaviorSubject<TelnyxCallRemoteModel> subject) => subject.close(),
      ),
    );
    _subjects.clear();
    _snapshots.clear();
  }

  bool _isTerminal(String status) => status == 'ended' || status == 'error';

  void _ensureAvailable() {
    if (_disposed) {
      throw StateError('The Telnyx call state store has been disposed');
    }
  }
}
