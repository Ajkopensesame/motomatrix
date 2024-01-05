import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motomatrix/models/vin_data.dart';
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
          child: Container(
            decoration: BoxDecoration(
              image: vehicleToDisplay != null
                  ? DecorationImage(
                      image: AssetImage(
                          'assets/logos/optimized/${vehicleToDisplay.make?.toLowerCase()}.png'),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final selectedVehicle = await showDialog<VinData?>(
                        context: context,
                        builder: (BuildContext context) =>
                            VehicleSelectionDialog(),
                      );
                      if (selectedVehicle != null) {
                        // Update the selected vehicle in the provider
                        ref
                            .read(vehicleProvider.notifier)
                            .setSelectedVehicle(selectedVehicle);
                        // Invoke the callback function
                        onVehicleSelected(selectedVehicle);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: const Color(
                            0xB0000000), // Darker semi-transparent black
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.touch_app,
                              color: Colors.white), // Tap Icon
                          const SizedBox(
                              width: 8), // Space between icon and text
                          Text(
                            vehicleToDisplay != null
                                ? ' ${vehicleToDisplay.make} ${vehicleToDisplay.model} ${vehicleToDisplay.year}'
                                : 'Select Vehicle',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
