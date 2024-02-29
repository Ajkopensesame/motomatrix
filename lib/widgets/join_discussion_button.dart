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
    return ElevatedButton(
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
      child: const Text(
        'Join Discussion',
        style: TextStyle(color: Colors.black), // Set text color to black
      ),
    );
  }
}
