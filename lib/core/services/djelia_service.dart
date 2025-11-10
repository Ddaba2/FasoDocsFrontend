import 'dart:convert';
import 'dart:io' if (dart.library.html) 'dart:html';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DjeliaService {
  /// Retourne l'URL de base selon la plateforme
  static Future<String> get baseUrl async {
    // Vérifier d'abord si une URL personnalisée est sauvegardée
    try {
      final prefs = await SharedPreferences.getInstance();
      final customUrl = prefs.getString('backend_url');
      if (customUrl != null && customUrl.isNotEmpty) {
        return customUrl;
      }
    } catch (e) {
      debugPrint('Erreur lecture URL personnalisée: $e');
    }

    if (kIsWeb) {
      // 🌐 CHROME / WEB
      // Le web tourne généralement sur localhost:XXXX
      // et communique avec le backend sur localhost:8080
      return "http://localhost:8080/api/djelia";
      
    } else if (Platform.isAndroid) {
      // 📱 ANDROID
      // Détecte automatiquement si émulateur ou appareil réel
      return _getAndroidUrl();
      
    } else if (Platform.isIOS) {
      // 🍎 iOS
      return "http://localhost:8080/api/djelia";
      
    } else {
      // 💻 Desktop (Windows/Mac/Linux)
      return "http://localhost:8080/api/djelia";
    }
  }
  
  /// Détermine l'URL pour Android (émulateur vs appareil réel)
  static String _getAndroidUrl() {
    // Par défaut, on utilise l'URL pour émulateur
    // Pour appareil réel, changez cette valeur dans les paramètres de l'app
    // ou utilisez l'écran de configuration
    return "http://10.0.2.2:8080/api/djelia";  // Émulateur
    // return "http://192.168.1.100:8080/api/djelia";  // Appareil réel (remplacer par votre IP)
  }
  
  /// Traduit du français en bambara ET génère l'audio
  static Future<Map<String, dynamic>> translateAndSpeak(String texteFrancais) async {
    try {
      // ✅ ÉTAPE 1 : VALIDATION - Vérifier que le texte n'est pas null ou vide
      debugPrint('═══════════════════════════════════════');
      debugPrint('🎤 DÉBUT APPEL DJELIA AI');
      debugPrint('═══════════════════════════════════════');
      
      debugPrint('📝 Texte reçu: "$texteFrancais"');
      debugPrint('🔍 Est null? ${texteFrancais == null}');
      debugPrint('🔍 Est vide? ${texteFrancais.trim().isEmpty}');
      
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
      
      // ✅ IMPORTANT : Utiliser l'endpoint /chatbot/read-quick (PAS /djelia/translate-and-speak)
      final endpoint = baseUrlString.replaceAll('/api/djelia', '/api/chatbot');
      final fullUrl = '$endpoint/read-quick';
      
      debugPrint('🌐 Plateforme : ${_getPlatformName()}');
      debugPrint('🔗 URL complète : $fullUrl');
      
      // ✅ ÉTAPE 4 : Construire le body (avec chunkSize comme le backend attend)
      final body = {
        'text': cleanText,  // ✅ ON EST SÛR QUE CE N'EST PAS NULL !
        'voiceDescription': 'Voix claire et naturelle',
        'chunkSize': 1.0,
      };
      
      debugPrint('📦 Body à envoyer:');
      debugPrint(jsonEncode(body));
      debugPrint('═══════════════════════════════════════');
      
      // ✅ ÉTAPE 5 : Envoyer la requête
      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
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
    if (kIsWeb) return 'Web (Chrome)';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Inconnue';
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
