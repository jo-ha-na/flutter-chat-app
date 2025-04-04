import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/pages/chat_page.dart';
import 'package:flutter_chat_app/utils/secure_storage.dart';
import 'package:intl/intl.dart';

class ChatHistoryPage extends StatefulWidget {
  const ChatHistoryPage({super.key});

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  String? currentUserId;
  bool _isLoading = true;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    final id = await SecureStorage().getUserId();
    debugPrint("🔐 ID utilisateur récupéré depuis chathistory: $id");
    setState(() {
      currentUserId = id;
      _isLoading = false;
    });
  }

  String _getOtherUserId(String chatId) {
    final parts = chatId.split('_');
    return parts[0] == currentUserId ? parts[1] : parts[0];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || currentUserId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004AAD),
        title: const Text(
          "Mes messages",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher un pseudo...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('chats')
                      .orderBy('lastUpdated', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allChats = snapshot.data!.docs;
                debugPrint(
                  "📥 Total des chats dans la DB depuis chathistory: ${allChats.length}",
                );
                debugPrint(
                  "📥 Total des documents dans 'chats' depuis chat history: ${snapshot.data!.docs.length}",
                );

                final chats =
                    allChats.where((doc) {
                      final users = List<String>.from(doc['users'] ?? []);
                      return users.contains(currentUserId);
                    }).toList();

                if (chats.isEmpty) {
                  debugPrint(
                    "❌ Aucun chat trouvé pour l'utilisateur $currentUserId",
                  );
                  return const Center(
                    child: Text("Aucune conversation pour le moment."),
                  );
                }

                debugPrint("✅ Chats filtrés trouvés : ${chats.length}");

                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final otherUserId = chat['users'].firstWhere(
                      (id) => id != currentUserId,
                    );

                    return StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('chats')
                              .doc(chat.id)
                              .collection('messages')
                              .orderBy('timestamp', descending: true)
                              .limit(1)
                              .snapshots(),
                      builder: (context, snapshotMsg) {
                        if (!snapshotMsg.hasData ||
                            snapshotMsg.data!.docs.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final lastMessage = snapshotMsg.data!.docs.first;
                        final lastText = lastMessage['text'] ?? '';
                        final timestamp =
                            lastMessage['timestamp'] as Timestamp?;
                        final timeString =
                            timestamp != null
                                ? DateFormat(
                                  'dd/MM/yyyy HH:mm',
                                ).format(timestamp.toDate())
                                : '';

                        return FutureBuilder<DocumentSnapshot>(
                          future:
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(otherUserId)
                                  .get(),
                          builder: (context, snapshotUser) {
                            if (!snapshotUser.hasData ||
                                !snapshotUser.data!.exists) {
                              return const SizedBox.shrink();
                            }

                            final userData =
                                snapshotUser.data!.data()
                                    as Map<String, dynamic>;
                            final pseudo = userData['pseudo'] ?? 'Utilisateur';

                            if (!pseudo.toLowerCase().contains(_searchQuery)) {
                              return const SizedBox.shrink();
                            }

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue.shade100,
                                child: Text(
                                  pseudo.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              title: Text(pseudo),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lastText,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    timeString,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            ChatPage(targetUserId: otherUserId),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
