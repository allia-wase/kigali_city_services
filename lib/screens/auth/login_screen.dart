import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthService.instance.signIn(_email, _password);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log in')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 80,
                  fit: BoxFit.contain,
                  // ignore: unnecessary_underscores
                  errorBuilder: (context, error, stackTrace) => const Text(
                    'Kigali City Services',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5C3D99),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Kigali City Services',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5C3D99),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (v) => _email = v ?? '',
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (v) => _password = v ?? '',
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              if (_error != null)
                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(_error!, style: const TextStyle(color: Colors.red))),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _submit, child: const Text('Login')),
              TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text('Create account')),
            ],
          ),
        ),
      ),
    );
  }
}
