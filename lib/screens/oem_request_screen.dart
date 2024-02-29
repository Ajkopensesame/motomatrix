import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motomatrix/models/vin_data.dart';
import 'package:motomatrix/widgets/custom_vehicle_app_bar.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_elevatedbutton.dart';
import '../widgets/custom_textfield.dart';

class OEMRequestScreen extends ConsumerStatefulWidget {
  const OEMRequestScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OEMRequestScreenState createState() => _OEMRequestScreenState();
}

class _OEMRequestScreenState extends ConsumerState<OEMRequestScreen> {
  String _selectedInfoType = 'Select Information Type';
  final TextEditingController _detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          _buildBackgroundImage(), // Background image
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomDropdown(
                  items: const [
                    'Select Information Type',
                    'Repair Procedures',
                    'Specifications',
                    'Wiring Diagrams',
                    'Other',
                  ],
                  value: _selectedInfoType,
                  onChanged: (value) {
                    setState(() {
                      _selectedInfoType = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _detailsController,
                  hintText: 'Additional Details or Comments',
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  onPressed: _submitRequest,
                  label: 'Submit Request',
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomVehicleAppBar(
        onVehicleSelected: (VinData selectedVehicle) {},
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Image.asset(
      'assets/images/oem_request.png', // Path to your 'oem_request.png' image
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  void _submitRequest() {
    // In a real-world scenario, send the request to the OEM or save it in a database

    // Handle the request submission logic here

    // Provide feedback to the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request submitted successfully!')),
    );
  }
}
