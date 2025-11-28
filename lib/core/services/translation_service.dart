import 'dart:io' show Platform;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class TranslationService {
  static AudioPlayer? _audioPlayer;
  
  // Get the base URL depending on the platform
  static String getBaseUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080'; // Android emulator
    } else {
      return 'http://localhost:8080'; // iOS simulator and physical devices
    }
  }
  
  // Djelia AI direct endpoints
  static String getDjeliaBaseUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000'; // Android emulator
    } else {
      return 'http://localhost:5000'; // iOS simulator and physical devices
    }
  }
  
  /// Translates French text to Bambara and plays the audio
  /// Returns true if successful, false otherwise
  static Future<bool> translateAndPlayAudio(String frenchText, {int speaker = 1}) async {
    try {
      // 1/3 Validate input
      if (frenchText.trim().isEmpty) {
        print('1/3 - Validation failed: Empty text provided');
        return false;
      }
      
      print('1/3 - Starting translation request for speaker $speaker');
      
      // Try direct Djelia AI first
      return await translateAndPlayAudioDirect(frenchText, speaker: speaker);
    } catch (e) {
      print('Fallback to proxy method due to: $e');
      // Fallback to proxy method
      return await translateAndPlayAudioProxy(frenchText, speaker: speaker);
    }
  }
  
  /// Translates French text to Bambara and plays the audio using proxy method
  static Future<bool> translateAndPlayAudioProxy(String frenchText, {int speaker = 1}) async {
    try {
      final url = '${getBaseUrl()}/api/chatbot/read-quick';
      print('2/3 - Making request to proxy: $url');
      
      // Set appropriate timeout based on text length
      final int timeoutSeconds = frenchText.length > 1000 ? 240 : 60;
      
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode({
          'texte': frenchText,
          'speaker': speaker // 1 = Moussa, 2 = Sekou, 3 = Seydou
        }),
      ).timeout(Duration(seconds: timeoutSeconds));
      
      print('3/3 - Proxy response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return await handleTranslationResponse(result);
      } else {
        print('3/3 - Proxy HTTP error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('3/3 - Exception in translateAndPlayAudioProxy: $e');
      return false;
    }
  }
  
  /// Translates French text to Bambara and plays the audio using Djelia AI directly
  static Future<bool> translateAndPlayAudioDirect(String frenchText, {int speaker = 1}) async {
    try {
      // 1/3 Translate French to Bambara
      print('1/3 - Translating French to Bambara');
      final String bambaraText = await translateToBambara(frenchText);
      
      // 2/3 Generate speech from Bambara text
      print('2/3 - Generating speech from Bambara text');
      final String? audioUrl = await generateSpeech(bambaraText, speaker: speaker);
      
      // 3/3 Play the audio
      print('3/3 - Playing audio');
      if (audioUrl != null) {
        await playAudio(audioUrl);
        return true;
      } else {
        print('3/3 - Failed to generate audio');
        return false;
      }
    } catch (e) {
      print('3/3 - Exception in translateAndPlayAudioDirect: $e');
      rethrow; // Rethrow to trigger fallback
    }
  }
  
  /// Translates French text to Bambara using Djelia AI directly
  static Future<String> translateToBambara(String frenchText) async {
    try {
      final url = '${getDjeliaBaseUrl()}/translate';
      print('🔄 Translating: $frenchText');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode({
          'text': frenchText,
          'source_lang': 'fr',
          'target_lang': 'bm'
        }),
      );
      
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final translatedText = result['translation'] ?? result['text'] ?? frenchText;
        print('✅ Translation successful: $translatedText');
        return translatedText;
      } else {
        print('❌ Translation error: ${response.statusCode}');
        return frenchText;
      }
    } catch (e) {
      print('❌ Translation exception: $e');
      return frenchText;
    }
  }
  
  /// Generates speech from Bambara text using Djelia AI directly
  static Future<String?> generateSpeech(String bambaraText, {int speaker = 1}) async {
    try {
      final url = '${getDjeliaBaseUrl()}/speak';
      print('🔊 Generating speech: $bambaraText');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode({
          'text': bambaraText,
          'language': 'bm',
          'speaker': speaker
        }),
      );
      
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final audioUrl = result['audioUrl'] ?? result['url'];
        if (audioUrl != null) {
          // Convert localhost URLs to 10.0.2.2 for Android emulator
          final String convertedUrl = convertUrlForAndroid(audioUrl);
          print('✅ Audio generated: $convertedUrl');
          return convertedUrl;
        }
      }
      print('❌ Speech generation error: ${response.statusCode}');
      return null;
    } catch (e) {
      print('❌ Speech generation exception: $e');
      return null;
    }
  }
  
  /// Convert localhost URLs to 10.0.2.2 for Android emulator
  static String convertUrlForAndroid(String url) {
    if (Platform.isAndroid && url.contains('localhost')) {
      return url.replaceFirst('localhost', '10.0.2.2');
    }
    return url;
  }
  
  /// Handles the translation response with fallback
  static Future<bool> handleTranslationResponse(Map<String, dynamic> result) async {
    try {
      if (result['success'] == true) {
        // Check if translation actually worked
        final originalText = result['originalText'];
        final translatedText = result['translatedText'];
        final audioUrl = result['audioUrl'];
        
        // If translation failed (same text), show a warning to the user
        if (originalText == translatedText) {
          // Show user a message that translation failed but audio will play in French
          print('⚠️ Translation failed, playing audio in French');
          // You might want to show a Snackbar or Dialog to inform the user
        } else {
          print('✅ Translation successful: $translatedText');
        }
        
        // Play the audio
        // Convert localhost URLs to 10.0.2.2 for Android emulator
        final String convertedUrl = convertUrlForAndroid(audioUrl);
        await playAudio(convertedUrl);
        return true;
      } else {
        print('❌ Error: ${result['error']}');
        return false;
      }
    } catch (e) {
      print('❌ Exception in handleTranslationResponse: $e');
      return false;
    }
  }
  
  /// Plays audio from a URL
  static Future<void> playAudio(String audioUrl) async {
    try {
      _audioPlayer ??= AudioPlayer();
      await _audioPlayer!.stop(); // Stop any currently playing audio
      await _audioPlayer!.setUrl(audioUrl);
      await _audioPlayer!.play();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }
  
  /// Stops the currently playing audio
  static Future<void> stopAudio() async {
    try {
      _audioPlayer ??= AudioPlayer();
      await _audioPlayer!.stop();
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }
  
  /// Check if audio is currently playing
  static bool get isPlaying => _audioPlayer?.playing ?? false;
  
  /// Get the current position of the audio player
  static Duration get currentPosition => _audioPlayer?.position ?? Duration.zero;
}