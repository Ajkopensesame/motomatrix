import 'package:flutter/material.dart';
import '../models/vin_data.dart';

class VINDetailsWidget extends StatelessWidget {
  final VinData vinData;

  VINDetailsWidget({required this.vinData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: _buildDetailsList(),
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

    detailsMap.forEach((title, value) {
      if (value != null && value.isNotEmpty && value != 'N/A' && value != 'N/a') {
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
