import 'package:flutter/material.dart';

class ForumPage extends StatelessWidget {
  final String dtcCode;
  final String make;
  final String model;
  final String year;
  final String engineDisplacement;

  const ForumPage({
    super.key,
    required this.dtcCode,
    required this.make,
    required this.model,
    required this.year,
    required this.engineDisplacement,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum for $dtcCode'),
      ),
      body: SingleChildScrollView( // Use SingleChildScrollView to allow for scrolling
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Discussing $dtcCode for $year $make $model with engine displacement $engineDisplacement'),
            const Divider(),
            Text('Concern', style: Theme.of(context).textTheme.titleLarge),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Describe the issue you are experiencing...',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null, // Allows for multi-line input
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic to save the 'concern' and navigate to the discussion thread
              },
              child: const Text('Post Concern'),
            ),
            const Divider(),
            // Placeholder for 'Cause' and 'Correction' sections
            // These could follow a similar pattern with text fields for input
            // and sections for displaying existing discussions
          ],
        ),
      ),
    );
  }
}
