import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/custom_app_bar.dart';

class ProfilAttaquantDefenseurPage extends StatefulWidget {
  const ProfilAttaquantDefenseurPage({super.key});

  @override
  State<ProfilAttaquantDefenseurPage> createState() =>
      _ProfilAttaquantDefenseurPageState();
}

class _ProfilAttaquantDefenseurPageState
    extends State<ProfilAttaquantDefenseurPage> {
  bool showAttaquants = true;

  final List<Map<String, String>> profilsAttaquants = [
    {
      'nom': 'Hacktiviste',
      'type': 'Militant numérique',
      'description': 'Motivé par des causes sociales ou politiques.',
      'tactique': 'Défiguration, DDoS, fuite de données',
      'methode': 'Utilise des outils publics pour perturber',
    },
    {
      'nom': 'Cybercriminel professionnel',
      'type': 'Hacker motivé par le profit',
      'description':
          "Utilise des attaques sophistiquées pour extorquer ou voler des informations.",
      'tactique': 'Phishing, ransomware, vol de données',
      'methode': 'Attaques planifiées, ciblées, avec infrastructure criminelle',
    },
    {
      'nom': "Espion d'État",
      'type': 'Cyber-agent gouvernemental',
      'description':
          "Travaille pour des États afin d'obtenir des données sensibles.",
      'tactique': 'APT, exfiltration, infiltration réseau',
      'methode': 'Exploits zero-day, campagnes furtives',
    },
    {
      'nom': 'Script Kiddie',
      'type': 'Amateur enthousiaste',
      'description': 'Utilise des outils existants sans réelle expertise.',
      'tactique': 'Scan de vulnérabilité, attaques basiques',
      'methode': 'Utilisation de scripts en ligne ou d\'outils crackés',
    },
    {
      'nom': 'Insider Malveillant',
      'type': 'Employé corrompu ou frustré',
      'description': "Exploite son accès interne pour saboter ou voler.",
      'tactique': 'Fuite de données, sabotage, effacement',
      'methode': 'Utilisation de ses accès privilégiés',
    },
    {
      'nom': 'Cyberterroriste',
      'type': 'Acteur idéologique extrême',
      'description':
          "Vise à créer la peur ou détruire des infrastructures critiques.",
      'tactique': 'Attaques sur systèmes critiques, DDoS à grande échelle',
      'methode': 'Planification méthodique, parfois en groupes organisés',
    },
    {
      'nom': 'Hacktiviste indépendant',
      'type': 'Lone Wolf numérique',
      'description': "Agit seul au nom d'une cause (ex : Anonymous).",
      'tactique': 'Leak de données, protestation numérique',
      'methode': 'Utilise VPN, anonymisation, réseaux distribués',
    },
    {
      'nom': 'Mercenaire du cyberespace',
      'type': 'Hackers à louer',
      'description': "Travaille pour des tiers sans attaches idéologiques.",
      'tactique': 'Attaques personnalisées selon client',
      'methode': 'Professionnalisme, discrétion',
    },
    {
      'nom': 'Botnet Operator',
      'type': "Contrôleur de réseau d'ordinateurs infectés",
      'description':
          'Utilise des machines zombies pour mener des attaques massives.',
      'tactique': 'Spam, DDoS, proxy illégal',
      'methode': 'Malware de propagation rapide',
    },
    {
      'nom': 'Spammeur professionnel',
      'type': 'Diffuseur de contenus non-sollicités',
      'description': "Envoie des campagnes de spam, phishing ou scams.",
      'tactique': 'Emails massifs, escroqueries en ligne',
      'methode': 'Scripts automatisés, bases de données d\'emails',
    },
  ];

  final List<Map<String, String>> profilsDefenseurs = [
    {
      'nom': 'Analyste SOC',
      'type': 'Détection et surveillance',
      'description': 'Surveille les systèmes 24/7 pour détecter les incidents.',
    },
    {
      'nom': 'Analyste en réponse aux incidents',
      'type': 'Réponse rapide',
      'description': 'Gère les attaques et restaure les systèmes.',
    },
    {
      'nom': 'Ingénieur sécurité',
      'type': 'Sécurisation des infrastructures',
      'description': 'Met en place pare-feux, VPN et contrôle les accès.',
    },
    {
      'nom': 'Chasseur de menaces',
      'type': 'Détection proactive',
      'description': 'Analyse les anomalies pour prévenir les attaques.',
    },
    {
      'nom': 'Architecte sécurité',
      'type': 'Concepteur de réseau sécurisé',
      'description': 'Planifie et construit une infrastructure résiliente.',
    },
    {
      'nom': 'Pentester (Testeur d’intrusion)',
      'type': 'Éthique offensive',
      'description':
          "Tente de pirater légalement les systèmes pour détecter les failles.",
    },
    {
      'nom': 'Consultant en cybersécurité',
      'type': 'Stratégie de défense',
      'description': 'Aide à concevoir des politiques de sécurité efficaces.',
    },
    {
      'nom': 'Formateur en cybersécurité',
      'type': 'Éducation et sensibilisation',
      'description': 'Forme les employés à la sécurité informatique.',
    },
    {
      'nom': 'RSSI',
      'type': 'Responsable stratégique',
      'description':
          'Définit la stratégie globale de sécurité de l’entreprise.',
    },
    {
      'nom': 'Expert en ingénierie sociale',
      'type': 'Analyse comportementale et communication',
      'description':
          'Détecte les manipulations, sensibilise aux risques humains.',
    },
    {
      'nom': 'Psychologue de la cybersécurité',
      'type': 'Analyse des comportements à risque',
      'description':
          'Étudie les profils, les motivations et les failles humaines.',
    },
    {
      'nom': 'Chercheur en cyberpsychologie',
      'type': 'Spécialiste cognition & tech',
      'description':
          'Explore les liens entre comportement humain et cybersécurité.',
    },
  ];

  void _showProfilDetails(Map<String, String> profil) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              profil['nom'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  profil.entries.map((e) {
                    if (e.key == 'nom') return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        "${e.key[0].toUpperCase()}${e.key.substring(1)}: ${e.value}",
                      ),
                    );
                  }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Fermer"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profils = showAttaquants ? profilsAttaquants : profilsDefenseurs;

    return Scaffold(
      appBar: CustomAppBar(title: "Profils ", onLogout: () {}, userName: ''),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset('assets/logo.png', height: 80)),
            const SizedBox(height: 12),
            ToggleButtons(
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              fillColor: Colors.blue,
              color: Colors.black,
              isSelected: [showAttaquants, !showAttaquants],
              onPressed: (index) => setState(() => showAttaquants = index == 0),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Voir les attaquants"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Voir les défenseurs"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: profils.length,
                itemBuilder: (context, index) {
                  final profil = profils[index];
                  final isAttaquant = showAttaquants;
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.security,
                        color: isAttaquant ? Colors.red : Colors.blue,
                      ),
                      title: Text(
                        profil['nom'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(profil['type'] ?? ''),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _showProfilDetails(profil),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(child: Image.asset('assets/lock-image.png', height: 80)),
          ],
        ),
      ),
    );
  }
}
