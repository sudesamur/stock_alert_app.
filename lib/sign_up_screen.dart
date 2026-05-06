import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _canCreate = false;

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return regex.hasMatch(email);
  }

  void _recalcCanCreate() {
    final emailOk = _isValidEmail(_emailController.text.trim());
    final passOk = _passwordController.text.length >= 6;
    final confirmOk = _confirmController.text == _passwordController.text;

    final ok = emailOk && passOk && confirmOk;
    if (ok != _canCreate) setState(() => _canCreate = ok);
  }

  void _createAccount() {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    // TODO: Buraya AWS Cognito / backend register bağlanacak.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created successfully (demo).')),
    );

    Navigator.pop(context); // demo: geri dön
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Create your account',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => _recalcCanCreate(),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final v = (value ?? '').trim();
                  if (v.isEmpty) return 'Email cannot be empty';
                  if (!_isValidEmail(v))
                    return 'Enter a valid email (e.g., a@b.com)';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                onChanged: (_) => _recalcCanCreate(),
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final v = value ?? '';
                  if (v.trim().isEmpty) return 'Password cannot be empty';
                  if (v.length < 6)
                    return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _confirmController,
                obscureText: true,
                onChanged: (_) => _recalcCanCreate(),
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final v = value ?? '';
                  if (v.trim().isEmpty)
                    return 'Confirm password cannot be empty';
                  if (v != _passwordController.text)
                    return 'Passwords do not match';
                  return null;
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canCreate ? _createAccount : null,
                  child: const Text('Create Account'),
                ),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
