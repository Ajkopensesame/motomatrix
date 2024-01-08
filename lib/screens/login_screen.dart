// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motomatrix/screens/signup_screen.dart';
import '../main.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_elevatedbutton.dart';
import '../widgets/custom_textbutton.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_background.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordError = false; // New variable to track password error state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Login'),
      body: CustomBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: true,
                  borderColor: _isPasswordError
                      ? Colors.red
                      : null, // Border color change
                ),
                const SizedBox(height: 32),
                CustomElevatedButton(
                  label: 'Login',
                  onPressed: () => _loginPressed(context),
                ),
                CustomTextButton(
                  label: "Don't have an account? Sign up",
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loginPressed(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty && password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    try {
      final user = await ref
          .read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email, password);
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        setState(() {
          _isPasswordError = true; // Set password error state to true
        });
      }
    }
  }
}
