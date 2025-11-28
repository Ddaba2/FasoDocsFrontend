// ========================================================================================
// SERVICE PROFIL - Gestion du profil utilisateur avec photo
// ========================================================================================

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
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
  /// Utilise l'endpoint dédié POST /api/auth/profil/photo (recommandé)
  Future<Map<String, dynamic>> uploadPhoto({
    required File photoFile,
  }) async {
    try {
      // 1. Vérifier que le fichier existe
      if (!await photoFile.exists()) {
        throw Exception('❌ Le fichier photo n\'existe pas: ${photoFile.path}');
      }
      
      final fileSize = await photoFile.length();
      debugPrint('📸 Lecture du fichier photo...');
      debugPrint('   - Fichier: ${photoFile.path}');
      debugPrint('   - Taille fichier: $fileSize bytes');
      
      // Vérifier la taille (max 5MB)
      if (fileSize > 5 * 1024 * 1024) {
        throw Exception('❌ La photo est trop volumineuse (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB). Maximum: 5MB');
      }
      
      // 2. Lire et convertir l'image en Base64
      final bytes = await photoFile.readAsBytes();
      debugPrint('   - Bytes lus: ${bytes.length} bytes');
      
      if (bytes.isEmpty) {
        throw Exception('❌ Le fichier photo est vide');
      }
      
      final base64Image = base64Encode(bytes);
      debugPrint('   - Base64 encodé: ${base64Image.length} caractères');
      
      if (base64Image.isEmpty) {
        throw Exception('❌ L\'encodage Base64 a échoué');
      }
      
      // 3. Déterminer le type MIME de l'image
      String mimeType = 'image/jpeg';
      final extension = photoFile.path.split('.').last.toLowerCase();
      if (extension == 'png') {
        mimeType = 'image/png';
      } else if (extension == 'jpg' || extension == 'jpeg') {
        mimeType = 'image/jpeg';
      }
      debugPrint('   - Type MIME détecté: $mimeType');
      
      // 4. Créer le Data URL avec le préfixe requis
      final photoBase64 = 'data:$mimeType;base64,$base64Image';
      
      // Vérifier que le préfixe est correct
      if (!photoBase64.startsWith('data:image/')) {
        throw Exception('❌ Format de photo invalide: doit commencer par "data:image/"');
      }
      
      debugPrint('📤 Upload de la photo (${bytes.length} bytes)...');
      debugPrint('📏 Taille Base64: ${photoBase64.length} caractères');
      debugPrint('📸 Format: ${photoBase64.substring(0, math.min(50, photoBase64.length))}...');
      debugPrint('📤 Envoi vers: ${ApiConfig.baseUrl}${ApiConfig.authProfilPhoto}');
      
      // 5. Vérifier le token avant l'upload
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token d\'authentification manquant. Veuillez vous reconnecter.');
      }
      debugPrint('🔑 Token présent: ${token.substring(0, math.min(20, token.length))}...');
      
      // 6. ✅ Utiliser l'endpoint dédié POST /api/auth/profil/photo (recommandé)
      await _authService.uploadPhotoProfil(photoBase64);
      
      debugPrint('✅ Photo uploadée avec succès via endpoint dédié');
      
      // Retourner un Map pour compatibilité avec l'ancienne interface
      return {
        'success': true,
        'message': 'Photo uploadée avec succès',
      };
    } catch (e) {
      debugPrint('❌ Erreur uploadPhoto : $e');
      rethrow;
    }
  }

  // ========================================================================================
  // MISE À JOUR COMPLÈTE DU PROFIL (avec photo optionnelle)
  // ========================================================================================
  
  /// Met à jour le profil complet (nom, prénom, photo optionnelle)
  /// ✅ Utilise l'endpoint dédié POST /api/auth/profil/photo pour la photo (recommandé)
  Future<Map<String, dynamic>> updateProfilComplet({
    required String nom,
    required String prenom,
    File? photoFile,
  }) async {
    try {
      debugPrint('💾 ===== DÉBUT MISE À JOUR PROFIL COMPLET =====');
      debugPrint('   - Nom: $nom');
      debugPrint('   - Prénom: $prenom');
      debugPrint('   - Photo fournie: ${photoFile != null}');
      
      // 1. Obtenir le token d'authentification
      final token = await _getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      // 2. Si une photo est fournie, l'uploader avec l'endpoint dédié
      if (photoFile != null) {
        debugPrint('📸 ===== DÉBUT UPLOAD PHOTO (endpoint dédié) =====');
        debugPrint('   - Fichier: ${photoFile.path}');
        
        // Vérifier que le fichier existe
        if (!await photoFile.exists()) {
          throw Exception('❌ Le fichier photo n\'existe pas: ${photoFile.path}');
        }
        
        final fileSize = await photoFile.length();
        debugPrint('   - Taille fichier: $fileSize bytes');
        
        // Vérifier la taille (max 5MB)
        if (fileSize > 5 * 1024 * 1024) {
          throw Exception('❌ La photo est trop volumineuse (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB). Maximum: 5MB');
        }
        
        // Lire et convertir en Base64
        final bytes = await photoFile.readAsBytes();
        debugPrint('   - Bytes lus: ${bytes.length} bytes');
        
        if (bytes.isEmpty) {
          throw Exception('❌ Le fichier photo est vide');
        }
        
        final base64Image = base64Encode(bytes);
        debugPrint('   - Base64 encodé: ${base64Image.length} caractères');
        
        if (base64Image.isEmpty) {
          throw Exception('❌ L\'encodage Base64 a échoué');
        }
        
        // Déterminer le type MIME de l'image
        String mimeType = 'image/jpeg';
        final extension = photoFile.path.split('.').last.toLowerCase();
        if (extension == 'png') {
          mimeType = 'image/png';
        } else if (extension == 'jpg' || extension == 'jpeg') {
          mimeType = 'image/jpeg';
        }
        debugPrint('   - Type MIME détecté: $mimeType');
        
        // Créer le Data URL avec le préfixe requis
        final photoDataUrl = 'data:$mimeType;base64,$base64Image';
        
        // Vérifier que le préfixe est correct
        if (!photoDataUrl.startsWith('data:image/')) {
          throw Exception('❌ Format de photo invalide: doit commencer par "data:image/"');
        }
        
        debugPrint('📤 Envoi photo vers: ${ApiConfig.baseUrl}${ApiConfig.authProfilPhoto}');
        debugPrint('📤 Photo longueur: ${photoDataUrl.length} caractères');
        debugPrint('📤 Préfixe: ${photoDataUrl.substring(0, math.min(30, photoDataUrl.length))}...');
        
        // ✅ Utiliser l'endpoint dédié POST /api/auth/profil/photo
        await _authService.uploadPhotoProfil(photoDataUrl);
        
        debugPrint('✅ Photo uploadée avec succès via endpoint dédié');
        debugPrint('📸 ===== FIN UPLOAD PHOTO =====');
      } else {
        debugPrint('⚠️ Aucune photo fournie (photoFile est null)');
      }
      
      // 3. Mettre à jour le profil (nom, prénom) avec PUT /auth/profil
      debugPrint('📤 Mise à jour du profil (nom, prénom)...');
      final Map<String, dynamic> data = {
        'nom': nom,
        'prenom': prenom,
      };
      
      final jsonBody = jsonEncode(data);
      debugPrint('📤 Envoi vers: ${ApiConfig.baseUrl}${ApiConfig.authProfil}');
      debugPrint('📤 Body: $jsonBody');
      
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.authProfil}'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonBody,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('⏱️ Timeout : Le serveur ne répond pas');
        },
      );

      debugPrint('📥 Réponse HTTP : ${response.statusCode}');
      debugPrint('📥 Réponse body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Profil mis à jour avec succès');
        
        // ⏳ Attendre un peu avant de recharger le profil
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Recharger le profil
        debugPrint('🔄 Rechargement du profil après mise à jour...');
        await _authService.getProfil();
        
        debugPrint('✅ ===== FIN MISE À JOUR PROFIL COMPLET =====');
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
          'Content-Type': 'application/json; charset=utf-8',
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
        maxWidth: 800,  // Limite selon le guide
        maxHeight: 800, // Limite selon le guide
        imageQuality: 85, // Qualité 0-100 (85 = bon compromis taille/qualité)
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
        maxWidth: 800,  // Limite selon le guide
        maxHeight: 800, // Limite selon le guide
        imageQuality: 85, // Qualité 0-100 (85 = bon compromis taille/qualité)
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

