# App Versioning Guide

This document explains how versioning works in this Flutter project and how to manage versions.

## Version Format

The app uses **Semantic Versioning** (SemVer) format: `MAJOR.MINOR.PATCH+BUILD`

- **MAJOR**: Incremented for incompatible API changes
- **MINOR**: Incremented for backwards-compatible functionality additions
- **PATCH**: Incremented for backwards-compatible bug fixes
- **BUILD**: Incremented for each build (can be used for CI/CD build numbers)

Example: `1.2.3+45` means version 1.2.3 with build number 45.

## Version Storage

The version is stored in **`pubspec.yaml`**:

```yaml
version: 1.0.0+1
```

Flutter automatically syncs this version to:
- **Android**: `versionName` (1.0.0) and `versionCode` (1)
- **iOS**: `CFBundleShortVersionString` (1.0.0) and `CFBundleVersion` (1)

## Version Management

### Using Makefile Commands

```bash
# Show current version
make version-app

# Bump patch version (1.0.0 -> 1.0.1)
make version-bump-patch

# Bump minor version (1.0.0 -> 1.1.0)
make version-bump-minor

# Bump major version (1.0.0 -> 2.0.0)
make version-bump-major

# Bump build number only (1.0.0+1 -> 1.0.0+2)
make version-bump-build

# Set version explicitly
make version-set VERSION=1.2.3 BUILD=10
```

### Using Version Script Directly

```bash
# Show current version
./scripts/version.sh get

# Bump version
./scripts/version.sh bump [major|minor|patch|build]

# Set version explicitly
./scripts/version.sh set 1.2.3 10
```

## Accessing Version in Code

Use the `VersionInfo` utility class:

```dart
import 'package:speckit_flutter_template/core/utils/version_info.dart';

// Get version string (e.g., "1.0.0")
String version = VersionInfo.version;

// Get build number (e.g., "1")
String buildNumber = VersionInfo.buildNumber;

// Get full version (e.g., "1.0.0+1")
String fullVersion = VersionInfo.fullVersion;

// Get app name
String appName = VersionInfo.appName;
```

**Important**: Call `VersionInfo.initialize()` once at app startup (already done in `main.dart`).

## CI/CD Versioning

### GitHub Actions

When deploying via GitHub Actions:

1. **Tag-based releases**: Create a git tag with version:
   ```bash
   git tag v1.2.3
   git push origin v1.2.3
   ```

2. **Automatic version sync**: Fastlane automatically syncs version from `pubspec.yaml` to iOS during build.

3. **Build numbers**: For iOS, you can use:
   - `GITHUB_RUN_NUMBER` (GitHub Actions run number)
   - Timestamp-based build numbers
   - Or keep build number from `pubspec.yaml`

### Fastlane

#### iOS

The iOS Fastlane lanes automatically sync version from `pubspec.yaml`:

```ruby
# Automatically syncs version from pubspec.yaml
sync_version_from_pubspec
```

This updates:
- `CFBundleShortVersionString` (version name)
- `CFBundleVersion` (build number)

#### Android

Android automatically reads version from `pubspec.yaml` via Flutter's Gradle plugin. No additional configuration needed.

## Version Display in UI

The app displays version in:
- **Settings Page**: Shows version in the About card
- **About Dialog**: Shows version when tapping "About" in the drawer

Both use `VersionInfo.version` to display the current version dynamically.

## Best Practices

1. **Single Source of Truth**: Always update version in `pubspec.yaml` - never manually edit Android or iOS version files.

2. **Semantic Versioning**: Follow SemVer rules:
   - **MAJOR**: Breaking changes
   - **MINOR**: New features (backwards compatible)
   - **PATCH**: Bug fixes

3. **Build Numbers**: Increment build number for every build, even if version name doesn't change.

4. **Pre-release**: Before releasing:
   ```bash
   # Bump version
   make version-bump-patch
   
   # Commit version change
   git add pubspec.yaml
   git commit -m "chore: bump version to 1.0.1"
   
   # Tag release
   git tag v1.0.1
   git push origin main --tags
   ```

5. **Version Tags**: Use git tags for releases:
   ```bash
   git tag v1.2.3
   git push origin v1.2.3
   ```

## Troubleshooting

### Version not updating in app

1. Ensure `VersionInfo.initialize()` is called in `main.dart`
2. Rebuild the app (hot reload doesn't update version info)
3. Check `pubspec.yaml` has correct version format

### iOS version mismatch

1. Ensure Fastlane `sync_version_from_pubspec` is called before build
2. Check `Runner.xcodeproj` project settings
3. Verify `pubspec.yaml` version format is correct

### Android version mismatch

1. Android reads directly from `pubspec.yaml` via Flutter
2. Clean and rebuild: `flutter clean && flutter build apk`
3. Verify `pubspec.yaml` version format

## Examples

### Release Workflow

```bash
# 1. Update version
make version-bump-patch

# 2. Review changes
git diff pubspec.yaml

# 3. Commit version bump
git add pubspec.yaml
git commit -m "chore: bump version to 1.0.1"

# 4. Tag release
git tag v1.0.1
git push origin main --tags

# 5. CI/CD will automatically build and deploy
```

### Development Workflow

```bash
# For each build during development
make version-bump-build

# This increments build number: 1.0.0+1 -> 1.0.0+2
# Useful for tracking builds without changing version name
```

## Related Files

- `pubspec.yaml`: Version source of truth
- `scripts/version.sh`: Version management script
- `lib/core/utils/version_info.dart`: Version utility class
- `ios/fastlane/Fastfile`: iOS version sync
- `android/fastlane/Fastfile`: Android version info
- `Makefile`: Version management commands
