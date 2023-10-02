import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chatTypes;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';
import '../providers/chat_notifier.dart';
import '../services/chatgpt_service.dart';
import '../utils/save_to_firebase_utils.dart'; // Assume you put saveConversationToFirestore here

class ChatScreen extends ConsumerWidget {
  final Function fetchPreviousConversation;

  ChatScreen({required this.fetchPreviousConversation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    fetchPreviousConversation();
    final messages = ref.watch(chatProvider);
    return _ChatScreenBuilder(ref: ref, messages: messages).build(context);
  }
}

class _ChatScreenBuilder {
  final WidgetRef ref;
  final List<chatTypes.TextMessage> messages;
  final ChatGPTService _chatGPTService = ChatGPTService();
  final chatTypes.User user = const chatTypes.User(id: 'user_id');
  final chatTypes.User aiAssistant = const chatTypes.User(id: 'genesis_id');
  bool waitingForConfirmation = false;
  String hintText = "How Can I Help";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  _ChatScreenBuilder({required this.ref, required this.messages});

  void startNewConversation() {
    ref.read(chatProvider.notifier).clearMessages();
  }

  void _handlePreFilledButton(String question) {
    _handleSendMessage(chatTypes.PartialText(text: question));
  }

  void _handleSendMessage(chatTypes.PartialText message) async {
    final question = message.text;
    final currentVinData = ref.watch(vinDataProvider);

    if (currentVinData != null) {
      hintText = "How Can I Help You With Your ${currentVinData.make}, ${currentVinData.model}, ${currentVinData.year}";
    }

    if (question.isNotEmpty && currentVinData != null) {
      final userMessage = chatTypes.TextMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: question,
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      ref.read(chatProvider.notifier).addMessage(userMessage);

      final response = await _chatGPTService.askChatGPT(question, currentVinData, waitingForConfirmation);

      if (response != null) {
        final aiMessage = chatTypes.TextMessage(
          id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          text: response,
          author: aiAssistant,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        );
        ref.read(chatProvider.notifier).addMessage(aiMessage);
        await saveConversationToFirestore(ref, messages);  // Assume saveConversationToFirestore function is updated accordingly
      }

      waitingForConfirmation = !waitingForConfirmation;
    }
  }

  Widget build(BuildContext context) {
    List<chatTypes.TextMessage> reversedMessages = messages.reversed.toList();
    final isTyping = ref.watch(chatProvider.notifier).isTyping;

    return Scaffold(
      appBar: AppBar(
        title: Text('Genesis Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => startNewConversation(),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/genesis.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (isTyping) CircularProgressIndicator(),
          Column(
            children: [
              Expanded(
                child: Chat(
                  messages: reversedMessages,
                  onSendPressed: _handleSendMessage,
                  user: user,
                  theme: DefaultChatTheme(
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              if (messages.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _handlePreFilledButton('Help Me Diagnose A DTC'),
                        child: Text('Help Me Diagnose A DTC'),
                      ),
                      ElevatedButton(
                        onPressed: () => _handlePreFilledButton('Help Me Diagnose a Noise'),
                        child: Text('Help Me Diagnose a Noise'),
                      ),
                      ElevatedButton(
                        onPressed: () => _handlePreFilledButton('Tell Me About Common Issues'),
                        child: Text('Tell Me About Common Issues'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
