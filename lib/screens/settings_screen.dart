import 'package:flutter/material.dart';
// Import your custom widgets if needed
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_elevatedbutton.dart';
import '../widgets/custom_textfield.dart';

class SettingsScreen extends StatefulWidget {
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
      appBar: CustomAppBar(title: 'Settings'),
      body: Stack(
        children: [
          _buildBackgroundImage(), // Background image
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                SwitchListTile(
                  title: Text('Dark Theme'),
                  value: _darkTheme,
                  onChanged: (value) {
                    setState(() {
                      _darkTheme = value;
                    });
                    // Apply the theme change if you have theme management in place
                  },
                ),
                SwitchListTile(
                  title: Text('Enable Notifications'),
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                    // Handle notification settings here
                  },
                ),
                SizedBox(height: 20),
                Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'New Password',
                  obscureText: true,
                ),
                SizedBox(height: 20),
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
    final newPassword = _passwordController.text;

    // Handle the password change logic here

    // Provide feedback to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password updated successfully!')),
    );
  }
}
