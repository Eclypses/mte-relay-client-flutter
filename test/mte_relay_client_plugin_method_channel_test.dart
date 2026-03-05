import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mte_relay_client_plugin/mte_relay_client_plugin_method_channel.dart';

import 'fixtures/test_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('mte_relay_client_plugin');
  final List<MethodCall> nativeCalls = <MethodCall>[];

  late MethodChannelMteRelayClientPlugin plugin;

  setUp(() {
    nativeCalls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
          nativeCalls.add(call);
          switch (call.method) {
            case 'initializeRelay':
              return null;
            case 'relayDataTask':
              return successfulMapResponse;
            default:
              return 'ok';
          }
        });

    plugin = MethodChannelMteRelayClientPlugin();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('outgoing native calls', () {
    test('initializeRelay should invoke initializeRelay method', () async {
      await plugin.initializeRelay();

      expect(nativeCalls.single.method, 'initializeRelay');
      expect(nativeCalls.single.arguments, isNull);
    });

    test('relayDataTask should invoke relayDataTask with args', () async {
      final result = await plugin.relayDataTask(testArgs);

      expect(nativeCalls.single.method, 'relayDataTask');
      expect(nativeCalls.single.arguments, testArgs);
      expect(result['success'], isTrue);
    });

    test('relayUploadFile should invoke relayUploadFile', () async {
      final result = await plugin.relayUploadFile(testArgs);

      expect(nativeCalls.single.method, 'relayUploadFile');
      expect(nativeCalls.single.arguments, testArgs);
      expect(result, 'ok');
    });

    test('relayDownloadFile should invoke relayDownloadFile', () async {
      final result = await plugin.relayDownloadFile(testArgs);

      expect(nativeCalls.single.method, 'relayDownloadFile');
      expect(nativeCalls.single.arguments, testArgs);
      expect(result, 'ok');
    });

    test('rePair should invoke rePair', () async {
      final result = await plugin.rePair(testArgs);

      expect(nativeCalls.single.method, 'rePair');
      expect(nativeCalls.single.arguments, testArgs);
      expect(result, 'ok');
    });

    test('adjustRelaySettings should invoke adjustRelaySettings', () async {
      final result = await plugin.adjustRelaySettings(testArgs);

      expect(nativeCalls.single.method, 'adjustRelaySettings');
      expect(nativeCalls.single.arguments, testArgs);
      expect(result, 'ok');
    });

    test('sendChunk should invoke writeToStream', () async {
      final result = await plugin.sendChunk({'streamID': 's1', 'data': [1, 2, 3]});

      expect(nativeCalls.single.method, 'writeToStream');
      expect(nativeCalls.single.arguments, {'streamID': 's1', 'data': [1, 2, 3]});
      expect(result, 'ok');
    });

    test('closeStream should invoke closeStream', () async {
      final result = await plugin.closeStream({'streamID': 's1'});

      expect(nativeCalls.single.method, 'closeStream');
      expect(nativeCalls.single.arguments, {'streamID': 's1'});
      expect(result, 'ok');
    });

    test('enableFileLogging should invoke enableFileLogging', () async {
      final result = await plugin.enableFileLogging({'enabled': true});

      expect(nativeCalls.single.method, 'enableFileLogging');
      expect(nativeCalls.single.arguments, {'enabled': true});
      expect(result, 'ok');
    });

    test('readLogFile should invoke readLogFile', () async {
      final result = await plugin.readLogFile({});

      expect(nativeCalls.single.method, 'readLogFile');
      expect(nativeCalls.single.arguments, {});
      expect(result, 'ok');
    });

    test('clearLogFile should invoke clearLogFile', () async {
      final result = await plugin.clearLogFile({});

      expect(nativeCalls.single.method, 'clearLogFile');
      expect(nativeCalls.single.arguments, {});
      expect(result, 'ok');
    });
  });

  group('incoming native callbacks', () {
    test('should emit stream id on getFileStream callback', () async {
      final emitted = <String>[];
      final subscription = plugin.relayRequestChunksStream.listen(emitted.add);

      await _invokeNativeCallback('getFileStream', 'stream-1');

      expect(emitted, ['stream-1']);
      await subscription.cancel();
    });

    test('should emit message on relayResponseMessage callback', () async {
      final emitted = <String>[];
      final subscription = plugin.relayResponseStream.listen(emitted.add);

      await _invokeNativeCallback('relayResponseMessage', 'connected');

      expect(emitted, ['connected']);
      await subscription.cancel();
    });

    test('should emit progress string on streamCompletionPercentage callback', () async {
      final emitted = <String>[];
      final subscription = plugin.relayStreamCompletionStream.listen(emitted.add);

      await _invokeNativeCallback('streamCompletionPercentage', 0.75);

      expect(emitted, ['0.75']);
      await subscription.cancel();
    });

    test('should emit payload on relayStreamResponse callback', () async {
      final payload = {'statusCode': 201, 'data': 'created'};
      final emitted = <dynamic>[];
      final subscription = plugin.relayStreamResponseStream.listen(emitted.add);

      await _invokeNativeCallback('relayStreamResponse', payload);

      expect(emitted, [payload]);
      await subscription.cancel();
    });

    test('streams should be broadcast to multiple listeners', () async {
      final first = <String>[];
      final second = <String>[];
      final firstSubscription = plugin.relayResponseStream.listen(first.add);
      final secondSubscription = plugin.relayResponseStream.listen(second.add);

      await _invokeNativeCallback('relayResponseMessage', 'first');
      await _invokeNativeCallback('relayResponseMessage', 'second');

      expect(first, ['first', 'second']);
      expect(second, ['first', 'second']);

      await firstSubscription.cancel();
      await secondSubscription.cancel();
    });
  });
}

Future<void> _invokeNativeCallback(String method, [dynamic arguments]) async {
  const channelName = 'mte_relay_client_plugin';
  const codec = StandardMethodCodec();
  final ByteData? message = codec.encodeMethodCall(MethodCall(method, arguments));

  await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .handlePlatformMessage(channelName, message, (_) {});

  await Future<void>.delayed(Duration.zero);
}
