import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class AudioService {
  static const String chatbotEndpoint = '/chatbot/read-quick';
  
  // Instance du lecteur audio
  static final AudioPlayer _audioPlayer = AudioPlayer()..setVolume(1.0); // 🔊 Volume au maximum
  
  // Méthode pour déclencher la synthèse vocale en bambara
  static Future<void> playProcedureAudio(String frenchText, {int speaker = 1}) async {
    try {
      // Afficher un indicateur de chargement à l'utilisateur
      // Vous devriez afficher un spinner de chargement ici
      
      // Construire l'URL complète en utilisant la configuration existante
      final String fullUrl = ApiConfig.buildUrl(chatbotEndpoint);
      
      // Faire l'appel API vers le backend
      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'texte': frenchText,
          'speaker': speaker, // 1 = Moussa, 2 = Sekou, 3 = Seydou
        }),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          // Utiliser l'URL compatible avec l'émulateur Android si disponible
          String audioUrl = data['androidEmulatorAudioUrl'] ?? data['audioUrl'];
          
          // 🔊 S'assurer que le volume est au maximum
          await _audioPlayer.setVolume(1.0);
          
          // Jouer l'audio
          await _audioPlayer.setUrl(audioUrl);
          await _audioPlayer.play();
        } else {
          // Gérer les erreurs du backend
          debugPrint('Erreur backend: ${data['error']}');
          // Afficher un message d'erreur à l'utilisateur
        }
      } else {
        // Gérer les erreurs HTTP
        debugPrint('Erreur HTTP: ${response.statusCode}');
        // Afficher un message d'erreur à l'utilisateur
      }
    } catch (e) {
      // Gérer les erreurs réseau ou autres
      debugPrint('Erreur lors de la lecture audio: $e');
      // Afficher un message d'erreur à l'utilisateur
    } finally {
      // Masquer l'indicateur de chargement
    }
  }
  
  // Méthode pour arrêter la lecture audio
  static Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      debugPrint('Erreur lors de l\'arrêt de l\'audio: $e');
    }
  }
  
  // Vérifier si l'audio est en cours de lecture
  static bool get isPlaying => _audioPlayer.playing;
  
  /// Récupère l'audio d'une procédure en Base64 depuis l'endpoint direct
  /// Retourne les données audio ou null si l'audio n'est pas disponible
  static Future<Map<String, dynamic>?> getProcedureAudioBase64(int procedureId) async {
    try {
      final String fullUrl = ApiConfig.buildUrl('/procedures/$procedureId/audio/base64');
      
      debugPrint('🎵 Récupération audio procédure $procedureId depuis: $fullUrl');
      
      // Préparer les headers avec authentification si disponible
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      
      // Ajouter le token d'authentification si disponible
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
          debugPrint('🔐 Token d\'authentification ajouté');
        }
      } catch (e) {
        debugPrint('⚠️ Impossible de récupérer le token: $e');
      }
      
      final response = await http.get(
        Uri.parse(fullUrl),
        headers: headers,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('⏱️ Timeout : Le serveur ne répond pas'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('✅ Audio récupéré avec succès');
        debugPrint('   Format: ${data['format'] ?? 'inconnu'}');
        debugPrint('   Taille: ${data['fileSize'] ?? 'inconnue'} bytes');
        return data;
      } else if (response.statusCode == 404) {
        debugPrint('⚠️ Aucun audio disponible pour la procédure $procedureId');
        return null;
      } else {
        debugPrint('❌ Erreur HTTP ${response.statusCode}: ${response.body}');
        throw Exception('Erreur serveur ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Erreur lors de la récupération de l\'audio: $e');
      rethrow;
    }
  }
  
  /// Joue l'audio d'une procédure depuis l'endpoint direct (Base64)
  /// Note: Cette méthode est utilisée par AudioService, mais IconeHautParleur
  /// utilise sa propre méthode _jouerAudio qui gère mieux les plateformes
  static Future<void> playProcedureAudioDirect(int procedureId) async {
    try {
      final audioData = await getProcedureAudioBase64(procedureId);
      
      if (audioData == null) {
        throw Exception('Aucun fichier audio disponible pour cette procédure');
      }
      
      final audioBase64 = audioData['audioBase64'] as String;
      final format = audioData['format'] as String? ?? 'wav';
      
      // Décoder Base64 en bytes
      final audioBytes = base64Decode(audioBase64);
      
      // Pour mobile, créer un fichier temporaire (plus fiable que data URI)
      // Pour web, utiliser MyCustomSource comme dans IconeHautParleur
      // Ici on utilise une approche simple avec data URI
      final audioUri = Uri.dataFromBytes(
        audioBytes,
        mimeType: 'audio/$format',
      );
      
      // 🔊 S'assurer que le volume est au maximum
      await _audioPlayer.setVolume(1.0);
      
      // Jouer l'audio depuis l'URI
      await _audioPlayer.setUrl(audioUri.toString());
      await _audioPlayer.play();
      
      debugPrint('✅ Audio joué avec succès (format: $format)');
    } catch (e) {
      debugPrint('❌ Erreur lors de la lecture audio: $e');
      rethrow;
    }
  }
}