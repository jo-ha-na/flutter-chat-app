import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/user_detail_page.dart';

class ProfileCardWidget extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> userData;
  final bool isCurrentUser;
  final bool showOnlyAvailable;

  ProfileCardWidget({
    super.key,
    required this.userId,
    required this.userData,
    required this.isCurrentUser,
    required this.showOnlyAvailable,
  }) {
    debugPrint('🧪 Constructor appelé pour $userId');
  }

  @override
  Widget build(BuildContext context) {
    final pseudo = userData['pseudo'] ?? 'Utilisateur';
    final disponible = userData['disponible'] == true;
    final services =
        List<String>.from(userData['services'] ?? []).take(3).toList();
    final role = userData['role'] ?? 'Non spécifié';
    final description = userData['description'] ?? '';

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 30,
                  color: Color(0xFF004AAD),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$pseudo${isCurrentUser ? ' (moi)' : ''}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004AAD),
                        ),
                      ),
                      Text(
                        "Rôle : $role",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        disponible
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
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
            const SizedBox(height: 12),
            if (services.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Services proposés :",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children:
                        services
                            .map(
                              (s) => Chip(
                                label: Text(s),
                                backgroundColor: Colors.blue.shade100,
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004AAD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => UserDetailPage(
                            userId: userId,
                            userData: userData,
                          ),
                    ),
                  );
                },
                child: const Text(
                  "Voir profil",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
