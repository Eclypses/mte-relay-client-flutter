# MTE Relay Client Flutter Plugin (SPM) - Library Context

## 1. Project Overview
This project (`mte-relay-client-flutter`) is a Flutter plugin that provides MTE-encrypted HTTP communication for iOS and Android applications via an MteRelay server. It wraps platform-specific native implementations (Swift for iOS via Swift Package Manager, Java for Android) behind a unified Dart API.

**Primary Goal:** To provide Flutter developers with a simple, drop-in solution for routing HTTP requests through an MteRelay server, where requests are automatically encrypted with MTE before transmission and decrypted on the server side before being forwarded to the original destination API.

**Note:** A CocoaPods variant exists at `mte-relay-client-flutter-pod.git` — this repo uses Swift Package Manager for iOS integration.

## 2. Intended Use
This plugin is designed for Flutter developers building iOS (14.0+) and Android applications that need to secure HTTP communications using Eclypses MTE encryption via an MteRelay server proxy.

*   **Supported Platforms:** iOS 14.0+, Android
*   **Core Features:**
    *   Standard HTTP data tasks (GET, POST, PUT, DELETE, etc.)
    *   Large file streaming uploads with chunked transfer
    *   Large file streaming downloads to local storage
    *   Automatic MTE pairing with the Relay server
    *   Automatic re-pairing on connection failures (one retry)
    *   Manual re-pairing API
    *   Configurable relay settings (chunk size, pair pool, persistence)
    *   Native file logging for debugging
    *   Selective header encryption
    *   Route encryption with optional unencrypted pathname prefix

## 3. Core Architecture
The plugin follows Flutter's federated plugin architecture with platform channels bridging Dart to native code.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           Flutter App (Dart)                                │
├─────────────────────────────────────────────────────────────────────────────┤
│  MteRelayClientPlugin  →  PlatformInterface  →  MethodChannel               │
├─────────────────────────────────────────────────────────────────────────────┤
│                        Platform Channel Bridge                              │
├────────────────────────────────┬────────────────────────────────────────────┤
│      iOS (Swift)               │           Android (Java)                   │
│  MteRelayClientPlugin.swift    │    MteRelayClientPlugin.java               │
│         ↓                      │              ↓                             │
│  MteRelay Package (SPM)        │    MteRelay Library (Gradle)               │
├────────────────────────────────┴────────────────────────────────────────────┤
│                          MteRelay Server                                    │
│              (Decrypts → Forwards → Encrypts Response)                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                        Original Destination API                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### A. Dart Layer (`lib/`)

#### `MteRelayClientPlugin` (Main Entry Point)
*   **Role**: Public API for Flutter applications.
*   **Responsibility**:
    *   Exposes all plugin methods: `initializeRelay()`, `relayDataTask()`, `relayUploadFile()`, `relayDownloadFile()`, `rePair()`, `adjustRelaySettings()`, etc.
    *   Exposes callback streams for async responses: `relayResponseStream`, `relayStreamResponseStream`, `relayRequestChunksStream`, `relayStreamCompletionStream`.

#### `MteRelayClientPluginPlatform` (Platform Interface)
*   **Role**: Abstract interface defining the contract for platform implementations.
*   **Responsibility**:
    *   Declares all method signatures that platform implementations must fulfill.
    *   Provides `UnimplementedError` defaults for safety.

#### `MethodChannelMteRelayClientPlugin` (Method Channel Implementation)
*   **Role**: Concrete implementation using Flutter MethodChannels.
*   **Responsibility**:
    *   Invokes native methods via `MethodChannel('mte_relay_client_plugin')`.
    *   Handles callbacks from native code via `setMethodCallHandler`.
    *   Manages `StreamController` instances for async event broadcasting.

#### Response Models
*   **`Result<T>`**: Generic response wrapper with typed data, headers, statusCode, error handling.
*   **`NativeHttpResponse`**: Response wrapper with `Uint8List` body for raw binary access.
*   Both provide convenience getters: `bodyAsString`, `bodyAsJsonObject`, `isSuccess`.

### B. iOS Native Layer (`ios/`)

#### `MteRelayClientPlugin.swift`
*   **Role**: FlutterPlugin implementation bridging Dart to native MteRelay.
*   **Responsibility**:
    *   Registers MethodChannel with Flutter engine.
    *   Initializes `Relay` instance from the MteRelay Swift Package.
    *   Implements delegate protocols: `RelayResponseDelegate`, `RelayStreamDelegate`, `RelayStreamResponseDelegate`, `RelayStreamCompletionDelegate`.
    *   Maps Flutter method calls to Relay API calls.
    *   Manages output streams for chunked file uploads.
    *   Invokes Flutter callbacks on main thread.

#### `Package.swift`
*   **Role**: Swift Package Manager manifest defining iOS plugin integration.
*   **Dependency**: `MteRelay` package from `eclypses-aws-mte-relay-client-ios.git` (v4.3.4+).
*   **Platform**: iOS 14.0+

### C. Android Native Layer (`android/`)

#### `MteRelayClientPlugin.java`
*   **Role**: FlutterPlugin implementation bridging Dart to native MteRelay.
*   **Responsibility**:
    *   Registers MethodChannel with Flutter engine.
    *   Initializes `Relay` instance from the MteRelay Android library.
    *   Implements callback interfaces: `RelayResponseListener`, `RelayStreamResponseListener`, `RelayStreamCompletionCallback`, etc.
    *   Uses Volley for HTTP request handling.
    *   Maps Flutter method calls to Relay API calls.
    *   Manages output streams for chunked file uploads.
    *   Invokes Flutter callbacks on main looper thread.

## 4. Data Flow

### Initialization
1. App calls `_mteRelayClientPlugin.initializeRelay()`.
2. Dart invokes `initializeRelay` on MethodChannel.
3. Native creates `Relay` instance, which connects and pairs with the MteRelay server.
4. Relay is ready for use.

### Standard HTTP Request (relayDataTask)
1. App creates args map: `url`, `route`, `method`, `headers`, `headersToEncrypt`, `body`, `pathnamePrefix`.
2. Dart invokes `relayDataTask` with args via MethodChannel.
3. Native constructs `URLRequest` (iOS) or Volley request (Android).
4. Native Relay encrypts route, selected headers, and body with MTE.
5. Encrypted request sent to MteRelay server.
6. MteRelay server decrypts, forwards to destination API, encrypts response.
7. Native Relay receives and decrypts response.
8. Response returned to Dart as `Map` with `success`, `statusCode`, `data`, `headers`.
9. App wraps in `Result` or `NativeHttpResponse` for convenient access.

### File Stream Upload
1. App prepares file and calls `relayUploadFile(args)`.
2. Native Relay requests body stream via `getFileStream` callback.
3. Dart receives `streamID` via `relayRequestChunksStream`.
4. App sends chunks via `sendChunk({streamID, data})`.
5. App calls `closeStream({streamID})` when complete.
6. Native streams chunks through MTE encryption to server.
7. Progress reported via `relayStreamCompletionStream`.
8. Response returned via `relayStreamResponseStream`.

### File Stream Download
1. App calls `relayDownloadFile(args)` with `downloadLocation` path.
2. Native Relay downloads encrypted stream from server.
3. Relay decrypts and writes to specified local file.
4. Progress reported via `relayStreamCompletionStream`.
5. Response returned via `relayStreamResponseStream`.

## 5. Key File Structure
```/
├── lib/                                    # Dart plugin code
│   ├── mte_relay_client_plugin.dart        # Main public API
│   ├── mte_relay_client_plugin_platform_interface.dart  # Abstract interface
│   ├── mte_relay_client_plugin_method_channel.dart      # MethodChannel impl
│   ├── mte_relay_response_model.dart       # Result<T> response wrapper
│   └── mte_relay_native_response.dart      # NativeHttpResponse wrapper
│
├── ios/                                    # iOS native code
│   └── mte_relay_client_plugin/
│       ├── Package.swift                   # Swift Package Manager manifest
│       └── Sources/mte_relay_client_plugin/
│           └── MteRelayClientPlugin.swift  # iOS FlutterPlugin
│
├── android/                                # Android native code
│   ├── build.gradle                        # Gradle build config
│   └── src/main/java/com/eclypses/mte_relay_client_plugin/
│       ├── MteRelayClientPlugin.java       # Android FlutterPlugin
│       └── VolleyRequestListener.java      # Volley callback interface
│
├── example/                                # Example Flutter app
│   ├── lib/
│   │   ├── main.dart                       # Full-featured demo app
│   │   ├── multipart_helper.dart           # Multipart request helper
│   │   └── local_file_helper.dart          # File management helper
│   └── assets/                             # Sample files for testing
│
├── dev_docs/                               # Developer documentation
│   └── LIBRARY_CONTEXT.md                  # This file
│
├── pubspec.yaml                            # Flutter plugin manifest
├── README.md                               # User integration guide
├── iosIntegrationGuide.md                  # Detailed iOS/CocoaPods setup
├── CHANGELOG.md                            # Version history
└── release.sh                              # Release automation script
```

## 6. Plugin API Reference

### Methods (via `MteRelayClientPlugin`)

| Method | Purpose | Returns |
|--------|---------|---------|
| `initializeRelay()` | Initialize MTE Relay connection | `Future<void>` |
| `relayDataTask(args)` | Standard HTTP request | `Future<Map>` |
| `relayUploadFile(args)` | Streaming file upload | `Future<String>` |
| `relayDownloadFile(args)` | Streaming file download | `Future<String>` |
| `rePair(args)` | Manual re-pairing with server | `Future<String>` |
| `adjustRelaySettings(args)` | Modify relay configuration | `Future<String>` |
| `sendChunk(args)` | Send file chunk during upload | `Future<void>` |
| `closeStream(args)` | Close upload stream | `Future<void>` |
| `enableFileLogging(args)` | Enable/disable native logging | `Future<String>` |
| `readLogFile(args)` | Read native log contents | `Future<String>` |
| `clearLogFile(args)` | Clear native log file | `Future<String>` |

### Streams (callbacks from native)

| Stream | Purpose | Event Type |
|--------|---------|------------|
| `relayResponseStream` | General relay messages | `String` |
| `relayStreamResponseStream` | File stream responses | `Map` with statusCode, data, headers, errors |
| `relayRequestChunksStream` | Request for upload chunks | `String` (streamID) |
| `relayStreamCompletionStream` | Upload/download progress | `String` (0.0 - 1.0) |

### Request Arguments Map

```dart
{
  'url': String,              // MteRelay server URL (required)
  'route': String,            // API route - WILL be encrypted (required)
  'method': String,           // HTTP method: GET, POST, PUT, DELETE (required)
  'headers': Map<String,String>,      // HTTP headers (required)
  'headersToEncrypt': List<String>,   // Headers to encrypt (required)
  'pathnamePrefix': String?,  // Unencrypted path prefix (optional)
  'body': String?,            // Request body (optional)
  'downloadLocation': String?, // Local file path for downloads (download only)
}
```

## 7. Configuration & Dependencies

### pubspec.yaml
*   **Version**: Defined in `version:` field (e.g., `4.3.1`)
*   **Platforms**: iOS and Android via `flutter.plugin.platforms`
*   **Dependencies**: `flutter`, `plugin_platform_interface`
Swift Package Manager)
*   **Minimum iOS**: 14.0
*   **Swift Tools Version**: 5.9+
*   **Package Dependency**: `MteRelay` from `eclypses-aws-mte-relay-client-ios.git` (v4.3.4+)
*   **Setup**: Automatic via Flutter plugin system — SPM handles dependency resolution
*   **Setup**: Requires Podfile modification (see `iosIntegrationGuide.md`)

### Android (Gradle)
*   **Setup**: Automatic via Flutter plugin system — no manual configuration needed
*   **MteRelay Library**: Bundled via Gradle dependencies

## 8. Release Process

Use the `release.sh` script:

```bash
./release.sh 4.4.0
```

This script:
1. Updates git ref in `example/pubspec.yaml`
3. Adds new version section to `CHANGELOG.md`
4. Creates git commit and tag (`v4.4.0`)

**Note:** Unlike the CocoaPods variant, this SPM version does not require podspec version updates.

---
This document provides concise technical context for the MTE Relay Client Flutter Plugin (SPM). For integration instructions, see `README
This document provides concise technical context for the MTE Relay Client Flutter Plugin. For integration instructions, see `README.md` and `iosIntegrationGuide.md`.
