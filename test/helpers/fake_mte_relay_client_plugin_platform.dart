import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:mte_relay_client_plugin/mte_relay_client_plugin_platform_interface.dart';

class FakeMteRelayClientPluginPlatform extends MteRelayClientPluginPlatform
    with MockPlatformInterfaceMixin {
  String? platformVersion = '42';
  Map<dynamic, dynamic> relayDataTaskResult = {
    'success': true,
    'data': 'ok',
    'statusCode': 200,
    'headers': <String, String>{},
  };

  String relayUploadFileResult = 'upload-ok';
  String relayDownloadFileResult = 'download-ok';
  String rePairResult = 'repair-ok';
  String adjustRelaySettingsResult = 'adjust-ok';
  String enableFileLoggingResult = 'logging-ok';
  String readLogFileResult = 'log-content';
  String clearLogFileResult = 'clear-ok';

  int getPlatformVersionCallCount = 0;
  int initializeRelayCallCount = 0;
  int relayDataTaskCallCount = 0;
  int relayUploadFileCallCount = 0;
  int relayDownloadFileCallCount = 0;
  int rePairCallCount = 0;
  int adjustRelaySettingsCallCount = 0;
  int sendChunkCallCount = 0;
  int closeStreamCallCount = 0;
  int enableFileLoggingCallCount = 0;
  int readLogFileCallCount = 0;
  int clearLogFileCallCount = 0;

  dynamic lastRelayDataTaskArgs;
  dynamic lastRelayUploadFileArgs;
  dynamic lastRelayDownloadFileArgs;
  dynamic lastRePairArgs;
  dynamic lastAdjustRelaySettingsArgs;
  dynamic lastSendChunkArgs;
  dynamic lastCloseStreamArgs;
  dynamic lastEnableFileLoggingArgs;
  dynamic lastReadLogFileArgs;
  dynamic lastClearLogFileArgs;

  bool shouldFailInitializeRelay = false;
  bool shouldFailRelayDataTask = false;
  bool shouldFailRelayUploadFile = false;
  bool shouldFailRelayDownloadFile = false;
  bool shouldFailRePair = false;
  bool shouldFailAdjustRelaySettings = false;
  bool shouldFailSendChunk = false;
  bool shouldFailCloseStream = false;
  bool shouldFailEnableFileLogging = false;
  bool shouldFailReadLogFile = false;
  bool shouldFailClearLogFile = false;

  final StreamController<String> _relayResponseController =
      StreamController<String>.broadcast();
  final StreamController<dynamic> _relayStreamResponseController =
      StreamController<dynamic>.broadcast();
  final StreamController<String> _relayRequestChunksController =
      StreamController<String>.broadcast();
  final StreamController<String> _relayStreamCompletionController =
      StreamController<String>.broadcast();

  @override
  Stream<String> get relayResponseStream => _relayResponseController.stream;

  @override
  Stream<dynamic> get relayStreamResponseStream =>
      _relayStreamResponseController.stream;

  @override
  Stream<String> get relayRequestChunksStream =>
      _relayRequestChunksController.stream;

  @override
  Stream<String> get relayStreamCompletionStream =>
      _relayStreamCompletionController.stream;

  void simulateRelayResponse(String message) => _relayResponseController.add(message);

  void simulateRelayStreamResponse(dynamic payload) =>
      _relayStreamResponseController.add(payload);

  void simulateRelayRequestChunks(String streamId) =>
      _relayRequestChunksController.add(streamId);

  void simulateRelayStreamCompletion(String progress) =>
      _relayStreamCompletionController.add(progress);

  @override
  Future<String?> getPlatformVersion() async {
    getPlatformVersionCallCount++;
    return platformVersion;
  }

  @override
  Future<void> initializeRelay() async {
    initializeRelayCallCount++;
    if (shouldFailInitializeRelay) {
      throw Exception('initializeRelay failed');
    }
  }

  @override
  Future<Map<dynamic, dynamic>> relayDataTask(dynamic args) async {
    relayDataTaskCallCount++;
    lastRelayDataTaskArgs = args;
    if (shouldFailRelayDataTask) {
      throw Exception('relayDataTask failed');
    }
    return relayDataTaskResult;
  }

  @override
  Future<String> relayUploadFile(dynamic args) async {
    relayUploadFileCallCount++;
    lastRelayUploadFileArgs = args;
    if (shouldFailRelayUploadFile) {
      throw Exception('relayUploadFile failed');
    }
    return relayUploadFileResult;
  }

  @override
  Future<String> relayDownloadFile(dynamic args) async {
    relayDownloadFileCallCount++;
    lastRelayDownloadFileArgs = args;
    if (shouldFailRelayDownloadFile) {
      throw Exception('relayDownloadFile failed');
    }
    return relayDownloadFileResult;
  }

  @override
  Future<String> rePair(dynamic args) async {
    rePairCallCount++;
    lastRePairArgs = args;
    if (shouldFailRePair) {
      throw Exception('rePair failed');
    }
    return rePairResult;
  }

  @override
  Future<String> adjustRelaySettings(dynamic args) async {
    adjustRelaySettingsCallCount++;
    lastAdjustRelaySettingsArgs = args;
    if (shouldFailAdjustRelaySettings) {
      throw Exception('adjustRelaySettings failed');
    }
    return adjustRelaySettingsResult;
  }

  @override
  Future<void> sendChunk(dynamic args) async {
    sendChunkCallCount++;
    lastSendChunkArgs = args;
    if (shouldFailSendChunk) {
      throw Exception('sendChunk failed');
    }
  }

  @override
  Future<void> closeStream(dynamic args) async {
    closeStreamCallCount++;
    lastCloseStreamArgs = args;
    if (shouldFailCloseStream) {
      throw Exception('closeStream failed');
    }
  }

  @override
  Future<String> enableFileLogging(dynamic args) async {
    enableFileLoggingCallCount++;
    lastEnableFileLoggingArgs = args;
    if (shouldFailEnableFileLogging) {
      throw Exception('enableFileLogging failed');
    }
    return enableFileLoggingResult;
  }

  @override
  Future<String> readLogFile(dynamic args) async {
    readLogFileCallCount++;
    lastReadLogFileArgs = args;
    if (shouldFailReadLogFile) {
      throw Exception('readLogFile failed');
    }
    return readLogFileResult;
  }

  @override
  Future<String> clearLogFile(dynamic args) async {
    clearLogFileCallCount++;
    lastClearLogFileArgs = args;
    if (shouldFailClearLogFile) {
      throw Exception('clearLogFile failed');
    }
    return clearLogFileResult;
  }

  Future<void> dispose() async {
    await _relayResponseController.close();
    await _relayStreamResponseController.close();
    await _relayRequestChunksController.close();
    await _relayStreamCompletionController.close();
  }
}
