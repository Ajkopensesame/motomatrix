class GenesisConstants {
  // Define URLs, API Endpoints, and other static string values here.
  static const String API_ENDPOINT = 'https://api.yourservice.com/';

  // Default values for the system.
  static const double DEFAULT_CONFIDENCE_THRESHOLD = 0.75;

  // Timeout for network requests.
  static const Duration NETWORK_TIMEOUT = Duration(seconds: 10);

  // Keywords or tokenization settings.
  static const List<String> STOP_WORDS = [
    'and', 'the', 'is', 'of', 'to', 'in', 'it', 'you', 'that', 'a', 'we', 'on'
    // ... add more common words which you'd like to ignore during processing.
  ];

  // Directories or paths for storing cached data, assets, etc.
  static const String CACHE_DIR = 'genesis_cache/';

  // Other settings or configurations specific to the Genesis module.
  // For example, threshold values, default configurations, etc.

  // Maximum history entries to keep.
  static const int MAX_HISTORY_ENTRIES = 100;

  // Neural network configurations, if required.
  static const int NN_INPUT_SIZE = 512;
  static const int NN_OUTPUT_SIZE = 128;
  static const String NN_MODEL_PATH = 'assets/models/nn_model.tflite';

// ... Add more constants as you see fit.
}

