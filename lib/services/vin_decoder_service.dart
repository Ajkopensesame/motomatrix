import 'dart:convert';
import 'package:http/http.dart' as http;

class VINDecoderService {
  final String _baseUrl = 'https://vpic.nhtsa.dot.gov/api/vehicles';

  Future<Map<String, dynamic>> decodeVIN(String vin) async {
    // First, try the standard DecodeVin endpoint
    Uri standardUri = Uri.parse('$_baseUrl/DecodeVin/$vin?format=json');
    http.Response response = await http.get(standardUri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = json.decode(response.body);
      if (decodedData['Results'] != null && decodedData['Results'].isNotEmpty) {
        return _transformResults(vin, decodedData['Results']);
      }
    }

    // If the standard decoder fails, try the Canadian VIN decoder
    Uri canadianUri = Uri.parse(
        '$_baseUrl/GetCanadianVehicleSpecifications/?format=json&vin=$vin');
    response = await http.get(canadianUri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = json.decode(response.body);
      if (decodedData['Results'] != null && decodedData['Results'].isNotEmpty) {
        return _transformResults(
            vin,
            decodedData[
                'Results']); // You may need a different transformation for Canadian data
      }
    }

    throw Exception(
        'Failed to decode VIN with both standard and Canadian decoders');
  }

  Map<String, dynamic> _transformResults(String vin, List<dynamic> results) {
    Map<String, dynamic> transformedResults = {'vin': vin};

    for (var result in results) {
      String variable = result['Variable'];
      dynamic value = result['Value'];

      switch (variable) {
        case 'Make':
          transformedResults['make'] = value ?? 'N/A';
          break;
        case 'Model':
          transformedResults['model'] = value ?? 'N/A';
          break;
        case 'Model Year':
          transformedResults['year'] = value?.toString() ?? 'N/A';
          break;
        case 'Vehicle Type':
          transformedResults['vehicleType'] = value ?? 'N/A';
          break;
        case 'Plant City':
          transformedResults['plantCity'] = value ?? 'N/A';
          break;
        case 'Manufacturer Name':
          transformedResults['manufacturer'] = value ?? 'N/A';
          break;
        case 'Plant Country':
          transformedResults['countryOfOrigin'] = value ?? 'N/A';
          break;
        case 'Body Class':
          transformedResults['bodyClass'] = value ?? 'N/A';
          break;
        case 'Doors':
          transformedResults['doors'] = value?.toString() ?? 'N/A';
          break;
        case 'Displacement (L)':
          transformedResults['engineDisplacement'] = value?.toString() ?? 'N/A';
          break;
        case 'Fuel Type - Primary':
          transformedResults['fuelType'] = value ?? 'N/A';
          break;
        case 'Trim':
          transformedResults['trimLevel'] = value ?? 'N/A';
          break;
        case 'Gross Vehicle Weight Rating From':
          transformedResults['gvwr'] = value ?? 'N/A';
          break;
        case 'Engine Number of Cylinders':
          transformedResults['engineCylinders'] = value?.toString() ?? 'N/A';
          break;
        case 'Engine Power (kW)':
          transformedResults['enginePowerKW'] = value?.toString() ?? 'N/A';
          break;
        case 'Trim2':
          transformedResults['trim2'] = value ?? 'N/A';
          break;
        case 'Displacement (CC)':
          transformedResults['engineDisplacementCC'] =
              value?.toString() ?? 'N/A';
          break;
        case 'Displacement (CI)':
          transformedResults['engineDisplacementCI'] =
              value?.toString() ?? 'N/A';
          break;
        case 'Engine Brake (hp) From':
          transformedResults['engineBrakeHP'] = value?.toString() ?? 'N/A';
          break;
        case 'Pretensioner':
          transformedResults['pretensioner'] = value ?? 'N/A';
          break;
        case 'Seat Belt Type':
          transformedResults['seatBeltType'] = value ?? 'N/A';
          break;
        case 'Other Restraint System Info':
          transformedResults['otherRestraintSystemInfo'] = value ?? 'N/A';
          break;
        case 'Front Air Bag Locations':
          transformedResults['frontAirBagLocations'] = value ?? 'N/A';
          break;
        case 'Side Air Bag Locations':
          transformedResults['sideAirBagLocations'] = value ?? 'N/A';
          break;
        case 'Tire Pressure Monitoring System (TPMS) Type':
          transformedResults['tpmsType'] = value ?? 'N/A';
          break;
      }
    }

    return transformedResults;
  }
}
