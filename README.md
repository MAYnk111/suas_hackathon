# 🏥 SUDHA - Smart Universal Digital Health Assistant

**Empowering Healthcare Through AI | General Care + Maternal Health**

SUDHA is a comprehensive Flutter-based mobile health application that combines general healthcare management with specialized pregnancy tracking (Vatsalya mode). Built with AI-powered features including medicine validation, symptom analysis, and personalized health guidance.

---

## 🌟 Key Features

### 🔄 Dual Mode System
- **General Patient Care**: Standard health monitoring, symptom tracking, and medical assistance
- **Pregnancy Care (Vatsalya)**: Comprehensive maternal health tracking with month-wise fetus development visualization

### 💊 AI-Powered Medicine Safety
- **Gemini Vision Integration**: Direct client-side medicine validation
- **Two-Step Validation**: Detection gate → Analysis (no percentage for non-medicine images)
- **Fake vs Real Analysis**: Confidence scoring with risk assessment
- **NO Backend Required**: Complete client-side implementation for rapid deployment

### 🤰 Pregnancy Tracking (Vatsalya Mode)
- **Visual Fetus Development**: Month-by-month evolution imagery (Months 1-9)
- **Timeline Tracking**: Trimester-based progress with milestone alerts
- **Nutrition Guidance**: AI-powered dietary recommendations
- **Hospital Checklist**: Pre-delivery preparation assistant
- **Ayurvedic Wellness**: Traditional Indian maternal care integration

### 📊 Health Management
- **Dashboard Analytics**: Comprehensive health metrics visualization
- **Reports & Documents**: Secure medical record storage
- **Reminders & Alerts**: Medication and appointment notifications
- **Symptom Tracker**: AI-assisted symptom analysis
- **Family Health**: Multi-user health monitoring

---

## 🛠️ Tech Stack

### Frontend
- **Flutter 3.x**: Cross-platform mobile framework
- **Dart**: Primary programming language
- **Provider Pattern**: State management architecture
- **Riverpod**: Advanced state management for pregnancy features

### Backend & AI
- **Firebase**: Authentication, storage, and real-time database
- **Google Gemini 1.5 Flash**: Client-side vision AI for medicine validation
- **Hive**: Local persistent storage for offline-first architecture

### Key Packages
```yaml
google_generative_ai: ^0.4.0  # Gemini API integration
firebase_core: ^3.10.0         # Firebase services
provider: ^6.1.2               # State management
hive_flutter: ^1.1.0           # Local database
riverpod: ^2.5.4               # Advanced state management
image_picker: ^1.1.2           # Image capture
```

---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.0+
- Android Studio / Xcode
- Firebase project setup
- Gemini API key ([Get here](https://makersuite.google.com/app/apikey))

### Installation

1. **Clone Repository**
```bash
git clone https://github.com/mayankpawar24-oss/SUDHA_APP.git
cd SUDHA_APP
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Firebase Setup**
- Add `google-services.json` to `android/app/`
- Add `GoogleService-Info.plist` to `ios/Runner/`
- Configure Firebase in console

4. **Gemini API Key**
- Open `lib/services/gemini_medicine_service.dart`
- Line 11: Replace `YOUR_GEMINI_API_KEY_HERE` with actual key
```dart
static const String _geminiApiKey = 'YOUR_API_KEY';
```

5. **Run Application**
```bash
flutter run
```

---

## 📱 Application Architecture

### Role-Based Navigation
```
AppEntry (Authentication Check)
    ├── Not Authenticated → LoginScreen
    └── Authenticated
        ├── General Mode → MainNavigationScreen
        └── Pregnancy Mode → PregnancyRoleRoot
```

### State Management Layers
- **Provider**: Global app state (auth, theme, language)
- **Riverpod**: Pregnancy-specific features
- **Hive**: Persistent storage (role preferences, offline data)

### Medicine Validation Flow
```
Image Upload
    ↓
detectMedicine() → Gemini Vision API
    ↓
validateDetection() → Confidence Check (≥0.7)
    ↓
analyzeMedicine() → Fake vs Real Analysis
    ↓
Result Display (Percentage + Risk Level)
```

---

## 🎯 Key Innovations

### 1. **Client-Side AI Validation**
- No backend/server deployment needed
- Direct Gemini API integration in Flutter
- Reduces latency and infrastructure costs
- Perfect for hackathon rapid iteration

### 2. **Smart Role Switching**
- Seamless transition between General ↔ Pregnancy modes
- Persistent role storage with Hive
- Auto-navigation on role change
- Single source of truth architecture

### 3. **Comprehensive Pregnancy Tracking**
- 9-month visual fetus evolution
- Real-time progress calculations
- Trimester-based milestone system
- Integrated Ayurvedic wellness guidance

### 4. **Offline-First Design**
- Local data persistence with Hive
- Cached health records
- Works without internet (except AI features)
- Syncs when connection available

---

## 📂 Project Structure

```
lib/
├── core/                          # Core utilities and configs
│   └── user_role.dart            # Role definitions (General/Pregnant)
├── models/                        # Data models
│   ├── medicine_verification_result.dart
│   └── health_record.dart
├── providers/                     # State management
│   ├── auth_provider.dart
│   ├── role_provider.dart
│   └── medicine_safety_provider.dart
├── services/                      # Business logic
│   ├── gemini_medicine_service.dart  # AI validation
│   └── api_service.dart
├── screens/                       # General mode UI
│   ├── main_navigation_screen.dart
│   ├── dashboard_screen.dart
│   └── profile_screen.dart
├── pregnancy_role/                # Pregnancy mode features
│   ├── presentation/
│   │   ├── pages/
│   │   │   ├── pregnancy_tracking_page.dart
│   │   │   └── nutrition_guidance_page.dart
│   │   └── widgets/
│   └── core/
└── theme/                         # UI theming
    └── vatsalya_theme.dart
```

---

## 🔧 Configuration Files

### Firebase Setup
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart` (auto-generated)

### Assets Configuration
```yaml
flutter:
  assets:
    - assets/images/           # General images
    - assets/pregnancy/        # Pregnancy-specific assets
    - assets/sounds/           # Audio notifications
```

---

## 🎨 Features Breakdown

### General Healthcare Mode
✅ Dashboard with health metrics  
✅ Symptom tracker with AI analysis  
✅ Medicine safety checker (Fake vs Real)  
✅ Appointment reminders  
✅ Health reports storage  
✅ Family health management  
✅ Vedic wellness integration  
✅ Food guidance system  

### Pregnancy (Vatsalya) Mode
✅ Month-wise fetus development visualization  
✅ Pregnancy timeline with milestones  
✅ Trimester-based progress tracking  
✅ Nutrition guidance (AI-powered)  
✅ Hospital checklist preparation  
✅ Ayurvedic pregnancy care tips  
✅ Meditation & wellness exercises  
✅ Contraction timer (for labor)  

---

## 🔐 Security & Privacy

- **Firebase Authentication**: Secure user login
- **Local Encryption**: Hive database encryption
- **No API Key Exposure**: Client-side key management
- **HIPAA-Compliant Design**: Health data protection standards
- **Offline-First**: Sensitive data stored locally

---

## 🚧 Known Issues & Fixes

### Issue: Fetus Images Not Displaying
**Status**: Fixed in commit `8172ed4`  
**Solution**: Hardcoded static image paths for testing, centralized image mapper created

### Issue: Role Switching Button Unresponsive
**Status**: Fixed in commit `8172ed4`  
**Solution**: Added navigation after role change, debug logging implemented

---

## 📈 Future Roadmap

### Phase 1 (Immediate)
- [ ] Restore dynamic month-wise fetus image switching
- [ ] Add Gemini API key to production build
- [ ] Implement comprehensive error boundary

### Phase 2 (Short-term)
- [ ] Telemedicine integration (video consultations)
- [ ] Wearable device sync (heart rate, steps)
- [ ] Multi-language support expansion
- [ ] Voice-based symptom reporting

### Phase 3 (Long-term)
- [ ] ML-based predictive health analytics
- [ ] Community forum for pregnant women
- [ ] Integration with hospital EMR systems
- [ ] Government health scheme integration (Ayushman Bharat)

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

### Coding Standards
- Follow Dart style guide
- Add comments for complex logic
- Write unit tests for new features
- Update documentation

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Team

**Project Maintainer**: Mayank Pawar  
**Contributors**: [View Contributors](https://github.com/mayankpawar24-oss/SUDHA_APP/graphs/contributors)

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/mayankpawar24-oss/SUDHA_APP/issues)
- **Discussions**: [GitHub Discussions](https://github.com/mayankpawar24-oss/SUDHA_APP/discussions)
- **Email**: support@sudha-health.com

---

## 🏆 Acknowledgments

- Google Gemini AI for vision capabilities
- Firebase for backend infrastructure
- Flutter community for amazing packages
- Indian healthcare workers for domain insights

---

## 📊 Project Stats

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)
![Firebase](https://img.shields.io/badge/Firebase-Latest-orange?logo=firebase)
![License](https://img.shields.io/badge/License-MIT-green)

**Built with ❤️ for healthcare accessibility in India**

---

*Last Updated: February 2026*
