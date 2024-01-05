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

    String userPrompt = """
We are discussing a ${selectedVehicle.year} ${selectedVehicle.make} ${selectedVehicle.model}. 
Issue: $question.
- Identify common issues related to $question for a ${selectedVehicle.year} ${selectedVehicle.make} ${selectedVehicle.model}.
- Guide me through troubleshooting and repairs step by step.
- Do not suggest external help from professional technicians, mechanics or dealerships.
- Engage me with follow-up questions for a more accurate diagnosis.
- Always prioritize safety and let me know of any precautions I should take.
""";

    if (conversation.isEmpty) {
      String systemPrompt = """
Genesis, you are an AI automotive diagnostic assistant. Your roles and responsibilities are as follows:
- Check for common problems associated with the users $question and provide to the user.
- Keep responses as specific and as brief as possible. 
- Ask user for further instructions
- Keep the user engaged with relevant follow-up questions.
- Do not suggest external mechanics or dealerships.
- Be specific and detailed in your solutions.
- Safety is the highest priority; make this clear in your guidance.
- Keep the conversation ongoing until the issue is resolved or a specific action point is reached.
- Assume the user basic knowledge of automotive diagnostics.
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
      if (choice.message.content is List<OpenAIChatCompletionChoiceMessageContentItemModel> && choice.message.content!.isNotEmpty) {
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
