import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motomatrix/widgets/custom_vehicle_app_bar.dart';
import '../models/vin_data.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/vin_summary_card.dart'; // Import VinSummaryCard

class MyGarageScreen extends StatefulWidget {
  const MyGarageScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyGarageScreenState createState() => _MyGarageScreenState();
}

class _MyGarageScreenState extends State<MyGarageScreen> {
  final _firestore = FirebaseFirestore.instance;
  late final String _userId;
  VinData? _lastSavedVehicle;

  VinData? get selectedVehicle => null;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: ('My Vehicles')),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mygarage.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('users')
                .doc(_userId)
                .collection('vehicles')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final vehicles = snapshot.data!.docs
                  .map((doc) =>
                      VinData.fromMap(doc.data() as Map<String, dynamic>))
                  .toList();

              return ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  return VinSummaryCard(vinData: vehicle);
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomVehicleAppBar(
        selectedVehicle: _lastSavedVehicle,
        onVehicleSelected: (VinData vehicle) {
          setState(() {
            _lastSavedVehicle = vehicle;
          });
        },
      ),
    );
  }
}
