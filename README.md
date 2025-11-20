# 📱 Task Management App

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![SQLite](https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white)](https://sqlite.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

A beautiful, modern Flutter task management application featuring glassmorphism design, local notifications, SQLite database, and comprehensive task organization capabilities. Built with Material Design 3 and optimized for both Android and iOS platforms.

## ✨ Features

### 🎯 Core Functionality
- ✅ **Complete Task Management**: Create, read, update, and delete tasks with ease
- ✅ **Smart Task Views**: Today Tasks, Completed Tasks, and Repeated Tasks screens
- ✅ **Subtasks & Progress Tracking**: Add subtasks with visual progress bars
- ✅ **Repeat Tasks**: Daily and weekly recurring tasks with automatic scheduling
- ✅ **Local Notifications**: Scheduled reminders with customizable sounds
- ✅ **Export Capabilities**: Export tasks to CSV and PDF formats
- ✅ **Theme Customization**: Light, dark, and system theme modes
- ✅ **Glassmorphism UI**: Premium frosted glass design with neon accents

### 🛠️ Technical Features
- 🗄️ **SQLite Database**: Robust local data storage with optimized queries
- 🔔 **Advanced Notifications**: Timezone-aware scheduling with permission handling
- 📊 **Progress Visualization**: Real-time progress tracking for tasks and subtasks
- 🔄 **Automatic Task Reset**: Smart handling of completed repeated tasks
- 📱 **Cross-Platform**: Native Android and iOS support
- 🎨 **Modern UI**: Glassmorphism design with smooth animations

## 📸 Screenshots

| Home Screen | Today Tasks | Add Task |
|-------------|-------------|----------|
| ![Home](screenshots/home.png) | ![Today](screenshots/today.png) | ![Add](screenshots/add_task.png) |

*Add your app screenshots to the `screenshots/` directory*

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK (bundled with Flutter)
- Android Studio / VS Code with Flutter extensions
- Xcode (for iOS development on macOS)

### Quick Start
```bash
# Clone the repository
git clone <repository-url>
cd task_mgmt

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Platform-Specific Setup

#### Android
```bash
# Build debug APK
flutter build apk

# Build release APK
flutter build apk --release
```

#### iOS (macOS only)
```bash
# Install CocoaPods dependencies
cd ios && pod install && cd ..

# Run on iOS simulator
flutter run
```

## 📖 Usage

### Creating Tasks
1. Tap the floating action button (+) on the home screen
2. Enter task title and description
3. Set due date and optional due time
4. Add subtasks for detailed task breakdown
5. Configure repeat settings (daily/weekly)
6. Save to create your task

### Managing Tasks
- **Mark Complete**: Swipe or tap checkbox to complete tasks
- **Edit Tasks**: Long press or tap edit icon on task cards
- **Delete Tasks**: Swipe left or use delete option with confirmation
- **View by Category**: Switch between Today, Completed, and Repeated tasks

### Notifications
- Grant notification permissions on first launch
- Tasks will notify at scheduled times
- Customize notification sounds in settings

### Exporting Data
- Navigate to Completed Tasks screen
- Tap export button
- Choose CSV or PDF format
- Share via email or other apps

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── task.dart            # Task model with subtasks
│   ├── subtask.dart         # Subtask model
│   └── background_settings.dart
├── database/                 # Database layer
│   └── database_helper.dart # SQLite operations
├── providers/                # State management
│   └── theme_provider.dart  # Theme state management
├── services/                 # Business logic
│   ├── notification_service.dart # Local notifications
│   ├── export_service.dart   # CSV/PDF export
│   └── repeat_task_service.dart # Repeat task logic
├── screens/                  # UI screens
│   ├── home_screen.dart     # Main navigation
│   ├── today_tasks_screen.dart
│   ├── completed_tasks_screen.dart
│   ├── repeated_tasks_screen.dart
│   ├── add_task_screen.dart # Task creation/editing
│   └── settings_screen.dart # App settings
├── widgets/                  # Reusable components
│   ├── task_card.dart       # Task display card
│   ├── subtask_list.dart    # Subtask management
│   ├── glass_widgets.dart   # Glassmorphism components
│   └── custom_background_container.dart
└── theme/                   # Design system
    └── glassmorphism_theme.dart # Theme configuration
```

## 📋 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `sqflite` | ^2.3.0 | SQLite database |
| `provider` | ^6.0.5 | State management |
| `flutter_local_notifications` | ^16.3.2 | Local notifications |
| `timezone` | ^0.9.2 | Timezone handling |
| `pdf` | ^3.10.4 | PDF generation |
| `csv` | ^6.0.0 | CSV export |
| `share_plus` | ^7.2.2 | File sharing |
| `shared_preferences` | ^2.2.2 | Persistent storage |
| `intl` | ^0.19.0 | Date formatting |
| `path_provider` | ^2.1.2 | File system access |
| `permission_handler` | ^11.0.1 | Permission management |
| `flutter_timezone` | ^1.0.8 | Timezone utilities |
| `google_fonts` | ^6.1.0 | Custom fonts |

## 🎨 Design System

### Glassmorphism Theme
- **Background**: Dark gradient (#0A0E27 → #1A1F3A → #0F1429)
- **Glass Effect**: 30px blur, 15% opacity, 20px border radius
- **Colors**: Neon blue (#00D9FF), purple (#B026FF), cyan (#00F5FF)
- **Typography**: Poppins for headings, Inter for body text
- **Animations**: Smooth scale, fade, and slide transitions

### Components
- `GlassCard`: Frosted glass containers
- `GlassButton`: Gradient buttons with glow effects
- `GlassContainer`: Customizable glass wrappers
- `NeonText`: Text with glow effects

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart

# Run on specific device
flutter run -d <device-id>
```

## 🚀 Deployment

### Android (Google Play)
1. Build release APK: `flutter build apk --release`
2. Sign with keystore
3. Upload to Google Play Console

### iOS (App Store)
1. Configure App Store Connect
2. Build archive: `flutter build ios --release`
3. Upload via Xcode or Transporter

*See [BUILD_SETUP_GUIDE.md](BUILD_SETUP_GUIDE.md) and [iOS_DEPLOYMENT_GUIDE.md](iOS_DEPLOYMENT_GUIDE.md) for detailed instructions*

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

### Development Guidelines
- Follow Flutter best practices
- Write clear, documented code
- Add tests for new features
- Update documentation as needed
- Ensure cross-platform compatibility

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for design inspiration
- SQLite for reliable data storage
- Open source community for various packages

## 📞 Support

If you have any questions or issues:
- Create an issue on GitHub
- Check existing documentation
- Review troubleshooting guides in build setup

---

**Made with ❤️ using Flutter**

*Star this repo if you find it helpful! ⭐*
