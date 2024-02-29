import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:flutter_chat_types/flutter_chat_types.dart' as chatTypes;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motomatrix/models/vin_data.dart';
import 'package:motomatrix/widgets/custom_app_bar.dart';
import 'package:motomatrix/widgets/custom_vehicle_app_bar.dart';
import '../providers/chat_notifier.dart';
import '../utils/handle_send_message.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatProvider);
    return _ChatScreenBuilder(ref: ref, messages: messages).build(context);
  }
}

class _ChatScreenBuilder {
  final WidgetRef ref;
  final List<chatTypes.TextMessage> messages;
  final AutoScrollController autoScrollController = AutoScrollController();
  final chatTypes.User user = const chatTypes.User(id: 'user_id');
  final chatTypes.User aiAssistant = const chatTypes.User(id: 'genesis_id');
  String hintText = "How Can I Help";

  _ChatScreenBuilder({required this.ref, required this.messages});

  void startNewConversation() {
    ref.read(chatProvider.notifier).clearMessages();
  }

  void _handlePreFilledButton(String question) {
    handleSendMessage(chatTypes.PartialText(text: question), hintText, user,
        aiAssistant, ref, messages, autoScrollController);
  }

  Widget build(BuildContext context) {
    List<chatTypes.TextMessage> reversedMessages = messages.reversed.toList();

    return Scaffold(
      appBar: const CustomAppBar(


      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/genesis.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              if (messages.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            _handlePreFilledButton('Help Me Diagnose A DTC'),
                        child: const Text(
                          'Help Me Diagnose A DTC',
                          style:
                              TextStyle(color: Colors.black), // Add this line
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            _handlePreFilledButton('Help Me Diagnose a Noise'),
                        child: const Text(
                          'Help Me Diagnose a Noise',
                          style:
                              TextStyle(color: Colors.black), // Add this line
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _handlePreFilledButton(
                            'Tell Me About Common Issues'),
                        child: const Text(
                          'Tell Me About Common Issues',
                          style:
                              TextStyle(color: Colors.black), // Add this line
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Chat(
                  messages: reversedMessages,
                  onSendPressed: (chatTypes.PartialText message) {
                    handleSendMessage(message, hintText, user, aiAssistant, ref,
                        messages, autoScrollController);
                  },
                  user: user,
                  scrollController: autoScrollController,
                  theme: const DefaultChatTheme(
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomVehicleAppBar(
        onVehicleSelected: (VinData selectedVehicle) {},
      ),
    );
  }
}
