# 🧘‍♂️ Yoga Flow App

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/BLoC-4285F4?style=for-the-badge&logo=google&logoColor=white" alt="BLoC">
  <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License">
</div>

<div align="center">
  <h3>A Dynamic Guided Yoga Session App</h3>
  <p><em>Fully dynamic, audio-synced, and modular yoga experience inspired by smart yoga products like ArvyaX</em></p>
</div>

---

## 🌟 Overview

**Yoga Flow App** is a cutting-edge Flutter application that transforms your device into a personalized yoga instructor. Built with modularity and flexibility at its core, this app dynamically generates guided yoga sessions from JSON configuration files, making it incredibly easy to customize and scale.

### 🎯 Why This App Stands Out

- **Zero Code Changes**: Add new poses by simply updating JSON files
- **Professional Grade**: Audio-synced guidance with perfect timing
- **Smart Architecture**: Built with Flutter BLoC for maintainability
- **Real-World Inspired**: Mimics functionality of premium yoga platforms

---

## ✨ Features

### Core Features
| Feature | Description | Status |
|---------|-------------|--------|
| 📱 **Dynamic JSON Parsing** | Automatically extracts pose data, images, and audio instructions | ✅ |
| 🧘‍♀️ **Guided Flow Experience** | Sequential pose guidance with images, audio, and timers | ✅ |
| 🎵 **Perfect Synchronization** | Seamless coordination between visuals, audio, and timing | ✅ |
| 🔧 **Plug-and-Play Design** | Add new poses without touching the codebase | ✅ |
| 🏗️ **BLoC State Management** | Clean, scalable architecture with separation of concerns | ✅ |

### Premium Features
- ⏯️ **Session Controls** - Play, pause, and resume functionality
- 🎶 **Background Music** - Optional ambient music layer
- 📊 **Live Progress Tracking** - Real-time progress bar and timer
- 🖼️ **Session Preview** - Preview all poses before starting

---

## 📸 Screenshots

<div align="center">
  
<table style="width: 100%;">
  <tr>
    <td align="center" width="25%">
      <img src="https://i.postimg.cc/yNcTFGKD/yoga-1.jpg" width="120"/><br>
      <b>Signup scree</b><br>
      Allow users login or signup
    </td>
    <td align="center" width="25%">
      <img src="https://i.postimg.cc/pVGKnvj0/yoga-2.jpg" width="120"/><br>
      <b>Blog Screen</b><br>
      Displays blogs here
    </td>
     <td align="center" width="25%">
      <img src="https://i.postimg.cc/j58nN6DW/yoga-3.jpg" width="120"/><br>
      <b>Add blogs</b><br>
      allows users to create and upload blogs
    </td>
   
   
  </tr>
  </table>

</div>


## 🏗️ Architecture

```
lib/
├── 🧠 blocs/              # BLoC state management
│   ├── session_bloc.dart
│   └── session_state.dart
├── 📦 models/             # Data models
│   ├── pose_model.dart
│   └── session_model.dart
├── 🖥️ screens/            # Application screens
│   ├── home_screen.dart
│   ├── preview_screen.dart
│   └── session_screen.dart
├── 🎨 widgets/            # Reusable UI components
│   ├── pose_viewer.dart
│   ├── session_timer.dart
│   └── control_panel.dart
├── 🔧 services/           # Core services
│   ├── audio_service.dart
│   └── json_parser.dart
└── 📁 assets/
    ├── 🖼️ images/         # Pose illustrations
    ├── 🔊 audio/          # Voice guidance files
    └── 📄 session_data.json # Session configuration
```

---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (latest version)
- Dart SDK
- Android Studio / VS Code
- A device or emulator for testing

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/yoga-flow-app.git
   cd yoga-flow-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Customize your session**
   - Edit `assets/session_data.json` with your poses
   - Add corresponding images to `assets/images/`
   - Add voice guidance to `assets/audio/`

4. **Run the application**
   ```bash
   flutter run
   ```

---

## 📋 Session Configuration

Create dynamic yoga sessions by editing the JSON configuration:

```json
{
  "session_name": "Morning Flow",
  "duration": 1200,
  "difficulty": "beginner",
  "poses": [
    {
      "name": "Mountain Pose",
      "image_path": "assets/images/mountain_pose.png",
      "audio_path": "assets/audio/mountain_pose.mp3",
      "duration": 30,
      "description": "Stand tall with feet hip-width apart..."
    }
  ]
}
```

### Adding New Poses

1. Add pose data to `session_data.json`
2. Include the pose image in `assets/images/`
3. Add voice guidance audio to `assets/audio/`
4. Run the app - **no code changes needed!**

---

## 🛠️ Tech Stack

<div align="center">

| Technology | Purpose | Version |
|------------|---------|---------|
| **Flutter** | Cross-platform framework | Latest |
| **Dart** | Programming language | Latest |
| **BLoC** | State management | ^8.1.0 |
| **just_audio** | Audio playback | ^0.9.34 |
| **JSON** | Data configuration | Native |

</div>

---

## 🔮 Future Roadmap

### Phase 1: Enhanced User Experience
- [ ] **Cloud Integration** - Sync sessions across devices
- [ ] **Progress Tracking** - Save and analyze workout history
- [ ] **Smart Notifications** - Daily practice reminders

### Phase 2: Advanced Features
- [ ] **Difficulty Levels** - Beginner to advanced classifications
- [ ] **Custom Routines** - User-created session builder
- [ ] **Social Features** - Share progress with friends

### Phase 3: AI Integration
- [ ] **Pose Recognition** - Camera-based form checking
- [ ] **Personalized Recommendations** - AI-powered session suggestions
- [ ] **Voice Commands** - Hands-free session control


---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Commit your changes** (`git commit -m 'Add some AmazingFeature'`)
4. **Push to the branch** (`git push origin feature/AmazingFeature`)
5. **Open a Pull Request**

### Development Guidelines
- Follow Flutter/Dart style guidelines
- Maintain BLoC pattern architecture
- Add tests for new features
- Update documentation as needed

---

## 👨‍💻 Author

<div align="center">

**Aditya Keshav Magar**


</div>

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Aditya Keshav Magar

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

---

## 🙏 Acknowledgments

- Inspired by smart yoga platforms like **ArvyaX**
- Flutter community for excellent packages
- Yoga instructors worldwide for guidance inspiration
- Open source contributors and testers

---

<div align="center">
  
**⭐ Star this repository if you found it helpful!**

*Made with ❤️ and Flutter*

</div>
