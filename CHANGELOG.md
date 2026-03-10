# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
-

### Changed
-

### Fixed
-


## [4.5.0] - 2026-03-10

### Added
-

### Changed
- Migrated iOS Swift package dependency from `eclypses-aws-mte-relay-client-ios` to `mte-relay-client-ios` and updated to `4.6.0`
- Updated iOS plugin minimum deployment target to `iOS 16.0`
- Updated example app default relay server URL to `https://mte-relay-demo-relay-server.eclypses.com`

### Fixed
-


## [4.4.0] - 2026-03-05

### Added
- Comprehensive Dart test suite across response models, platform interface, method channel bridge, and public API delegation
- Reusable test fixtures and fake platform helpers under `test/fixtures` and `test/helpers`
- Testing guide in `dev_docs/TESTING_SUMMARY.md`

### Changed
- Azure pipeline aligned to shared plugin pattern: run analyze + tests with coverage on `develop` and `master`
- Release workflow script updated to also bump README git ref and include README in release commit set
- Dart SDK constraints normalized from dev SDK pins to stable-compatible constraints in root and example pubspec files

### Fixed
- Removed duplicate `4.3.0` section and duplicate reference entry in changelog
- Corrected malformed changelog release links (including `4.2.8`, `4.2.9`) and standardized tag link format
- Synced README dependency example version ref to current plugin version


## [4.3.0] - 2026-01-22

### Added
- Added dev_docs directory and release script

### Changed
- Enhanced README to be a comprehensive implementation guide, suitable for all experience levels

### Fixed
- Removed Pod-based files


## [4.2.11] - 2025-09-30

### Added 
-

### Changed
- Updated mte_relay_client_plugin.java to remove unneeded Override
- Updated pubspec.yaml to pull updated MteRelay library
- Updated Version number throughout

### Fixed
-

## [4.2.10] - 2025-09-05

### Added 
-

### Changed
- Updated mte_relay_client_plugin.java to remove unneeded Override
- Updated pubspec.yaml to pull updated MteRelay library
- Updated Version number throughout

### Fixed
-

## [4.2.9] - 2025-09-04

### Added
-

### Changed
- Updated to use Swift Package Manager instead of CocoaPods
- Updated Version number throughout

### Fixed
-

## [4.2.8] - 2025-09-03

### Added 
-

### Changed
- Updated to reference updated MteRelay for iOS
- Updated Version number throughout

### Fixed
-

## [4.2.7] - 2025-09-03

### Added 
- 

### Changed
- Updated mte_relay_client_plugin.podspec

### Fixed
-

## [4.2.6] - 2025-09-02

### Added 
-

## [4.2.5] - 2025-09-02

### Added 
-

### Changed
- Updated Version number in README.md

### Fixed
-

## [4.2.4] - 2025-09-02

### Added 
-

### Changed
- Updated Version number in pubspec.yaml

### Fixed
-

## [4.2.3] - 2025-08-27

### Added 
-

### Changed
- Updated Version number in pubspec.yaml
- Removed escape characters from Android Response Body Json
- Removed square brackets from Android Response Headers
- Upgraded iOS Relay Package which downgraded iOS Target from v16 to v14

### Fixed
-

## [4.2.2] - 2025-07-03

### Added 
-

### Fixed
-

## [4.2.1] - 2025-05-21

### Added 
-

### Changed
- Updated Version number in pubspec.yaml
- Removed escape characters from Android Response Body Json
- Removed square brackets from Android Response Headers
- Upgraded iOS Relay Package which downgraded iOS Target from v16 to v14

### Fixed
-

## [1.0.0] - Initial Release

### Added
- Initial Release. iOS plugin calls are working. Android not yet implemented.

[1.0.0]: https://github.com/Eclypses/mte-relay-client-flutter/releases/tag/v1.0.0
[4.2.1]: https://github.com/Eclypses/mte-relay-client-flutter/releases/tag/v4.2.1
[4.2.2]: https://github.com/Eclypses/mte-relay-client-flutter/releases/tag/v4.2.2
[4.2.3]: https://github.com/Eclypses/mte-relay-client-flutter/releases/tag/v4.2.3
[4.2.4]: https://github.com/Eclypses/mte-relay-client-flutter/releases/tag/v4.2.4
[4.2.5]: https://github.com/Eclypses/mte-relay-client-flutter/releases/tag/v4.2.5
[4.2.6]: https://github.com/Eclypses/mte-relay-client-flutter/releases/tag/v4.2.6
[4.2.7]: https://github.com/Eclypses/mte-relay-client-flutter/releases/tag/v4.2.7
[4.2.8]: https://github.com/Eclypses/mte-relay-client-flutter/releases/tag/v4.2.8
[4.2.9]: https://github.com/Eclypses/mte-relay-client-flutter/releases/tag/v4.2.9
[4.2.10]: https://github.com/Eclypses/mte-relay-client-flutter/releases/tag/v4.2.10
[4.2.11]: https://github.com/Eclypses/mte-relay-client-flutter/releases/tag/v4.2.11
[4.3.0]: https://github.com/Eclypses/mte-relay-client-flutter/releases/tag/v4.3.0

[4.4.0]: https://github.com/Eclypses/mte-relay-client-flutter/releases/tag/v4.4.0

[4.5.0]: https://github.com/Eclypses/mte-relay-client-flutter/releases/tag/v4.5.0
