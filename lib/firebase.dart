/// Firebase configuration and initialization for Kigali City Services.
library;

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/// Initialize Firebase with platform-specific options.
/// Call this in main() before runApp().
Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
