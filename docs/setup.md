# Setup Guide

Step-by-step setup for Kigali City Services with Firebase.

## Prerequisites

- Flutter SDK installed
- Android Studio / Xcode (for Android/iOS development)
- A Google account for Firebase

## 1. Clone and Install Dependencies

```bash
git clone <repository-url>
cd kigali_city_services
flutter pub get
```

## 2. Firebase Project Setup

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **Create a project** (or use an existing one)
3. Add an **Android** app:
   - Package name: `com.example.kigali_city_services` (or your app ID from `android/app/build.gradle`)
   - Download `google-services.json` and place it in `android/app/`
4. Add an **iOS** app (optional for iOS builds):
   - Bundle ID: `com.example.kigaliCityServices` (or your iOS bundle ID)
   - Download `GoogleService-Info.plist` and place it in `ios/Runner/`

## 3. Enable Firebase Services

- **Authentication**: In the Firebase Console, go to Build > Authentication. Enable **Email/Password**.
- **Cloud Firestore**: Go to Build > Firestore Database. Create a database (start in test mode for development). Add security rules before production.

## 4. Firestore Security Rules (Example)

For development, you can use:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /profiles/{uid} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
    match /listings/{id} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && resource.data.createdBy == request.auth.uid;
    }
  }
}
```

For production, tighten rules as needed.

## 5. Run the App

```bash
flutter run
```

If the emulator or device was just started, wait for it to fully boot before running.
