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
    String vehicleDetails = selectedVehicle.toString();
    String userPrompt = """
Scenario: A technician is diagnosing a $vehicleDetails that has triggered a Diagnostic Trouble Code (DTC): $dtcCode.

1. **Issue Description and Severity**: For the $vehicleDetails, describe the issue related to DTC $dtcCode, including its potential impact on vehicle performance and safety.
2. **Affected System/Component**: Identify the specific system or component likely affected by this DTC.
3. **Step-by-Step Fix**: Provide a step-by-step guide for diagnosing and resolving this issue.
4. **Common Mistakes**: Highlight any common mistakes or misdiagnoses typically associated with this DTC.
5. **Safety Precautions**: Outline any safety precautions or critical checks to be considered while addressing this DTC.
6. **Similar Cases**: Share insights on similar cases or related DTCs observed in the same make and model.
7. **Preventive Measures**: Suggest preventive actions to avoid future occurrences of this DTC.

Aim for a response that balances technical accuracy with clarity, suitable for a professional with basic to intermediate understanding of vehicle diagnostics.
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
