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

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  Future<void> _checkProfile() async {
    final userId = await SecureStorage().getUserId();
    debugPrint("🔐 ID utilisateur récupéré : $userId");
    if (userId == null) {
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
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = doc.data();
    debugPrint("📄 Données Firestore : $data");

    if (data == null ||
        !(data.containsKey('pseudo') &&
            data.containsKey('disponible') &&
            data.containsKey('role') &&
            data['pseudo'] != '' &&
            data['role'] != null)) {
      Future.delayed(Duration.zero, () => _showProfileDialog(userId));
    } else {
      setState(() {
        debugPrint("✅ Profil utilisateur complet");
        _hasFilledProfile = true;
        _isLoading = false;
      });
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
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: pseudoController,
                            decoration: InputDecoration(
                              labelText: "Pseudo (visible par les autres)",
                              labelStyle: const TextStyle(
                                color: Colors.black87,
                              ),
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
                                  return SizedBox(
                                    width: 240,
                                    child: ChoiceChip(
                                      label: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            role['label']!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            role['desc']!,
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      selected: selectedRole == role['label'],
                                      selectedColor: Colors.blue.shade100,
                                      onSelected:
                                          (_) => setStateDialog(
                                            () => selectedRole = role['label'],
                                          ),
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
                                    }, SetOptions(merge: true));

                                if (mounted) {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    _hasFilledProfile = true;
                                    _isLoading = false;
                                  });
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF004AAD),
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 32),
            const SizedBox(width: 5),
            const Text(
              'Communauté',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: 'Modifier mon profil',
            onPressed:
                () => Navigator.pushNamed(context, '/userCommunityBoard'),
          ),
          IconButton(
            icon: const Icon(Icons.message_rounded, color: Colors.white),
            tooltip: 'Voir mes messages',
            onPressed: () => Navigator.pushNamed(context, '/chatHist'),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Rechercher pseudo ou service",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<String?>(
                future: SecureStorage().getUserId(),
                builder: (context, snapshotUserId) {
                  if (!snapshotUserId.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final currentUserId = snapshotUserId.data;

                  return StreamBuilder<QuerySnapshot>(
                    stream:
                        FirebaseFirestore.instance
                            .collection('users')
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final query = _searchController.text.toLowerCase();

                      var users =
                          snapshot.data!.docs.where((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            final isAvailable = data['disponible'] == true;
                            final pseudo = (data['pseudo'] ?? '').toLowerCase();
                            final services =
                                (data['services'] ?? [])
                                    .join(' ')
                                    .toLowerCase();
                            final match =
                                pseudo.contains(query) ||
                                services.contains(query);
                            return (!showOnlyAvailable || isAvailable) && match;
                          }).toList();

                      users.sort((a, b) {
                        if (a.id == currentUserId) return -1;
                        if (b.id == currentUserId) return 1;
                        return 0;
                      });

                      if (users.isEmpty) {
                        return const Center(
                          child: Text("Aucun profil trouvé."),
                        );
                      }

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final data = user.data() as Map<String, dynamic>;
                          final isCurrentUser = user.id == currentUserId;
                          return ProfileCardWidget(
                            userId: user.id,
                            userData: data,
                            isCurrentUser: isCurrentUser,
                            showOnlyAvailable: showOnlyAvailable,
                          );
                        },
                      );
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
