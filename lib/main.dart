import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_app/pages/home_page.dart';
import 'package:flutter_chat_app/pages/analyse_page.dart';
import 'package:flutter_chat_app/pages/qcm_page.dart';
import 'package:flutter_chat_app/pages/simulation_page.dart';
import 'package:flutter_chat_app/pages/user_profile_page.dart';
import 'package:flutter_chat_app/pages/user_board_page.dart';
import 'package:flutter_chat_app/pages/about_page.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:flutter_chat_app/pages/register_page.dart';
import 'package:flutter_chat_app/pages/profil_attaquant_defenseur_page.dart';
import 'package:flutter_chat_app/pages/user_community_board.dart';
import 'package:flutter_chat_app/pages/user_detail_page.dart';
import 'package:flutter_chat_app/pages/community_chat_page.dart';
import 'package:flutter_chat_app/pages/chat_page.dart';
import 'package:flutter_chat_app/pages/chat_history_page.dart';
import 'package:flutter_chat_app/utils/secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final SecureStorage _secureStorage = SecureStorage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CyberPsy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,

      // ✅ Page de démarrage avec vérification du token + userId
      home: const InitPage(),

      // ✅ Routes simples
      routes: {
        '/home': (context) => HomePage(),
        '/analyse': (context) => AnalysePage(),
        '/qcm': (context) => QcmPage(),
        '/simulation': (context) => const SimulationPage(),
        '/profil': (context) => const UserProfilePage(),
        '/userBoard': (context) => const UserBoardPage(),
        '/aboutus': (context) => const AboutPage(),
        '/login': (context) => const LoginPage(),
        '/profilsAD': (context) => const ProfilAttaquantDefenseurPage(),
        '/register': (context) => const RegisterPage(),
        '/userCommunityBoard': (context) => const UserCommunityBoardPage(),
        '/chatHist': (context) => const ChatHistoryPage(),
        '/communityChat': (context) => const CommunityChatPage(),
      },

      // ✅ Routes dynamiques avec arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/chat') {
          final targetUserId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => ChatPage(targetUserId: targetUserId),
          );
        } else if (settings.name == '/userDetail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (_) => UserDetailPage(
                  userId: args['userId'],
                  userData: args['userData'],
                ),
          );
        }
        return null;
      },
    );
  }
}

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  final SecureStorage _secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    final token = await _secureStorage.getToken();
    final userId = await _secureStorage.getUserId();
    debugPrint("🔐 Vérification token: $token / userId: $userId");

    if (!mounted) return;

    if (token != null && userId != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
