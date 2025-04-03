import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 🔥 Envoie un message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    await _db.collection('messages').doc(chatId).collection('chat').add({
      'text': text,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// 🔥 Stream des messages d'une conversation
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _db
        .collection('messages')
        .doc(chatId)
        .collection('chat')
        .orderBy('timestamp')
        .snapshots();
  }

  /// 🔥 Stream des utilisateurs connectés
  Stream<QuerySnapshot> getConnectedUsers() {
    return _db.collection('utilisateurs').snapshots();
  }

  /// 🔥 Génère un ID de chat unique
  String getChatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode ? '$uid1-$uid2' : '$uid2-$uid1';
  }
}
