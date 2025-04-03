// lib/pages/profil_page.dart

import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  final Map<String, dynamic> user;

  const ProfilPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "👤 ${user['prenom']} ${user['nom']}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text("📧 Email : ${user['email']}"),
                Text("🛡️ Rôle : ${user['role']}"),
                Text("📊 Niveau : ${user['niveauUtilisateur'] ?? 'N/A'}"),
                Text("📅 Dernière activité : ${user['derniereActivite']}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
