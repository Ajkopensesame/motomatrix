import 'package:flutter/material.dart';
import 'package:motomatrix/models/vin_data.dart';

class VehicleProvider extends ChangeNotifier {
  VinData? _selectedVehicle;

  VinData? get selectedVehicle => _selectedVehicle;

  get make => null;

  get model => null;

  get year => null;

  set selectedVehicle(VinData? vehicle) {
    _selectedVehicle = vehicle;
    notifyListeners();
  }

  void setSelectedVehicle(VinData selectedVehicle) {
    _selectedVehicle = selectedVehicle;
    notifyListeners();
  }
}
