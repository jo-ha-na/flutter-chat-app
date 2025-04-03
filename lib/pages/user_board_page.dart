import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/api_service.dart';
import 'package:flutter_chat_app/models/utilisateur.dart';

class UserBoardPage extends StatefulWidget {
  const UserBoardPage({super.key});

  @override
  State<UserBoardPage> createState() => _UserBoardPageState();
}

class _UserBoardPageState extends State<UserBoardPage> {
  Utilisateur? utilisateur;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final user = await ApiService.getCurrentUser();
      setState(() {
        utilisateur = user;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Erreur récupération user: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon tableau de bord")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : utilisateur == null
              ? const Center(child: Text("Utilisateur non trouvé."))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Bienvenue ${utilisateur!.prenom} ${utilisateur!.nom} !",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      child: ListTile(
                        title: const Text("Email"),
                        subtitle: Text(utilisateur!.email),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text("Dernière activité"),
                        subtitle: Text(utilisateur!.derniereActivite ?? 'N/A'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text("Rôle"),
                        subtitle: Text(utilisateur!.role ?? 'Utilisateur'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text("Niveau de sensibilisation"),
                        subtitle: Text("Choisissez-le depuis la page Analyse"),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
