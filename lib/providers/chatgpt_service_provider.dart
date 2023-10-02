import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/chatgpt_service.dart';

final chatGPTServiceProvider = Provider<ChatGPTService>((ref) {
  return ChatGPTService();
});
