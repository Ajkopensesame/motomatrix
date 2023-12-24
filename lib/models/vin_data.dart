class StringUtil {
  static String toTitleCase(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text.toLowerCase().split(' ').map((word) {
      final String firstLetter = word.isNotEmpty ? word[0].toUpperCase() : '';
      final String remaining = word.length > 1 ? word.substring(1) : '';
      return '$firstLetter$remaining';
    }).join(' ');
  }
}


class VinData {
  String? documentId;
  String? id;
  final String? make;
  final String? model;
  final String? year;
  final String? plantCity;
  final String? trimLevel;
  final String? vehicleType;
  final String? plantCountry;
  final String? bodyClass;
  final String? doors;
  final String? engineDisplacement;
  final String? fuelType;
  final String? transmissionType;
  final String? driveType;
  final String? gvwr;
  final String? curbWeight;
  final String? wheelbase;
  final String? numberOfSeats;
  final String? numberOfAirbags;
  final String? abs;
  final String? esc;
  final String? tpmsType;

  VinData({
    this.id,
    this.make,
    this.model,
    this.year,
    this.plantCity,
    this.trimLevel,
    this.vehicleType,
    this.plantCountry,
    this.bodyClass,
    this.doors,
    this.engineDisplacement,
    this.fuelType,
    this.transmissionType,
    this.driveType,
    this.gvwr,
    this.curbWeight,
    this.wheelbase,
    this.numberOfSeats,
    this.numberOfAirbags,
    this.abs,
    this.esc,
    this.tpmsType,
  });

  // Convert the object to a map
  Map<String, dynamic> toMap() {
    return {
      'vin': id,
      'make': make,
      'model': model,
      'year': year,
      'plantCity': plantCity,
      'trimLevel': trimLevel,
      'vehicleType': vehicleType,
      'plantCountry': plantCountry,
      'bodyClass': bodyClass,
      'doors': doors,
      'engineDisplacement': engineDisplacement,
      'fuelType': fuelType,
      'transmissionType': transmissionType,
      'driveType': driveType,
      'gvwr': gvwr,
      'curbWeight': curbWeight,
      'wheelbase': wheelbase,
      'numberOfSeats': numberOfSeats,
      'numberOfAirbags': numberOfAirbags,
      'abs': abs,
      'esc': esc,
      'tpmsType': tpmsType,
    };
  }

  // Create an object from a map
  VinData.fromMap(Map<String, dynamic> map)
      : id = map['vin'],
        make = StringUtil.toTitleCase(map['make']?? ''),
        model = StringUtil.toTitleCase(map['model']?? ''),
        year = StringUtil.toTitleCase(map['year']?? ''),
        plantCity = StringUtil.toTitleCase(map['plantCity']?? ''),
        trimLevel = StringUtil.toTitleCase(map['trimLevel']?? ''),
        vehicleType = StringUtil.toTitleCase(map['vehicleType']?? ''),
        plantCountry = StringUtil.toTitleCase(map['plantCountry']?? ''),
        bodyClass = StringUtil.toTitleCase(map['bodyClass']?? ''),
        doors = StringUtil.toTitleCase(map['doors']?? ''),
        engineDisplacement = StringUtil.toTitleCase(map['engineDisplacement']?? ''),
        fuelType = StringUtil.toTitleCase(map['fuelType']?? ''),
        transmissionType = StringUtil.toTitleCase(map['transmissionType']?? ''),
        driveType = StringUtil.toTitleCase(map['driveType']?? ''),
        gvwr = StringUtil.toTitleCase(map['gvwr']?? ''),
        curbWeight = StringUtil.toTitleCase(map['curbWeight']?? ''),
        wheelbase = StringUtil.toTitleCase(map['wheelbase']?? ''),
        numberOfSeats = StringUtil.toTitleCase(map['numberOfSeats']?? ''),
        numberOfAirbags = StringUtil.toTitleCase(map['numberOfAirbags']?? ''),
        abs = StringUtil.toTitleCase(map['abs']?? ''),
        esc = StringUtil.toTitleCase(map['esc']?? ''),
        tpmsType = StringUtil.toTitleCase(map['tpmsType']?? '');

  List<Map<String, String>> getDetails() {
    return [
      {'title': 'Make', 'value': make ?? 'N/A'},
      {'title': 'Model', 'value': model ?? 'N/A'},
      {'title': 'Year', 'value': year ?? 'N/A'},
      {'title': 'Plant City', 'value': plantCity ?? 'N/A'},
      {'title': 'Trim Level', 'value': trimLevel ?? 'N/A'},
      {'title': 'Vehicle Type', 'value': vehicleType ?? 'N/A'},
      {'title': 'Plant Country', 'value': plantCountry ?? 'N/A'},
      {'title': 'Body Class', 'value': bodyClass ?? 'N/A'},
      {'title': 'Doors', 'value': doors ?? 'N/A'},
      {'title': 'Engine Displacement', 'value': engineDisplacement ?? 'N/A'},
      {'title': 'Fuel Type', 'value': fuelType ?? 'N/A'},
      {'title': 'Transmission Type', 'value': transmissionType ?? 'N/A'},
      {'title': 'Drive Type', 'value': driveType ?? 'N/A'},
      {'title': 'GVWR', 'value': gvwr ?? 'N/A'},
      {'title': 'Curb Weight', 'value': curbWeight ?? 'N/A'},
      {'title': 'Wheelbase', 'value': wheelbase ?? 'N/A'},
      {'title': 'Number of Seats', 'value': numberOfSeats ?? 'N/A'},
      {'title': 'Number of Airbags', 'value': numberOfAirbags ?? 'N/A'},
      {'title': 'ABS', 'value': abs ?? 'N/A'},
      {'title': 'ESC', 'value': esc ?? 'N/A'},
      {'title': 'TPMS Type', 'value': tpmsType ?? 'N/A'},
    ];
  }
}