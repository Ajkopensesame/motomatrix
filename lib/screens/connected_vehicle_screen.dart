// connected_vehicle_screen.dart

import 'package:flutter/material.dart';

class ConnectedVehicleScreen extends StatefulWidget {
  @override
  _ConnectedVehicleScreenState createState() => _ConnectedVehicleScreenState();
}

class _ConnectedVehicleScreenState extends State<ConnectedVehicleScreen> {
  bool _isConnected = true; // Assuming the device is connected when this screen is navigated to

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connected Vehicle'),
        actions: [
          if (_isConnected)
            IconButton(
              icon: Icon(Icons.bluetooth_connected),
              onPressed: _disconnectVehicle,
            )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Vehicle Connected!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Vehicle Information:',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            // Sample vehicle information
            Text('Make: Toyota'),
            Text('Model: Camry'),
            Text('Year: 2020'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isConnected ? _disconnectVehicle : null,
              child: Text('Disconnect'),
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
