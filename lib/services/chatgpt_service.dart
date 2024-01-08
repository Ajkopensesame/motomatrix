import 'package:motomatrix/models/vin_data.dart';
// import '../providers/vehicle_provider.dart'; // Remove if not used
import '../secrets/keys.dart';
import 'package:dart_openai/dart_openai.dart';
import '../models/custom_openai_chat_message_model.dart';

class ChatGPTService {
  List<CustomOpenAIChatMessageModel> conversation = [];

  ChatGPTService() {
    OpenAI.apiKey = ApiKeys.openApiKey;
  }

  Future<void> fetchPreviousConversations() async {}

  Future<OpenAIChatCompletionModel> askChatGPT(
      String question, VinData selectedVehicle) async {
    if (question.isEmpty) {
      throw Exception("Please enter a valid question.");
    }
    String vehicleDetails = selectedVehicle.toString();
    String userPrompt = """
Discussing vehicle: $vehicleDetails 
Issue: $question.
Please help me with my $question. 
""";

    if (conversation.isEmpty) {
      String systemPrompt = """
I am an AI trained to assist with a variety of inquiries and tasks. Please describe your question or issue in detail, and I will do my best to provide information, guidance, or assistance. 

Whether it's technical advice, problem-solving, general information, or specific instructions, I'm here to help. Just provide as much context as you can to ensure the most accurate and helpful response. 

If your query is about a specific topic or task, like diagnosing a vehicle issue, coding, recipe suggestions, historical facts, or anything else, please include all relevant details like specific codes, requirements, preferences, or constraints you have.

Remember, while I strive to provide accurate and up-to-date information, my responses are based on the data and training I have received, and some situations might require specialized expertise or additional research.
""";

      conversation.add(
        CustomOpenAIChatMessageModel(
          role: 'system',
          content: systemPrompt,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }

    conversation.add(
      CustomOpenAIChatMessageModel(
        role: 'user',
        content: userPrompt,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    // Convert conversation to OpenAIChatCompletionChoiceMessageModel
    var messages = conversation.map((customMessage) {
      var contentItem = OpenAIChatCompletionChoiceMessageContentItemModel.text(
          customMessage.content);
      return OpenAIChatCompletionChoiceMessageModel(
        role: customMessage.role == 'system'
            ? OpenAIChatMessageRole.system
            : OpenAIChatMessageRole.user,
        content: [contentItem],
      );
    }).toList();

    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: messages,
    );

    if (chatCompletion.choices.isEmpty) {
      throw Exception('Failed to fetch answer from ChatGPT');
    }

    // Correctly handle the received choices
    for (var choice in chatCompletion.choices) {
      if (choice.message.content
              is List<OpenAIChatCompletionChoiceMessageContentItemModel> &&
          choice.message.content!.isNotEmpty) {
        // Assuming the first item in the list contains the desired text
        var firstItem = choice.message.content?.first;
        // Assuming that firstItem has a text property which is a String
        String? content = firstItem?.text;
        conversation.add(
          CustomOpenAIChatMessageModel(
            role: 'assistant',
            content: content!.trim(),
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      }
    }

    return chatCompletion;
  }

  sendRequest(Map<String, Object> map) {}
}
