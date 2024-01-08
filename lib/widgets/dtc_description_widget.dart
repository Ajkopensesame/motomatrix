import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DtcDescriptionWidget extends StatelessWidget {
  final String dtcDescription;
  final int searchCount;

  const DtcDescriptionWidget({
    super.key,
    required this.dtcDescription,
    required this.searchCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.search, size: 26, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      'This DTC searched $searchCount ${searchCount == 1 ? 'time' : 'times'}!',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10), // Spacing between count and description
                Text(
                  dtcDescription,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20), // Added space for visual separation
                ElevatedButton(
                  onPressed: () {
                    // Placeholder action for the button
                    // You'll likely want to replace this with navigation logic to the discussion page
                    if (kDebugMode) {
                      print('Button Pressed');
                    }
                  },
                  child: const Text('Join or Start Discussion'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
