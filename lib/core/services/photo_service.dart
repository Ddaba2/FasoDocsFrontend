// ========================================================================================
// SERVICE PHOTO - Upload simple de photo de profil
// ========================================================================================

import 'dart:convert';
import 'dart:math' as math;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

/// Upload simple de photo de profil
/// Utilise directement l'endpoint POST /api/auth/profil/photo
Future<void> uploadPhotoProfil(String token, String baseUrl) async {
  final dio = Dio();
  
  print('📸 ===== DÉBUT UPLOAD PHOTO =====');
  
  try {
    // 1. Sélectionner l'image
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    
    if (image == null) {
      print('❌ Aucune image sélectionnée');
      return;
    }
    
    print('📸 Image sélectionnée: ${image.path}');
    
    // 2. Convertir en Base64
    final bytes = await image.readAsBytes();
    print('📸 Taille du fichier: ${bytes.length} bytes');
    
    final base64Image = base64Encode(bytes);
    final photoData = 'data:image/jpeg;base64,$base64Image';
    
    print('📸 Photo: ${photoData.length} caractères');
    print('📸 Préfixe: ${photoData.substring(0, math.min(30, photoData.length))}...');
    print('📤 Envoi vers: $baseUrl/auth/profil/photo');
    print('🔑 Token: ${token.substring(0, math.min(20, token.length))}...');
    
    // 3. Uploader
    final response = await dio.post(
      '$baseUrl/auth/profil/photo',
      data: {'photoProfil': photoData},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    
    print('✅ Upload réussi: ${response.statusCode}');
    print('✅ Réponse: ${response.data}');
    print('📸 ===== FIN UPLOAD PHOTO =====');
  } on DioException catch (e) {
    print('❌ Erreur DioException: ${e.message}');
    if (e.response != null) {
      print('   Status: ${e.response?.statusCode}');
      print('   Data: ${e.response?.data}');
    }
    print('📸 ===== FIN UPLOAD PHOTO (ERREUR) =====');
  } catch (e) {
    print('❌ Erreur: $e');
    print('📸 ===== FIN UPLOAD PHOTO (ERREUR) =====');
  }
}

