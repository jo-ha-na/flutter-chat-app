import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // 📦 Instanciation du storage sécurisé
  final _storage = const FlutterSecureStorage();

  static const _keyToken = 'auth_token';
  static const _keyUserId = 'user_id';

  /// 🔐 Sauvegarder le token JWT
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  /// 🔓 Récupérer le token JWT
  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  /// 🧹 Supprimer le token JWT
  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  /// 🔐 Sauvegarder l'ID utilisateur
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _keyUserId, value: userId);
  }

  /// 🔓 Récupérer l'ID utilisateur
  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  /// 🧹 Supprimer l'ID utilisateur
  Future<void> deleteUserId() async {
    await _storage.delete(key: _keyUserId);
  }

  /// 🧼 Supprimer toutes les données (logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
