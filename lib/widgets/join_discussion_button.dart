import 'package:flutter/material.dart';

import '../screens/forum_screen.dart';

class JoinDiscussionButton extends StatelessWidget {
  final String dtcCode;
  final String make;
  final String model;
  final String year;
  final String engineDisplacement;

  const JoinDiscussionButton({
    super.key,
    required this.dtcCode,
    required this.make,
    required this.model,
    required this.year,
    required this.engineDisplacement,
  });

  @override
  Widget build(BuildContext context) {
    // Access the app's theme
    ThemeData theme = Theme.of(context);

    return ElevatedButton.icon(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ForumPage(
              dtcCode: dtcCode,
              make: make,
              model: model,
              year: year,
              engineDisplacement: engineDisplacement,
            ),
          ),
        );
      },
      icon: const Icon(Icons.radio_button_checked),  // Substitute icon for bullseye
      label: const Text('Post And Find Fix'),  // Button text
      style: ElevatedButton.styleFrom(
        foregroundColor: theme.colorScheme.onPrimary, backgroundColor: theme.primaryColor, // Use the onPrimary color for text and icon
        textStyle: const TextStyle(
          fontSize: 18, // Make text larger
          fontWeight: FontWeight.bold,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
