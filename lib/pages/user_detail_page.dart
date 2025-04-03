import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDetailPage extends StatelessWidget {
  final String userId;
  final Map<String, dynamic>? userData; // <- optionnel

  const UserDetailPage({super.key, required this.userId, this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil utilisateur")),
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
    final disponible = data['disponible'] == true;
    final services = List<String>.from(data['services'] ?? []);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, size: 40),
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
                      disponible ? Colors.green.shade100 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  disponible ? "Disponible" : "Indisponible",
                  style: TextStyle(
                    color:
                        disponible
                            ? Colors.green.shade800
                            : Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text("Rôle : $role", style: const TextStyle(fontSize: 16)),
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
                children: services.map((s) => Chip(label: Text(s))).toList(),
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
              ),
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text("Envoyer un message"),
              onPressed: () {
                Navigator.pushNamed(context, '/chat', arguments: userId);
              },
            ),
          ),
        ],
      ),
    );
  }
}
