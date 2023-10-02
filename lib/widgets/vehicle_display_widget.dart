import 'package:flutter/material.dart';

class VehicleDisplayWidget extends StatelessWidget {
  final String? make;
  final String? model;
  final String? year;

  VehicleDisplayWidget({this.make, this.model, this.year});

  @override
  Widget build(BuildContext context) {
    String logoAssetPath = 'assets/logos/optimized/${make?.toLowerCase()}.png';

    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7), // Opaque background
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Image.asset(
            logoAssetPath,
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
              // If the logo isn't found, display a placeholder or an error widget
              return Icon(Icons.error, size: 50, color: Colors.red);
            },
            width: 100, // Set your desired width for the logo
          ),
          SizedBox(height: 10),
          Text(make ?? 'Unknown Make', style: TextStyle(fontSize: 20)),
          if (model != null && model!.isNotEmpty) ...[
            SizedBox(height: 5),
            Text(model!, style: TextStyle(fontSize: 18)),
          ],
          if (year != null && year!.isNotEmpty) ...[
            SizedBox(height: 5),
            Text(year!, style: TextStyle(fontSize: 16)),
          ],
        ],
      ),
    );
  }
}
