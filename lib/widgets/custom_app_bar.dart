import 'package:flutter/material.dart';
import 'package:flutter_chat_app/utils/secure_storage.dart';
import 'package:flutter_chat_app/pages/account_settings_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? userName;
  final VoidCallback onLogout;
  final bool showUserMenu;

  const CustomAppBar({
    super.key,
    required this.title,
    this.userName,
    required this.onLogout,
    this.showUserMenu = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _openSettings(BuildContext context) async {
    final userId = await SecureStorage().getUserId();
    if (userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AccountSettingsPage(userId: int.parse(userId)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible de récupérer l'ID utilisateur"),
        ),
      );
    }
  }

  void _navigateToDashboard(BuildContext context) {
    Navigator.pushNamed(context, '/userBoard');
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF004AAD),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (showUserMenu && userName != null)
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'dashboard') {
                _navigateToDashboard(context);
              } else if (value == 'settings') {
                _openSettings(context);
              } else if (value == 'logout') {
                onLogout();
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'dashboard',
                    child: Text('Mon tableau de bord'),
                  ),
                  PopupMenuItem(value: 'settings', child: Text('Paramètres')),
                  PopupMenuItem(value: 'logout', child: Text('Se déconnecter')),
                ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  "👋 $userName",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          )
        else if (userName != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(child: Text("👋 $userName")),
          ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () => _openSettings(context),
          tooltip: "Paramètres",
        ),

        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: onLogout,
          tooltip: "Se déconnecter",
        ),
      ],
    );
  }
}
