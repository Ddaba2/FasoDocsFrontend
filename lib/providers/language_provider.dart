// ========================================================================================
// LANGUAGE PROVIDER - Gestion complète de la langue avec backend sync
// ========================================================================================

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LanguageProvider with ChangeNotifier {
  String _currentLanguage = 'fr';
  
  String get currentLanguage => _currentLanguage;
  
  // Liste des langues disponibles avec drapeaux
  final List<Map<String, String>> languages = [
    {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
  ];

  LanguageProvider() {
    _loadLanguage();
  }

  // Charger la langue sauvegardée
  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentLanguage = prefs.getString('language') ?? 'fr';
      notifyListeners();
      print('✅ Langue chargée: $_currentLanguage');
    } catch (e) {
      print('❌ Erreur chargement langue: $e');
    }
  }

  // Changer la langue (avec sauvegarde locale + backend)
  Future<void> changeLanguage(String code, String? token) async {
    _currentLanguage = code;
    
    // Sauvegarder localement
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', code);
    
    // Mettre à jour sur le backend si token disponible
    if (token != null && token.isNotEmpty) {
      await _updateBackend(code, token);
    }
    
    notifyListeners();
    print('✅ Langue changée: $code');
  }

  // Mettre à jour la langue sur le backend
  Future<void> _updateBackend(String code, String token) async {
    try {
      // TODO: Remplacer par votre URL backend réelle
      final response = await http.put(
        Uri.parse('http://192.168.1.100:8080/api/auth/profil'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'languePreferee': code}),
      );
      
      if (response.statusCode == 200) {
        print('✅ Langue mise à jour sur le backend: $code');
      } else {
        print('⚠️ Échec mise à jour backend: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur mise à jour langue backend: $e');
    }
  }

  // Récupérer le nom de la langue actuelle
  String get languageName => languages
      .firstWhere((l) => l['code'] == _currentLanguage)['name']!;
  
  // Récupérer le drapeau de la langue actuelle
  String get languageFlag => languages
      .firstWhere((l) => l['code'] == _currentLanguage)['flag']!;
  
  // Obtenir la locale Flutter
  Locale get locale => Locale(_currentLanguage);
}

