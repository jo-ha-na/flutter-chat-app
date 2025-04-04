import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/utils/secure_storage.dart';

class UserDetailPage extends StatelessWidget {
  final String userId;
  final Map<String, dynamic>? userData;

  const UserDetailPage({super.key, required this.userId, this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF004AAD),
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 32),
            const SizedBox(width: 8),
            const Text(
              "Profil utilisateur",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body:
          userData != null
              ? _buildContent(context, userData!)
              : FutureBuilder<DocumentSnapshot>(
                future:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(
                      child: Text("Utilisateur introuvable."),
                    );
                  }
                  final data = snapshot.data!.data() as Map<String, dynamic>;

                  return _buildContent(context, data);
                },
              ),
    );
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> data) {
    final pseudo = data['pseudo'] ?? 'Utilisateur';
    final role = data['role'] ?? 'Non précisé';
    final description = data['description'] ?? '';
    final disponible = data['disponible'] == true;
    final services = List<String>.from(data['services'] ?? []);

    return FutureBuilder<String?>(
      future: SecureStorage().getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentUserId = snapshot.data;
        final isCurrentUser = currentUserId != null && currentUserId == userId;
        debugPrint(
          "🔎 Comparaison userId : currentUser=$currentUserId, affiché=$userId, résultat=$isCurrentUser",
        );

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, size: 40, color: Color(0xFF004AAD)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      pseudo,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          disponible
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      disponible ? "Disponible" : "Indisponible",
                      style: TextStyle(
                        color:
                            disponible
                                ? Colors.green.shade800
                                : Colors.red.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text("Rôle : $role", style: const TextStyle(fontSize: 16)),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  "Description : \"$description\"",
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
              const SizedBox(height: 24),
              const Text(
                "Services proposés :",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              services.isEmpty
                  ? const Text("Aucun service renseigné.")
                  : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        services.map((s) => Chip(label: Text(s))).toList(),
                  ),
              const Spacer(),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004AAD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    foregroundColor: Colors.white,
                  ),
                  icon: Icon(
                    isCurrentUser ? Icons.edit : Icons.chat_bubble_outline,
                  ),
                  label: Text(
                    isCurrentUser
                        ? "Modifier mon profil"
                        : "Envoyer un message",
                  ),
                  onPressed: () {
                    if (isCurrentUser) {
                      Navigator.pushNamed(context, '/userCommunityBoard');
                    } else {
                      Navigator.pushNamed(context, '/chat', arguments: userId);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
