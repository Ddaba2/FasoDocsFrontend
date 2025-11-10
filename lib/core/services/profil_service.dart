// ========================================================================================
// SERVICE PROFIL - Gestion du profil utilisateur avec photo
// ========================================================================================

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import 'auth_service.dart';

class ProfilService {
  final AuthService _authService = authService;

  // ========================================================================================
  // UPLOAD DE PHOTO DE PROFIL
  // ========================================================================================
  
  /// Upload SEULEMENT une photo de profil en Base64
  /// Le backend met à jour uniquement les champs non-null
  Future<Map<String, dynamic>> uploadPhoto({
    required File photoFile,
  }) async {
    try {
      // 1. Obtenir le token d'authentification
      final token = await _getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      // 2. Lire et convertir l'image en Base64
      debugPrint('📸 Lecture du fichier photo...');
      final bytes = await photoFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      // 3. Déterminer le type MIME de l'image
      String mimeType = 'image/jpeg';
      final extension = photoFile.path.split('.').last.toLowerCase();
      if (extension == 'png') {
        mimeType = 'image/png';
      } else if (extension == 'jpg' || extension == 'jpeg') {
        mimeType = 'image/jpeg';
      }
      
      final photoBase64 = 'data:$mimeType;base64,$base64Image';
      
      debugPrint('📤 Upload de la photo (${bytes.length} bytes)...');
      debugPrint('📏 Taille Base64: ${photoBase64.length} caractères');

      // 4. ✅ Envoyer avec PUT /profil (le backend met à jour seulement photoProfil si c'est le seul champ)
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.authProfil}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'photoProfil': photoBase64,  // ✅ Seulement la photo
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('⏱️ Timeout : Le serveur ne répond pas');
        },
      );

      debugPrint('📥 Réponse HTTP : ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('✅ Photo uploadée avec succès');
        
        // Recharger le profil pour mettre à jour les données locales
        await _authService.getProfil();
        
        return data;
      } else if (response.statusCode == 401) {
        throw Exception('🔒 Non authentifié. Veuillez vous reconnecter.');
      } else if (response.statusCode == 413) {
        throw Exception('📦 Fichier trop volumineux. Maximum 5MB.');
      } else {
        try {
          final errorData = jsonDecode(response.body);
          throw Exception(errorData['message'] ?? 'Erreur serveur : ${response.statusCode}');
        } catch (e) {
          throw Exception('Erreur serveur : ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint('❌ Erreur uploadPhoto : $e');
      rethrow;
    }
  }

  // ========================================================================================
  // MISE À JOUR COMPLÈTE DU PROFIL (avec photo optionnelle)
  // ========================================================================================
  
  /// Met à jour le profil complet (nom, prénom, photo optionnelle)
  Future<Map<String, dynamic>> updateProfilComplet({
    required String nom,
    required String prenom,
    File? photoFile,
  }) async {
    try {
      // 1. Obtenir le token d'authentification
      final token = await _getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      // 2. Préparer les données
      final Map<String, dynamic> data = {
        'nom': nom,
        'prenom': prenom,
      };

      // 3. Si une photo est fournie, la convertir en Base64
      if (photoFile != null) {
        debugPrint('📸 Conversion de la photo en Base64...');
        final bytes = await photoFile.readAsBytes();
        final base64Image = base64Encode(bytes);
        
        String mimeType = 'image/jpeg';
        final extension = photoFile.path.split('.').last.toLowerCase();
        if (extension == 'png') {
          mimeType = 'image/png';
        }
        
        data['photoProfil'] = 'data:$mimeType;base64,$base64Image';
        debugPrint('📤 Photo incluse dans la mise à jour');
      }

      // 4. Envoyer la requête
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.authProfil}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('⏱️ Timeout : Le serveur ne répond pas');
        },
      );

      debugPrint('📥 Réponse HTTP : ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Profil mis à jour avec succès');
        
        // Recharger le profil
        await _authService.getProfil();
        
        return responseData;
      } else if (response.statusCode == 401) {
        throw Exception('🔒 Non authentifié. Veuillez vous reconnecter.');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Erreur serveur : ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Erreur updateProfilComplet : $e');
      rethrow;
    }
  }

  // ========================================================================================
  // SUPPRESSION DE PHOTO
  // ========================================================================================
  
  /// Supprime la photo de profil
  /// ✅ Envoie photoProfil="" pour supprimer (le backend accepte les champs non-null)
  Future<void> supprimerPhoto() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      debugPrint('🗑️ Suppression de la photo...');

      // ✅ Utiliser PUT /profil avec photoProfil vide
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.authProfil}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'photoProfil': '',  // ✅ Chaîne vide pour supprimer
        }),
      );

      debugPrint('📥 Réponse HTTP : ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('✅ Photo supprimée avec succès');
        
        // Recharger le profil
        await _authService.getProfil();
      } else if (response.statusCode == 401) {
        throw Exception('🔒 Non authentifié. Veuillez vous reconnecter.');
      } else {
        try {
          final errorData = jsonDecode(response.body);
          throw Exception(errorData['message'] ?? 'Erreur lors de la suppression');
        } catch (e) {
          throw Exception('Erreur lors de la suppression');
        }
      }
    } catch (e) {
      debugPrint('❌ Erreur supprimerPhoto : $e');
      rethrow;
    }
  }

  // ========================================================================================
  // UTILITAIRES POUR SÉLECTION D'IMAGE
  // ========================================================================================
  
  /// Sélectionner une image depuis la galerie
  Future<File?> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Erreur pickImageFromGallery : $e');
      return null;
    }
  }

  /// Prendre une photo avec la caméra
  Future<File?> takePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Erreur takePhoto : $e');
      return null;
    }
  }

  /// Afficher un dialogue de choix (Galerie / Caméra)
  Future<File?> showImageSourceDialog(BuildContext context) async {
    return await showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choisir une photo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galerie'),
                onTap: () async {
                  Navigator.pop(context);
                  final file = await pickImageFromGallery();
                  if (file != null && context.mounted) {
                    Navigator.pop(context, file);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Appareil photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final file = await takePhoto();
                  if (file != null && context.mounted) {
                    Navigator.pop(context, file);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  // ========================================================================================
  // MÉTHODES PRIVÉES
  // ========================================================================================
  
  /// Récupérer le token d'authentification
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}

// Instance globale du service de profil
final ProfilService profilService = ProfilService();

