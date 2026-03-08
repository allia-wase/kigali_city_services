# Firestore Database Reference

This document describes the Cloud Firestore collections used by Kigali City Services.

## Collections

### `profiles`

Stores user profile data. Each document ID is the Firebase Auth UID.

| Field         | Type   | Required | Description          |
|---------------|--------|----------|----------------------|
| uid           | string | Yes      | Matches document ID  |
| email         | string | Yes      | User email           |
| displayName   | string | No       | Optional display name|

**Write**: On sign-up, `AuthService.signUp` creates a document at `profiles/{uid}`.

**Read**: `AuthService.userProfileStream(uid)` returns `profiles/{uid}` snapshots.

---

### `listings`

Stores location listings. Document IDs are auto-generated.

| Field      | Type      | Required | Description                          |
|-----------|-----------|----------|--------------------------------------|
| name      | string    | Yes      | Listing name                         |
| category  | string    | Yes      | Hospital, Police Station, Library, Restaurant, Café, Park, Tourist Attraction |
| address   | string    | Yes      | Street address                       |
| contact   | string    | Yes      | Phone or contact info                |
| description | string  | Yes      | Free-text description                |
| latitude  | number    | Yes      | Geographic latitude                  |
| longitude | number    | Yes      | Geographic longitude                 |
| createdBy | string    | Yes      | UID of creator                       |
| timestamp | timestamp | Yes      | Creation time                        |

**Queries**:

- All listings: `listings` ordered by `timestamp` descending
- User's listings: `listings` where `createdBy == uid`

**Indexes**: Firestore may require composite indexes for these queries. Follow the link in the error message to create them in the console.
