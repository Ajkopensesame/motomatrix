import 'package:flutter/material.dart';
import 'package:motomatrix/models/vin_data.dart';
import 'package:motomatrix/services/firestore_service.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class VehicleSelectionDialog extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();
  static const darkBlue = Color(0xFF193B52);

  VehicleSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adjust the size of the dialog to fit its content
        children: [
          FutureBuilder(
            future: _firestoreService.getSavedVINs(),
            builder: (BuildContext context, AsyncSnapshot<List<VinData>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  width: double.infinity,
                  height: 100, // Adjust the height as needed
                  child: Center(child: CircularProgressIndicator()), // Loading indicator
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: snapshot.data!.expand((vinData) {
                      return [
                        ListTile(
                          title: Text(
                            '${vinData.year} ${vinData.make} ${vinData.model}',
                            textAlign: TextAlign.center, // Center the text within the title space of ListTile
                          ),
                          onTap: () {
                            Navigator.of(context).pop(vinData);
                          },
                        ),
                        const Divider(color: darkBlue), // Divider after each ListTile, including the last one
                      ];
                    }).toList(),
                  ),
                );
              }
            },
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/vin_decoder');
            },
            child: Container(
              padding: const EdgeInsets.all(8.0), // Adjust padding as needed
              alignment: Alignment.center,
              child: const Row(
                mainAxisSize: MainAxisSize.min, // Use MainAxisSize.min to size the row to fit its children
                children: [
                  Icon(Symbols.barcode_scanner, color: darkBlue, size: 40), // Adjust icon size as needed
                  SizedBox(width: 8), // Add some space between the icon and the text
                  Text(
                    'VIN Decoder',
                    style: TextStyle(
                      color: darkBlue, // Use the same color as the icon for consistency
                      fontSize: 16, // Adjust font size as needed
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
