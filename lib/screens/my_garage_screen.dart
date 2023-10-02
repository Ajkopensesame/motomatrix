import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vin_data.dart';

class MyGarageScreen extends StatefulWidget {
  @override
  _MyGarageScreenState createState() => _MyGarageScreenState();
}

class _MyGarageScreenState extends State<MyGarageScreen> {
  final _firestore = FirebaseFirestore.instance;
  late final String _userId; // Declare _userId as a late final variable

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';  // Initialize _userId with the current authenticated user's ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Vehicles')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').doc(_userId).collection('vehicles').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final vehicles = snapshot.data!.docs.map((doc) => VinData.fromMap(doc.data() as Map<String, dynamic>)).toList();

          return ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return ListTile(
                title: Text(vehicle.make ?? 'Unknown Make'),
                subtitle: Text(vehicle.model ?? 'Unknown Model'),
                onTap: () {
                  Navigator.pop(context, vehicle);
                },
              );
            },
          );
        },
      ),
    );
  }
}
