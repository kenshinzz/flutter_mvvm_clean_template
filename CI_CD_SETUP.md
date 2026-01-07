# CI/CD Setup Guide

This project uses **GitHub Actions** for CI/CD and **Fastlane** for app deployment.

## Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        GitHub Actions                            │
├─────────────────────────────────────────────────────────────────┤
│  CI (ci.yml)                                                    │
│  ├── Analyze & Test                                             │
│  ├── Build Android APK                                          │
│  └── Build iOS (no codesign)                                    │
├─────────────────────────────────────────────────────────────────┤
│  CD Android (cd-android.yml)                                    │
│  └── Fastlane → Play Store                                      │
├─────────────────────────────────────────────────────────────────┤
│  CD iOS (cd-ios.yml)                                            │
│  └── Fastlane → TestFlight / App Store                          │
└─────────────────────────────────────────────────────────────────┘
```

## GitHub Actions Workflows

### 1. CI Workflow (`ci.yml`)

**Triggers:** Push/PR to `main` or `develop`

| Job | Description |
|-----|-------------|
| `analyze-and-test` | Runs `flutter analyze` and `flutter test` |
| `build-android` | Builds debug and release APKs |
| `build-ios` | Builds iOS without code signing |

### 2. CD Android (`cd-android.yml`)

**Triggers:** Push tags `v*` or manual dispatch

Deploys to Google Play Store using Fastlane.

### 3. CD iOS (`cd-ios.yml`)

**Triggers:** Push tags `v*` or manual dispatch

Deploys to TestFlight/App Store using Fastlane.

---

## Setup Instructions

### Step 1: GitHub Secrets

Add these secrets to your GitHub repository:

#### Android Secrets

| Secret | Description |
|--------|-------------|
| `ANDROID_KEYSTORE_BASE64` | Base64-encoded upload keystore |
| `ANDROID_KEY_ALIAS` | Key alias |
| `ANDROID_KEY_PASSWORD` | Key password |
| `ANDROID_STORE_PASSWORD` | Keystore password |
| `GOOGLE_PLAY_JSON_KEY` | Google Play Service Account JSON |

**Generate Base64 keystore:**
```bash
base64 -i upload-keystore.jks | pbcopy
```

#### iOS Secrets

| Secret | Description |
|--------|-------------|
| `APP_STORE_CONNECT_API_KEY_ID` | App Store Connect API Key ID |
| `APP_STORE_CONNECT_API_ISSUER_ID` | App Store Connect Issuer ID |
| `APP_STORE_CONNECT_API_KEY_CONTENT` | API Key (.p8 file content) |
| `MATCH_PASSWORD` | Fastlane Match encryption password |
| `MATCH_GIT_URL` | Git repo URL for Match certificates |
| `MATCH_GIT_BASIC_AUTHORIZATION` | Base64-encoded `username:token` |

### Step 2: Local Fastlane Setup

#### Install Fastlane

```bash
# macOS
brew install fastlane

# Or using RubyGems
gem install fastlane
```

#### iOS Setup

```bash
cd ios
bundle install
```

Update `ios/fastlane/Appfile`:
```ruby
app_identifier("your.bundle.id")
apple_id("your@email.com")
team_id("YOUR_TEAM_ID")
```

#### Android Setup

```bash
cd android
bundle install
```

Update `android/fastlane/Appfile`:
```ruby
json_key_file("fastlane/google-play-key.json")
package_name("your.package.name")
```

### Step 3: Code Signing

#### iOS - Using Fastlane Match

1. Create a private Git repo for certificates
2. Initialize Match:
   ```bash
   cd ios
   fastlane match init
   ```
3. Generate certificates:
   ```bash
   fastlane match appstore
   fastlane match development
   ```

#### Android - Create Upload Key

1. Generate keystore:
   ```bash
   keytool -genkey -v -keystore upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias upload
   ```

2. Create `android/key.properties`:
   ```properties
   storePassword=YOUR_STORE_PASSWORD
   keyPassword=YOUR_KEY_PASSWORD
   keyAlias=upload
   storeFile=../upload-keystore.jks
   ```

3. Update `android/app/build.gradle.kts` for release signing

---

## Fastlane Commands

### iOS

```bash
cd ios

# Deploy to TestFlight
bundle exec fastlane beta

# Deploy to App Store
bundle exec fastlane release

# Sync certificates
bundle exec fastlane sync_certs

# Register new device
bundle exec fastlane register_device
```

### Android

```bash
cd android

# Deploy to Internal Testing
bundle exec fastlane beta

# Deploy to Production
bundle exec fastlane release

# Promote from Internal to Production
bundle exec fastlane promote_to_production

# Deploy to Firebase App Distribution
bundle exec fastlane firebase
```

---

## Workflow Examples

### Automatic Deployment on Tag

```bash
# Create and push a version tag
git tag v1.0.0
git push origin v1.0.0
```

This triggers:
- `cd-android.yml` → Deploys to Play Store Internal Testing
- `cd-ios.yml` → Deploys to TestFlight

### Manual Deployment

1. Go to GitHub → Actions
2. Select `CD Android` or `CD iOS`
3. Click "Run workflow"
4. Choose lane (`beta` or `release`)

---

## File Structure

```
.github/
└── workflows/
    ├── ci.yml              # CI workflow
    ├── cd-android.yml      # Android deployment
    └── cd-ios.yml          # iOS deployment

android/
├── Gemfile                 # Ruby dependencies
└── fastlane/
    ├── Appfile             # App configuration
    ├── Fastfile            # Fastlane lanes
    └── Pluginfile          # Fastlane plugins

ios/
├── Gemfile                 # Ruby dependencies
└── fastlane/
    ├── Appfile             # App configuration
    ├── Fastfile            # Fastlane lanes
    └── Pluginfile          # Fastlane plugins
```

---

## Troubleshooting

### Common Issues

1. **Build fails with code signing error (iOS)**
   - Run `fastlane match appstore --readonly` locally
   - Ensure `MATCH_PASSWORD` secret is correct

2. **Play Store upload fails**
   - Verify Service Account has proper permissions
   - App must have at least one manual upload first

3. **Flutter version mismatch**
   - Update `FLUTTER_VERSION` in workflow files

### Debug Locally

```bash
# Test Android build
flutter build appbundle --release

# Test iOS build
flutter build ios --release --no-codesign

# Run Fastlane with verbose output
bundle exec fastlane beta --verbose
```

---

## Additional Resources

- [Fastlane Documentation](https://docs.fastlane.tools/)
- [GitHub Actions for Flutter](https://docs.github.com/en/actions)
- [App Store Connect API](https://developer.apple.com/app-store-connect/api/)
- [Google Play Developer API](https://developers.google.com/android-publisher)

