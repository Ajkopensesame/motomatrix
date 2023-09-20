import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/custom_elevatedbutton.dart';
import '../widgets/custom_textfield.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String _userName = 'John Doe'; // Sample data for demonstration
  String _userEmail = 'john.doe@example.com'; // Sample data for demonstration
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = _userName;
    _emailController.text = _userEmail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'User Profile'),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/user_profile.png'), // Path to your image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://via.placeholder.com/100'), // Sample profile image
                ),
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: _nameController,
                hintText: 'Name',
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: _emailController,
                hintText: 'Email',
              ),
              SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: _updateProfile,
                label: 'Update Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateProfile() {
    final updatedName = _nameController.text;
    final updatedEmail = _emailController.text;

    // Provide feedback to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully!')),
    );
  }
}
