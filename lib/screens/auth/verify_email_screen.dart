import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../main.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  Timer? _timer;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _checkVerified();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _checkVerified());
  }

  Future<void> _checkVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    setState(() {
      _isVerified = user?.emailVerified ?? false;
    });
    if (_isVerified) {
      _timer?.cancel();
      // push to home by replacing this screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeShell()),
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Center(
        child: _isVerified
            ? const Text('Email verified!')
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Please check your inbox and verify your email.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.currentUser?.sendEmailVerification();
                    },
                    child: const Text('Resend link'),
                  ),
                ],
              ),
      ),
    );
  }
}
