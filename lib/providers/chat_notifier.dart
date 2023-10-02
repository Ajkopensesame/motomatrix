import 'package:flutter_chat_types/flutter_chat_types.dart' as chatTypes;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatNotifier extends StateNotifier<List<chatTypes.TextMessage>> {
  ChatNotifier() : super([]);
  bool isTyping = false;

  void addMessage(chatTypes.TextMessage message) {
    state = [...state, message];
  }
  void clearMessages() {
    state = [];
  }

  void showTyping(bool value) {
    isTyping = value;
  }

  void loadPreviousMessages(List<chatTypes.TextMessage> previousMessages) {
    // Add previous messages to the state
    state = [...previousMessages, ...state];
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, List<chatTypes.TextMessage>>(
      (ref) => ChatNotifier(),
);
