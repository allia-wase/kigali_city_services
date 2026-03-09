# KCS – Kigali City Services & Places Directory

Flutter app for browsing services and places in Kigali: listings, map view, search, and category filtering.

## Features

- **Authentication**: Sign up, login, logout with Firebase Auth. Email verification required.
- **Listings CRUD**: Create, read, update, delete listings (name, category, address, contact, description, coordinates).
- **Directory**: Browse listings with real-time Firestore updates, search by name, filter by category.
- **Map View**: OpenStreetMap with markers; tap to open listing detail.
- **My Listings**: View, edit, delete your own listings. Loading and error states during delete.
- **Settings**: User profile, email verification status, theme (light/dark/system), notification toggle, log out.

## Firebase Setup

1. Install [Firebase CLI](https://firebase.google.com/docs/cli).
2. Enable **Firebase Auth** (Email/Password) and **Cloud Firestore** in the [Firebase Console](https://console.firebase.google.com).
3. From the project directory:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This generates `lib/firebase_options.dart` and downloads `google-services.json` (Android) and `GoogleService-Info.plist` (iOS). Do not commit these files if they contain your project's API keys.

## Firestore Collections

- **profiles** – User profiles. Document ID = Firebase Auth UID. Fields: `uid`, `email`, `displayName`.
- **listings** – Services and places. Fields: `name`, `category`, `address`, `contact`, `description`, `latitude`, `longitude`, `createdBy`, `timestamp`.

## State Management

Uses **Riverpod**:

- **Auth**: `authStateProvider`, `userProfileProvider` – auth state and profile stream.
- **Listings**: `listingListProvider`, `userListingsProvider`, `filteredListingsProvider` – all listings, user listings, search/filter results.
- **Search/filter**: `searchQueryProvider`, `categoryFilterProvider`.
- **Theme**: `themeModeProvider`, `flutterThemeModeProvider`.

Firestore CRUD is in `FirestoreService`; UI never calls Firebase directly. Loading, success, and error states are handled for auth and CRUD.

## Navigation

- **MaterialApp** with auth-based routing: unauthenticated → LoginScreen; unverified email → VerifyEmailScreen; verified → HomeShell.
- **Bottom navigation**: Directory, My Listings, Map View, Settings.
- **Routes**: `/signup`. Listing form/detail via `Navigator.push`.

## Project Structure

```
lib/
├── main.dart              # Entry, Firebase init, auth routing, HomeShell
├── firebase.dart          # initializeFirebase()
├── firebase_options.dart  # Platform config
├── models/                # Listing, UserProfile
├── providers/             # auth, listing, theme
├── services/              # AuthService, FirestoreService
├── screens/               # auth, home, listing
└── theme/                 # app_theme.dart
```

## Running the App

```bash
flutter pub get
flutter run
```
