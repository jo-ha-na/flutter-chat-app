import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/api_service.dart';
import 'package:flutter_chat_app/pages/privacy_policy_page.dart';

class AccountSettingsPage extends StatefulWidget {
  final int userId;

  const AccountSettingsPage({super.key, required this.userId});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _message = '';

  Future<void> _updatePassword() async {
    final newPassword = _passwordController.text.trim();
    if (newPassword.isEmpty) {
      setState(() => _message = 'Veuillez entrer un mot de passe.');
      return;
    }

    setState(() => _isLoading = true);

    final success = await ApiService.updatePassword(widget.userId, newPassword);

    setState(() {
      _message =
          success
              ? '✅ Mot de passe mis à jour avec succès.'
              : '❌ Échec de la mise à jour du mot de passe.';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres du compte')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nouveau mot de passe',
              ),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _updatePassword,
                  child: const Text('Mettre à jour'),
                ),
            const SizedBox(height: 10),
            Text(
              _message,
              style: TextStyle(
                color: _message.startsWith('✅') ? Colors.green : Colors.red,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
                );
              },
              child: const Text(
                "Voir la politique de confidentialité",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
