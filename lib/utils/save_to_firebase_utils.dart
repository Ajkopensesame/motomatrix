import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chatTypes;
import '../main.dart';

Future<void> saveConversationToFirestore(WidgetRef ref, List<chatTypes.TextMessage> messages) async {
  final currentUser = fbAuth.FirebaseAuth.instance.currentUser;
  final userId = currentUser?.uid ?? 'anonymous';
  final currentVinData = ref.watch(vinDataProvider);

  final documentRef = FirebaseFirestore.instance.collection('conversations').doc(userId);
  await documentRef.set({
    'userId': userId,
    'make': currentVinData?.make,
    'model': currentVinData?.model,
    'year': currentVinData?.year,
    'vin': currentVinData?.id,
    'messages': messages.map((e) => e.toJson()).toList(),
  }, SetOptions(merge: true));
}
