import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCommunityBoardPage extends StatefulWidget {
  const UserCommunityBoardPage({super.key});

  @override
  State<UserCommunityBoardPage> createState() => _UserCommunityBoardPageState();
}

class _UserCommunityBoardPageState extends State<UserCommunityBoardPage> {
  final _pseudoController = TextEditingController();
  bool _disponible = true;
  final _servicesController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    final data = doc.data();
    if (data != null) {
      _pseudoController.text = data['pseudo'] ?? '';
      _disponible = data['disponible'] ?? true;
      _servicesController.text = (data['services'] ?? []).join(', ');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _save() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final services =
        _servicesController.text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'pseudo': _pseudoController.text.trim(),
      'disponible': _disponible,
      'services': services,
    }, SetOptions(merge: true));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil communautaire mis à jour !")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon Profil Communautaire")),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _pseudoController,
                      decoration: const InputDecoration(labelText: "Pseudo"),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text("Disponible"),
                        const Spacer(),
                        Switch(
                          value: _disponible,
                          onChanged: (val) => setState(() => _disponible = val),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _servicesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Services proposés (optionnel)",
                        hintText:
                            "Ex : audit mot de passe, configuration antivirus",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004AAD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _save,
                        child: const Text(
                          "Enregistrer",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
