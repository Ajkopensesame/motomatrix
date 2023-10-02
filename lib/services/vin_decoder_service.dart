import 'dart:convert';
import 'package:http/http.dart' as http;

class VINDecoderService {
  final String _baseUrl = 'https://vpic.nhtsa.dot.gov/api/vehicles';

  Future<Map<String, dynamic>> decodeVIN(String vin) async {
    final response = await http.get(Uri.parse('$_baseUrl/DecodeVin/$vin?format=json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = json.decode(response.body);
      if (decodedData['Results'] != null && decodedData['Results'].isNotEmpty) {
        return _transformResults(vin, decodedData['Results']);
      } else {
        throw Exception('Failed to decode VIN');
      }
    } else {
      throw Exception('Failed to load data from NHTSA API');
    }
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
        case 'Engine Model':
          transformedResults['engineType'] = value ?? 'N/A';
          break;
        case 'Transmission Style':
          transformedResults['transmission'] = value ?? 'N/A';
          break;
        case 'Drive Type':
          transformedResults['drivetrain'] = value ?? 'N/A';
          break;
        case 'Manufacturer Name':
          transformedResults['manufacturer'] = value ?? 'N/A';
          break;
        case 'Plant Country':
          transformedResults['countryOfOrigin'] = value ?? 'N/A';
          break;
        case 'Fuel Type - Primary':
          transformedResults['fuelType'] = value ?? 'N/A';
          break;
        case 'Plant City':
          transformedResults['plantCity'] = value ?? 'N/A';
          break;
        case 'Body Class':
          transformedResults['bodyClass'] = value ?? 'N/A';
          break;
        case 'Number of Doors':
          transformedResults['doors'] = value ?? 'N/A';
          break;
        case 'Engine Displacement (in liters)':
          transformedResults['engineDisplacement'] = value ?? 'N/A';
          break;
        case 'Gross Vehicle Weight Rating (GVWR)':
          transformedResults['gvwr'] = value ?? 'N/A';
          break;
        case 'Curb Weight':
          transformedResults['curbWeight'] = value ?? 'N/A';
          break;
        case 'Wheelbase':
          transformedResults['wheelbase'] = value ?? 'N/A';
          break;
        case 'Number of Seats':
          transformedResults['numberOfSeats'] = value ?? 'N/A';
          break;
        case 'Number of Airbags (Front, Side, and Knee)':
          transformedResults['airbags'] = value ?? 'N/A';
          break;
        case 'Anti-lock Braking System (ABS)':
          transformedResults['abs'] = value ?? 'N/A';
          break;
        case 'Electronic Stability Control (ESC)':
          transformedResults['esc'] = value ?? 'N/A';
          break;
        case 'Tire Pressure Monitoring System (TPMS) Type':
          transformedResults['tpmsType'] = value ?? 'N/A';
          break;
        case 'Trim Level':
          transformedResults['trimLevel'] = value ?? 'N/A';
          break;
        case 'Transmission Type':
          transformedResults['transmissionType'] = value ?? 'N/A';
          break;
      }
    }

    return transformedResults;
  }
}
