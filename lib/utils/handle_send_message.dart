import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: library_prefixes
import 'package:flutter_chat_types/flutter_chat_types.dart' as chatTypes;
import 'package:motomatrix/models/vin_data.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../main.dart';
import '../providers/chat_notifier.dart';
import '../providers/chatgpt_service_provider.dart';
import '../utils/save_to_firebase_utils.dart';

// Initialize an empty list for the conversation
List<OpenAIChatCompletionChoiceMessageModel> conversation = [];

Future<void> handleSendMessage(
    chatTypes.PartialText message,
    String hintText,
    chatTypes.User user,
    chatTypes.User aiAssistant,
    WidgetRef ref,
    List<chatTypes.TextMessage> messages,
    AutoScrollController autoScrollController) async {
  final chatGPTService =
      ref.read(chatGPTServiceProvider); // Reading the service from the provider
  await chatGPTService.fetchPreviousConversations();
  final question = message.text;
  final VinData? selectedVehicle = ref.read(vehicleProvider).selectedVehicle;

  if (question.isNotEmpty) {
    final userMessage = chatTypes.TextMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: question,
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    ref.read(chatProvider.notifier).addMessage(userMessage);
    int latestMessageIndex = messages.length - 1;
    autoScrollController.scrollToIndex(latestMessageIndex,
        preferPosition: AutoScrollPosition.end);

    // Create chat completion using OpenAIChatCompletionModel
    OpenAIChatCompletionModel chatCompletion =
        await chatGPTService.askChatGPT(question, selectedVehicle as VinData);

    if (chatCompletion.choices.isNotEmpty) {
      // Assuming each item in the list has a 'text' property which is a string
      final contentList = chatCompletion.choices.first.message.content
          ?.map((item) => item.text?.trim()) // Trim each string in the list
          .whereType<String>() // Filter out any empty strings
          .toList();

      final joinedContent = contentList != null && contentList.isNotEmpty
          ? contentList.join(' ') // Join all non-empty, trimmed strings
          : 'Fallback or default response';

      final aiMessage = chatTypes.TextMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        text: joinedContent,
        author: aiAssistant,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      ref.read(chatProvider.notifier).addMessage(aiMessage);
      latestMessageIndex = messages.length - 1;
      autoScrollController.scrollToIndex(latestMessageIndex,
          preferPosition: AutoScrollPosition.end);

      // Fetch the updated messages list
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      final updatedMessages = ref.read(chatProvider.notifier).state;

      // Save to Firestore
      saveConversationToFirestore(ref, updatedMessages);
    }
  }
}
