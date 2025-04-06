import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/api_service.dart';
import 'package:flutter_chat_app/utils/secure_storage.dart';
import 'dart:convert' show utf8;
import 'dart:math';

class QcmPage extends StatefulWidget {
  const QcmPage({super.key});

  @override
  _QcmPageState createState() => _QcmPageState();
}

class _QcmPageState extends State<QcmPage> {
  List<dynamic> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isLoading = true;
  bool _isSubmitted = false;
  String? _currentAnecdote;
  final List<Map<String, dynamic>> _results = [];
  late int _niveau;
  final Random _random = Random();
  final List<String> _usedAnecdotes = [];

  final List<String> _anecdotesIngenierieSociale = [
    "🎭 L'ingénierie sociale repose souvent sur la manipulation psychologique pour inciter à divulguer des informations sensibles.",
    "🕵️‍♂️ Un faux technicien a réussi à pénétrer une entreprise simplement en portant un badge et une attitude assurée.",
    "📞 Un appel téléphonique bien ciblé a permis à un hacker d'obtenir des accès administrateur en prétendant être du support technique.",
    "📧 90% des cyberattaques réussies commencent par un email de phishing.",
    "📱 Une attaque célèbre de 2020 visait des célébrités sur Twitter par une simple arnaque d'ingénierie sociale.",
    "🔓 Le facteur humain reste la faille numéro un en cybersécurité.",
    "🔍 Une simple recherche sur les réseaux sociaux a permis à un attaquant de personnaliser un mail de phishing imparable.",
    "👨‍💼 Kevin Mitnick, célèbre hacker, prouvait que manipuler les gens était plus efficace que le piratage.",
    "🎯 En 2015, des hackers russes ont manipulé des employés de centrales électriques par appels frauduleux.",
    "📂 Un faux message Slack d’un supérieur a conduit un employé à divulguer des fichiers confidentiels.",
    "🎣 En 2016, une fraude au président a détourné 100M€ à deux multinationales, juste avec des mails crédibles.",
    "📸 Une fausse offre sur LinkedIn a permis de soutirer des infos sensibles à un ingénieur.",
    "💬 Sur un forum, un hacker a utilisé la flatterie pour obtenir un accès privilégié.",
    "👨‍⚕️ Dans une simulation hospitalière, une blouse blanche a suffi à faire passer un intrus.",
    "🏢 Un post-it avec un mot de passe a suffi à un stagiaire malveillant pour accéder au réseau interne.",
    "🎁 Des colis cadeaux envoyés avec QR codes piégés ont compromis des grandes entreprises.",
    "🖨️ Un faux technicien imprimante a branché une clé USB infectée pour pénétrer le réseau.",
    "👩‍💻 Une RH fictive a mené un faux entretien pour collecter des accès internes.",
    "🧠 Les biais cognitifs comme l'autorité ou l'urgence sont exploités en ingénierie sociale.",
    "📊 50% des employés cliquent sur un lien s’il vient d’un collègue sans vérifier.",
    "🎭 Une étude montre que les attaques par ingénierie sociale sont 3x plus efficaces que les attaques techniques.",
    "📱 Une campagne WhatsApp a diffusé des liens malveillants en se faisant passer pour des offres d’emploi.",
    "💼 Des hackers se sont fait passer pour des recruteurs pour infiltrer des startups tech.",
    "💳 Une enquête de 2022 montre que 1 utilisateur sur 4 partage ses mots de passe avec ses collègues.",
    "📷 Une fausse équipe de tournage a obtenu des accès à un centre de données sous prétexte d'un reportage.",
    "💣 Dans une attaque ciblée, des hackers ont envoyé un faux email de sécurité incendie pour évacuer un bâtiment et voler un serveur physique.",
    "📞 Un appel soi-disant du DSI a convaincu un employé d’ouvrir un accès VPN à distance.",
    "🧾 En 2021, une fausse facture a permis de détourner plus de 10 000€ en une journée.",
    "💬 Une discussion Slack usurpée a suffi pour changer les identifiants d’un compte AWS.",
    "🔐 Une simple clé USB gratuite laissée dans un parking a infecté les postes internes d’une banque.",
    "🧠 Le biais de réciprocité : offrir un café puis demander un petit service informatique… une astuce classique !",
    "🎥 Des acteurs ont été engagés pour simuler une réunion Zoom afin de piéger une dirigeante d’entreprise.",
    "🖼️ Une image corrompue envoyée par mail interne a servi de porte d’entrée à une attaque.",
    "📱 Un faux SMS d’alerte bancaire a poussé plusieurs employés à cliquer sur un lien de phishing.",
    "🧪 Un test d’intrusion physique a révélé que 6 employés sur 10 tenaient la porte à un inconnu sans badge.",
    "👨‍🔧 En se faisant passer pour un sous-traitant IT, un attaquant a accédé au datacenter d’un hôpital.",
    "📚 En se présentant comme étudiant, un hacker a pu interviewer des DSI et collecter des données sensibles.",
    "🎭 Le social engineering s’appuie sur notre empathie naturelle pour tromper.",
    "🖥️ Une mise à jour fictive a permis à un hacker d’installer un malware en interne.",
    "📞 Une voix synthétique d’IA a été utilisée pour imiter un PDG et détourner un virement.",
    "📁 L’hameçonnage par partage de documents Google Drive est en forte hausse depuis 2020.",
    "🧑‍🏫 Une fausse conférence sur la cybersécurité a servi de prétexte à la collecte de données de badge.",
    "📦 Des colis Amazon falsifiés ont été utilisés pour introduire des traceurs dans les bureaux d’une entreprise.",
    "💌 Un hacker a séduit une victime sur un site de rencontre pour lui faire installer un cheval de Troie.",
    "🔍 Un audit a montré que les cadres supérieurs cliquaient plus souvent sur des liens suspects que les techniciens.",
    "🎓 De nombreuses attaques commencent dans les universités : étudiants et professeurs sont des cibles privilégiées.",
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String level = ModalRoute.of(context)!.settings.arguments as String;
    _niveau = _mapLevelToInt(level);
    _loadQuestions();
  }

  int _mapLevelToInt(String level) {
    switch (level) {
      case "intermediaire":
        return 2;
      case "avance":
        return 3;
      default:
        return 1;
    }
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await ApiService.getQcmByLevel(_niveau);
      setState(() {
        _questions =
            questions.map((q) {
              final decodedQuestion = utf8.decode(
                q['question'].toString().runes.toList(),
              );
              return {...q, 'question': decodedQuestion};
            }).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur chargement QCM: $e');
      setState(() => _isLoading = false);
    }
  }

  String _getUniqueAnecdote() {
    final unused =
        _anecdotesIngenierieSociale
            .toSet()
            .difference(_usedAnecdotes.toSet())
            .toList();
    if (unused.isEmpty) _usedAnecdotes.clear();
    final freshList =
        _anecdotesIngenierieSociale
            .toSet()
            .difference(_usedAnecdotes.toSet())
            .toList();
    final newAnecdote = freshList[_random.nextInt(freshList.length)];
    _usedAnecdotes.add(newAnecdote);
    return newAnecdote;
  }

  Future<void> _submitAnswer(String userAnswer) async {
    final question = _questions[_currentIndex];
    final idQcm = question['idQcm'];
    final correctAnswer = question['correctAnswer'];
    final source = question['source'];

    final userId = await SecureStorage().getUserId() ?? "3";

    try {
      final result = await ApiService.submitQcmAnswer(
        idQcm: idQcm,
        idUser: int.parse(userId),
        reponse: userAnswer,
      );

      final isCorrect = result['isCorrect'];
      final anecdote =
          (question['anecdote'] as String?) ?? _getUniqueAnecdote();

      setState(() {
        _currentAnecdote = anecdote;
        _results.add({
          'question': question['question'],
          'userAnswer': userAnswer,
          'correctAnswer': correctAnswer,
          'isCorrect': isCorrect,
          'source': source,
          'anecdote': anecdote,
        });

        if (isCorrect == true) _score++;

        if (_currentIndex < _questions.length - 1) {
          _currentIndex++;
        } else {
          _isSubmitted = true;
        }
      });
    } catch (e) {
      print('Erreur soumission QCM: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Aucune question disponible.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004AAD),
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 32),
            const SizedBox(width: 5),
            const Text('QCM', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: _isSubmitted ? _buildResultView() : _buildQuestionView(),
    );
  }

  Widget _buildQuestionView() {
    final question = _questions[_currentIndex];
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Question ${_currentIndex + 1}/${_questions.length}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Text(
              question['question'],
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              onPressed: () => _submitAnswer("Vrai"),
              child: const Text(
                "Vrai",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              onPressed: () => _submitAnswer("Faux"),
              child: const Text(
                "Faux",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_currentAnecdote != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Text(
                "🔍 Anecdote : $_currentAnecdote",
                style: const TextStyle(fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    final scoreMessage =
        _score >= _questions.length * 0.8
            ? "🎉 Bravo ! Vous avez un excellent niveau."
            : _score >= _questions.length * 0.5
            ? "🙂 Bon travail, mais vous pouvez encore progresser."
            : "😕 Continuez à vous former, chaque clic compte.";

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Votre score : $_score / ${_questions.length}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 12),
          Text(scoreMessage, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: _results.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final res = _results[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          res['question'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Votre réponse : ${res['userAnswer']}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        if (!res['isCorrect'])
                          Text(
                            "Bonne réponse : ${res['correctAnswer']}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        if (res['source'] != null)
                          Text(
                            "Source : ${res['source']}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          "🔍 Anecdote : ${res['anecdote']}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            res['isCorrect']
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: res['isCorrect'] ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
