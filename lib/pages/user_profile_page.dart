import 'package:flutter/material.dart';
import '../models/utilisateur.dart';
import '../services/api_service.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Utilisateur? utilisateur;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final user = await ApiService.getCurrentUser();
      setState(() {
        utilisateur = user;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('❌ Erreur profil utilisateur : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil utilisateur")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : utilisateur == null
              ? const Center(child: Text("Utilisateur non trouvé."))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("👤 Nom : ${utilisateur!.nom}"),
                    Text("🧾 Prénom : ${utilisateur!.prenom}"),
                    Text("📧 Email : ${utilisateur!.email}"),
                    Text(
                      "🕒 Dernière activité : ${utilisateur!.derniereActivite ?? 'N/A'}",
                    ),
                    Text("🔐 Rôle : ${utilisateur!.role ?? 'Utilisateur'}"),
                    const SizedBox(height: 20),
                    const Text(
                      "🎯 Niveau de sensibilisation : sélectionné via l’analyse",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
    );
  }
}
