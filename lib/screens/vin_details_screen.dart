// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:motomatrix/services/dtc_save_to_firebase.dart';
import '../models/vin_data.dart';
import '../widgets/customVINcard.dart';

class VINDetailsScreen extends StatefulWidget {
  final VinData vinData;

  const VINDetailsScreen({super.key, required this.vinData});

  @override
  _VINDetailsScreenState createState() => _VINDetailsScreenState();
}

class _VINDetailsScreenState extends State<VINDetailsScreen> {
  List<Map<String, dynamic>> userSearchedDtcEntries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserSearchedDtcEntries();
  }

  Future<void> _fetchUserSearchedDtcEntries() async {
    try {
      var fetchedEntries = await VehicleDataService()
          .fetchUserSearchedDtcEntries(
              widget.vinData.make, widget.vinData.model, widget.vinData.year);
      setState(() {
        userSearchedDtcEntries = fetchedEntries;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String logoAssetPath =
        'assets/logos/optimized/${widget.vinData.make?.toLowerCase()}.png'; // Image path based on make

    return Scaffold(
      appBar: AppBar(title: const Text('VIN Details')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomVINCard(vinData: widget.vinData),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: userSearchedDtcEntries.length,
              itemBuilder: (context, index) {
                var entry = userSearchedDtcEntries[index];
                return ExpansionTile(
                  title: Text(
                    "${entry['year']} ${entry['make']} ${entry['model']} - ${entry['dtc']}",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  children: [
                    ListTile(title: Text(entry['chatGPTResponse'])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Placeholder action for the button
                          // Here you can add the logic to navigate to the discussion page
                          print('Join Discussion button pressed for DTC ${entry['dtc']}');
                        },
                        child: const Text('Join Discussion'),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Place the Image.asset here so it appears after the list
            Image.asset(
              logoAssetPath,
              fit: BoxFit.contain,
            ),
            Container(height: 80), // Blank container with a height of 80 pixels

          ],
        ),
      ),
    );
  }
}
