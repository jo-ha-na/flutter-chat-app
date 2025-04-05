import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/custom_app_bar.dart';
import 'package:flutter_chat_app/services/api_service.dart';
import 'package:flutter_chat_app/models/utilisateur.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Utilisateur? utilisateur;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await ApiService.getCurrentUser();
    setState(() {
      utilisateur = user;
    });
  }

  void _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Déconnexion"),
            content: const Text("Souhaitez-vous vous déconnecter ?"),
            actions: [
              TextButton(
                child: const Text("Annuler"),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text("Se déconnecter"),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await ApiService.logout();
      // 🔁 On vide tout l'historique et on va vers login
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  Widget buildActionTile({
    required IconData icon,
    required String label,
    required String route,
    String? subtitle,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 18)),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName =
        utilisateur != null
            ? "${utilisateur!.prenom} ${utilisateur!.nom}"
            : null;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Accueil",
        userName: userName,
        onLogout: _logout,
        showUserMenu: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Center(child: Image.asset('assets/logo.png', height: 100)),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'CyberPsy',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004AAD),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Progressez avec le soutien de la communauté et des experts en cybersécurité.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 32),
              buildActionTile(
                icon: Icons.assignment_outlined,
                label: "QCM – Évaluer vos connaissances",
                route: '/analyse',
                subtitle:
                    "Répondez à un questionnaire et découvrez votre niveau.",
              ),
              const SizedBox(height: 12),
              buildActionTile(
                icon: Icons.security_outlined,
                label: "Profils Attaquants/Défenseurs",
                route: '/profilsAD',
                subtitle:
                    "Consultez des modèles d'attaquants et de défenseurs.",
              ),
              const SizedBox(height: 12),
              buildActionTile(
                icon: Icons.play_circle_outline,
                label: "Simulation – Tester vos réactions",
                route: '/simulation',
                subtitle:
                    "Affrontez des scénarios concrets et améliorez vos réflexes.",
              ),
              const SizedBox(height: 12),
              buildActionTile(
                icon: Icons.support_agent,
                label: "Chat – Conseils par la communauté",
                route: '/communityChat',
                subtitle:
                    "Discutez avec des défenseurs  et échangez sur vos expériences.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
