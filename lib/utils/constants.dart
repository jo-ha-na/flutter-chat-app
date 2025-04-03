import 'package:flutter/material.dart';

/// 🌐 URL de base pour ton API Spring Boot (hébergée sur Azure)
const String API_BASE_URL = "https://cyberpsy.loca.lt/api";

/// 🎨 Couleurs de l'application
const Color primaryColor = Color(0xFF1565C0); // Bleu profond
const Color accentColor = Color(0xFF42A5F5); // Bleu clair
const Color backgroundColor = Color(0xFFF5F5F5);
const Color textColor = Color(0xFF212121);
const Color cardColor = Colors.white;

/// 🕒 Format de date utilisé dans l’app
const String dateFormat = 'dd/MM/yyyy HH:mm';

/// 📱 Styles de texte de base
const TextStyle titleStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
const TextStyle subtitleStyle = TextStyle(fontSize: 16, color: Colors.grey);
