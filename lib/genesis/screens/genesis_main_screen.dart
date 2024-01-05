/*

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motomatrix/models/vehicle_selection_dialog.dart';
import 'package:motomatrix/models/vin_data.dart';
import 'package:motomatrix/widgets/custom_vehicle_app_bar.dart';
import '../../main.dart';
import '../../screens/chat_screen.dart'; // [ADDED] import the ChatScreen
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_textbutton.dart';

class GenesisMainScreen extends ConsumerStatefulWidget {
  const GenesisMainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GenesisMainScreenState createState() => _GenesisMainScreenState();
}

class _GenesisMainScreenState extends ConsumerState<GenesisMainScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Select Vehicle'),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/genesis.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            CustomTextButton(
              label: "Chat with Genesis",
              onPressed:
                  _navigateToChat, // [ADDED] Navigate to ChatScreen logic
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomVehicleAppBar(
        onVehicleSelected: (VinData selectedVehicle) {},
      ),
    );
  }

  Future<void> _selectVehicle() async {
    final selectedVehicle = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return VehicleSelectionDialog(); // This is a custom dialog that you need to implement
      },
    );

    if (selectedVehicle != null) {
      ref.read(vinDataProvider.notifier).setVinData(selectedVehicle);
    }
  }

  // [ADDED] Logic to navigate to the chat screen with Genesis
  void _navigateToChat() {
    VinData? selectedVehicle = ref.read(vehicleProvider).selectedVehicle;

    if (selectedVehicle != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(selectedVehicle: selectedVehicle),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a vehicle first.')),
      );
    }
  }
}
*/