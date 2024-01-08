class DtcEntry {
  String make;
  String model;
  String year;
  String dtcCode;
  String engineDisplacement;
  String chatGPTResponse;
  int searchCount; // Field to store the number of times this entry has been searched

  DtcEntry({
    required this.make,
    required this.model,
    required this.year,
    required this.dtcCode,
    required this.engineDisplacement,
    required this.chatGPTResponse,
    this.searchCount = 0,
  });

  // You can add methods to convert to and from Map if needed, for Firestore compatibility.
}
