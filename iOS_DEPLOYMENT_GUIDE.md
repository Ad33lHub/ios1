# Task Management App - iOS Deployment Guide

This guide walks you through preparing the Flutter app for iOS deployment via Codemagic CI/CD.

## Project Setup (Already Completed ✅)

✅ **Podfile** - Created with iOS 12.0 deployment target
✅ **codemagic.yaml** - CI/CD workflow configuration
✅ **ExportOptions.plist** - iOS app export settings
✅ **Info.plist** - Configured with all required permissions:
   - Photo Library access
   - Camera access
   - Microphone access
   - Calendar access
   - Reminders access
   - Background modes (fetch, remote-notification)

## Prerequisites

Before building on Codemagic, you need:

1. **Apple Developer Account** - Required for code signing
   - Visit: https://developer.apple.com/
   - Enroll in Apple Developer Program ($99/year)

2. **GitHub Repository** - To connect with Codemagic
   - Push this code to GitHub
   - Codemagic will clone and build automatically

3. **Codemagic Account** - Free tier available
   - Sign up at: https://codemagic.io/
   - Connect your GitHub account

## Step 1: Prepare Your GitHub Repository

Run these commands from your project root:

```bash
# Initialize git if not done
git init

# Add all files
git add .

# Commit changes
git commit -m "Prepare app for iOS deployment with Codemagic"

# Add remote (replace YOUR_USERNAME and REPO_NAME)
git remote add origin https://github.com/YOUR_USERNAME/task_mgmt.git
git branch -M main
git push -u origin main
```

## Step 2: Create App Store Connect Records

1. Go to https://appstoreconnect.apple.com
2. Create a new app with these details:
   - **App Name**: Task Management
   - **Bundle ID**: com.taskmgmt.app (or your custom ID)
   - **SKU**: unique identifier (e.g., TASKMGMT001)
   - **Platform**: iOS

3. Create an **App Store Connect API Key** for Codemagic:
   - Users & Access → Keys → App Store Connect API
   - Create new key with role: **Admin**
   - Download the private key (.p8 file)
   - Note the: Issuer ID and Key ID

## Step 3: Configure Codemagic

### 3.1 Sign Up & Connect Repository

1. Go to https://codemagic.io/
2. Sign up with GitHub
3. Click "Add Application"
4. Select your `task_mgmt` repository
5. Click "Connect"

### 3.2 Configure Build Settings

1. In Codemagic, go to **Project Settings**
2. Select **Build configuration** tab
3. Set:
   - **Platform**: Flutter
   - **Flutter Channel**: stable
   - **Build type**: iOS app for distribution (ipa)
   - **Xcode version**: Latest available

### 3.3 Setup Code Signing

1. Go to **Project Settings** → **Code signing**
2. Under **iOS signing**:
   - Click "Add" for App Store Connect API Key
   - Upload your `.p8` private key file
   - Enter Issuer ID and Key ID
   - Select the app from App Store Connect
   - Click "Create"

### 3.4 Configure Environment Variables (Optional)

If you want to set bundle ID or version dynamically:

1. Go to **Project Settings** → **Variables**
2. Add:
   - `BUNDLE_ID`: com.taskmgmt.app
   - `APP_VERSION`: 1.0.0

3. Update `codemagic.yaml`:
   ```yaml
   build_number: $(($(date +%s) / 60))
   ```

## Step 4: Trigger Your First Build

1. In Codemagic, click **"Start new build"** on your project
2. Select **"ios-release"** workflow
3. Click **"Build"**

The build will:
- Clone your GitHub repo
- Run `flutter pub get`
- Run `pod install`
- Run `flutter analyze`
- Build release iOS app
- Generate IPA file

This takes approximately 15-20 minutes.

## Step 5: Distribute Your App

### Option A: TestFlight (Recommended)

1. In Codemagic build settings, enable **TestFlight distribution**:
   - Go to **Project Settings** → **Publishing**
   - Under **App Store Connect**:
     - Check "Publish to TestFlight"
     - Codemagic will auto-publish successful builds

2. In App Store Connect:
   - Go to your app → TestFlight
   - Add internal testers (emails)
   - Invite them to test

3. Testers receive email link and can install via TestFlight app

### Option B: Manual Distribution

1. Download IPA from Codemagic:
   - Go to **Build artifacts**
   - Download `.ipa` file

2. Use one of these methods:
   - **TestFlight**: Drag IPA into App Store Connect Web
   - **Ad-Hoc**: Distribute to specific device UDIDs
   - **Enterprise**: Distribute internally (requires Enterprise license)

### Option C: App Store

1. Configure app details in App Store Connect:
   - Screenshots
   - Description
   - Privacy Policy
   - Support email

2. Submit for review in App Store Connect

3. Apple reviews (typically 24-48 hours)

4. Once approved, your app is live!

## Troubleshooting

### Build Fails: Pod Install Error
```bash
# On Mac (if building locally)
cd ios
rm -rf Pods
pod install --repo-update
cd ..
```

### Build Fails: Swift Version Mismatch
- Check `codemagic.yaml` for correct Xcode version
- Update iOS deployment target in `ios/Podfile` if needed

### Build Succeeds but App Crashes
- Check Codemagic build logs
- Check device logs in Xcode (if testing locally on Mac)
- Verify all required permissions in `Info.plist`

### IPA Size Too Large
- Run `flutter build ios --release --split-per-abi` (on Mac)
- Codemagic may auto-split for App Store

## Bundle ID Configuration

Currently set to: **com.taskmgmt.app**

To change bundle ID:
1. Update in `ios/ExportOptions.plist`
2. Update in `codemagic.yaml` (BUNDLE_ID variable)
3. Configure in App Store Connect to match

## App Icons

Add your app icons here:
```
ios/Runner/Assets.xcassets/AppIcon.appiconset/
```

Sizes needed:
- 20x20 (notifications)
- 29x29 (settings)
- 40x40 (spotlight)
- 60x60 (app)
- 76x76 (iPad)
- 120x120 (app high-res)
- 167x167 (iPad pro)
- 180x180 (app max)

## Next Steps

1. **Push to GitHub** - Commit and push all changes
2. **Setup Codemagic** - Follow the configuration steps above
3. **Trigger Build** - Start your first iOS build
4. **Test on Device** - Use TestFlight to test on real iOS device
5. **Submit to App Store** - Once tested, submit for review

## Resources

- [Flutter iOS Deployment](https://flutter.dev/docs/deployment/ios)
- [Codemagic Documentation](https://docs.codemagic.io/)
- [App Store Connect](https://appstoreconnect.apple.com/)
- [Apple Developer Program](https://developer.apple.com/programs/)

## Support

For issues:
- Check Codemagic build logs
- Review Flutter documentation
- Check Apple Developer forums
