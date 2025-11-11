import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../services/djelia_service.dart';
import 'package:path_provider/path_provider.dart';

// Import conditionnel pour les opérations fichier
import 'file_helper_io.dart' if (dart.library.html) 'file_helper_web.dart';

class IconeHautParleur extends StatefulWidget {
  final String texteFrancais;
  final Color? couleur;
  final double? taille;
  
  const IconeHautParleur({
    super.key,
    required this.texteFrancais,
    this.couleur,
    this.taille = 24,
  });
  
  @override
  State<IconeHautParleur> createState() => _IconeHautParleurState();
}

class _IconeHautParleurState extends State<IconeHautParleur> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isLoading = false;
  bool _isPlaying = false;
  String? _traductionBambara;
  
  @override
  void initState() {
    super.initState();
    
    // Écouter l'état du lecteur audio
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
        });
      }
    });
  }
  
  /// Fonction appelée au clic sur l'icône
  Future<void> _onHautParleurClick() async {
    if (_isLoading) return;
    
    // Si déjà en lecture, arrêter
    if (_isPlaying) {
      await _audioPlayer.stop();
      return;
    }
    
    // ✅ VALIDATION : Vérifier que le texte n'est pas vide AVANT l'appel
    if (widget.texteFrancais.trim().isEmpty) {
      debugPrint('❌ Texte vide, impossible de traduire');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Aucun texte à traduire'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      debugPrint('🎯 Clic sur haut-parleur pour : "${widget.texteFrancais}"');
      
      // 1️⃣ Appeler l'API backend
      final result = await DjeliaService.translateAndSpeak(widget.texteFrancais);
      
      // 2️⃣ Récupérer les données
      final traductionBambara = result['translatedText'] as String;
      final audioBase64 = result['audioBase64'] as String;
      
      setState(() {
        _traductionBambara = traductionBambara;
        _isLoading = false;
      });
      
      // 3️⃣ Afficher la traduction dans un SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🇫🇷 Français : ${widget.texteFrancais}'),
                const SizedBox(height: 4),
                Text('🇲🇱 Bambara : $traductionBambara', 
                     style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      
      // 4️⃣ Jouer l'audio selon la plateforme
      await _jouerAudio(audioBase64);
      
      debugPrint('✅ Traduction et lecture audio réussies !');
      
    } catch (e) {
      setState(() => _isLoading = false);
      
      debugPrint('❌ Erreur complète : $e');
      
      // Afficher l'erreur
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur : ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }
  
  /// Joue l'audio selon la plateforme
  Future<void> _jouerAudio(String audioBase64) async {
    if (kIsWeb) {
      // 🌐 WEB (Chrome)
      await _jouerAudioWeb(audioBase64);
    } else {
      // 📱 MOBILE (Android/iOS)
      await _jouerAudioMobile(audioBase64);
    }
  }
  
  /// Joue l'audio sur Web (Chrome)
  Future<void> _jouerAudioWeb(String audioBase64) async {
    try {
      debugPrint('🌐 Lecture audio sur Web...');
      
      // Convertir Base64 en bytes
      final bytes = base64Decode(audioBase64);
      
      // Jouer via just_audio (supporte Web)
      await _audioPlayer.setAudioSource(
        MyCustomSource(bytes),
      );
      await _audioPlayer.play();
      
      debugPrint('✅ Audio joué sur Web');
    } catch (e) {
      debugPrint('❌ Erreur lecture audio Web : $e');
      throw Exception('Erreur lecture audio Web : $e');
    }
  }
  
  /// Joue l'audio sur Mobile (Android/iOS)
  Future<void> _jouerAudioMobile(String audioBase64) async {
    if (kIsWeb) {
      throw Exception('_jouerAudioMobile ne doit pas être appelé sur le web');
    }
    
    try {
      debugPrint('📱 Lecture audio sur Mobile...');
      
      // Décoder l'audio Base64 en bytes
      final audioBytes = base64Decode(audioBase64);
      
      // Sauvegarder temporairement dans un fichier (dart:io uniquement)
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${tempDir.path}/djelia_audio_$timestamp.wav';
      
      // Créer et écrire le fichier
      await FileHelper.writeAudioFile(filePath, audioBytes);
      
      debugPrint('📁 Fichier audio créé : $filePath');
      
      // Jouer l'audio depuis le fichier
      await _audioPlayer.setFilePath(filePath);
      await _audioPlayer.play();
      
      debugPrint('✅ Audio joué sur Mobile');
    } catch (e) {
      debugPrint('❌ Erreur lecture audio Mobile : $e');
      throw Exception('Erreur lecture audio Mobile : $e');
    }
  }
  
  
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _isLoading
          ? SizedBox(
              width: widget.taille,
              height: widget.taille,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(
                  widget.couleur ?? Colors.orange,
                ),
              ),
            )
          : Icon(
              _isPlaying ? Icons.stop_circle : Icons.volume_up,
              size: widget.taille,
              color: widget.couleur ?? Colors.orange,
            ),
      onPressed: _isLoading ? null : _onHautParleurClick,
      tooltip: 'Écouter en bambara',
    );
  }
}

// Source audio personnalisée pour just_audio (Web)
class MyCustomSource extends StreamAudioSource {
  final List<int> bytes;
  
  MyCustomSource(this.bytes);
  
  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/wav',
    );
  }
}

