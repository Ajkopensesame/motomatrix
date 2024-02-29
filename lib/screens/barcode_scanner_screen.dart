import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  BarcodeScannerScreenState createState() => BarcodeScannerScreenState();
}

class BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  bool _isScanProcessed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan VIN')),
      body: AiBarcodeScanner(
        onScan: (String value) {
          if (!_isScanProcessed) {
            _isScanProcessed = true;
            // Print context and scanned value before pop
            if (kDebugMode) {
              print("Context: $context");
            }
            if (kDebugMode) {
              print("Before pop: $value");
            }
            Navigator.pop(context, value);
            // Note: The after pop print won't execute here because pop removes this screen from the navigation stack
          }
        },
      ),
    );
  }
}
