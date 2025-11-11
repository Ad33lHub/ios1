# Build Setup Guide - Required Tools

This guide lists all the tools and software needed to build the Task Management Flutter app without errors.

## ✅ Required Tools & Software

### 1. **Flutter SDK** (Required)
- **Download**: https://docs.flutter.dev/get-started/install
- **Version**: Flutter 3.9.2 or higher
- **Check installation**: `flutter --version`
- **Verify setup**: `flutter doctor`

### 2. **Android Studio** (Required for Android builds)
- **Download**: https://developer.android.com/studio
- **Includes**:
  - Android SDK
  - Android SDK Platform-Tools
  - Android Emulator (optional, for testing)
  - Gradle build system

### 3. **Java Development Kit (JDK)** (Required)
- **Version**: JDK 11 or higher
- **Download**: 
  - Oracle JDK: https://www.oracle.com/java/technologies/downloads/
  - OpenJDK: https://adoptium.net/ (Recommended)
- **Verify**: `java -version`
- **Set JAVA_HOME** environment variable

### 4. **Android SDK** (Required)
- Usually installed with Android Studio
- **Required components**:
  - Android SDK Platform (API level 33 or higher)
  - Android SDK Build-Tools
  - Android SDK Command-line Tools
- **Location**: Usually at `C:\Users\<YourUsername>\AppData\Local\Android\Sdk`
- **Set ANDROID_HOME** environment variable

### 5. **Gradle** (Required)
- Usually bundled with Android Studio
- **Version**: 7.5 or higher
- **Verify**: `gradle --version`

## 🔧 Configuration Steps

### Step 1: Install Flutter
```bash
# Download Flutter SDK and extract it
# Add Flutter to PATH environment variable
flutter doctor
```

### Step 2: Install Android Studio
1. Download and install Android Studio
2. Open Android Studio → More Actions → SDK Manager
3. Install:
   - Android SDK Platform 33 (or latest)
   - Android SDK Build-Tools
   - Android SDK Command-line Tools
   - Android SDK Platform-Tools

### Step 3: Set Environment Variables
Add these to your system environment variables:

**Windows:**
```bash
# Flutter
FLUTTER_HOME = C:\src\flutter
PATH += %FLUTTER_HOME%\bin

# Android
ANDROID_HOME = C:\Users\<YourUsername>\AppData\Local\Android\Sdk
PATH += %ANDROID_HOME%\platform-tools
PATH += %ANDROID_HOME%\tools
PATH += %ANDROID_HOME%\tools\bin

# Java
JAVA_HOME = C:\Program Files\Java\jdk-11
PATH += %JAVA_HOME%\bin
```

### Step 4: Accept Android Licenses
```bash
flutter doctor --android-licenses
# Press 'y' to accept all licenses
```

### Step 5: Verify Installation
```bash
flutter doctor -v
```

This should show:
- ✅ Flutter (Channel stable, version 3.9.2+)
- ✅ Android toolchain (Android SDK)
- ✅ Android Studio
- ✅ VS Code or Android Studio (for editing)
- ✅ Connected device or emulator (optional)

## 🛠️ Build Configuration (Already Done)

The following configurations have been applied to fix build errors:

### 1. Core Library Desugaring (Fixed)
- **File**: `android/app/build.gradle.kts`
- **Enabled**: `isCoreLibraryDesugaringEnabled = true`
- **Dependency**: Added `desugar_jdk_libs:2.0.4`
- **Purpose**: Allows Java 8+ APIs on older Android versions

### 2. Java Version (Configured)
- **Version**: Java 11
- **Configuration**: Set in `build.gradle.kts`

### 3. Flutter Local Notifications (Updated)
- **Version**: 17.2.4 (updated from 16.3.3)
- **Reason**: Fixes compilation errors

## 📱 Building the APK

### Build Release APK
```bash
flutter clean
flutter pub get
flutter build apk --release
```

### Build App Bundle (for Google Play)
```bash
flutter build appbundle --release
```

### Output Location
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- App Bundle: `build/app/outputs/bundle/release/app-release.aab`

## 🐛 Troubleshooting

### Error: "Core library desugaring required"
✅ **Fixed**: Already enabled in `build.gradle.kts`

### Error: "Java version mismatch"
- Check Java version: `java -version`
- Should be JDK 11 or higher
- Update `JAVA_HOME` if needed

### Error: "Android SDK not found"
- Install Android Studio
- Set `ANDROID_HOME` environment variable
- Run `flutter doctor` to verify

### Error: "Gradle build failed"
- Clean build: `flutter clean`
- Update dependencies: `flutter pub get`
- Check internet connection (for downloading dependencies)

### Error: "License not accepted"
```bash
flutter doctor --android-licenses
# Accept all licenses
```

## 📋 Quick Checklist

Before building, ensure:
- [ ] Flutter SDK installed and in PATH
- [ ] Android Studio installed
- [ ] Android SDK installed (API 33+)
- [ ] JDK 11+ installed
- [ ] JAVA_HOME set
- [ ] ANDROID_HOME set
- [ ] Android licenses accepted
- [ ] `flutter doctor` shows no critical issues
- [ ] Internet connection (for downloading packages)

## 🚀 Quick Start Commands

```bash
# 1. Verify setup
flutter doctor

# 2. Get dependencies
flutter pub get

# 3. Clean previous builds
flutter clean

# 4. Build APK
flutter build apk --release

# 5. Install on device (if connected)
flutter install
```

## 📚 Additional Resources

- Flutter Installation: https://docs.flutter.dev/get-started/install
- Android Studio Setup: https://developer.android.com/studio
- Flutter Build Guide: https://docs.flutter.dev/deployment/android
- Gradle Configuration: https://docs.gradle.org/current/userguide/userguide.html

## ⚠️ Important Notes

1. **Internet Connection**: Required for downloading dependencies and packages
2. **Disk Space**: Ensure at least 2GB free space for SDKs and builds
3. **RAM**: At least 4GB RAM recommended (8GB+ preferred)
4. **Build Time**: First build may take 10-15 minutes (downloading dependencies)
5. **Subsequent Builds**: Usually faster (2-5 minutes)

## ✅ Current Project Status

All build configuration issues have been fixed:
- ✅ Core library desugaring enabled
- ✅ Java 11 configured
- ✅ Flutter local notifications updated to v17.2.4
- ✅ Android manifest permissions configured
- ✅ Dependencies updated and compatible

The app should now build successfully! 🎉


