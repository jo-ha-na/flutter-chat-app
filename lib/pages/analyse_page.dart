import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/custom_app_bar.dart';
import 'package:flutter_chat_app/services/api_service.dart';
import 'package:flutter_chat_app/utils/secure_storage.dart';

class AnalysePage extends StatefulWidget {
  const AnalysePage({super.key});

  @override
  _AnalysePageState createState() => _AnalysePageState();
}

class _AnalysePageState extends State<AnalysePage> {
  String? _userName;
  String _selectedLevel = "debutant";

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final user = await ApiService.getCurrentUser();
    if (user != null) {
      setState(() {
        _userName = "${user.prenom} ${user.nom}";
      });
    }
  }

  void _logout() async {
    await SecureStorage().clearAll(); // ou deleteToken + deleteUserId
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _startQcm() {
    Navigator.pushNamed(context, '/qcm', arguments: _selectedLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Analyse',
        userName: _userName,
        onLogout: _logout,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 80),
            const SizedBox(height: 16),
            const Text(
              "Analyse de votre niveau de sensibilisation",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              "Répondez à une série de questions adaptées à votre niveau. L'analyse vous permettra d'identifier vos forces et vos axes d'amélioration en matière de cybersécurité.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              "Choisissez votre niveau :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedLevel,
              items: const [
                DropdownMenuItem(value: "debutant", child: Text("Débutant")),
                DropdownMenuItem(
                  value: "intermediaire",
                  child: Text("Intermédiaire"),
                ),
                DropdownMenuItem(value: "avance", child: Text("Avancé")),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedLevel = value!;
                });
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: _startQcm,
                child: const Text(
                  "Commencer l’analyse",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Image.asset('assets/lock-image.png', height: 80),
          ],
        ),
      ),
    );
  }
}
