import 'package:core_data/clients/telnyx_call_state_store.dart';
import 'package:core_data/model/remote/telnyx_call.remote.model.dart';
import 'package:test/test.dart';

void main() {
  group('TelnyxCallStateStore', () {
    test('replays a snapshot emitted before subscription', () async {
      final TelnyxCallStateStore store = TelnyxCallStateStore();
      const TelnyxCallRemoteModel ringing = TelnyxCallRemoteModel(
        callId: 'call-42',
        direction: 'incoming',
        status: 'ringing',
      );

      expect(store.add(ringing), isTrue);

      await expectLater(store.watch('call-42'), emits(ringing));
      await store.dispose();
    });

    test('does not lose a snapshot when subscription starts first', () async {
      final TelnyxCallStateStore store = TelnyxCallStateStore();
      const TelnyxCallRemoteModel active = TelnyxCallRemoteModel(
        callId: 'call-42',
        direction: 'outgoing',
        status: 'active',
      );
      final Future<void> expectation = expectLater(
        store.watch('call-42'),
        emits(active),
      );

      expect(store.add(active), isTrue);

      await expectation;
      await store.dispose();
    });

    test('allows recovery after dropped because it is not terminal', () async {
      final TelnyxCallStateStore store = TelnyxCallStateStore();
      const TelnyxCallRemoteModel dropped = TelnyxCallRemoteModel(
        callId: 'call-42',
        direction: 'outgoing',
        status: 'dropped',
      );
      const TelnyxCallRemoteModel reconnecting = TelnyxCallRemoteModel(
        callId: 'call-42',
        direction: 'outgoing',
        status: 'reconnecting',
      );

      expect(store.add(dropped), isTrue);
      expect(store.add(reconnecting), isTrue);

      await expectLater(store.watch('call-42'), emits(reconnecting));
      await store.dispose();
    });

    test('rejects every transition after ended or error', () async {
      final TelnyxCallStateStore store = TelnyxCallStateStore();
      const TelnyxCallRemoteModel ended = TelnyxCallRemoteModel(
        callId: 'ended-call',
        direction: 'outgoing',
        status: 'ended',
      );
      const TelnyxCallRemoteModel failed = TelnyxCallRemoteModel(
        callId: 'failed-call',
        direction: 'incoming',
        status: 'error',
      );

      expect(store.add(ended), isTrue);
      expect(store.add(ended.copyWith(status: 'active')), isFalse);
      expect(store.add(failed), isTrue);
      expect(store.add(failed.copyWith(status: 'ringing')), isFalse);

      await expectLater(store.watch('ended-call'), emits(ended));
      await expectLater(store.watch('failed-call'), emits(failed));
      await store.dispose();
    });

    test('closes all per-call subjects on dispose', () async {
      final TelnyxCallStateStore store = TelnyxCallStateStore();
      final Future<void> streamDone = expectLater(
        store.watch('call-42'),
        emitsDone,
      );

      await store.dispose();

      await streamDone;
      expect(() => store.watch('call-42'), throwsStateError);
    });
  });
}
