import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import 'connected_vehicle_screen.dart';

class OBD2Screen extends StatefulWidget {
  @override
  _OBD2ScreenState createState() => _OBD2ScreenState();
}

class _OBD2ScreenState extends State<OBD2Screen> {
  bool _isConnected = false; // To track Bluetooth connection status
  List<String> _obdData = []; // Sample data for demonstration

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'OBD2 Interaction'),
      body: Stack(
        children: [
          _buildBackgroundImage(), // Background image
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (_isConnected) ...[
                  Expanded(
                    child: ListView.builder(
                      itemCount: _obdData.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_obdData[index]),
                        );
                      },
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleBluetoothConnection,
        child: Icon(
          _isConnected ? Icons.bluetooth_connected : Icons.bluetooth,
          color: Theme.of(context).primaryColor,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Image.asset(
      'assets/images/obd2.png', // Path to your 'obd2.png' image
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  void _connectOBD2() {
    // In a real-world scenario, initiate Bluetooth connection here
    // For demonstration, we'll simulate a connection and sample data retrieval
    setState(() {
      _isConnected = true;
      _obdData = [
        'Vehicle Speed: 60 mph',
        'Engine RPM: 3000',
        'Coolant Temperature: 90°C',
        // ... Add more sample data
      ];
    });
  }

  void _disconnectOBD2() {
    // In a real-world scenario, disconnect from the OBD2 device here
    setState(() {
      _isConnected = false;
      _obdData = [];
    });
  }

  void _handleBluetoothConnection() {
    if (_isConnected) {
      _disconnectOBD2();
    } else {
      _connectOBD2();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConnectedVehicleScreen()),
      );
    }
  }
}
