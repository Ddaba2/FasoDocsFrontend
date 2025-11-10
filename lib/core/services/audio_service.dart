import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import '../config/api_config.dart';

class AudioService {
  static const String chatbotEndpoint = '/chatbot/read-quick';
  
  // Instance du lecteur audio
  static final AudioPlayer _audioPlayer = AudioPlayer();
  
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
}