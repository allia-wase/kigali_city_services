// File generated from google-services.json and GoogleService-Info.plist.
// Run `dart run flutterfire configure` to regenerate with latest config.

import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return android;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBp2HbNuJap5iM7ARIxDVUjiB1ICvmtwW0',
    appId: '1:609988193974:android:5c5e1f178cf23f91040017',
    messagingSenderId: '609988193974',
    projectId: 'kigali-city-services-b83d4',
    storageBucket: 'kigali-city-services-b83d4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCmFAoqVmSi67MdKHuGHABbsu29ehSQMyQ',
    appId: '1:609988193974:ios:b2c0faf7c5b7070f040017',
    messagingSenderId: '609988193974',
    projectId: 'kigali-city-services-b83d4',
    storageBucket: 'kigali-city-services-b83d4.firebasestorage.app',
    iosBundleId: 'com.example.kigaliCityServices',
  );
}
