import 'package:flutter/material.dart';
import 'package:motomatrix/widgets/custom_background.dart';
import '../models/vin_data.dart';

class VINDetailsWidget extends StatelessWidget {
  final VinData vinData;

  const VINDetailsWidget({super.key, required this.vinData});

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      // Optional: Use CustomBackground for a consistent look
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16), // Added padding for better spacing
          child: Column(
            children: _buildDetailsList(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDetailsList() {
    List<Widget> detailsList = [];

    // Using a map to easily iterate and build the list
    Map<String, String?> detailsMap = {
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

    detailsMap.forEach((title, value) {
      if (value != null &&
          value.isNotEmpty &&
          value != 'N/A' &&
          value != 'N/a') {
        detailsList.add(_buildDetailTile(title, value));
      }
    });

    return detailsList;
  }

  Widget _buildDetailTile(String title, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
    );
  }
}
