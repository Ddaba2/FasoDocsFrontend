import 'package:flutter/material.dart';
import '../services/audio_service.dart'; // Changed from translation_service.dart

class AudioMicrophoneIcon extends StatefulWidget {
  final String frenchText;
  final int speaker; // 1 = Moussa, 2 = Sekou, 3 = Seydou

  const AudioMicrophoneIcon({
    super.key,
    required this.frenchText,
    this.speaker = 1,
  });

  @override
  State<AudioMicrophoneIcon> createState() => _AudioMicrophoneIconState();
}

class _AudioMicrophoneIconState extends State<AudioMicrophoneIcon> {
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : Icon(
              _isPlaying ? Icons.stop : Icons.volume_up,
              color: _isPlaying ? Colors.red : Colors.green,
            ),
      onPressed: _onPressed,
    );
  }

  void _onPressed() async {
    if (_isPlaying) {
      // Stop the audio
      await AudioService.stopAudio(); // Changed from TranslationService
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    } else {
      // Play the audio
      if (widget.frenchText.trim().isEmpty) {
        // Don't play if text is empty
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Call the new audio service
        await AudioService.playProcedureAudio(
          widget.frenchText,
          speaker: widget.speaker,
        );
        
        // Set playing state
        setState(() {
          _isLoading = false;
          _isPlaying = true; // Assume success since we don't get a return value
        });

        // Listen for when the audio finishes playing
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            setState(() {
              _isPlaying = false;
            });
          }
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _isPlaying = false;
        });
        // In production, you might want to show a snackbar or dialog instead
        debugPrint('Error playing audio: $e');
      }
    }
  }
}