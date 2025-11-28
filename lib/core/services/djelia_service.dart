import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class DjeliaService {
  /// Retourne l'URL de base selon la plateforme
  /// Utilise ApiConfig.baseUrl pour être cohérent avec le reste de l'application
  static Future<String> get baseUrl async {
    // Vérifier d'abord si une URL personnalisée est sauvegardée
    try {
      final prefs = await SharedPreferences.getInstance();
      final customUrl = prefs.getString('backend_url');
      if (customUrl != null && customUrl.isNotEmpty) {
        // Si l'URL personnalisée ne se termine pas par /djelia, l'ajouter
        if (customUrl.endsWith('/djelia')) {
          return customUrl;
        } else {
          return customUrl.replaceAll('/api', '/api/djelia');
        }
      }
    } catch (e) {
      debugPrint('Erreur lecture URL personnalisée: $e');
    }

    // Utiliser ApiConfig.baseUrl comme base et remplacer /api par /api/djelia
    // Cela garantit que DjeliaService utilise la même IP que le reste de l'application
    final apiBaseUrl = ApiConfig.baseUrl;
    
    if (kIsWeb) {
      // Pour le web, utiliser directement localhost
      return "http://localhost:8080/api/djelia";
    }
    
    // Pour les autres plateformes, utiliser ApiConfig.baseUrl qui contient déjà la bonne IP
    // Exemple: http://192.168.11.109:8080/api -> http://192.168.11.109:8080/api/djelia
    if (apiBaseUrl.endsWith('/api')) {
      // Ajouter /djelia à la fin
      return '$apiBaseUrl/djelia';
    } else {
      // Si l'URL ne se termine pas par /api, normaliser et ajouter /api/djelia
      final normalizedUrl = apiBaseUrl.endsWith('/') ? apiBaseUrl.substring(0, apiBaseUrl.length - 1) : apiBaseUrl;
      return '$normalizedUrl/api/djelia';
    }
  }
  
  /// Traduit du français en bambara ET génère l'audio avec fallback automatique
  /// [procedureId] : Optionnel, permet d'activer le fallback vers l'audio préenregistré si Djelia AI échoue
  static Future<Map<String, dynamic>> translateAndSpeak(
    String texteFrancais, {
    int? procedureId,
  }) async {
    try {
      // ✅ ÉTAPE 1 : VALIDATION - Vérifier que le texte n'est pas null ou vide
      debugPrint('═══════════════════════════════════════');
      debugPrint('🎤 DÉBUT APPEL DJELIA AI');
      debugPrint('═══════════════════════════════════════');
      
      debugPrint('📝 Texte reçu: "$texteFrancais"');
      debugPrint('🔍 Est null? ${texteFrancais == null}');
      debugPrint('🔍 Est vide? ${texteFrancais.trim().isEmpty}');
      if (procedureId != null) {
        debugPrint('🆔 ProcedureId fourni: $procedureId (fallback activé)');
      } else {
        debugPrint('⚠️ ProcedureId non fourni (fallback désactivé)');
      }
      
      if (texteFrancais.trim().isEmpty) {
        debugPrint('❌ ERREUR : Texte vide ou null');
        throw Exception('Le texte à traduire est vide');
      }
      
      // ✅ ÉTAPE 2 : Nettoyer le texte
      final cleanText = texteFrancais.trim();
      debugPrint('✅ Texte nettoyé: "$cleanText"');
      debugPrint('📏 Longueur: ${cleanText.length} caractères');
      
      // ✅ ÉTAPE 3 : Préparer l'URL
      final baseUrlString = await baseUrl;
      
      // ✅ IMPORTANT : Utiliser le nouvel endpoint /djelia/translate-and-speak avec fallback
      final endpoint = baseUrlString.replaceAll('/api/djelia', '/api/djelia');
      final fullUrl = '$endpoint/translate-and-speak';
      
      debugPrint('🌐 Plateforme : ${_getPlatformName()}');
      debugPrint('🔗 URL complète : $fullUrl');
      
      // ✅ ÉTAPE 4 : Construire le body avec procedureId pour activer le fallback
      final body = {
        'text': cleanText,  // ✅ ON EST SÛR QUE CE N'EST PAS NULL !
        if (procedureId != null) 'procedureId': procedureId, // ⚠️ IMPORTANT pour activer le fallback
      };
      
      debugPrint('📦 Body à envoyer:');
      debugPrint(jsonEncode(body));
      debugPrint('═══════════════════════════════════════');
      
      // ✅ ÉTAPE 5 : Envoyer la requête
      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json; charset=utf-8',
        },
        body: jsonEncode(body),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('⏱️ Timeout : Le serveur ne répond pas'),
      );
      
      debugPrint('');
      debugPrint('═══════════════════════════════════════');
      debugPrint('📥 RÉPONSE REÇUE');
      debugPrint('═══════════════════════════════════════');
      debugPrint('📊 Status Code: ${response.statusCode}');
      debugPrint('📄 Body:');
      debugPrint(response.body);
      debugPrint('═══════════════════════════════════════');
      
      if (response.statusCode == 200) {
        // ✅ SUCCÈS !
        final data = jsonDecode(response.body);
        final translation = data['translatedText'];
        final audioBase64 = data['audioBase64'];
        
        debugPrint('✅ Traduction: $translation');
        debugPrint('✅ Audio reçu: ${audioBase64?.length ?? 0} caractères');
        debugPrint('═══════════════════════════════════════');
        
        return data;
      } else if (response.statusCode == 401) {
        throw Exception('🔒 Erreur d\'authentification avec Djelia AI');
      } else if (response.statusCode == 429) {
        throw Exception('⚠️ Quota API dépassé. Réessayez plus tard.');
      } else {
        // ❌ ERREUR
        debugPrint('❌ Erreur ${response.statusCode}');
        debugPrint('❌ Message: ${response.body}');
        debugPrint('═══════════════════════════════════════');
        
        // Essayer d'extraire le message d'erreur
        String errorDetail = 'Erreur serveur ${response.statusCode}';
        try {
          final errorData = jsonDecode(response.body);
          errorDetail = errorData['message'] ?? errorData['error'] ?? response.body;
        } catch (e) {
          errorDetail = response.body;
        }
        
        throw Exception(errorDetail);
      }
    } catch (e, stackTrace) {
      debugPrint('');
      debugPrint('═══════════════════════════════════════');
      debugPrint('💥 EXCEPTION');
      debugPrint('═══════════════════════════════════════');
      debugPrint('❌ Erreur: $e');
      debugPrint('📚 Stack trace:');
      debugPrint(stackTrace.toString());
      debugPrint('═══════════════════════════════════════');
      rethrow;
    }
  }
  
  /// Retourne le nom de la plateforme actuelle
  static String _getPlatformName() {
    if (kIsWeb) {
      return 'Web (Chrome)';
    }
    // Pour les plateformes natives, retourner un nom générique
    return 'Mobile/Desktop';
  }
  
  /// Test de connexion au backend
  static Future<bool> testConnection() async {
    try {
      final url = await baseUrl;
      final response = await http.get(
        Uri.parse('$url/health'),
      ).timeout(const Duration(seconds: 10));
      
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ Test connexion échoué : $e');
      return false;
    }
  }

  /// Sauvegarder une URL personnalisée
  static Future<void> saveCustomUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('backend_url', url);
  }

  /// Supprimer l'URL personnalisée
  static Future<void> clearCustomUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('backend_url');
  }
}
