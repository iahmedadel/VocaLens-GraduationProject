# VocaLens - iOS Voice Assistant App

<div align="center">
  <img src="GraduationProject/Resourses/Assets.xcassets/Onboarding Screens/Glasses/Glasses2.imageset/VocaLens.png" alt="VocaLens Logo" width="200"/>
  
  [![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)](https://developer.apple.com/ios/)
  [![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org/)
  [![SwiftUI](https://img.shields.io/badge/SwiftUI-4.0-red.svg)](https://developer.apple.com/xcode/swiftui/)
  [![Xcode](https://img.shields.io/badge/Xcode-15.0+-green.svg)](https://developer.apple.com/xcode/)
</div>

## 📱 About VocaLens

VocaLens is an innovative iOS voice assistant application designed to help users with disabilities (mute and deaf people) speech-to-text conversion, multilingual support, and intelligent conversation management. Built with SwiftUI and modern iOS development practices, VocaLens provides a seamless and accessible experience for users who need assistance with voice communication.

## ✨ Key Features

### 🎯 Core Functionality
- **Speech-to-Text Conversion**: Real time Arabic speech recognition and transcription
- **Multi Language Support**: Arabic and English language support with RTL/LTR layout
- **Intelligent Chat Interface**: AI-powered conversation management with saving messages
- **Voice Customization**: Adjustable voice levels and text font sizes
- **Translation Toggle**: Switch between Arabic and English text output

### 💬 Chat & Communication
- **Conversation History**: Persistent chat history with local storage (Swift Data)
- **Message Selection**: Multi-select messages for organization
- **Favorites System**: Save important conversations with custom icons

### 🎨 User Experience
- **Customizable Interface**: Personalize text colors, fonts, and appearance
- **Dark/Light Mode**: Automatic theme switching based on system preferences
- **Accessibility**: Voice feedback and accessibility features
- **Onboarding**: Guided setup process for new users
- **Responsive Design**: Optimized for all iOS device sizes

### 🔐 Authentication & Security
- **User Registration**: Secure sign-up process with email verification
- **Login System**: Login Through email and password
- **Password Recovery**: OTP-based password reset functionality
- **Keychain Integration**: Secure credential storage 
- **Session Management**: Automatic login state handling

## 🛠 Technical Stack


- **SwiftUI**: Modern declarative UI framework
- **SwiftData**: Local data persistence and management
- **PhotosUI**: Image picker integration


### Architecture
- **MVVM Pattern**: Model-View-ViewModel architecture

## 🏗 Project Structure

```
GraduationProject/
├── ar.lproj/
│   └── Localizable.strings
├── en.lproj/
│   └── Localizable.strings
├── ContentView.swift
├── GraduationProjectApp.swift
├── Info.plist
├── VocaLensApp.swift
├── Custom TextField/
│   └── Toggles.swift
├── Data Layer/
│   └── KeyChain Helper.swift
├── Extensions/
│   ├── Dark-Light.swift
│   ├── HexaColors.swift
│   ├── LocalizationManager.swift
│   └── Resolve Packages_2025-02-28T12-26-42.txt
├── Models/
│   └── ChatModels.swift
├── Network Manager /
│   ├── Apis.swift
│   └── Network .swift
├── Preview Content/
│   └── Preview Assets.xcassets/
│       └── Contents.json
├── Registration/
│   ├── Login/
│   │   ├── Auth Login/
│   │   │   ├── LoginModel.swift
│   │   │   ├── LoginScreen.swift
│   │   │   └── LoginViewModel.swift
│   │   └── forget password /
│   │       ├── Forget Password - email/
│   │       │   ├── ForgetPasswordModel.swift
│   │       │   ├── ForgetPasswordView.swift
│   │       │   └── ForgetPasswordViewModel.swift
│   │       ├── New pssword/
│   │       │   ├── New Password Model.swift
│   │       │   ├── NewpasswordView.swift
│   │       │   └── NewPasswordViewModel.swift
│   │       └── Reset password - Otp/
│   │           ├── ResetPasswordModel.swift
│   │           ├── ResetPasswordOtpView.swift
│   │           └── ResetPasswordOTPViewModel.swift
│   ├── OTP/
│   │   ├── LoadingView.swift
│   │   ├── OtpModel.swift
│   │   ├── OtpView.swift
│   │   └── OtpViewModel.swift
│   └── SingUp/
│       ├── SignUpModel.swift
│       ├── SignUpScreen.swift
│       └── SignUpViewModel.swift
├── Resourses/
│   └── Assets.xcassets/
│       ├── AccentColor.colorset/
│       │   └── Contents.json
│       ├── AppIcon.appiconset/
│       │   ├── Contents.json
│       │   └── Screenshot 2025-02-17 at 8.53.06 PM.png
│       ├── Colors/
│       │   ├── backGroundtxtField.colorset/
│       │   ├── borderCellColor.colorset/
│       │   ├── ButtonColor.colorset/
│       │   ├── cellColor.colorset/
│       │   ├── Color.colorset/
│       │   ├── Color1.colorset/
│       │   ├── Color_main.colorset/
│       │   ├── darkcolor.colorset/
│       │   ├── gray.imageset/
│       │   ├── LabelColor.colorset/
│       │   ├── labelColor2.colorset/
│       │   ├── LaunchScreenColor.colorset/
│       │   ├── LaunchSpeedoColor.colorset/
│       │   ├── mainColorScreen.colorset/
│       │   ├── MoreBGColor.colorset/
│       │   ├── OTPborderColor.colorset/
│       │   ├── TextFieldBorderColor.colorset/
│       │   ├── title2Color.colorset/
│       │   └── titleColor.colorset/
│       ├── Onboarding Screens/
│       │   ├── Glasses/
│       │   ├── Gloves/
│       │   ├── OnBoardingCartton/
│       │   └── Paging Control/
│       └── Registration Screens/
│           ├── emailImage.imageset/
│           ├── eyeImage.imageset/
│           ├── personImage.imageset/
│           └── phoneImage.imageset/
├── Splash+OnBoarding/
│   ├── FirstOnBoarding.swift
│   ├── SecondOnBoarding.swift
│   ├── SplashScreen.swift
│   └── ThirdOnBoarding.swift
├── Tab Bar/
│   ├── Chat/
│   │   ├── Chat Model.swift
│   │   ├── Chat.swift
│   │   ├── ChatViewModel.swift
│   │   └── PersistenceController.swift
│   ├── CustomTabBarView.swift
│   ├── Favorites/
│   │   ├── ChatDetailView.swift
│   │   ├── Favorites Model.swift
│   │   ├── Favorites ViewModel.swift
│   │   └── Favorites.swift
│   ├── Home/
│   │   ├── Home.swift
│   │   └── HomeViewModel.swift
│   ├── MainTabBar.swift
│   ├── Profile/
│   │   └── Profile.swift
│   └── Setting/
│       ├── ContactUs.swift
│       └── Setting.swift
├── ViewModels/
│   └── ChatDataViewModel.swift
```

<div align="center">
  <p>Made with ❤️ for the iOS community</p>
  <p>VocaLens - Empowering communication through voice technology</p>
</div>
