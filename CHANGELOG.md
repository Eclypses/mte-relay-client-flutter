# Changelog

All notable changes to this project will be documented in this file.

## [4.2.2] - 2025-05-21

### Added
- Added convenience getters to Result class
- Added NativeHttpResponse class to map responses from Native code. 

### Changed
- Updated Version number in pubspec.yaml

[4.2.2]: https://github.com/Eclypses/eclypses-aws-mte-relay-client-ios/releases/tag/4.2.2
<br><br>

## [4.2.1] - 2025-05-21

### Added
 

### Changed
- Updated README to correct method signatures
- Updated Version number in pubspec.yaml
- Various minor bug fixes

### Fixed
- Reurning 'Result' for logging methods

[4.2.1]: https://github.com/Eclypses/eclypses-aws-mte-relay-client-ios/releases/tag/4.2.1
<br><br>

## [4.2.0] - 2025-05-17

### Added
- Added Native Logging To File, available to Flutter (work in progress)
- Added Native http response StatusCode values to result object and FileStreamResponseStream arguments. 

### Changed
- Set Native default pairPoolSize to 5.

### Fixed
- Swift - Fixed null exception where we tried to remove non-existant storedHost.
- Removed debug comments

[4.2.0]: https://github.com/Eclypses/eclypses-aws-mte-relay-client-ios/releases/tag/4.2.0
<br><br>
## 1.0.0

* Initial Release. iOS plugin calls are working. Android not yet implemented.
