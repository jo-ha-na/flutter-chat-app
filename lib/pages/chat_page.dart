import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/utils/secure_storage.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String targetUserId;

  const ChatPage({super.key, required this.targetUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  String? currentUserId;
  late String chatId;
  String targetUserPseudo = "";
  bool targetUserOnline = false;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    currentUserId = await SecureStorage().getUserId();
    if (currentUserId == null) {
      debugPrint("❌ Aucune session utilisateur trouvée");
      return;
    }

    chatId = _getChatId(currentUserId!, widget.targetUserId);
    debugPrint("✅ Chat ID généré: $chatId");
    _fetchTargetUserData();
    setState(() {});
  }

  String _getChatId(String userA, String userB) {
    return (userA.compareTo(userB) < 0) ? "${userA}_$userB" : "${userB}_$userA";
  }

  Future<void> _fetchTargetUserData() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.targetUserId)
            .get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        debugPrint("✅ Document data: $data");
        setState(() {
          targetUserPseudo = data['pseudo'] ?? "Utilisateur";
          targetUserOnline =
              data.containsKey('isOnline') ? data['isOnline'] : false;
        });
        debugPrint(
          "✅ Données utilisateur récupérées: $targetUserPseudo, online: $targetUserOnline",
        );
      }
    } else {
      debugPrint("❌ Utilisateur cible introuvable dans Firestore");
    }
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || currentUserId == null) return;

    try {
      // 🔧 On s'assure que le document du chat existe
      await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
        'users': [currentUserId, widget.targetUserId],
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 📩 On ajoute le message
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
            'senderId': currentUserId,
            'receiverId': widget.targetUserId,
            'text': text,
            'timestamp': FieldValue.serverTimestamp(),
          });

      debugPrint("📩 Message envoyé: $text");
      _messageController.clear();
    } catch (e) {
      debugPrint("❌ Erreur d'envoi de message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      return const Scaffold(
        body: Center(child: Text("Chargement de la session...")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004AAD),
        title: Row(
          children: [
            const Icon(Icons.person, color: Colors.white),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  targetUserPseudo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  targetUserOnline ? "En ligne" : "Hors ligne",
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        targetUserOnline ? Colors.green[100] : Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('chats')
                      .doc(chatId)
                      .collection('messages')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());

                final messages = snapshot.data!.docs;
                debugPrint("📨 ${messages.length} messages chargés");

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['senderId'] == currentUserId;
                    final time = (msg['timestamp'] as Timestamp?)?.toDate();
                    final timeFormatted =
                        time != null ? DateFormat.Hm().format(time) : '';

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              isMe
                                  ? Colors.blue.shade100
                                  : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg['text'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              timeFormatted,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Écrire un message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004AAD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _sendMessage,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
