import 'package:flutter/material.dart';

class DtcCard extends StatelessWidget {
  final String dtcCode;
  final String description;
  final String severityLevel; // New field
  final String possibleCauses; // New field
  final String recommendedActions; // New field
  final String relatedSymptoms; // New field

  const DtcCard({super.key, 
    required this.dtcCode,
    required this.description,
    required this.severityLevel, // Initialize new field
    required this.possibleCauses, // Initialize new field
    required this.recommendedActions, // Initialize new field
    required this.relatedSymptoms, // Initialize new field
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DTC: $dtcCode',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Description: $description',
              style: const TextStyle(fontSize: 16),
            ),
            _buildDetailRow('Severity Level:', severityLevel),
            _buildDetailRow('Possible Causes:', possibleCauses),
            _buildDetailRow('Recommended Actions:', recommendedActions),
            _buildDetailRow('Related Symptoms:', relatedSymptoms),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(detail),
          ),
        ],
      ),
    );
  }
}

