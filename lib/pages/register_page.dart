import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chat_app/utils/constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String message = '';
  bool isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse('$API_BASE_URL/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
        "prenom": _prenomController.text.trim(),
        "nom": _nomController.text.trim(),
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 201) {
      setState(() => message = "✅ Compte créé avec succès !");
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else if (response.statusCode == 409) {
      setState(() => message = "❌ Email déjà utilisé");
    } else {
      setState(() => message = "❌ Erreur : ${response.body}");
    }
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
                          'Créer un nouveau compte',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _prenomController,
                          decoration: inputStyle.copyWith(labelText: 'Prénom'),
                          validator:
                              (value) =>
                                  value!.isEmpty ? 'Entrez un prénom' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nomController,
                          decoration: inputStyle.copyWith(labelText: 'Nom'),
                          validator:
                              (value) =>
                                  value!.isEmpty ? 'Entrez un nom' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailController,
                          decoration: inputStyle.copyWith(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          validator:
                              (value) =>
                                  value!.isEmpty ? 'Entrez un email' : null,
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
                                  value!.length < 6
                                      ? '6 caractères minimum'
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
                            onPressed: _register,
                            child: const Text(
                              "S'inscrire",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          message,
                          style: TextStyle(
                            color:
                                message.startsWith("✅")
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text(
                            "Déjà enregistrée ? Connectez-vous ici",
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
