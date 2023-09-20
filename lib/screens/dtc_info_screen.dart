import 'package:flutter/material.dart';
// Import other necessary packages and custom widgets

class DTCInfoScreen extends StatefulWidget {
  @override
  _DTCInfoScreenState createState() => _DTCInfoScreenState();
}

class _DTCInfoScreenState extends State<DTCInfoScreen> {
  // Initialize variables and controllers

  Future<List<dynamic>> fetchData() async {
    // Simulated data fetching logic. Replace with your actual data fetching logic.
    await Future.delayed(Duration(seconds: 2));
    return ['DTC1', 'DTC2', 'DTC3'];  // Sample data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DTC Information'),
        // Use custom_app_bar.dart if needed
      ),
      body: Stack(
        children: [
          _buildBackgroundImage(), // Background image
          FutureBuilder<List<dynamic>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(snapshot.data![index]),
                  ),
                );
              }
              return Center(child: Text('No DTC data available'));  // Default return
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Image.asset(
      'assets/images/dtc_info.png', // Path to your 'dtc_info.png' image
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
