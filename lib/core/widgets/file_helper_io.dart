// Helper pour les opérations fichier sur mobile/desktop
import 'dart:io';

class FileHelper {
  static Future<void> writeAudioFile(String filePath, List<int> bytes) async {
    final file = File(filePath);
    await file.writeAsBytes(bytes);
  }
}

