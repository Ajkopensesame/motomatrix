import 'package:flutter/material.dart';
import '../models/vin_data.dart';
import '../screens/vin_details_screen.dart'; // Ensure this is the correct path to your VIN details screen

class VinSummaryCard extends StatelessWidget {
  final VinData vinData;

  const VinSummaryCard({super.key, required this.vinData});

  @override
  Widget build(BuildContext context) {
    // Function to convert the first letter of each word to uppercase
    String toTitleCase(String text) {
      return text.split(' ').map((word) {
        if (word.isNotEmpty) {
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        }
        return '';
      }).join(' ');
    }

    String makeTitleCase = toTitleCase(vinData.make ?? ''); // Apply title case to the whole make string

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
          borderRadius: BorderRadius.circular(15.0), // Adds a radius of 15.0 to the card
        ),
        child: ListTile(
          title: Text(
            '${vinData.year} $makeTitleCase ${vinData.model} - ${vinData.engineDisplacement}L', // Updated order and included engine displacement
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
