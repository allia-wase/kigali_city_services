import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../models/user_profile.dart';

final authStateProvider = StreamProvider<User?>(
  (ref) => AuthService.instance.authStateChanges,
);

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return const Stream.empty();
  return AuthService.instance.userProfileStream(user.uid);
});
