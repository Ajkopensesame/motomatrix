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
      'Manufacturer Name': Icons.factory,
      'Plant Country': Icons.flag,
      'Body Class': Icons.directions_bus,
      'Doors': Icons.door_front_door,
      'Engine Displacement': Icons.build_circle,
      'Fuel Type': Icons.local_gas_station,
      'Engine Cylinders': Icons.engineering,
      'Engine Power (kW)': Icons.power,
      'Trim2': Icons.layers_clear,
      'Displacement (CC)': Icons.memory,
      'Displacement (CI)': Icons.square_foot,
      'Engine Brake (hp) From': Icons.speed,
      'Pretensioner': Icons.security,
      'Seat Belt Type': Icons.security,
      'Other Restraint System Info': Icons.info_outline,
      'Front Air Bag Locations': Icons.security,
      'Side Air Bag Locations': Icons.security,
      'TPMS Type': Icons.tire_repair,
      'GVWR': Icons.scale,
      // Add more icon mappings as needed
    };

    Map<String, String?> details = {
      'VIN': vinData.id,
      'Make': vinData.make,
      'Model': vinData.model,
      'Year': vinData.year,
      'Plant City': vinData.plantCity,
      'Trim Level': vinData.trimLevel,
      'Vehicle Type': vinData.vehicleType,
      'Manufacturer Name': vinData.manufacturer,
      'Plant Country': vinData.plantCountry,
      'Body Class': vinData.bodyClass,
      'Doors': vinData.doors,
      'Engine Displacement': vinData.engineDisplacement,
      'Fuel Type': vinData.fuelType,
      'Engine Cylinders': vinData.engineCylinders,
      'Engine Power (kW)': vinData.enginePowerKW,
      'Trim2': vinData.trim2,
      'Displacement (CC)': vinData.engineDisplacementCC,
      'Displacement (CI)': vinData.engineDisplacementCI,
      'Engine Brake (hp) From': vinData.engineBrakeHP,
      'Pretensioner': vinData.pretensioner,
      'Seat Belt Type': vinData.seatBeltType,
      'Other Restraint System Info': vinData.otherRestraintSystemInfo,
      'Front Air Bag Locations': vinData.frontAirBagLocations,
      'Side Air Bag Locations': vinData.sideAirBagLocations,
      'TPMS Type': vinData.tpmsType,
      'GVWR': vinData.gvwr,
      // Add more fields as needed
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
