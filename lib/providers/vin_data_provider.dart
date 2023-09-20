import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vin_data.dart';  // Adjust the import path based on your directory structure

final vinDataProvider = StateProvider<VinData?>((ref) => null);
