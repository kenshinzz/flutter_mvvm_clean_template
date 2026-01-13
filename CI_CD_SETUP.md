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

| Secret | Description | How to Obtain |
|--------|-------------|---------------|
| `APP_STORE_CONNECT_API_KEY_ID` | App Store Connect API Key ID | See detailed steps below |
| `APP_STORE_CONNECT_API_ISSUER_ID` | App Store Connect Issuer ID | See detailed steps below |
| `APP_STORE_CONNECT_API_KEY_CONTENT` | API Key (.p8 file content) | See detailed steps below |
| `MATCH_PASSWORD` | Fastlane Match encryption password | See detailed steps below |
| `MATCH_GIT_URL` | Git repo URL for Match certificates | See detailed steps below |
| `MATCH_GIT_BRANCH` | Branch name for this app (branch-per-app pattern) | See detailed steps below |
| `MATCH_GIT_BASIC_AUTHORIZATION` | Base64-encoded `username:token` | See detailed steps below |

##### Step-by-Step: App Store Connect API Credentials

**1. Create App Store Connect API Key**

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Navigate to **Users and Access** → **Keys** tab
3. Click the **+** button to create a new key
4. Enter a name (e.g., "GitHub Actions CI/CD")
5. Select **Access Level**: **Admin** or **App Manager** (minimum required: **App Manager**)
6. Click **Generate**
7. **Important**: Download the `.p8` key file immediately (you can only download it once!)
8. Note down:
   - **Key ID** (e.g., `ABC123DEF4`) → This is `APP_STORE_CONNECT_API_KEY_ID`
   - **Issuer ID** (shown at top of Keys page, e.g., `12345678-1234-1234-1234-123456789012`) → This is `APP_STORE_CONNECT_API_ISSUER_ID`

**2. Get API Key Content**

The `.p8` file content is what you need for `APP_STORE_CONNECT_API_KEY_CONTENT`:

```bash
# Copy the entire content of the .p8 file (including headers)
cat AuthKey_ABC123DEF4.p8 | pbcopy

# Or read it:
cat AuthKey_ABC123DEF4.p8
```

The content should look like:
```
-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQg...
... (more lines) ...
-----END PRIVATE KEY-----
```

**3. Add to GitHub Secrets**

Go to your GitHub repository → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**:

- `APP_STORE_CONNECT_API_KEY_ID`: Paste the Key ID (e.g., `ABC123DEF4`)
- `APP_STORE_CONNECT_API_ISSUER_ID`: Paste the Issuer ID (e.g., `12345678-1234-1234-1234-123456789012`)
- `APP_STORE_CONNECT_API_KEY_CONTENT`: Paste the entire `.p8` file content (including `-----BEGIN PRIVATE KEY-----` and `-----END PRIVATE KEY-----`)

##### Step-by-Step: Fastlane Match Credentials

**1. Create Match Password**

This is a password you create yourself to encrypt certificates in the Match repository:

```bash
# Generate a secure password (or create your own)
openssl rand -base64 32
```

Save this password securely → This is `MATCH_PASSWORD`

**2. Create Private Git Repository for Certificates**

Match stores certificates and provisioning profiles in a Git repository:

1. Create a **private** repository on GitHub (e.g., `your-org/ios-certificates`)
2. Copy the repository URL → This is `MATCH_GIT_URL`
   - HTTPS: `https://github.com/your-org/ios-certificates.git`
   - SSH: `git@github.com:your-org/ios-certificates.git`

**3. Generate GitHub Personal Access Token**

For CI/CD, Match needs authentication to access the certificates repository:

1. Go to GitHub → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. Click **Generate new token (classic)**
3. Give it a name (e.g., "Fastlane Match CI/CD")
4. Select scopes:
   - ✅ `repo` (Full control of private repositories)
5. Click **Generate token**
6. **Copy the token immediately** (you won't see it again!)

**4. Create Basic Authorization**

`MATCH_GIT_BASIC_AUTHORIZATION` is Base64-encoded `username:token`:

```bash
# Replace YOUR_USERNAME and YOUR_TOKEN
echo -n "YOUR_USERNAME:YOUR_TOKEN" | base64 | pbcopy
```

Or manually:
```bash
# Example: username is "octocat", token is "ghp_1234567890abcdef"
echo -n "octocat:ghp_1234567890abcdef" | base64
# Output: b2N0b2NhdDpnaHBfMTIzNDU2Nzg5MGFiY2RlZg==
```

**5. Initialize Match Locally (First Time Setup)**

```bash
cd ios

# Initialize Match
bundle exec fastlane match init

# When prompted:
# 1. Select "git" as storage mode
# 2. Enter your Git repository URL (MATCH_GIT_URL)
# 3. Enter your Match password (MATCH_PASSWORD)

# Generate certificates for App Store
bundle exec fastlane match appstore

# Generate certificates for Development (optional, for local testing)
bundle exec fastlane match development
```

**6. Add to GitHub Secrets**

- `MATCH_PASSWORD`: Your Match encryption password
- `MATCH_GIT_URL`: Your certificates repository URL (e.g., `https://github.com/IYCLLC/ms-ios-certs.git`)
- `MATCH_GIT_BRANCH`: **Required for branch-per-app pattern** - Your app's branch name (e.g., `mvvm-template`)
- `MATCH_GIT_BASIC_AUTHORIZATION`: Base64-encoded `username:token` (e.g., `b2N0b2NhdDpnaHBfMTIzNDU2Nzg5MGFiY2RlZg==`)

##### Quick Reference: All iOS Secrets

```bash
# 1. App Store Connect API Key
APP_STORE_CONNECT_API_KEY_ID="ABC123DEF4"
APP_STORE_CONNECT_API_ISSUER_ID="12345678-1234-1234-1234-123456789012"
APP_STORE_CONNECT_API_KEY_CONTENT="-----BEGIN PRIVATE KEY-----\nMIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQg...\n-----END PRIVATE KEY-----"

# 2. Match Credentials (Centralized repo with branch-per-app)
MATCH_PASSWORD="your-secure-password-here"
MATCH_GIT_URL="https://github.com/IYCLLC/ms-ios-certs.git"
MATCH_GIT_BRANCH="your-app-name"  # Branch name for this app
MATCH_GIT_BASIC_AUTHORIZATION="$(echo -n 'username:token' | base64)"
```

##### Verify Setup

Test locally before using in CI/CD:

```bash
cd ios

# Test Match access (with branch-per-app)
MATCH_PASSWORD="your-password" \
MATCH_GIT_URL="https://github.com/IYCLLC/ms-ios-certs.git" \
MATCH_GIT_BRANCH="your-app-name" \
MATCH_GIT_BASIC_AUTHORIZATION="$(echo -n 'username:token' | base64)" \
bundle exec fastlane match appstore --readonly

# Test App Store Connect API
APP_STORE_CONNECT_API_KEY_ID="your-key-id" \
APP_STORE_CONNECT_API_ISSUER_ID="your-issuer-id" \
bundle exec fastlane run app_store_connect_api_key \
  key_id:"$APP_STORE_CONNECT_API_KEY_ID" \
  issuer_id:"$APP_STORE_CONNECT_API_ISSUER_ID" \
  key_filepath:"path/to/AuthKey_*.p8"
```

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

**⚠️ IMPORTANT: You MUST create a private Git repository for certificates before using Match.**

**1. Centralized Git Repository with Branch-Per-App Pattern**

This project uses a centralized repository: `https://github.com/IYCLLC/ms-ios-certs.git`

**Each app uses its own branch** (e.g., `mvvm-template`, `app-name`, etc.)

**If you need to create a new branch for this app:**
1. Clone the repository: `git clone https://github.com/IYCLLC/ms-ios-certs.git`
2. Create a new branch: `git checkout -b your-app-name`
3. Push the branch: `git push -u origin your-app-name`
4. Use this branch name in `MATCH_GIT_BRANCH` secret

**Benefits:**
- ✅ Single repository for all apps
- ✅ Easier certificate management
- ✅ Isolated certificates per app (via branches)

**2. Create Match Password**

Generate a secure password to encrypt certificates in the repository:

```bash
# Generate a secure password
openssl rand -base64 32

# Or create your own strong password
# Save this password securely - you'll need it for CI/CD
```

**3. Initialize Match**

```bash
cd ios

# Initialize Match (this will create Matchfile)
bundle exec fastlane match init

# When prompted:
# 1. Select "git" as storage mode
# 2. Enter your Git repository URL: https://github.com/IYCLLC/ms-ios-certs.git
# 3. Enter your Match password (from step 2)
#
# After initialization, edit Matchfile and add:
# git_branch("your-app-name")  # Or use MATCH_GIT_BRANCH env var
```

This creates a `Matchfile` in `ios/fastlane/` with your configuration.

**4. Generate Certificates (First Time Only)**

```bash
cd ios

# Generate App Store certificates (for TestFlight/App Store)
bundle exec fastlane match appstore

# Generate Development certificates (optional, for local testing)
bundle exec fastlane match development
```

**What happens:**
- Match connects to Apple Developer Portal
- Creates/retrieves certificates and provisioning profiles
- Encrypts them with your Match password
- Stores them in your Git repository
- Downloads and installs them locally

**5. Verify Certificates Repository**

Check your Git repository - it should now contain:
```
ios-certificates/
├── certs/
│   └── distribution/
│       └── [encrypted certificate files]
├── profiles/
│   └── appstore/
│       └── [encrypted provisioning profiles]
└── README.md (auto-generated by Match)
```

**6. Add GitHub Secrets**

Add these to your GitHub repository secrets:

- `MATCH_PASSWORD`: The password you created in step 2
- `MATCH_GIT_URL`: Your certificates repository URL (from step 1)
- `MATCH_GIT_BASIC_AUTHORIZATION`: Base64-encoded `username:token` (see Step 1 above for how to create this)

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

