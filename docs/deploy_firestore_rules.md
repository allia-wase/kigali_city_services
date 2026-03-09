# Deploy Firestore Rules to Fix Permission-Denied

If you see `[cloud_firestore/permission-denied]` when loading profiles or listings, deploy the Firestore rules.

## Steps

1. **Install Firebase CLI** (if not already):
   ```bash
   npm install -g firebase-tools
   ```

2. **Log in to Firebase**:
   ```bash
   firebase login
   ```

3. **Link your project** (use your Firebase project ID, e.g. `kigali-city-services-b83d4`):
   ```bash
   firebase use kigali-city-services-b83d4
   ```
   Or run `firebase init` and select your project.

4. **Deploy Firestore rules**:
   ```bash
   firebase deploy --only firestore
   ```

5. **Verify** in [Firebase Console](https://console.firebase.google.com) → Firestore Database → Rules. The rules should match `firestore.rules` in this project.

## Rules Summary

- **profiles/{uid}**: Read/write only if `request.auth.uid == uid`
- **listings**: Read allowed for all; create requires auth; update/delete only by `createdBy` owner
