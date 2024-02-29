import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class VehicleDisplayWidget extends StatelessWidget {
  final String? make;
  final String? model;
  final String? year;

  const VehicleDisplayWidget({super.key, this.make, this.model, this.year});

  @override
  Widget build(BuildContext context) {
    String logoAssetPath = 'assets/logos/optimized/${make?.toLowerCase()}.png';

    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7), // Opaque background
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Image.asset(
            logoAssetPath,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              // If the logo isn't found, display a placeholder or an error widget
              return const Icon(Icons.error, size: 50, color: Colors.red);
            },
            width: 100, // Set your desired width for the logo
          ),
          const SizedBox(height: 10),
          Text(make ?? 'Unknown Make', style: const TextStyle(fontSize: 20)),
          if (model != null && model!.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(model!, style: const TextStyle(fontSize: 18)),
          ],
          if (year != null && year!.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(year!, style: const TextStyle(fontSize: 16)),
          ],
          IconButton(
            icon: const Icon(Symbols.barcode_scanner,
                color: Colors.blue,
                size: 30), // Adjust the icon's color and size as needed
            onPressed: () {
              Navigator.of(context).pushNamed('/vin_decoder');
            },
          ),
        ],
      ),
    );
  }
}
