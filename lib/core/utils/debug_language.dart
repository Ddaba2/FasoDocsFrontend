// ========================================================================================
// DEBUG LANGUAGE - Utilitaire pour déboguer le système multilingue
// ========================================================================================

import 'package:shared_preferences/shared_preferences.dart';

class DebugLanguage {
  /// Afficher les informations de debug sur la langue
  static Future<void> printLanguageInfo() async {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🌍 DEBUG LANGUE');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString('language') ?? 'NON DÉFINIE';
      
      print('📱 Langue sauvegardée: $savedLanguage');
      print('✅ Header Accept-Language qui sera envoyé: $savedLanguage');
      print('');
      print('📌 IMPORTANT:');
      print('   Le backend doit utiliser ce header pour retourner');
      print('   les catégories/procédures dans la langue demandée.');
      print('');
      print('🔍 Vérifiez dans les logs que vous voyez:');
      print('   "🌐 Accept-Language: $savedLanguage"');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    } catch (e) {
      print('❌ Erreur debug langue: $e');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
  }
  
  /// Vérifier si le backend gère les traductions
  static void printBackendWarning() {
    print('');
    print('⚠️  ATTENTION BACKEND:');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('Si les catégories restent en français alors que');
    print('la langue est "en", c\'est que le backend ne gère');
    print('pas encore le header Accept-Language.');
    print('');
    print('📖 Consultez: BACKEND_MULTILINGUAL_SETUP.md');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('');
  }
}

