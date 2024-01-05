import 'package:flutter/material.dart';
import '../models/vin_data.dart';
import '../screens/vin_details_screen.dart'; // Ensure you have this screen as suggested earlier

class VinSummaryCard extends StatelessWidget {
  final VinData vinData;

  const VinSummaryCard({super.key, required this.vinData});

  @override
  Widget build(BuildContext context) {
    String makeTitleCase = vinData.make![0].toUpperCase() + vinData.make!.substring(1).toLowerCase();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VINDetailsScreen(vinData: vinData),
          ),
        );
      },
      child: Card(
        color: Colors.white.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),  // This adds a radius of 15.0 to the card
        ),
        child: ListTile(
          title: Text(
            '$makeTitleCase ${vinData.model} ${vinData.year}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
