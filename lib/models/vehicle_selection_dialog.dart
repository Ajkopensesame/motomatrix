import 'package:flutter/material.dart';
import 'package:motomatrix/models/vin_data.dart';
import 'package:motomatrix/services/firestore_service.dart';

class VehicleSelectionDialog extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  VehicleSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: FutureBuilder(
        future: _firestoreService.getSavedVINs(),
        builder: (BuildContext context, AsyncSnapshot<List<VinData>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: double.infinity,
              height: 100, // Set the height as per your requirement
              decoration: BoxDecoration(
                color: Colors.transparent.withOpacity(
                    0.2), // Set the color and opacity as per your requirement
                borderRadius: BorderRadius.circular(
                    20), // Set the border radius as per your requirement
              ),
              alignment: Alignment.center,
              child: const Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.black, // Set the text color to black
                  fontSize: 24.0, // Set the font size as per your requirement
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return SingleChildScrollView(
              child: Column(
                children: snapshot.data!.map((vinData) {
                  return ListTile(
                    title: Text(
                        '${vinData.make} ${vinData.model} ${vinData.year}'),
                    onTap: () {
                      Navigator.of(context).pop(vinData);
                    },
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
