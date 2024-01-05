import 'package:flutter/material.dart';

class CustomDTCCard extends StatelessWidget {
  final String code;
  final String description;
  final String severity;
  final VoidCallback? onDetailsPressed;
  final VoidCallback? onFixPressed;

  const CustomDTCCard({
    super.key,
    required this.code,
    required this.description,
    required this.severity,
    this.onDetailsPressed,
    this.onFixPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  avatar: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: _getSeverityIcon(severity),
                  ),
                  label: Text(
                    code,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: _getSeverityColor(severity),
                ),
                Text(
                  _getSeverityText(severity),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onDetailsPressed,
                  child: const Text('Details'),
                ),
                TextButton(
                  onPressed: onFixPressed,
                  child: const Text('Possible Fixes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Icon _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return const Icon(Icons.error, color: Colors.white);
      case 'medium':
        return const Icon(Icons.warning, color: Colors.white);
      case 'low':
        return const Icon(Icons.info, color: Colors.white);
      default:
        return const Icon(Icons.help, color: Colors.white);
    }
  }

  String _getSeverityText(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return 'High Severity';
      case 'medium':
        return 'Medium Severity';
      case 'low':
        return 'Low Severity';
      default:
        return 'Unknown Severity';
    }
  }
}
