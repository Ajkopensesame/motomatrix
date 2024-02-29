// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_avatar/random_avatar.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_elevatedbutton.dart';
import '../widgets/custom_textfield.dart';
import 'package:motomatrix/providers/firebase_auth_service_provider.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuthService = ref.watch(firebaseAuthServiceProvider);
    final user = firebaseAuthService.getCurrentUser();

    final TextEditingController nameController =
    TextEditingController(text: user?.name ?? '');
    final TextEditingController emailController =
    TextEditingController(text: user?.email ?? '');
    final TextEditingController passwordController = TextEditingController();

    void updateProfile() async {
      try {
        await firebaseAuthService.updateUserDisplayName(nameController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }

    void signOut() async {
      await firebaseAuthService.signOut();
      Navigator.pushReplacementNamed(context, '/login'); // Replace with the route name of your login screen
    }

    void changePassword() async {
      final newPassword = passwordController.text.trim();
      if (newPassword.isNotEmpty) {
        try {
          await firebaseAuthService.updateUserPassword(newPassword);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password updated successfully!')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update password: $e')),
          );
        }
      }
    }

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/user_profile.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Center(
                child: user?.photoUrl != null
                    ? CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user!.photoUrl!),
                )
                    : RandomAvatar(user?.id ?? 'default', height: 100, width: 100),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: nameController,
                hintText: 'Name',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: emailController,
                hintText: 'Email',
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: updateProfile,
                label: 'Update Profile',
              ),
              CustomElevatedButton(
                onPressed: signOut,
                label: 'Sign Out',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: passwordController,
                hintText: 'New Password',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: changePassword,
                label: 'Update Password',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
