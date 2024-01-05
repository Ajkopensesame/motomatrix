import '../models/vin_data.dart';
import '../secrets/keys.dart';
import 'package:dart_openai/dart_openai.dart';

class DtcChatGPTService {
  DtcChatGPTService() {
    OpenAI.apiKey = ApiKeys.openApiKey;
  }

  Future<OpenAIChatCompletionModel> askDtcChatGPT(
      String dtcCode, VinData selectedVehicle) async {
    if (dtcCode.isEmpty) {
      throw Exception("Please enter a valid DTC code.");
    }

    String userPrompt = """
We are discussing a ${selectedVehicle.year} ${selectedVehicle.make} ${selectedVehicle.model} with a Diagnostic Trouble Code (DTC): $dtcCode.
- Vehicle Identifier : Provide the ${selectedVehicle.year} ${selectedVehicle.make} ${selectedVehicle.model}.
- Code Identifier: Provide the unique alphanumeric code of the DTC.
- Severity Level: Indicate the severity of the issue (e.g., minor, moderate, critical).
- System or Component Affected: Describe which part of the vehicle is affected by this DTC (e.g., engine, transmission).
- Description of the Issue: Offer a clear, concise explanation of the problem indicated by the DTC.
- Possible Causes: List common causes for the DTC code $dtcCode, helping in preliminary diagnostics.
- Recommended Actions: Suggest initial steps or actions the user can take to address the DTC. Please note that the user should not be referred to a dealer or mechanic. Avoid suggesting professional technicians or dealerships.
- Refer user to Request OEM Information for more information.
""";

    // Create a content item model with the user prompt
    var contentItem =
        OpenAIChatCompletionChoiceMessageContentItemModel.text(userPrompt);

    // Create a message model with the content item
    var messageModel = OpenAIChatCompletionChoiceMessageModel(
      role: OpenAIChatMessageRole.user,
      content: [contentItem],
    );

    // Call the OpenAI chat create method with the message model
    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: [messageModel],
    );

    if (chatCompletion.choices.isEmpty) {
      throw Exception('Failed to fetch answer from ChatGPT');
    }

    return chatCompletion;
  }
}
