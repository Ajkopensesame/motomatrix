import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motomatrix/models/vin_data.dart';
import 'package:motomatrix/screens/vin_details_screen.dart';
import 'package:motomatrix/services/vin_decoder_service.dart';
import 'package:motomatrix/services/firestore_service.dart';
import 'package:motomatrix/widgets/custom_app_bar.dart';
import 'package:motomatrix/widgets/vin_summary_card.dart';
import '../widgets/custom_elevatedbutton.dart';
import '../widgets/custom_textfield.dart';
import 'barcode_scanner_screen.dart';

class VINDecoderScreen extends ConsumerStatefulWidget {
  const VINDecoderScreen({super.key});

  @override
  VINDecoderScreenState createState() => VINDecoderScreenState();
}

class VINDecoderScreenState extends ConsumerState<VINDecoderScreen> {
  final VINDecoderService _vinDecoderService = VINDecoderService();
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _vinController = TextEditingController();
  final List<VinData> _vinDataList = [];

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("VINDecoderScreen initState");
    }
    _fetchSavedVINs();
  }

  void _fetchSavedVINs() async {
    if (kDebugMode) {
      print("VINDecoderScreen _fetchSavedVINs");
    }
    List<VinData> savedVINs = await _firestoreService.getSavedVINs();
    setState(() {
      _vinDataList.clear();
      _vinDataList.addAll(savedVINs);
    });
  }

  void _decodeVIN(String vin) async {
    if (kDebugMode) {
      print("VINDecoderScreen _decodeVIN");
    }

    final scaffoldMessenger = ScaffoldMessenger.of(context); // Local reference to ScaffoldMessenger

    // Check if the widget is still mounted before proceeding.
    if (!mounted) return;

    bool vinAlreadyAdded = _vinDataList.any((vinData) => vinData.id == vin);

    if (vinAlreadyAdded) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('VIN already added')));
    } else {
      try {
        final data = await _vinDecoderService.decodeVIN(vin);
        VinData vinData = VinData.fromMap(data);

        try {
          await _firestoreService.saveVinData(vinData);

          // Check again because the above await could have taken some time.
          if (!mounted) return;

          scaffoldMessenger.showSnackBar(const SnackBar(content: Text('VIN decoded and saved successfully!')));

          setState(() {
            _vinDataList.add(vinData);
          });

          // Local reference to Navigator
          final navigator = Navigator.of(context);

          // Navigate to VINDetailsScreen with the decoded VinData
          navigator.push(
            MaterialPageRoute(
              builder: (context) => VINDetailsScreen(vinData: vinData),
            ),
          );

        } catch (e) {
          if (!mounted) return;
          scaffoldMessenger.showSnackBar(SnackBar(content: Text('Error saving decoded VIN: $e')));
        }
      } catch (e) {
        if (!mounted) return;
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('Error decoding VIN: $e')));
      }
    }
  }

  Future<void> _deleteVinData(VinData vinData) async {
    if (kDebugMode) {
      print("VINDecoderScreen _deleteVinData");
    }
    if (vinData.documentId != null) {
      // Capture the ScaffoldMessenger before the async gap
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      try {
        await _firestoreService.deleteVinData(vinData.documentId!);
        scaffoldMessenger.showSnackBar(const SnackBar(content: Text('VIN deleted successfully!')));

        setState(() {
          _vinDataList.removeWhere((data) => data.documentId == vinData.documentId);
        });
      } catch (error) {
        // Use the captured ScaffoldMessenger to show the snack bar
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('Error deleting VIN: $error')));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("VINDecoderScreen build");
    }
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/vin_decoder.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: _vinController,
              labelText: 'Enter VIN',
              hintText: 'Enter VIN here',
              suffixIcon: IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () async {
                  if (kDebugMode) {
                    print("VINDecoderScreen SuffixIcon onPressed");
                  }
                  final scannedVin = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BarcodeScannerScreen(),
                    ),
                  );

                  if (scannedVin != null && mounted) {
                    setState(() {
                      _vinController.text = scannedVin;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: CustomElevatedButton(
                label: 'Decode VIN',
                onPressed: () {
                  if (kDebugMode) {
                    print("VINDecoderScreen Decode VIN onPressed");
                  }
                  _decodeVIN(_vinController.text);
                },
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
                    onDismissed: (_) {
                      if (kDebugMode) {
                        print("VINDecoderScreen Dismissible onDismissed");
                      }
                      _deleteVinData(vinData);
                    },
                    background: Container(color: Colors.red, alignment: Alignment.centerRight, child: const Icon(Icons.delete, color: Colors.white)),
                    child: VinSummaryCard(vinData: vinData),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
