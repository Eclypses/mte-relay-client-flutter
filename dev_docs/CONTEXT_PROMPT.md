

## Context

Read these files to provide Context for this prompt:
- LIBRARY_CONTEXT.md - Library architecture, public API, and platform integration

- TESTING_SUMMARY.md - Copied from socketx-client-flutter for your reference, then edit to conform to this project.


## Rules

- Simpler is better.
- Choose understandability over absolute conciseness and efficiency.
- Maintainability is high priority.
- Choose native over 3rd party when possible. 
- Let's talk about it when these rules need to be bent a little, in your estimation.


## For Testing Tasks

When adding or improving tests for this library, follow these guidelines:

### 1. **Planning Phase**
- Start by reading LIBRARY_CONTEXT.md to understand the plugin architecture
- Read TESTING_SUMMARY.md to understand established patterns
- Identify the testing layer needed (error models, platform interface, method channel, public API)
- Check existing test utilities in test/helpers/ for reusable code

### 2. **Test Organization**
- Mirror the source code structure in the test/ directory
- Place test helpers in test/helpers/
- Place test fixtures in test/fixtures/
- Name test files to match the source file: `socketx_client.dart` → `socketx_client_test.dart`

### 3. **Testing Strategy**
- **Error Model Tests**: Test pure Dart models first (fastest, easiest)
  - `SocketXError.fromMap()` factory, `SocketXErrorType.fromString()` parsing
  - Use test fixtures from test_data.dart
  - Focus on edge cases: missing keys, unknown types, case sensitivity
  
- **Platform Interface Tests**: Test the abstract contract
  - Default instance type, instance setter with token verification
  - UnimplementedError defaults for all base class methods
  
- **Method Channel Tests**: Test Dart ↔ Native bridge
  - Use `TestDefaultBinaryMessengerBinding` to mock the native side
  - Test outgoing calls (connect, disconnect, sendText, sendBinary)
  - Simulate incoming native callbacks (onConnected, onMessage, onError)
  - Verify stream behavior: broadcast, ordering, multiple listeners
  
- **Public API Tests**: Test SocketXClient with injected fake
  - Use FakeSocketXClientPlatform for platform simulation
  - Verify all methods delegate correctly
  - Test stream routing from platform to public API
  - Test error propagation

### 4. **Test Quality Guidelines**
- ✅ **DO**: Use descriptive test names ("should emit text message on onMessageStream")
- ✅ **DO**: Follow Arrange-Act-Assert pattern
- ✅ **DO**: Test behavior, not implementation details
- ✅ **DO**: Make tests independent (can run in any order)
- ✅ **DO**: Handle async properly (await, Future.delayed for streams)
- ✅ **DO**: Test edge cases (empty, null, special characters, large data)
- ✅ **DO**: Test error paths and recovery
- ❌ **DON'T**: Test private methods or variables
- ❌ **DON'T**: Rely on external services or real SocketX servers
- ❌ **DON'T**: Create brittle tests that break with refactoring

### 5. **Coverage Goals**
- Target 90%+ code coverage (achievable since this is a small library)
- Current coverage: 100% line coverage across all 3 library files
- Prioritize testing:
  1. Error model parsing (pure Dart, no dependencies)
  2. Method channel bridge (outgoing calls + incoming callbacks)
  3. Public API delegation and stream routing
  4. Platform interface contract

### 6. **Reusable Patterns**
Refer to TESTING_SUMMARY.md for patterns:
- Mocking method channels with `TestDefaultBinaryMessengerBinding`
- Simulating native callbacks
- Hand-written fakes with `MockPlatformInterfaceMixin`
- Testing broadcast stream behavior
- Testing error propagation through layers

### 7. **Running Tests**
```bash
flutter test                    # Run all tests
flutter test --coverage         # Generate coverage report
flutter test path/to/test.dart  # Run specific test file
```


## Task Template for Future Work

### For New Features:
1. Understand the feature requirements
2. Identify components that need testing
3. Choose appropriate testing layer(s)
4. Write tests following established patterns
5. Ensure all tests pass before implementation
6. Update TESTING_SUMMARY.md if introducing new patterns

### For Bug Fixes:
1. Write a failing test that reproduces the bug
2. Fix the bug
3. Verify the test now passes
4. Add related edge case tests
5. Run full test suite to prevent regressions

### For Refactoring:
1. Ensure comprehensive test coverage exists first
2. Run tests before refactoring
3. Refactor code
4. Run tests again - they should still pass
5. If tests break, either fix the refactoring or update tests (only if the contract changed) 