import 'package:dart_openai/dart_openai.dart';
import '../models/vin_data.dart';
import '../secrets/keys.dart';

class ChatGPTService {
  List<OpenAIChatCompletionChoiceMessageModel> conversation = [];

  ChatGPTService() {
    // Set the API key for OpenAI
    OpenAI.apiKey = ApiKeys.openApiKey;
  }

  Future<String> askChatGPT(String question, VinData currentVinData, bool waitingForConfirmation) async {
    if (question.isEmpty) {
      return "Please enter a valid question.";
    }

    String context = "I am working on a ${currentVinData.year} ${currentVinData.make} ${currentVinData.model}. ";
    String fullPrompt = context;
    if (waitingForConfirmation) {
      fullPrompt += "Is this the information you were looking for?";
    } else {
      fullPrompt += question;
    }

    conversation.add(OpenAIChatCompletionChoiceMessageModel(
      content: fullPrompt,
      role: OpenAIChatMessageRole.user,
    ));

    String response = "";
    OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: conversation,
    );

    if (chatCompletion.choices.isNotEmpty) {
      response = chatCompletion.choices[0].message.content.trim();
      conversation.add(OpenAIChatCompletionChoiceMessageModel(
        content: response,
        role: OpenAIChatMessageRole.assistant,
      ));
    } else {
      throw Exception('Failed to fetch answer from ChatGPT');
    }

    return response;
  }
}
