import 'package:flutter/material.dart';
import '../models/vin_data.dart';
import '../widgets/customVINcard.dart';
import '../widgets/custom_app_bar.dart';

class VINDetailsScreen extends StatelessWidget {
  final VinData vinData;

  const VINDetailsScreen({super.key, required this.vinData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title:('VIN Details')),
      body: CustomVINCard(vinData: vinData),
    );
  }
}
