import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();
  final _auth = FirebaseAuth.instance;
  final _db   = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signUp(String email, String pw) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: pw);
    await cred.user!.sendEmailVerification();
    await _db.collection('profiles').doc(cred.user!.uid).set(
      UserProfile(uid: cred.user!.uid, email: email).toMap(),
    );
    return cred.user;
  }

  Future<User?> signIn(String email, String pw) =>
      _auth.signInWithEmailAndPassword(email: email, password: pw).then((c) => c.user);

  Future<void> signOut() => _auth.signOut();

  Stream<UserProfile?> userProfileStream(String uid) => _db
      .collection('profiles')
      .doc(uid)
      .snapshots()
      .map((s) => s.exists ? UserProfile.fromMap(s.data()!) : null);
}
