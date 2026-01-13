# Fastlane Match Setup Guide

## Quick Start: Setting Up Match for iOS Code Signing

### Prerequisites
- ✅ Apple Developer Account
- ✅ GitHub account (or Git hosting service)
- ✅ Fastlane installed (`bundle install` in `ios/` directory)

---

## Step-by-Step Setup

### 1. Centralized Git Repository with Branch-Per-App Pattern

**This project uses a centralized repository with different branches for each app.**

**Repository:** `https://github.com/IYCLLC/ms-ios-certs.git`

**Branch Pattern:** Each app uses its own branch (e.g., `app-name`, `mvvm-template`, etc.)

**Benefits:**
- ✅ Single repository for all apps
- ✅ Easier certificate management
- ✅ Shared certificates across apps (if needed)
- ✅ Isolated certificates per app (via branches)

**If you need to create a new branch for this app:**
1. Clone the repository: `git clone https://github.com/IYCLLC/ms-ios-certs.git`
2. Create a new branch: `git checkout -b your-app-name`
3. Push the branch: `git push -u origin your-app-name`
4. Use this branch name in `MATCH_GIT_BRANCH` secret

### 2. Create Match Password

Generate a secure password to encrypt certificates:

```bash
openssl rand -base64 32
```

**Save this password securely** - you'll need it for:
- Local development
- GitHub Secrets (for CI/CD)

### 3. Initialize Match

```bash
cd ios

# Initialize Match
bundle exec fastlane match init
```

**When prompted:**
1. Select storage mode: **`git`**
2. Enter Git repository URL: `https://github.com/IYCLLC/ms-ios-certs.git`
3. Enter Match password: `[your password from step 2]`

This creates `ios/fastlane/Matchfile` with your configuration.

**For branch-per-app pattern, edit `Matchfile` and add:**
```ruby
git_url("https://github.com/IYCLLC/ms-ios-certs.git")
git_branch("your-app-name")  # Replace with your app's branch name
```

Or use environment variable `MATCH_GIT_BRANCH` (recommended for CI/CD).

### 4. Generate Certificates (First Time)

```bash
cd ios

# Generate App Store certificates (for TestFlight/App Store)
bundle exec fastlane match appstore

# Optional: Generate Development certificates (for local testing)
bundle exec fastlane match development
```

**What happens:**
- ✅ Match connects to Apple Developer Portal
- ✅ Creates/retrieves certificates and provisioning profiles
- ✅ Encrypts them with your Match password
- ✅ Pushes them to your Git repository
- ✅ Downloads and installs them locally

### 5. Verify Setup

Check your Git repository - it should contain:
```
ios-certificates/
├── certs/
│   └── distribution/
│       └── [encrypted certificate files]
├── profiles/
│   └── appstore/
│       └── [encrypted provisioning profiles]
└── README.md
```

### 6. Configure GitHub Secrets

Add these secrets to your GitHub repository:

1. **MATCH_PASSWORD**
   - Value: The password from step 2

2. **MATCH_GIT_URL**
   - Value: `https://github.com/IYCLLC/ms-ios-certs.git`

3. **MATCH_GIT_BRANCH** ⚠️ **REQUIRED for branch-per-app pattern**
   - Value: Your app's branch name (e.g., `mvvm-template`, `app-name`)
   - This tells Match which branch to use for this app's certificates

4. **MATCH_GIT_BASIC_AUTHORIZATION**
   - Create a GitHub Personal Access Token:
     - GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
     - Generate new token with `repo` scope
   - Base64 encode `username:token`:
     ```bash
     echo -n "your-username:your-token" | base64
     ```
   - Value: The base64 output

---

## Common Commands

### Sync Certificates (Read-Only)
```bash
cd ios
bundle exec fastlane match appstore --readonly
```

### Regenerate Certificates (⚠️ Use with caution)
```bash
cd ios
bundle exec fastlane match appstore --force
```

### View Match Status
```bash
cd ios
bundle exec fastlane match appstore --readonly
```

---

## Troubleshooting

### "Repository not found" Error
- ✅ Verify repository URL is correct
- ✅ Ensure repository is accessible (private repos need authentication)
- ✅ Check `MATCH_GIT_BASIC_AUTHORIZATION` secret is correct

### "Wrong password" Error
- ✅ Verify `MATCH_PASSWORD` matches the one used during `match init`
- ✅ Check GitHub Secrets are set correctly

### "No certificates found"
- ✅ Run `fastlane match appstore` first to generate certificates
- ✅ Verify certificates exist in your Git repository

---

## Security Best Practices

1. ✅ **Always use a private repository** for certificates
2. ✅ **Never commit Matchfile** to your main app repository (it's in `.gitignore`)
3. ✅ **Use strong Match password** (at least 32 characters)
4. ✅ **Rotate passwords periodically** if compromised
5. ✅ **Limit access** to the certificates repository (only CI/CD and trusted developers)

---

## Next Steps

After setting up Match:
1. ✅ Add GitHub Secrets (see step 6 above)
2. ✅ Test CI/CD deployment
3. ✅ Verify certificates are working in your Fastfile

For more details, see `CI_CD_SETUP.md`.
