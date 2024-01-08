class StringUtil {
  static String toTitleCase(String text) {
    // List of exceptions that should retain their specific capitalization
    const Map<String, String> exceptions = {
      'mercedes-benz': 'Mercedes-Benz',
      'm-class': 'M-Class',
      // Add other exceptions here as needed
    };

    if (text.isEmpty) return text;

    // Check if the entire text is an exception
    final String lowerText = text.toLowerCase();
    if (exceptions.containsKey(lowerText)) {
      return exceptions[lowerText]!;
    }

    // Convert text to title case while considering exceptions for parts of the text
    return text
        .toLowerCase()
        .split(' ')
        .map((word) {
      // Check if the word is an exception
      final String lowerWord = word.toLowerCase();
      if (exceptions.containsKey(lowerWord)) {
        return exceptions[lowerWord]!;
      }

      final String firstLetter = word.isNotEmpty ? word[0].toUpperCase() : '';
      final String remaining = word.length > 1 ? word.substring(1) : '';
      return '$firstLetter$remaining';
    })
        .join(' ');
  }
}


class VinData {
  DateTime? createdAt;
  String? documentId;
  String? id;

  final String? make;
  final String? model;
  final String? year;
  final String? plantCity;
  final String? trimLevel;
  final String? vehicleType;
  final String? manufacturer;
  final String? plantCountry;
  final String? bodyClass;
  final String? doors;
  final String? engineDisplacement;
  final String? fuelType;
  final String? engineCylinders;
  final String? enginePowerKW;
  final String? trim2;
  final String? engineDisplacementCC;
  final String? engineDisplacementCI;
  final String? engineBrakeHP;
  final String? pretensioner;
  final String? seatBeltType;
  final String? otherRestraintSystemInfo;
  final String? frontAirBagLocations;
  final String? sideAirBagLocations;
  final String? tpmsType;
  final String? gvwr;

  VinData({
    this.createdAt,
    this.documentId,
    this.id,
    this.make,
    this.model,
    this.year,
    this.plantCity,
    this.trimLevel,
    this.vehicleType,
    this.manufacturer,
    this.plantCountry,
    this.bodyClass,
    this.doors,
    this.engineDisplacement,
    this.fuelType,
    this.engineCylinders,
    this.enginePowerKW,
    this.trim2,
    this.engineDisplacementCC,
    this.engineDisplacementCI,
    this.engineBrakeHP,
    this.pretensioner,
    this.seatBeltType,
    this.otherRestraintSystemInfo,
    this.frontAirBagLocations,
    this.sideAirBagLocations,
    this.tpmsType,
    this.gvwr,
  });

  // Convert the object to a map
  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'vin': id,
      'make': make,
      'model': model,
      'year': year,
      'plantCity': plantCity,
      'trimLevel': trimLevel,
      'vehicleType': vehicleType,
      'manufacturer': manufacturer,
      'plantCountry': plantCountry,
      'bodyClass': bodyClass,
      'doors': doors,
      'engineDisplacement': engineDisplacement,
      'fuelType': fuelType,
      'engineCylinders': engineCylinders,
      'enginePowerKW': enginePowerKW,
      'trim2': trim2,
      'engineDisplacementCC': engineDisplacementCC,
      'engineDisplacementCI': engineDisplacementCI,
      'engineBrakeHP': engineBrakeHP,
      'pretensioner': pretensioner,
      'seatBeltType': seatBeltType,
      'otherRestraintSystemInfo': otherRestraintSystemInfo,
      'frontAirBagLocations': frontAirBagLocations,
      'sideAirBagLocations': sideAirBagLocations,
      'tpmsType': tpmsType,
      'gvwr': gvwr,
    };
  }

  // Create an object from a map
  factory VinData.fromMap(Map<String, dynamic> map) {
    return VinData(
      id: map['vin'],
      make: StringUtil.toTitleCase(map['make'] ?? ''),
      model: StringUtil.toTitleCase(map['model'] ?? ''),
      year: StringUtil.toTitleCase(map['year'] ?? ''),
      plantCity: StringUtil.toTitleCase(map['plantCity'] ?? ''),
      trimLevel: StringUtil.toTitleCase(map['trimLevel'] ?? ''),
      vehicleType: StringUtil.toTitleCase(map['vehicleType'] ?? ''),
      manufacturer: StringUtil.toTitleCase(map['manufacturer'] ?? ''),
      plantCountry: StringUtil.toTitleCase(map['countryOfOrigin'] ?? ''),
      bodyClass: StringUtil.toTitleCase(map['bodyClass'] ?? ''),
      doors: StringUtil.toTitleCase(map['doors'] ?? ''),
      engineDisplacement:
          StringUtil.toTitleCase(map['engineDisplacement'] ?? ''),
      fuelType: StringUtil.toTitleCase(map['fuelType'] ?? ''),
      engineCylinders: StringUtil.toTitleCase(map['engineCylinders'] ?? ''),
      enginePowerKW: StringUtil.toTitleCase(map['enginePowerKW'] ?? ''),
      trim2: StringUtil.toTitleCase(map['trim2'] ?? ''),
      engineDisplacementCC:
          StringUtil.toTitleCase(map['engineDisplacementCC'] ?? ''),
      engineDisplacementCI:
          StringUtil.toTitleCase(map['engineDisplacementCI'] ?? ''),
      engineBrakeHP: StringUtil.toTitleCase(map['engineBrakeHP'] ?? ''),
      pretensioner: StringUtil.toTitleCase(map['pretensioner'] ?? ''),
      seatBeltType: StringUtil.toTitleCase(map['seatBeltType'] ?? ''),
      otherRestraintSystemInfo:
          StringUtil.toTitleCase(map['otherRestraintSystemInfo'] ?? ''),
      frontAirBagLocations:
          StringUtil.toTitleCase(map['frontAirBagLocations'] ?? ''),
      sideAirBagLocations:
          StringUtil.toTitleCase(map['sideAirBagLocations'] ?? ''),
      tpmsType: StringUtil.toTitleCase(map['tpmsType'] ?? ''),
      gvwr: StringUtil.toTitleCase(map['gvwr'] ?? ''),
    );
  }
  List<Map<String, String>> getDetails() {
    return [
      {'title': 'Make', 'value': make ?? 'N/A'},
      {'title': 'Model', 'value': model ?? 'N/A'},
      {'title': 'Year', 'value': year ?? 'N/A'},
      {'title': 'Plant City', 'value': plantCity ?? 'N/A'},
      {'title': 'Trim Level', 'value': trimLevel ?? 'N/A'},
      {'title': 'Vehicle Type', 'value': vehicleType ?? 'N/A'},
      {'title': 'Manufacturer Name', 'value': manufacturer ?? 'N/A'},
      {'title': 'Plant Country', 'value': plantCountry ?? 'N/A'},
      {'title': 'Body Class', 'value': bodyClass ?? 'N/A'},
      {'title': 'Doors', 'value': doors ?? 'N/A'},
      {
        'title': 'Engine Displacement (L)',
        'value': engineDisplacement ?? 'N/A'
      },
      {'title': 'Fuel Type - Primary', 'value': fuelType ?? 'N/A'},
      {
        'title': 'Engine Number of Cylinders',
        'value': engineCylinders ?? 'N/A'
      },
      {'title': 'Engine Power (kW)', 'value': enginePowerKW ?? 'N/A'},
      {'title': 'Trim2', 'value': trim2 ?? 'N/A'},
      {'title': 'Displacement (CC)', 'value': engineDisplacementCC ?? 'N/A'},
      {'title': 'Displacement (CI)', 'value': engineDisplacementCI ?? 'N/A'},
      {'title': 'Engine Brake (hp) From', 'value': engineBrakeHP ?? 'N/A'},
      {'title': 'Pretensioner', 'value': pretensioner ?? 'N/A'},
      {'title': 'Seat Belt Type', 'value': seatBeltType ?? 'N/A'},
      {
        'title': 'Other Restraint System Info',
        'value': otherRestraintSystemInfo ?? 'N/A'
      },
      {
        'title': 'Front Air Bag Locations',
        'value': frontAirBagLocations ?? 'N/A'
      },
      {
        'title': 'Side Air Bag Locations',
        'value': sideAirBagLocations ?? 'N/A'
      },
      {'title': 'TPMS Type', 'value': tpmsType ?? 'N/A'},
      {'title': 'GVWR', 'value': gvwr ?? 'N/A'},
    ];
  }

  @override
  String toString() {
    return 'Make: ${make ?? 'N/A'}, Model: ${model ?? 'N/A'}, Year: ${year ?? 'N/A'}, Fuel Type: ${fuelType ?? 'N/A'}, Engine Displacement: ${engineDisplacement ?? 'N/A'},';
    // Add other relevant fields as needed
  }
}
