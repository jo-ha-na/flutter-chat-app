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
      debugPrint("❌ Erreur récupération user: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF004AAD),
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 32),
            const SizedBox(width: 8),
            const Text(
              "Mon tableau de bord",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : utilisateur == null
              ? const Center(child: Text("Utilisateur non trouvé."))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bienvenue ${utilisateur!.prenom} ${utilisateur!.nom} !",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004AAD),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildInfoCard(
                      icon: Icons.email,
                      label: "Email",
                      value: utilisateur!.email,
                    ),
                    _buildInfoCard(
                      icon: Icons.access_time,
                      label: "Dernière activité",
                      value: utilisateur!.derniereActivite ?? 'Non disponible',
                    ),
                    _buildInfoCard(
                      icon: Icons.security,
                      label: "Rôle",
                      value: utilisateur!.role,
                    ),
                    _buildInfoCard(
                      icon: Icons.bar_chart,
                      label: "Niveau de sensibilisation",
                      value: "À définir dans l'analyse",
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF004AAD)),
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }
}
