# TicTask: Time in Action ⏱️

> Master your time with TicTask. Create tasks and subtasks, control every second with start/stop and track your performance with clarity. Productivity has never been so simple.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-lightgrey?style=for-the-badge)](https://flutter.dev/multi-platform)

## 🚀 Features

### ✅ Task Management
- Create and organize tasks with detailed descriptions
- Hierarchical subtask system for better organization
- Tag system for categorization and filtering
- Intuitive task completion tracking

### ⏲️ Time Tracking
- Precise start/stop timer functionality
- Real-time tracking with visual feedback
- Automatic time calculations
- Historical time data storage

### 📊 Performance Analytics
- Detailed time reports and statistics
- Performance tracking across tasks and projects
- Visual charts and progress indicators
- Export functionality for data analysis

### 🎨 User Experience
- Clean, modern interface design
- Dark and light theme support
- Cross-platform consistency
- Responsive design for all screen sizes

## 🛠️ Technology Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **Database**: Hive (local storage)
- **State Management**: Provider/ViewModel pattern
- **Architecture**: MVVM (Model-View-ViewModel)
- **Platforms**: iOS, Android, macOS, Windows, Linux

## 📱 Screenshots

*Coming soon - Add your app screenshots here*

## 🔧 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (2.17 or higher)
- IDE: VS Code, Android Studio, or IntelliJ

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/tictask.git
   cd tictask
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate required files**
   ```bash
   dart run build_runner build
   ```

4. **Configure app icons** (optional)
   ```bash
   dart run flutter_launcher_icons
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

### Building for Release

Use the provided build script for easy deployment:

```bash
./build_with_icon.sh
```

Or build manually for specific platforms:

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# macOS
flutter build macos --release

# Windows
flutter build windows --release

# Linux
flutter build linux --release
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── task.dart            # Task model
│   ├── subtask.dart         # Subtask model
│   ├── tag.dart             # Tag model
│   └── time_point.dart      # Time tracking model
├── viewmodels/              # Business logic
│   ├── task_viewmodel.dart  # Task management logic
│   └── subtask_viewmodel.dart
├── views/                   # UI screens
│   ├── task_list_screen.dart
│   ├── task_form.dart
│   ├── subtask_screen.dart
│   └── splash_screen.dart
├── widgets/                 # Reusable UI components
│   └── tictask_branding.dart
└── utils/                   # Utilities
    └── csv_exporter.dart    # Data export functionality
```

## 🎯 Core Features Implementation

### Task Model
```dart
@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;
  
  @HiveField(1)
  String description;
  
  @HiveField(2)
  bool isCompleted;
  
  @HiveField(3)
  List<Subtask> subtasks;
  
  @HiveField(4)
  List<Tag> tags;
  
  @HiveField(5)
  List<TimePoint> timePoints;
}
```

### Time Tracking
- Real-time timer with millisecond precision
- Automatic pause/resume functionality
- Historical time data with CSV export
- Visual progress indicators

## 🚀 Roadmap

- [ ] Cloud synchronization
- [ ] Team collaboration features
- [ ] Advanced reporting and analytics
- [ ] Integration with calendar apps
- [ ] Pomodoro timer technique
- [ ] Voice commands and shortcuts
- [ ] Widget support for quick access

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines

- Follow Flutter/Dart style guidelines
- Write meaningful commit messages
- Add tests for new features
- Update documentation as needed
- Ensure cross-platform compatibility

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎨 Branding

**TicTask** follows a clean, modern design philosophy:

- **Colors**: Professional blue and white theme
- **Typography**: Clean, readable fonts
- **Icons**: Minimalist, intuitive iconography
- **UX**: Focus on simplicity and efficiency

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/tictask/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/tictask/discussions)
- **Email**: support@tictask.app

## 🌟 Acknowledgments

- Flutter team for the amazing framework
- Hive for efficient local storage
- The open-source community for inspiration and contributions

---

**TicTask: Time in Action** - Where productivity meets simplicity.

*Made with ❤️ using Flutter*
