// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
// Import your custom widgets if needed
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_elevatedbutton.dart';
import '../widgets/custom_textfield.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkTheme = false;
  bool _notificationsEnabled = true;
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: Stack(
        children: [
          _buildBackgroundImage(), // Background image
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                SwitchListTile(
                  title: const Text('Dark Theme'),
                  value: _darkTheme,
                  onChanged: (value) {
                    setState(() {
                      _darkTheme = value;
                    });
                    // Apply the theme change if you have theme management in place
                  },
                ),
                SwitchListTile(
                  title: const Text('Enable Notifications'),
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                    // Handle notification settings here
                  },
                ),
                const SizedBox(height: 20),
                const Text('Change Password',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'New Password',
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  onPressed: _changePassword,
                  label: 'Update Password',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Image.asset(
      'assets/images/settings.png', // Path to your 'settings.png' image
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  void _changePassword() {
    // In a real-world scenario, update the user's password in the database or authentication system

    // Handle the password change logic here

    // Provide feedback to the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password updated successfully!')),
    );
  }
}
