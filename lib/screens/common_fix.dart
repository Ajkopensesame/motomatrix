import 'package:flutter/material.dart';
// Import your custom widgets if needed
import '../widgets/custom_app_bar.dart';

class CommonFixScreen extends StatefulWidget {
  @override
  _CommonFixScreenState createState() => _CommonFixScreenState();
}

class _CommonFixScreenState extends State<CommonFixScreen> {
  // Sample data for demonstration purposes
  List<DTCFix> commonFixes = [
    DTCFix(code: 'P0010', description: 'Camshaft Position Actuator Circuit/Open', fix: 'Replace camshaft position sensor'),
    DTCFix(code: 'P0020', description: 'Bank 2 Camshaft Sensor Actuator', fix: 'Check the engine oil level and condition'),
    // ... Add more sample data or fetch from a database/API
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Common Fixes'), // Use your custom app bar
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/common_fix.png'), // Path to your image
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: commonFixes.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('${commonFixes[index].code} - ${commonFixes[index].description}'),
              subtitle: Text('Common Fix: ${commonFixes[index].fix}'),
              leading: Icon(Icons.build), // An icon representing a fix
              onTap: () {
                // Navigate to a detailed screen or show more info if needed
              },
            );
          },
        ),
      ),
    );
  }
}

class DTCFix {
  final String code;
  final String description;
  final String fix;

  DTCFix({required this.code, required this.description, required this.fix});
}
