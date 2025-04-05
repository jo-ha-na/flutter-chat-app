import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/pages/user_detail_page.dart';
import 'package:flutter_chat_app/utils/secure_storage.dart';

class UserCommunityBoardPage extends StatefulWidget {
  const UserCommunityBoardPage({super.key});

  @override
  State<UserCommunityBoardPage> createState() => _UserCommunityBoardPageState();
}

class _UserCommunityBoardPageState extends State<UserCommunityBoardPage> {
  final _pseudoController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _servicesController = TextEditingController();
  bool _disponible = true;
  String? _selectedRole;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isPremium = false;

  final List<String> roles = ['Explorateur', 'Demandeur', 'Accompagnant'];
  final List<String> suggestedServices = [
    'Audit mot de passe',
    'Configuration antivirus',
    'Sensibilisation cybersécurité',
    'Support psychologique',
    'Détection de phishing',
    'Défense réseau',
    'Analyse comportementale',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final userId = await SecureStorage().getUserId();
    if (!mounted) return;
    if (userId == null) {
      debugPrint("❌ Aucun ID utilisateur trouvé dans SecureStorage.");
      setState(() => _isLoading = false);
      return;
    }

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = doc.data();

    if (!mounted) return;
    if (data != null) {
      debugPrint("✅ Données chargées : $data");
      setState(() {
        _pseudoController.text = data['pseudo'] ?? '';
        _descriptionController.text = data['description'] ?? '';
        _disponible = data['disponible'] ?? true;
        _selectedRole = data['role'];
        _servicesController.text = (data['services'] ?? []).join(', ');
        _isPremium = data['premium'] ?? false;
        _isLoading = false;
      });
    } else {
      debugPrint("⚠️ Aucune donnée trouvée pour cet utilisateur.");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _save() async {
    final userId = await SecureStorage().getUserId();
    if (userId == null) {
      debugPrint("❌ Impossible d’enregistrer : aucun ID utilisateur.");
      return;
    }

    if (_pseudoController.text.trim().isEmpty ||
        _selectedRole == null ||
        _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez remplir tous les champs obligatoires."),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final payload = {
      'pseudo': _pseudoController.text.trim(),
      'description': _descriptionController.text.trim(),
      'role': _selectedRole,
      'premium': _isPremium,
      'disponible': _disponible,
      'services':
          _servicesController.text
              .split(',')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList(),
    };

    debugPrint("📤 Sauvegarde : $payload");

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(payload, SetOptions(merge: true));

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Profil mis à jour !")));

    Navigator.pushReplacementNamed(context, '/communityChat');

    setState(() => _isSaving = false);
  }

  void _addSuggestedService(String service) {
    final existing = _servicesController.text.trim();
    final Set<String> allServices =
        existing.isNotEmpty
            ? existing.split(',').map((s) => s.trim()).toSet()
            : <String>{};

    if (allServices.add(service)) {
      setState(() {
        _servicesController.text = allServices.join(', ');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF004AAD),
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 32),
            const SizedBox(width: 8),
            const Text(
              "Mon profil sur le chat",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _pseudoController,
                      decoration: const InputDecoration(
                        labelText: "Pseudo",
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Rôle :",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          roles.map((role) {
                            return ChoiceChip(
                              label: Text(role),
                              selected: _selectedRole == role,
                              selectedColor: Colors.blue.shade100,
                              onSelected:
                                  (_) => setState(() => _selectedRole = role),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: "Mini-description",
                        prefixIcon: Icon(Icons.info_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text("Disponible pour discuter"),
                        const Spacer(),
                        Switch(
                          value: _disponible,
                          onChanged: (val) => setState(() => _disponible = val),
                          activeColor: Colors.green,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Profil premium "),
                        const Spacer(),
                        Switch(
                          value: _isPremium,
                          onChanged: (val) => setState(() => _isPremium = val),
                          activeColor: Colors.amber,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Suggestions de services :",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      spacing: 8,
                      children:
                          suggestedServices.map((s) {
                            return ActionChip(
                              label: Text(s),
                              onPressed: () => _addSuggestedService(s),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _servicesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Liste de vos services",
                        hintText:
                            "Ex : audit mot de passe, configuration antivirus",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.miscellaneous_services),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004AAD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _isSaving ? null : _save,
                        icon: const Icon(Icons.save),
                        label: const Text(
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
