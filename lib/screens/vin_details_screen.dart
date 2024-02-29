import 'package:flutter/material.dart';
import 'package:motomatrix/services/dtc_save_to_firebase.dart';
import '../models/vin_data.dart';
import '../widgets/customVINcard.dart';
import '../widgets/join_discussion_button.dart'; // Make sure to import your JoinDiscussionButton widget

class VINDetailsScreen extends StatefulWidget {
  final VinData vinData;

  const VINDetailsScreen({super.key, required this.vinData});

  @override
  VINDetailsScreenState createState() => VINDetailsScreenState();
}

class VINDetailsScreenState extends State<VINDetailsScreen> {
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
                      child: JoinDiscussionButton(
                        dtcCode: entry['dtc'],
                        make: entry['make'] ?? 'Unknown',  // Provide a fallback value
                        model: entry['model'] ?? 'Unknown',  // Provide a fallback value
                        year: entry['year']?.toString() ?? 'Unknown',  // Ensure year is a string and provide a fallback
                        engineDisplacement: entry['engineDisplacement'] ?? 'Unknown',   // Provide a fallback value
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
