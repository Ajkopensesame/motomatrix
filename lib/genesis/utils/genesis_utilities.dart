import 'dart:convert';

class GenesisUtilities {
  /// Converts a given map to a JSON string.
  static String mapToJson(Map<String, dynamic> data) {
    return jsonEncode(data);
  }

  /// Converts a given JSON string to a map.
  static Map<String, dynamic> jsonToMap(String jsonString) {
    return jsonDecode(jsonString);
  }

  /// Generates a hash for a given string, useful for caching or indexing.
  static String generateHash(String data) {
    return data.hashCode.toString();
  }

  /// Validates if a given string is a valid JSON string.
  static bool isValidJson(String str) {
    try {
      jsonDecode(str);
    } catch (e) {
      return false;
    }
    return true;
  }

  /// Truncates a given string to a specified length with an ellipsis.
  static String truncateString(String str, int length) {
    if (str.length <= length) {
      return str;
    }
    return str.substring(0, length) + '...';
  }

  /// Checks if a string contains any of the stop words.
  static bool containsStopWords(String input, List<String> stopWords) {
    for (var word in stopWords) {
      if (input.toLowerCase().contains(word)) {
        return true;
      }
    }
    return false;
  }

  /// Filters and cleans an input string, removing any stop words.
  static String filterInput(String input, List<String> stopWords) {
    return input.split(' ').where((word) => !stopWords.contains(word)).join(' ');
  }

  /// A function to calculate similarity between two strings.
  /// This could be based on algorithms like Levenshtein distance, Jaccard similarity, etc.
  static double calculateStringSimilarity(String a, String b) {
    // This is a placeholder. Implement an algorithm or use a library that offers this functionality.
    return 0.0; // Return similarity score between 0 and 1.
  }

// ... Add more utility functions as you need for Genesis.
}

