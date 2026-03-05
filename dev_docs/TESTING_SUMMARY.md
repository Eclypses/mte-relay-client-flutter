# MTE Relay Client Flutter Plugin - Testing Summary

## Overview

The plugin now has a layered Dart-side test suite that mirrors the architecture in `lib/`:

1. Response model tests (`Result`, `NativeHttpResponse`)
2. Platform interface contract tests
3. Method channel bridge tests
4. Public API delegation tests via injected fake platform

This suite uses Flutter's native testing tools and hand-written fakes (no external mocking framework).

---

## Current Test Statistics

- **Total tests**: 55 passing
- **Test files**: 5
- **Reusable helpers**: 1 fake + 1 fixtures file
- **Last verified**: `flutter test` (all passing)

---

## Test Organization

```
test/
  fixtures/
    test_data.dart
  helpers/
    fake_mte_relay_client_plugin_platform.dart
  mte_relay_response_model_test.dart
  mte_relay_native_response_test.dart
  mte_relay_client_plugin_platform_interface_test.dart
  mte_relay_client_plugin_method_channel_test.dart
  mte_relay_client_plugin_test.dart
```

---

## File-by-File Coverage Intent

### `mte_relay_response_model_test.dart`
- Verifies `Result.fromMap()` success/error parsing
- Verifies header coercion and null handling
- Verifies `toMap()`, `bodyAsString`, and `bodyAsJsonObject`

### `mte_relay_native_response_test.dart`
- Verifies `NativeHttpResponse.fromMap()` success/error parsing
- Verifies `safeData`, `bodyAsString`, and `bodyAsJsonObject`
- Verifies `toMap()` serialization shape

### `mte_relay_client_plugin_platform_interface_test.dart`
- Verifies default platform instance type
- Verifies token enforcement in `instance` setter
- Verifies base-class `UnimplementedError` defaults

### `mte_relay_client_plugin_method_channel_test.dart`
- Verifies outgoing native method names + args for all API calls
- Verifies incoming native callbacks map to stream emissions
- Verifies broadcast behavior for callback streams

### `mte_relay_client_plugin_test.dart`
- Verifies public API delegates to `MteRelayClientPluginPlatform.instance`
- Verifies argument forwarding and returned values
- Verifies stream routing through public stream getters
- Verifies error propagation from platform layer

---

## Key Testing Patterns

### Hand-Written Fake Platform

`FakeMteRelayClientPluginPlatform` provides:
- deterministic return values
- failure flags for negative-path tests
- call counters and last-argument capture
- stream simulation helpers

### Method Channel Mocking

Method channel tests use:
- `TestDefaultBinaryMessengerBinding` for intercepting outgoing calls
- `handlePlatformMessage()` with `StandardMethodCodec` for simulating native callbacks

### Async Stream Validation

Tests subscribe to plugin streams, simulate events, then await microtask completion before asserting emitted values.

---

## Running Tests

```bash
flutter test
flutter test --coverage
flutter test test/mte_relay_client_plugin_method_channel_test.dart
```

---

## CI Coverage Gate

- Pipeline file: `azure-pipelines.yml`
- CI runs: `flutter pub get` + `flutter test --coverage`
- Coverage source: `coverage/lcov.info`
- Gate type: line coverage from LCOV totals (`LH / LF * 100`)
- Default threshold: `90%` (configurable via `coverageThreshold` variable)
- Coverage artifacts are published as build artifact `coverage`

---

## Next Improvements (Optional)

- Add dedicated tests for the fake helper itself (if we want tighter guarantees on test infrastructure behavior)
