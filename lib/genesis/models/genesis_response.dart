class GenesisResponse {
  // The main response text.
  final String response;

  // Confidence level of the response. Useful when relying on AI models.
  final double confidence;

  // Algorithm or source that produced this response.
  final String source;

  // Timestamp to know when this response was generated.
  final DateTime timestamp;

  GenesisResponse({
    required this.response,
    required this.confidence,
    required this.source,
    required this.timestamp,
  });

  // Helper to convert object to JSON for storage or transmission purposes.
  Map<String, dynamic> toJson() => {
    'response': response,
    'confidence': confidence,
    'source': source,
    'timestamp': timestamp.toIso8601String(),
  };

  // Helper to create object from JSON, especially useful when retrieving data.
  static GenesisResponse fromJson(Map<String, dynamic> json) {
    return GenesisResponse(
      response: json['response'],
      confidence: json['confidence'],
      source: json['source'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

