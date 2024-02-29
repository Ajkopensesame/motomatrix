// ignore_for_file: library_prefixes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chatTypes;
import '../providers/vin_data_provider.dart';

Future<void> saveConversationToFirestore(
    WidgetRef ref, List<chatTypes.TextMessage> messages) async {
  final currentUser = fbAuth.FirebaseAuth.instance.currentUser;
  final userId = currentUser?.uid ?? 'anonymous';
  final currentVinData = ref.watch(vinDataProvider);

  final conversationId = "$userId-${currentVinData?.id}";
  final documentRef = FirebaseFirestore.instance
      .collection('conversations')
      .doc(conversationId);

  final docSnapshot = await documentRef.get();
  List<dynamic> existingMessages = [];
  if (docSnapshot.exists) {
    existingMessages = docSnapshot.data()?['messages'] ?? [];
  }

  // Filter out messages that are already in existingMessages based on their id
  final newMessages = messages
      .where((msg) =>
          !existingMessages.any((existingMsg) => existingMsg['id'] == msg.id))
      .map((e) => e.toJson())
      .toList();

  // Combine existing messages with new messages
  final allMessages = [...existingMessages, ...newMessages];

  await documentRef.set({
    'userId': userId,
    'make': currentVinData?.make,
    'model': currentVinData?.model,
    'year': currentVinData?.year,
    'vin': currentVinData?.id,
    'messages': allMessages,
  }, SetOptions(merge: true));
}
