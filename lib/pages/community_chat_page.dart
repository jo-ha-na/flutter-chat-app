import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/widgets/profile_card_widget.dart';
import 'package:flutter_chat_app/utils/secure_storage.dart';

class CommunityChatPage extends StatefulWidget {
  const CommunityChatPage({super.key});

  @override
  State<CommunityChatPage> createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends State<CommunityChatPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasFilledProfile = false;
  bool _isLoading = true;
  bool showOnlyAvailable = true;

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  Future<void> _checkProfile() async {
    final userId = await SecureStorage().getUserId(); // 🔐 ID depuis Azure
    if (userId == null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "ID utilisateur introuvable. Veuillez vous reconnecter.",
          ),
        ),
      );
      return;
    }

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = doc.data();

    if (data == null ||
        !data.containsKey('pseudo') ||
        !data.containsKey('disponible')) {
      _showProfileDialog(userId);
    } else {
      setState(() {
        _hasFilledProfile = true;
        _isLoading = false;
      });
    }
  }

  void _showProfileDialog(String userId) {
    final pseudoController = TextEditingController();
    bool isAvailable = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setStateDialog) => AlertDialog(
                  title: const Text("Complétez votre profil communautaire"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: pseudoController,
                        decoration: const InputDecoration(
                          labelText: "Pseudo (visible par les autres)",
                        ),
                      ),
                      Row(
                        children: [
                          const Text("Disponible pour discuter"),
                          const Spacer(),
                          Switch(
                            value: isAvailable,
                            onChanged:
                                (val) =>
                                    setStateDialog(() => isAvailable = val),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .set({
                              'pseudo': pseudoController.text.trim(),
                              'disponible': isAvailable,
                            }, SetOptions(merge: true));

                        Navigator.of(context).pop();
                        setState(() {
                          _hasFilledProfile = true;
                          _isLoading = false;
                        });
                      },
                      child: const Text("Valider"),
                    ),
                  ],
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 32),
            const SizedBox(width: 8),
            const Text('Chat', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Modifier mon profil',
            onPressed:
                () => Navigator.pushNamed(context, '/userCommunityBoard'),
          ),
          Row(
            children: [
              const Text("Disponibles"),
              Switch(
                value: showOnlyAvailable,
                onChanged: (val) => setState(() => showOnlyAvailable = val),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Rechercher un pseudo ou un service",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final query = _searchController.text.toLowerCase();

                  final users =
                      snapshot.data!.docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final isAvailable = data['disponible'] == true;
                        final pseudo = (data['pseudo'] ?? '').toLowerCase();
                        final services =
                            (data['services'] ?? []).join(' ').toLowerCase();
                        final match =
                            pseudo.contains(query) || services.contains(query);
                        return (!showOnlyAvailable || isAvailable) && match;
                      }).toList();

                  if (users.isEmpty) {
                    return const Center(child: Text("Aucun profil trouvé."));
                  }

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final data = user.data() as Map<String, dynamic>;
                      return ProfileCardWidget(userId: user.id, userData: data);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
