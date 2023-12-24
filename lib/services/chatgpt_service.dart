import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/vin_data.dart';
import '../secrets/keys.dart';
import 'package:dart_openai/dart_openai.dart';
import '../models/custom_openai_chat_message_model.dart';  // Make sure to create this model

class ChatGPTService {
  List<CustomOpenAIChatMessageModel> conversation = [];

  ChatGPTService() {
    OpenAI.apiKey = ApiKeys.openApiKey;
  }
  Future<void> fetchPreviousConversations() async {

  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<OpenAIChatCompletionModel> askChatGPT(String question, VinData currentVinData) async {
    if (question.isEmpty) {
      throw Exception("Please enter a valid question.");
    }

    String userPrompt = """
We are discussing a ${currentVinData.year} ${currentVinData.make} ${currentVinData.model}. 
Issue: $question.
- Identify common issues related to $question for a ${currentVinData.year} ${currentVinData.make} ${currentVinData.model}.
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
