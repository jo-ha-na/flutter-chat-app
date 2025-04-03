import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/user_detail_page.dart';

class ProfileCardWidget extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const ProfileCardWidget({
    super.key,
    required this.userId,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    final pseudo = userData['pseudo'] ?? 'Utilisateur';
    final disponible = userData['disponible'] == true;
    final services = userData['services'] ?? [];

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person_outline, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    pseudo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        disponible
                            ? Colors.green.shade100
                            : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    disponible ? "Disponible" : "Indisponible",
                    style: TextStyle(
                      color:
                          disponible
                              ? Colors.green.shade800
                              : Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
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
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: List<Widget>.from(
                      services.map((s) => Chip(label: Text(s))),
                    ),
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
                      builder: (_) => UserDetailPage(userId: userId),
                    ),
                  );
                },
                child: const Text("Voir profil"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
