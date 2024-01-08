import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motomatrix/models/vin_data.dart';
import 'package:motomatrix/screens/dtc_info_screen.dart';
import 'package:motomatrix/services/firestore_service.dart';
import 'package:motomatrix/main.dart';
import 'package:motomatrix/models/vehicle_selection_dialog.dart';

class CustomVehicleAppBar extends ConsumerWidget {
  final Null Function(VinData selectedVehicle) onVehicleSelected;

  const CustomVehicleAppBar({
    super.key,
    required this.onVehicleSelected,
    VinData? selectedVehicle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch the last saved vehicle once when the AppBar is built
    final lastSavedVehicleFuture = _fetchLastSavedVehicle();

    // Schedule a callback for the end of this frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final VinData? lastSavedVehicle = await lastSavedVehicleFuture;
      if (lastSavedVehicle != null &&
          ref.read(vehicleProvider).selectedVehicle == null) {
        ref.read(vehicleProvider.notifier).setSelectedVehicle(lastSavedVehicle);
      }
    });

    return FutureBuilder<VinData?>(
      future: lastSavedVehicleFuture,
      builder: (context, snapshot) {
        // Determine which vehicle to display
        final vehicleToDisplay =
            ref.watch(vehicleProvider).selectedVehicle ?? snapshot.data;

        return BottomAppBar(
          color: AppColors.darkBlue, // Retaining the black background
          child: Stack(
            children: [
              // ClipRRect to apply a rounded corner to the image
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                  child: vehicleToDisplay != null
                      ? Image.asset(
                    'assets/logos/optimized/${vehicleToDisplay.make?.toLowerCase()}.png',
                    fit: BoxFit.fitWidth, // You can use BoxFit.cover to maintain aspect ratio
                  )
                      : Container(), // Provide an empty container if there's no vehicle to display
                ),
              ),

              // AppBar content centered horizontally
              Center(
                child: GestureDetector(
                  onTap: () async {
                    final selectedVehicle = await showDialog<VinData?>(
                      context: context,
                      builder: (BuildContext context) => VehicleSelectionDialog(),
                    );
                    if (selectedVehicle != null) {
                      ref
                          .read(vehicleProvider.notifier)
                          .setSelectedVehicle(selectedVehicle);
                      onVehicleSelected(selectedVehicle);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: const Color(0xB0000000), // Darker semi-transparent black
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.touch_app, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          vehicleToDisplay != null
                              ? ' ${vehicleToDisplay.year} ${vehicleToDisplay.make} ${vehicleToDisplay.model}'
                              : 'Select Vehicle',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<VinData?> _fetchLastSavedVehicle() async {
    FirestoreService firestoreService = FirestoreService();
    return await firestoreService.getLastSavedVehicle();
  }
}
