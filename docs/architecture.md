# Architecture Overview

Kigali City Services follows a layered, clean architecture with clear separation of concerns.

## Layers

```
UI (Screens) → Providers → Services → Firebase (Auth, Firestore)
```

### UI Layer (`screens/`)

- **Auth screens**: Login, Signup, Verify Email
- **Home screens**: Directory, My Listings, Map View, Settings
- **Listing screens**: Form (create/edit), Detail

Screens use `ConsumerWidget` or `ConsumerStatefulWidget` to read providers via `ref.watch()` or `ref.read()`. No direct Firebase calls.

### Provider Layer (`providers/`)

- **auth_provider.dart**: Auth state and user profile streams
- **listing_provider.dart**: Listings streams, search query, category filter, filtered list
- **theme_provider.dart**: Theme mode (light/dark/system)

Providers connect services to the UI and expose derived state.

### Service Layer (`services/`)

- **auth_service.dart**: Firebase Auth (signUp, signIn, signOut) and profile reads
- **firestore_service.dart**: Listings CRUD and streams

Services encapsulate all Firebase access. They are singletons (e.g. `AuthService.instance`).

### Model Layer (`models/`)

- **listing.dart**: Listing with Firestore `toMap`/`fromDoc`
- **user_profile.dart**: UserProfile with `toMap`/`fromMap`

Models define data structures and serialization for Firestore.

## Data Flow

1. **Authentication**: User signs in/up → AuthService → Firebase Auth. Profile written/read via Firestore.
2. **Listings**: Firestore streams → FirestoreService → Riverpod StreamProvider → UI.
3. **Filtering**: searchQueryProvider + categoryFilterProvider → filteredListingsProvider (derived) → Directory UI.

## Firebase Integration Points

- `main.dart`: `Firebase.initializeApp()` on startup
- `AuthService`: `FirebaseAuth`, `FirebaseFirestore` (profiles)
- `FirestoreService`: `FirebaseFirestore` (listings)
