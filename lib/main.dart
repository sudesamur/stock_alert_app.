import 'package:flutter/material.dart';
import 'product_list_screen.dart';
import 'sign_up_screen.dart';

void main() {
  runApp(const MyApp());
}

// ✅ Email kontrolü (basit ve yeterli)
bool isValidEmail(String email) {
  final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  return regex.hasMatch(email);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stockify',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 246, 168, 228),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 61, 42, 1),
        ),
      ),
      home: const MyHomePage(title: 'STOCKIFY'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _canLogin = false;
  bool _obscurePassword = true;

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return regex.hasMatch(email);
  }

  void _recalcCanLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final ok = _isValidEmail(email) && password.length >= 6;
    if (ok != _canLogin) setState(() => _canLogin = ok);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 220),
              const SizedBox(height: 32),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => _recalcCanLogin(),
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
                obscureText: _obscurePassword,
                onChanged: (_) => _recalcCanLogin(),
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  final v = value ?? '';
                  if (v.trim().isEmpty) return 'Password cannot be empty';
                  if (v.length < 6)
                    return 'Password must be at least 6 characters';
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // ✅ LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canLogin
                      ? () {
                          final ok = _formKey.currentState?.validate() ?? false;
                          if (!ok) return;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProductListScreen(),
                            ),
                          );
                        }
                      : null,
                  child: const Text('Login'),
                ),
              ),

              const SizedBox(height: 12),

              // ✅ SIGN UP BUTTON (EKLENEN KISIM)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: const Text('Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}