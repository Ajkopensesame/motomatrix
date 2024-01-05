import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motomatrix/screens/signup_screen.dart';
import '../main.dart';
import '../widgets/custom_app_bar.dart'; // <-- Import the CustomAppBar
import '../widgets/custom_elevatedbutton.dart';
import '../widgets/custom_textbutton.dart';
import '../widgets/custom_textfield.dart'; // <-- Import the CustomTextField
import '../widgets/custom_background.dart'; // <-- Import the CustomBackground

class LoginScreen extends ConsumerWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(
        // <-- Use the CustomAppBar here
        title: 'Login',
      ),
      body: CustomBackground(
        // <-- Use the CustomBackground here
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  // <-- Use the CustomTextField here
                  controller: _emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  // <-- Use the CustomTextField here
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                CustomElevatedButton(
                  // <-- Use the CustomElevatedButton here
                  label: 'Login',
                  onPressed: () async {
                    try {
                      final user = await ref
                          .read(firebaseAuthProvider)
                          .signInWithEmailAndPassword(
                            _emailController.text,
                            _passwordController.text,
                          );
                      if (user != null) {
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacementNamed(context, '/dashboard');
                      }
                    } catch (error) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login failed: $error')),
                      );
                    }
                  },
                ),
                CustomTextButton(
                  // <-- Use the CustomTextButton here
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
}
