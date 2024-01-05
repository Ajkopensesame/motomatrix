// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../models/vin_data.dart';

class CustomVINCard extends StatelessWidget {
  final VinData vinData;

  const CustomVINCard({super.key, required this.vinData});

  static const darkBlue = Color(0xFF193B52);

  @override
  Widget build(BuildContext context) {
    String logoAssetPath =
        'assets/logos/optimized/${vinData.make?.toLowerCase()}.png';

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [],
        ),
        child: Column(
          children: [
            Image.asset(
              logoAssetPath,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildDetailsList(),
              ),
            ),
            Image.asset(
              logoAssetPath,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDetailsList() {
    List<Widget> detailsList = [];

    Map<String, IconData> detailIcons = {
      'VIN': Icons.confirmation_number,
      'Make': Icons.business,
      'Model': Icons.category,
      'Year': Icons.calendar_today,
      'Plant City': Icons.location_city,
      'Trim Level': Icons.layers,
      'Vehicle Type': Icons.directions_car,
      'Plant Country': Icons.flag,
      'Body Class': Icons.directions_bus,
      'Doors': Icons.door_front_door,
      'Engine Displacement': Icons.build_circle,
      'Fuel Type': Icons.local_gas_station,
      'Transmission Type': Icons.settings,
      'Drive Type': Icons.drive_eta,
      'GVWR': Icons.scale,
      'Curb Weight': Icons.line_weight,
      'Wheelbase': Icons.straighten,
      'Number of Seats': Icons.event_seat,
      'Number of Airbags': Icons.airline_seat_individual_suite,
      'ABS': Icons.security,
      'ESC': Icons.build,
      'TPMS Type': Icons.tire_repair,
    };

    Map<String, String?> details = {
      'VIN': vinData.id,
      'Make': vinData.make,
      'Model': vinData.model,
      'Year': vinData.year,
      'Plant City': vinData.plantCity,
      'Trim Level': vinData.trimLevel,
      'Vehicle Type': vinData.vehicleType,
      'Plant Country': vinData.plantCountry,
      'Body Class': vinData.bodyClass,
      'Doors': vinData.doors,
      'Engine Displacement': vinData.engineDisplacement,
      'Fuel Type': vinData.fuelType,
      'Transmission Type': vinData.transmissionType,
      'Drive Type': vinData.driveType,
      'GVWR': vinData.gvwr,
      'Curb Weight': vinData.curbWeight,
      'Wheelbase': vinData.wheelbase,
      'Number of Seats': vinData.numberOfSeats,
      'Number of Airbags': vinData.numberOfAirbags,
      'ABS': vinData.abs,
      'ESC': vinData.esc,
      'TPMS Type': vinData.tpmsType,
    };

    details.forEach((key, value) {
      if (value != null &&
          value.isNotEmpty &&
          value != 'N/A' &&
          value != 'N/a') {
        detailsList.add(_buildDetailItem(key, value, detailIcons[key]));
        detailsList.add(const Divider(color: Colors.grey));
      }
    });

    return detailsList;
  }

  Widget _buildDetailItem(String key, String value, IconData? icon) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: darkBlue),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(key, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }
}
