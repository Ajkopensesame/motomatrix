// connected_vehicle_screen.dart

import 'package:flutter/material.dart';

class ConnectedVehicleScreen extends StatefulWidget {
  const ConnectedVehicleScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConnectedVehicleScreenState createState() => _ConnectedVehicleScreenState();
}

class _ConnectedVehicleScreenState extends State<ConnectedVehicleScreen> {
  bool _isConnected =
      true; // Assuming the device is connected when this screen is navigated to

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connected Vehicle'),
        actions: [
          if (_isConnected)
            IconButton(
              icon: const Icon(Icons.bluetooth_connected),
              onPressed: _disconnectVehicle,
            )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Vehicle Connected!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Vehicle Information:',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            // Sample vehicle information
            const Text('Make: Toyota'),
            const Text('Model: Camry'),
            const Text('Year: 2020'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isConnected ? _disconnectVehicle : null,
              child: const Text('Disconnect'),
            ),
          ],
        ),
      ),
    );
  }

  void _disconnectVehicle() {
    // In a real-world scenario, you would handle the Bluetooth disconnection logic here
    setState(() {
      _isConnected = false;
    });
    Navigator.pop(context); // Return to the previous screen after disconnecting
  }
}
