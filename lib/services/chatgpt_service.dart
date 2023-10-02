import '../models/vin_data.dart';
import '../secrets/keys.dart';
import 'package:dart_openai/dart_openai.dart';
import '../models/custom_openai_chat_message_model.dart';  // Make sure to create this model

class ChatGPTService {
  List<CustomOpenAIChatMessageModel> conversation = [];

  ChatGPTService() {
    OpenAI.apiKey = ApiKeys.openApiKey;
  }

  Future<OpenAIChatCompletionModel> askChatGPT(String question, VinData currentVinData) async {
    if (question.isEmpty) {
      throw Exception("Please enter a valid question.");
    }

    String userPrompt = """
We are discussing a ${currentVinData.year} ${currentVinData.make} ${currentVinData.model}. 
Issue: $question.
- Review our conversation history for context.
- Identify common issues related to $question for a ${currentVinData.year} ${currentVinData.make} ${currentVinData.model}.
- Provide a comprehensive diagnosis.
- Guide me through troubleshooting and repairs step by step.
- Assume I have professional-level tools and expertise. No external help needed.
- Engage me with follow-up questions for a more accurate diagnosis.
- Always prioritize safety and let me know of any precautions I should take.
""";

    if (conversation.isEmpty) {
      String systemPrompt = """
Genesis, you are an AI automotive diagnostic assistant. Your roles and responsibilities are as follows:
- Remember the conversation history to maintain context.
- Provide detailed, step-by-step diagnostic and repair instructions.
- Keep the user engaged with relevant follow-up questions.
- Assume the user has access to professional-level repair tools.
- Do not suggest external mechanics or dealerships.
- Be specific and detailed in your solutions.
- Safety is the highest priority; make this clear in your guidance.
- Use the user's VIN data for more accurate diagnostics.
- Keep the conversation ongoing until the issue is resolved or a specific action point is reached.
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

    OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: conversation.map((customMessage) => OpenAIChatCompletionChoiceMessageModel(
        role: customMessage.role == 'system' ? OpenAIChatMessageRole.system : OpenAIChatMessageRole.user,
        content: customMessage.content,
      )).toList(),
    );

    if (chatCompletion.choices.isEmpty) {
      throw Exception('Failed to fetch answer from ChatGPT');
    }

    conversation.add(
      CustomOpenAIChatMessageModel(
        role: 'assistant',
        content: chatCompletion.choices[0].message.content.trim(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    return chatCompletion;
  }
}
