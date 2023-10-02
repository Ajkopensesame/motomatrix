import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chatTypes;
import '../main.dart';
import '../providers/chat_notifier.dart';
import '../providers/chatgpt_service_provider.dart';
import '../services/chatgpt_service.dart';
import '../utils/save_to_firebase_utils.dart';

// Initialize an empty list for the conversation
List<OpenAIChatCompletionChoiceMessageModel> conversation = [];

Future<void> handleSendMessage(
    chatTypes.PartialText message,
    String hintText,
    chatTypes.User user,
    chatTypes.User aiAssistant,
    WidgetRef ref,
    List<chatTypes.TextMessage> messages) async {

  final chatGPTService = ref.read(chatGPTServiceProvider); // Reading the service from the provider
  final question = message.text;
  final currentVinData = ref.watch(vinDataProvider);

  if (question.isNotEmpty && currentVinData != null) {
    final userMessage = chatTypes.TextMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: question,
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    ref.read(chatProvider.notifier).addMessage(userMessage);

    // Create chat completion using OpenAIChatCompletionModel
    OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: "You are a vehicle diagnostic specialist.",
          role: OpenAIChatMessageRole.system,
        ),
        OpenAIChatCompletionChoiceMessageModel(
          content: "I am working on a ${currentVinData.year} ${currentVinData.make} ${currentVinData.model}.",
          role: OpenAIChatMessageRole.user,
        ),
        OpenAIChatCompletionChoiceMessageModel(
          content: question,
          role: OpenAIChatMessageRole.user,
        ),
      ],
    );

    if (chatCompletion.choices.isNotEmpty) {
      final content = chatCompletion.choices.first.message.content ?? "No response"; // Default value
      final aiMessage = chatTypes.TextMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        text: content,
        author: aiAssistant,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      ref.read(chatProvider.notifier).addMessage(aiMessage);

      // Fetch the updated messages list
      final updatedMessages = ref.read(chatProvider.notifier).state;

      // Save to Firestore
      saveConversationToFirestore(ref, updatedMessages);
    }
  }
}