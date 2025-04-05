import 'package:flutter/material.dart';
import 'package:flutter_chat_app/utils/secure_storage.dart';

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
    _checkSession();
  }

  Future<void> _checkSession() async {
    final token = await _secureStorage.getToken();
    final userId = await _secureStorage.getUserId();

    debugPrint("🧭 InitPage: token = $token | userId = $userId");

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
