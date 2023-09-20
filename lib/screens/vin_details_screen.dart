import 'package:flutter/material.dart';
import '../models/vin_data.dart';
import '../widgets/vindetails_widget.dart';

class VINDetailsScreen extends StatelessWidget {
  final VinData vinData;

  VINDetailsScreen({required this.vinData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VIN Details')),
      body: VINDetailsWidget(vinData: vinData),
    );
  }
}
