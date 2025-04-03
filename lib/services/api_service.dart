// ✅ lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_chat_app/utils/constants.dart';
import 'package:flutter_chat_app/utils/secure_storage.dart';
import 'package:flutter_chat_app/models/utilisateur.dart';

class ApiService {
  static final _client = http.Client();

  /// 🔐 Authentification
  static Future<String?> login(String email, String password) async {
    final response = await _client.post(
      Uri.parse('$API_BASE_URL/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final token = response.body;
      await SecureStorage().saveToken(token);
      return token;
    } else {
      throw Exception('Erreur de connexion');
    }
  }

  static Future<void> logout() async {
    await SecureStorage().deleteToken();
    await SecureStorage().deleteUserId();
  }

  static Future<Utilisateur?> getCurrentUser() async {
    final token = await SecureStorage().getToken();
    final response = await _client.get(
      Uri.parse('$API_BASE_URL/auth/getuser'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Utilisateur.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  static Future<bool> updatePassword(int id, String newPassword) async {
    final response = await _client.put(
      Uri.parse('$API_BASE_URL/auth/$id/updatepassword'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newPassword),
    );

    return response.statusCode == 200;
  }

  /// 📋 QCM
  static Future<List<dynamic>> getQcmByLevel(int niveau) async {
    final response = await _client.get(
      Uri.parse('$API_BASE_URL/qcm/niveau/$niveau'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur chargement QCM');
    }
  }

  static Future<Map<String, dynamic>> submitQcmAnswer({
    required int idQcm,
    required int idUser,
    required String reponse,
  }) async {
    final response = await _client.post(
      Uri.parse('$API_BASE_URL/qcm/submit'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idQcm': idQcm, 'idUser': idUser, 'reponse': reponse}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur soumission QCM');
    }
  }

  /// 🧠 Simulation : profils, scénarios, résultats
  static Future<List<dynamic>> getAllProfilAttaquants() async {
    final response = await _client.get(
      Uri.parse('$API_BASE_URL/profilAttaquants'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur chargement profils attaquants');
    }
  }

  static Future<List<dynamic>> getScenarioSimulations() async {
    final response = await _client.get(
      Uri.parse('$API_BASE_URL/scenarioSimulations'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur chargement scénarios');
    }
  }

  static Future<List<dynamic>> getResultatSimulations() async {
    final response = await _client.get(
      Uri.parse('$API_BASE_URL/resultatSimulations'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur chargement résultats');
    }
  }
}
