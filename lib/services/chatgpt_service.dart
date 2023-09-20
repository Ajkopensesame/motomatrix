import 'dart:convert';

import 'package:http/http.dart' as http;

import '../secrets/keys.dart';

class ChatGPTService {
  final String myKey = ApiKeys.openApiKey;

  Future<String> askChatGPT(String question) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/engines/davinci/completions'),
      headers: {
        'Authorization': 'Bearer $myKey',
        'Content-Type': 'application/json',
      },
      body: '{"prompt": "$question", "max_tokens": 150}',
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['choices'][0]['text'].trim();
    } else {
      throw Exception('Failed to fetch answer from ChatGPT');
    }
  }
}
