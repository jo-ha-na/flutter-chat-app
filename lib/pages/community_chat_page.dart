import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/widgets/profile_card_widget.dart';
import 'package:flutter_chat_app/utils/secure_storage.dart';
import 'package:flutter_chat_app/pages/user_detail_page.dart';

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
  String? _currentUserId;
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  Future<void> _checkProfile() async {
    debugPrint("🔎 Vérification du profil utilisateur...");
    _currentUserId = await SecureStorage().getUserId();

    if (_currentUserId == null) {
      debugPrint("❌ Aucun ID trouvé dans le SecureStorage");
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
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUserId)
            .get();
    final data = doc.data();
    debugPrint("📄 Données Firestore récupérées : $data");

    final isValid =
        data != null &&
        data.containsKey('pseudo') &&
        data.containsKey('disponible') &&
        data.containsKey('role') &&
        (data['pseudo']?.toString().trim().isNotEmpty ?? false) &&
        data['role'] != null;

    if (isValid) {
      debugPrint("✅ Profil utilisateur complet");
      setState(() {
        _hasFilledProfile = true;
        _isLoading = false;
        _isPremium = data['premium'] == true;
      });
    } else {
      debugPrint("⚠️ Profil incomplet. Affichage du formulaire...");
      Future.delayed(Duration.zero, () => _showProfileDialog(_currentUserId!));
    }
  }

  void _showProfileDialog(String userId) {
    final pseudoController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedRole;
    bool isAvailable = true;
    final List<Map<String, String>> roles = [
      {'label': 'Explorateur', 'desc': 'Pour discuter et découvrir'},
      {
        'label': 'Demandeur',
        'desc': 'Pour poser des questions ou chercher un service',
      },
      {'label': 'Accompagnant', 'desc': 'Pour proposer ses services'},
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setStateDialog) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.blue.shade50,
                  title: const Text(
                    "Complétez votre profil communautaire",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004AAD),
                      fontSize: 20,
                    ),
                  ),
                  content: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.75,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: pseudoController,
                            decoration: InputDecoration(
                              labelText: "Pseudo (visible par les autres)",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text("Choisissez un rôle :"),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                roles.map((role) {
                                  return ChoiceChip(
                                    label: Text(role['label']!),
                                    selected: selectedRole == role['label'],
                                    selectedColor: Colors.blue.shade100,
                                    onSelected:
                                        (_) => setStateDialog(
                                          () => selectedRole = role['label'],
                                        ),
                                  );
                                }).toList(),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: descriptionController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              labelText: "Mini-description (facultatif)",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Text("Disponible pour discuter"),
                              const Spacer(),
                              Switch(
                                activeColor: Colors.blue,
                                value: isAvailable,
                                onChanged:
                                    (val) =>
                                        setStateDialog(() => isAvailable = val),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004AAD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed:
                          selectedRole == null ||
                                  pseudoController.text.trim().isEmpty
                              ? null
                              : () async {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userId)
                                    .set({
                                      'pseudo': pseudoController.text.trim(),
                                      'disponible': isAvailable,
                                      'role': selectedRole,
                                      'description':
                                          descriptionController.text.trim(),
                                      'premium': false,
                                    }, SetOptions(merge: true));
                                if (mounted) {
                                  Navigator.of(context).pop();
                                  debugPrint("✅ Profil enregistré");
                                  _checkProfile();
                                }
                              },
                      child: const Text(
                        "Valider",
                        style: TextStyle(color: Colors.white),
                      ),
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

    if (!_hasFilledProfile) {
      return const Scaffold(
        body: Center(child: Text("Chargement du profil...")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004AAD),
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 32),
            const SizedBox(width: 5),
            const Text('Communauté', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed:
                () => Navigator.pushNamed(context, '/userCommunityBoard'),
          ),
          IconButton(
            icon: const Icon(Icons.message, color: Colors.white),
            onPressed:
                _isPremium
                    ? () => Navigator.pushNamed(context, '/chatHist')
                    : () => showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text("Fonctionnalité premium"),
                            content: const Text(
                              "Seuls les membres premium peuvent accéder à l'historique des messages.\nContactez l'administrateur sur cyber@Psy.com pour passer premium.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                    ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un pseudo ou un service",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());

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
                      return (!_hasFilledProfile || _currentUserId == doc.id)
                          ? false
                          : (!showOnlyAvailable || isAvailable) && match;
                    }).toList();

                users.sort((a, b) {
                  if (a.id == _currentUserId) return -1;
                  if (b.id == _currentUserId) return 1;
                  return 0;
                });

                if (users.isEmpty)
                  return const Center(child: Text("Aucun profil trouvé."));

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final data = user.data() as Map<String, dynamic>;
                    return ProfileCardWidget(
                      userId: user.id,
                      userData: data,
                      isCurrentUser: user.id == _currentUserId,
                      showOnlyAvailable: showOnlyAvailable,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
