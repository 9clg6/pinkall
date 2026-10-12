import 'package:core_data/core_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/core/providers/data/endpoint/telnyx.sdk_client.provider.dart';

void main() {
  test('keeps the Telnyx transport alive between screen listeners', () async {
    final ProviderContainer container = ProviderContainer();
    final ProviderSubscription<AsyncValue<TelnyxSdkClient>> subscription =
        container.listen(telnyxSdkClientProvider, (_, _) {});
    final TelnyxSdkClient client = await container.read(
      telnyxSdkClientProvider.future,
    );

    subscription.close();
    await container.pump();

    expect(client.watchConnectionStates, returnsNormally);

    container.dispose();
    await Future<void>.delayed(Duration.zero);

    expect(client.watchConnectionStates, throwsStateError);
  });
}
