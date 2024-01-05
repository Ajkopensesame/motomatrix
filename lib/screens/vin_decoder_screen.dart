// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motomatrix/main.dart';
import 'package:motomatrix/widgets/custom_vehicle_app_bar.dart';
import '../models/vin_data.dart';
import '../services/vin_decoder_service.dart';
import '../services/firestore_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_elevatedbutton.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/vin_summary_card.dart';
import '../screens/vin_details_screen.dart';

class VINDecoderScreen extends ConsumerStatefulWidget {
  const VINDecoderScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VINDecoderScreenState createState() => _VINDecoderScreenState();
}

class _VINDecoderScreenState extends ConsumerState<VINDecoderScreen> {
  final VINDecoderService _vinDecoderService = VINDecoderService();
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _vinController = TextEditingController();
  final List<VinData> _vinDataList = [];

  @override
  void initState() {
    super.initState();
    _fetchSavedVINs();
  }

  void _fetchSavedVINs() async {
    List savedVINs = await _firestoreService.getSavedVINs();
    setState(() {
      _vinDataList.clear();
      _vinDataList.addAll(savedVINs as Iterable<VinData>);
    });
  }

  void _decodeVIN(BuildContext context) async {
    String enteredVin = _vinController.text;

    // Check if the entered VIN is already in the list
    bool vinAlreadyAdded = _vinDataList.any((vinData) => vinData.id == enteredVin);

    if (vinAlreadyAdded) {
      // Show a snackbar if the VIN is already added
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('VIN already added')),
      );
    } else {
      // Existing logic to decode and save VIN
      try {
        final data = await _vinDecoderService.decodeVIN(enteredVin);
        VinData vinData = VinData.fromMap(data);

        try {
          await _firestoreService.saveVinData(vinData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('VIN decoded and saved successfully!')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving decoded VIN: $e')),
          );
        }

        ref.read(vehicleProvider.notifier).setSelectedVehicle(vinData);

        setState(() {
          _vinDataList.add(vinData);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error decoding VIN: $e')),
        );
      }
    }
  }


  Future<void> _deleteVinData(VinData vinData) async {
    if (vinData.documentId != null) {
      try {
        await _firestoreService.deleteVinData(vinData.documentId!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('VIN deleted successfully!')),
        );

        setState(() {
          _vinDataList.remove(vinData);
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting VIN: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'VIN Decoder'),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/vin_decoder.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _vinController,
                label: 'Enter VIN',
                hintText: 'Enter VIN',
              ),
              const SizedBox(height: 20),
              Center(
                child: CustomElevatedButton(
                  label: 'Decode VIN',
                  onPressed: () => _decodeVIN(context),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _vinDataList.length,
                  itemBuilder: (context, index) {
                    final vinData = _vinDataList[index];
                    return Dismissible(
                      key: ValueKey(vinData.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20.0),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        // Handle deletion synchronously
                        _deleteVinData(vinData);
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VINDetailsScreen(vinData: vinData),
                            ),
                          );
                        },
                        child: VinSummaryCard(vinData: vinData),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomVehicleAppBar(
        onVehicleSelected: (VinData selectedVehicle) {},
      ),
    );
  }
}
