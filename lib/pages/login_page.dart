import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/utils/constants.dart';
import 'package:flutter_chat_app/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  String message = '';

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$API_BASE_URL/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final token = response.body;
        await SecureStorage().saveToken(token);

        final userResponse = await http.get(
          Uri.parse('$API_BASE_URL/auth/getuser'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (userResponse.statusCode == 200) {
          final userData = jsonDecode(userResponse.body);
          final userId = userData['idUtilisateur'].toString();
          await SecureStorage().saveUserId(userId);

          Navigator.pushReplacementNamed(context, '/home');
        } else {
          setState(
            () => message = "Erreur lors de la récupération de l'utilisateur.",
          );
        }
      } else {
        setState(() => message = "Identifiants invalides.");
      }
    } catch (e) {
      setState(() => message = "Erreur de connexion : $e");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final inputStyle = InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Image.asset('assets/logo.png', height: 80),
                        const SizedBox(height: 16),
                        const Text(
                          'CyberPsy',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A3AFF),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Connectez-vous à votre compte',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _emailController,
                          decoration: inputStyle.copyWith(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          validator:
                              (value) =>
                                  value!.isEmpty ? 'Entrez votre email' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          decoration: inputStyle.copyWith(
                            labelText: 'Mot de passe',
                          ),
                          obscureText: true,
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'Entrez votre mot de passe'
                                      : null,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF004AAD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _login,
                            child: const Text(
                              "Se connecter",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (message.isNotEmpty)
                          Text(
                            message,
                            style: TextStyle(
                              color:
                                  message.contains("❌")
                                      ? Colors.red
                                      : Colors.green,
                            ),
                          ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              '/register',
                            );
                          },
                          child: const Text(
                            "Pas encore de compte ? S'inscrire",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
