// ========================================================================================
// CHATBOT SERVICE - Service pour le chatbot Djelia
// ========================================================================================

import 'api_service.dart';
import '../config/api_config.dart';
import '../../models/api_models.dart';

class ChatbotService {
  final ApiService _apiService = apiService;
  
  /// Chat simple avec Djelia
  Future<ChatResponse> chat(String question, String langue) async {
    try {
      final response = await _apiService.post(
        ApiConfig.chatbotChat,
        data: ChatRequest(question: question, langue: langue).toJson(),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChatResponse.fromJson(response.data);
      } else {
        throw Exception('Erreur lors du chat');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Chat avec synthèse vocale
  Future<ChatResponse> chatAudio(String question, String langue) async {
    try {
      final response = await _apiService.post(
        ApiConfig.chatbotChatAudio,
        data: ChatRequest(question: question, langue: langue).toJson(),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChatResponse.fromJson(response.data);
      } else {
        throw Exception('Erreur lors du chat audio');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Traduire un texte
  Future<TranslationResponse> translate(String texte, String fromLang, String toLang) async {
    try {
      final response = await _apiService.post(
        ApiConfig.chatbotTranslate,
        data: TranslationRequest(
          texte: texte,
          fromLang: fromLang,
          toLang: toLang,
        ).toJson(),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return TranslationResponse.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de la traduction');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Synthèse vocale
  Future<SpeakResponse> speak(String texte, String langue) async {
    try {
      final response = await _apiService.post(
        ApiConfig.chatbotSpeak,
        data: SpeakRequest(texte: texte, langue: langue).toJson(),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return SpeakResponse.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de la synthèse vocale');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Traduire FR vers BM
  Future<TranslationResponse> translateFrToBm(String texte) async {
    try {
      final preview = texte.length > 50 ? texte.substring(0, 50) : texte;
      print('🌐 Envoi traduction FR->BM: $preview...');
      
      final response = await _apiService.post(
        ApiConfig.chatbotTranslateFrToBm,
        data: {'texte': texte}, // Envoyer en format JSON
      );
      
      print('📦 Réponse backend: ${response.data}');
      print('📦 Type: ${response.data.runtimeType}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final translated = TranslationResponse.fromJson(response.data);
        final previewTrans = translated.texteTraduit.length > 50 
            ? translated.texteTraduit.substring(0, 50) 
            : translated.texteTraduit;
        print('✅ Texte traduit extrait: $previewTrans...');
        return translated;
      } else {
        throw Exception('Erreur lors de la traduction');
      }
    } catch (e) {
      print('❌ Erreur traduction: $e');
      throw Exception('Erreur: $e');
    }
  }
  
  /// Traduire BM vers FR
  Future<TranslationResponse> translateBmToFr(String texte) async {
    try {
      final response = await _apiService.post(
        ApiConfig.chatbotTranslateBmToFr,
        data: {'texte': texte}, // Envoyer en format JSON
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return TranslationResponse.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de la traduction');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Lire un texte en audio
  Future<Map<String, dynamic>> readAudio(String texte) async {
    try {
      final response = await _apiService.post(
        ApiConfig.chatbotReadAudio,
        data: texte,
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Erreur lors de la lecture audio');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Lecture audio rapide
  Future<Map<String, dynamic>> readQuick(String texte) async {
    try {
      final response = await _apiService.post(
        ApiConfig.chatbotReadQuick,
        data: texte,
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Erreur lors de la lecture rapide');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Vérifier la santé du service
  Future<Map<String, dynamic>> checkHealth() async {
    try {
      final response = await _apiService.get(ApiConfig.chatbotHealth);
      return response.data;
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
}

// Instance globale du service chatbot
final ChatbotService chatbotService = ChatbotService();

