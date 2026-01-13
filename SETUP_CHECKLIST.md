# Setup Checklist

This checklist helps ensure your template is properly configured before using it in production.

## 🔴 Critical - Must Configure Before Production

### 1. Application Identity

- [ ] **Android Package Name** (`android/app/build.gradle.kts`)
  - Current: `com.example.speckit_flutter_template`
  - Change to: `com.yourcompany.yourapp`
  - Also update in `android/fastlane/Appfile`

- [ ] **iOS Bundle Identifier** (`ios/fastlane/Appfile`)
  - Current: `com.example.speckitFlutterTemplate`
  - Change to: `com.yourcompany.yourapp`
  - Update in Xcode project settings

- [ ] **App Display Name**
  - Android: `android/app/src/main/AndroidManifest.xml` → `android:label`
  - iOS: `ios/Runner/Info.plist` → `CFBundleDisplayName`
  - Current: "speckit_flutter_template" / "Speckit Flutter Template"

### 2. API Configuration

- [ ] **API Base URLs** (`lib/core/config/env_config.dart`)
  - Dev: `https://dev-api.example.com` → Your dev API
  - Staging: `https://staging-api.example.com` → Your staging API
  - Prod: `https://api.example.com` → Your production API

- [ ] **API Constants** (`lib/core/constants/app_constants.dart`)
  - Update `baseUrl` if using a single environment
  - Verify timeout values match your API requirements

### 3. Code Signing

- [ ] **Android Release Signing** (`android/app/build.gradle.kts`)
  - Currently using debug keys (line 37)
  - Create release keystore:
    ```bash
    keytool -genkey -v -keystore upload-keystore.jks \
      -keyalg RSA -keysize 2048 -validity 10000 \
      -alias upload
    ```
  - Create `android/key.properties`:
    ```properties
    storePassword=YOUR_STORE_PASSWORD
    keyPassword=YOUR_KEY_PASSWORD
    keyAlias=upload
    storeFile=../upload-keystore.jks
    ```
  - Update `build.gradle.kts` to use release signing config

- [ ] **iOS Code Signing**
  - ⚠️ **REQUIRED**: Create a private Git repository for certificates
    - See `ios/fastlane/MATCH_SETUP.md` for detailed instructions
  - Set up certificates via Fastlane Match:
    ```bash
    cd ios
    bundle exec fastlane match init
    bundle exec fastlane match appstore
    ```
  - Update `ios/fastlane/Appfile` with your Apple ID and Team ID

### 4. Fastlane Configuration

- [ ] **iOS Fastlane** (`ios/fastlane/Appfile`)
  - Update `apple_id("your-apple-id@example.com")`
  - Update `team_id("YOUR_TEAM_ID")` if needed
  - Configure Match for certificate management

- [ ] **Android Fastlane** (`android/fastlane/Appfile`)
  - Update `package_name("com.example.speckit_flutter_template")`
  - Add `google-play-key.json` to `android/fastlane/`
  - Set up Google Play Service Account

### 5. GitHub Configuration

- [ ] **Repository URLs** (`README.md`)
  - Replace `YOUR_USERNAME` with your GitHub username
  - Update clone URL in README
  - Update CI badge URL

- [ ] **GitHub Secrets** (for CI/CD)
  - Android:
    - `ANDROID_KEYSTORE_BASE64`
    - `ANDROID_KEY_ALIAS`
    - `ANDROID_KEY_PASSWORD`
    - `ANDROID_STORE_PASSWORD`
    - `GOOGLE_PLAY_JSON_KEY`
  - iOS:
    - `APP_STORE_CONNECT_API_KEY_ID`
    - `APP_STORE_CONNECT_API_ISSUER_ID`
    - `APP_STORE_CONNECT_API_KEY_CONTENT`
    - `MATCH_PASSWORD`
    - `MATCH_GIT_URL`
    - `MATCH_GIT_BRANCH` (branch name for this app in centralized repo)
    - `MATCH_GIT_BASIC_AUTHORIZATION`
  - **📖 See `CI_CD_SETUP.md` for detailed step-by-step instructions on obtaining these secrets**

## 🟡 Important - Recommended Before Production

### 6. Documentation

- [ ] **LICENSE File**
  - Add appropriate license (MIT, Apache 2.0, etc.)
  - Update `pubspec.yaml` if publishing to pub.dev

- [ ] **CHANGELOG.md**
  - Create changelog for version tracking
  - Follow [Keep a Changelog](https://keepachangelog.com/) format

- [ ] **CONTRIBUTING.md** (Optional)
  - Add contribution guidelines if accepting contributions

- [ ] **SECURITY.md** (Optional)
  - Add security policy for vulnerability reporting

### 7. App Metadata

- [ ] **App Icons**
  - Replace default Flutter icons with your app icons
  - Android: `android/app/src/main/res/mipmap-*/`
  - iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

- [ ] **Splash Screen**
  - Customize splash screen assets
  - Update `ios/Runner/Base.lproj/LaunchScreen.storyboard`
  - Update Android launch theme

- [ ] **App Description** (`pubspec.yaml`)
  - Update `description` field
  - Add repository URL if public

### 8. Environment Variables

- [ ] **Create `.env.example`** (Optional)
  - Document required environment variables
  - Example:
    ```env
    API_BASE_URL=https://api.example.com
    API_KEY=your_api_key_here
    ```

### 9. Testing

- [ ] **Update Test Mocks**
  - Ensure all mocks are generated: `dart run build_runner build`
  - Review test coverage
  - Add integration tests for critical flows

- [ ] **Golden Tests**
  - Update golden images if UI changed
  - Verify CI golden tests pass

### 10. Security Review

- [ ] **API Keys & Secrets**
  - Never commit API keys or secrets
  - Use environment variables or secure storage
  - Review `.gitignore` includes all sensitive files

- [ ] **Permissions**
  - Review AndroidManifest.xml permissions
  - Review iOS Info.plist permissions
  - Request only necessary permissions

- [ ] **Network Security**
  - Configure Android Network Security Config if needed
  - Review SSL pinning requirements
  - Verify HTTPS-only API calls

## 🟢 Nice to Have - Optional Enhancements

### 11. Additional Features

- [ ] **Crash Reporting**
  - Integrate Firebase Crashlytics or Sentry
  - Update `env_config.dart` `enableCrashlytics` flag

- [ ] **Analytics**
  - Add Firebase Analytics or similar
  - Configure event tracking

- [ ] **Push Notifications**
  - Set up FCM (Firebase Cloud Messaging)
  - Configure notification handling

- [ ] **Deep Linking**
  - Configure universal links (iOS)
  - Configure app links (Android)
  - Update GoRouter with deep link handling

### 12. Performance

- [ ] **Performance Monitoring**
  - Add performance monitoring tools
  - Set up performance budgets

- [ ] **Asset Optimization**
  - Optimize images and assets
  - Use appropriate image formats (WebP, etc.)

### 13. Accessibility

- [ ] **Accessibility Testing**
  - Test with screen readers
  - Verify semantic labels
  - Test with accessibility tools

## 📋 Quick Verification Commands

```bash
# Verify no placeholder values remain
grep -r "example.com\|YOUR_\|PLACEHOLDER\|CHANGE_ME" --exclude-dir=build --exclude-dir=.dart_tool --exclude-dir=.git .

# Check for TODO comments
grep -r "TODO\|FIXME" --exclude-dir=build --exclude-dir=.dart_tool --exclude-dir=.git lib/

# Verify builds work
flutter build apk --release --split-per-abi
flutter build ios --release --no-codesign

# Run all tests
flutter test --coverage
flutter analyze
```

## 🎯 Priority Order

1. **Before First Commit**: Items 1-3 (Identity, API, Signing)
2. **Before First Release**: Items 4-5 (Fastlane, GitHub)
3. **Before Public Release**: Items 6-10 (Documentation, Security)
4. **Ongoing**: Items 11-13 (Enhancements)

---

**Note**: This is a template project. Many placeholder values are intentional and should be replaced when using this template for a real project.
