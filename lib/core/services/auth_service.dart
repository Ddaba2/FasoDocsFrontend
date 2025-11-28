// ========================================================================================
// AUTH SERVICE - Service pour la gestion de l'authentification
// ========================================================================================

import 'dart:convert';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../config/api_config.dart';
import '../../models/user_model.dart';
import '../../models/api_models.dart';

class AuthService {
  final ApiService _apiService = apiService;
  
  // Inscription d'un nouveau citoyen
  // Enregistre dans la table "citoyen" du backend avec les champs requis
  Future<MessageResponse> inscription({
    required String nom,
    required String prenom,
    required String telephone,
    required String email,
    required String motDePasse,
    required String confirmerMotDePasse,
  }) async {
    try {
      print('📝 Inscription avec: nom=$nom, prenom=$prenom, telephone=$telephone, email=$email');
      
      final response = await _apiService.post(
        ApiConfig.authInscription,
        data: {
          'nom': nom,
          'prenom': prenom,
          'telephone': telephone,
          'email': email,
          'motDePasse': motDePasse, // camelCase pour le backend Spring Boot
          'confirmerMotDePasse': confirmerMotDePasse, // camelCase pour le backend
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Inscription réussie');
        return MessageResponse.fromJson(response.data);
      } else {
        final errorMsg = response.data['message'] ?? 'Échec de l\'inscription';
        print('❌ Erreur inscription: $errorMsg');
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('❌ Erreur inscription: $e');
      throw Exception('Erreur d\'inscription: $e');
    }
  }
  
  // Connexion par téléphone - Envoie un code SMS
  Future<MessageResponse> connexionTelephone(String telephone) async {
    try {
      final response = await _apiService.post(
        ApiConfig.authConnexionTelephone,
        data: {'telephone': telephone},
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return MessageResponse.fromJson(response.data);
      } else {
        // Extraire le message d'erreur du backend
        final errorMsg = response.data?['message'] ?? 'Échec de l\'envoi du code SMS';
        throw AuthException(
          message: errorMsg,
          statusCode: response.statusCode ?? 0,
        );
      }
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException(
        message: 'Erreur de connexion: $e',
        statusCode: 0,
      );
    }
  }
  
  // Vérification SMS et connexion
  Future<JwtResponse> verifierSms(String telephone, String code) async {
    try {
      final response = await _apiService.post(
        ApiConfig.authVerifierSms,
        data: {
          'telephone': telephone,
          'code': code,
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jwtResponse = JwtResponse.fromJson(response.data);
        
        // Sauvegarder le token
        await _saveToken(jwtResponse.token);
        
        return jwtResponse;
      } else {
        throw Exception('Code invalide');
      }
    } catch (e) {
      throw Exception('Erreur de vérification: $e');
    }
  }
  
  // Vérification de l'email
  Future<MessageResponse> verifyEmail(String code) async {
    try {
      final response = await _apiService.get(
        ApiConfig.authVerify,
        queryParameters: {'code': code},
      );
      
      if (response.statusCode == 200) {
        return MessageResponse.fromJson(response.data);
      } else {
        throw Exception('Code invalide');
      }
    } catch (e) {
      throw Exception('Erreur de vérification: $e');
    }
  }
  
  // Obtenir le profil de l'utilisateur
  Future<User> getProfil() async {
    try {
      final response = await _apiService.get(ApiConfig.authProfil);
      
      if (response.statusCode == 200) {
        // Log de débogage pour voir la réponse du backend
        debugPrint('📥 Réponse getProfil: ${response.data}');
        final photoProfilStr = response.data['photoProfil']?.toString() ?? 'NULL';
        final photoProfilPreview = photoProfilStr != 'NULL' && photoProfilStr.length > 50 
            ? "${photoProfilStr.substring(0, 50)}..." 
            : photoProfilStr;
        debugPrint('📸 photoProfil dans la réponse: $photoProfilPreview');
        debugPrint('📸 photoUrl dans la réponse: ${response.data['photoUrl']}');
        
        final user = User.fromJson(response.data);
        
        // Log de débogage pour voir ce qui est stocké dans User
        final userPhotoProfilPreview = user.photoProfil != null && user.photoProfil!.length > 50
            ? "${user.photoProfil!.substring(0, 50)}..."
            : user.photoProfil?.toString() ?? "NULL";
        debugPrint('📸 User.photoProfil après parsing: $userPhotoProfilPreview');
        debugPrint('📸 User.photoUrl après parsing: ${user.photoUrl}');
        
        await _saveUser(user);
        return user;
      } else if (response.statusCode == 400) {
        // Erreur d'authentification - l'utilisateur n'est probablement pas connecté
        final errorMsg = response.data['message'] ?? 'Non authentifié';
        throw Exception('Authentification requise: $errorMsg');
      } else {
        final errorMsg = response.data['message'] ?? 'Erreur inconnue';
        throw Exception('Erreur ${response.statusCode}: $errorMsg');
      }
    } catch (e) {
      print('❌ Erreur getProfil: $e');
      rethrow;
    }
  }
  
  // Mettre à jour le profil
  Future<MessageResponse> updateProfil(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put(
        ApiConfig.authProfil,
        data: data,
      );
      
      if (response.statusCode == 200) {
        // Recharger le profil
        await getProfil();
        return MessageResponse.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de la mise à jour');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  // Uploader la photo de profil
  // base64Image doit commencer par "data:image/..." (ex: "data:image/jpeg;base64,...")
  Future<void> uploadPhotoProfil(String base64Image) async {
    try {
      debugPrint('📸 Upload photo de profil...');
      debugPrint('📸 Photo complète: ${base64Image.length} caractères');
      debugPrint('📸 Préfixe: ${base64Image.substring(0, math.min(30, base64Image.length))}...');
      
      // 1. Vérifier que l'image est au format data URI
      if (!base64Image.startsWith('data:image/')) {
        throw Exception('Le format de l\'image doit commencer par "data:image/..."');
      }
      
      // 2. Vérifier le token d'authentification
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token d\'authentification manquant. Veuillez vous reconnecter.');
      }
      debugPrint('🔑 Token présent: ${token.substring(0, math.min(20, token.length))}...');
      
      // 3. Préparer les données
      final requestData = {
        'photoProfil': base64Image,
      };
      debugPrint('📤 Envoi vers: ${ApiConfig.baseUrl}${ApiConfig.authProfilPhoto}');
      debugPrint('📤 Body contient "photoProfil": ${requestData.containsKey('photoProfil')}');
      debugPrint('📤 Body contient "data:image": ${base64Image.contains('data:image')}');
      debugPrint('📤 Body contient "base64": ${base64Image.contains('base64')}');
      
      // 4. Envoyer la requête
      final response = await _apiService.post(
        ApiConfig.authProfilPhoto,
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
          },
        ),
      );
      
      debugPrint('📥 Réponse serveur: ${response.statusCode}');
      debugPrint('📥 Réponse data: ${response.data}');
      
      if (response.statusCode == 200) {
        debugPrint('✅ Photo uploadée avec succès');
        
        // 5. Vérifier que la photo a été sauvegardée
        await _verifierPhotoSauvegardee();
      } else {
        final errorMsg = response.data?['message'] ?? 'Erreur lors de l\'upload de la photo';
        debugPrint('❌ Erreur upload photo: $errorMsg (Status: ${response.statusCode})');
        throw Exception(errorMsg);
      }
    } on DioException catch (e) {
      debugPrint('❌ Erreur DioException: ${e.message}');
      if (e.response != null) {
        debugPrint('   Status: ${e.response?.statusCode}');
        debugPrint('   Data: ${e.response?.data}');
        
        if (e.response?.statusCode == 401) {
          throw Exception('Non authentifié. Veuillez vous reconnecter.');
        } else if (e.response?.statusCode == 400) {
          final errorMsg = e.response?.data?['message'] ?? 'Format de photo incorrect';
          throw Exception(errorMsg);
        } else if (e.response?.statusCode == 413) {
          throw Exception('Fichier trop volumineux. Maximum 5MB.');
        }
      }
      rethrow;
    } catch (e) {
      debugPrint('❌ Erreur uploadPhotoProfil: $e');
      rethrow;
    }
  }
  
  /// Vérifier que la photo a été sauvegardée dans le profil
  Future<void> _verifierPhotoSauvegardee() async {
    try {
      debugPrint('🔍 Vérification de la photo sauvegardée...');
      final user = await getProfil();
      
      if (user.photoProfil != null && user.photoProfil!.isNotEmpty) {
        final photoPreview = user.photoProfil!.length > 50
            ? "${user.photoProfil!.substring(0, 50)}..."
            : user.photoProfil!;
        debugPrint('✅ Photo confirmée dans le profil: ${user.photoProfil!.length} caractères');
        debugPrint('📸 Aperçu: $photoPreview');
      } else {
        debugPrint('⚠️ Photo toujours NULL après upload');
      }
    } catch (e) {
      debugPrint('⚠️ Erreur lors de la vérification: $e');
      // Ne pas faire échouer l'upload si la vérification échoue
    }
  }
  
  // Déconnexion (Logout)
  Future<void> logout() async {
    try {
      // Appeler l'endpoint de déconnexion du backend
      await _apiService.post(ApiConfig.authDeconnexion);
    } catch (e) {
      // Ignorer l'erreur
      debugPrint('Erreur logout: $e');
    } finally {
      // Supprimer le token localement
      await _removeToken();
      await _removeUser();
      _apiService.removeAuthToken();
    }
  }
  
  // Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    final token = await _getToken();
    if (token != null) {
      _apiService.setAuthToken(token);
      return true;
    }
    return false;
  }
  
  // Obtenir l'utilisateur actuel
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('current_user');
      
      if (userJson != null) {
        return User.fromJson(json.decode(userJson));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  // Sauvegarder le token
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    _apiService.setAuthToken(token);
  }
  
  // Récupérer le token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
  
  // Supprimer le token
  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
  
  // Sauvegarder l'utilisateur (public pour permettre la sauvegarde après inscription)
  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', json.encode(user.toJson()));
  }
  
  // Méthode publique pour sauvegarder l'utilisateur
  Future<void> saveUser(User user) async {
    await _saveUser(user);
  }
  
  // Supprimer l'utilisateur
  Future<void> _removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
  }
}

// Exception personnalisée pour les erreurs d'authentification
class AuthException implements Exception {
  final String message;
  final int statusCode;
  
  AuthException({
    required this.message,
    required this.statusCode,
  });
  
  bool get isAccountDisabled => 
    message.toLowerCase().contains('désactivé') || 
    message.toLowerCase().contains('desactive') ||
    message.toLowerCase().contains('disabled');
  
  @override
  String toString() => message;
}

// Instance globale du service d'authentification
final AuthService authService = AuthService();