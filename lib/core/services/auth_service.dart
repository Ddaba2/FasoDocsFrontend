// ========================================================================================
// AUTH SERVICE - Service pour la gestion de l'authentification
// ========================================================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../config/api_config.dart';
import '../../models/user_model.dart';
import '../../models/api_models.dart';

class AuthService {
  final ApiService _apiService = apiService;
  
  // Inscription d'un nouveau citoyen
  Future<MessageResponse> inscription({
    required String nomComplet,
    required String telephone,
    required String email,
    required String motDePasse,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.authInscription,
        data: {
          'nomComplet': nomComplet,
          'telephone': telephone,
          'email': email,
          'motDePasse': motDePasse,
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return MessageResponse.fromJson(response.data);
      } else {
        throw Exception('Échec de l\'inscription');
      }
    } catch (e) {
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
        throw Exception('Échec de l\'envoi du code SMS');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
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
        final user = User.fromJson(response.data);
        await _saveUser(user);
        return user;
      } else {
        throw Exception('Erreur lors de la récupération du profil');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
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
  
  // Sauvegarder l'utilisateur
  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', json.encode(user.toJson()));
  }
  
  // Supprimer l'utilisateur
  Future<void> _removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
  }
}

// Instance globale du service d'authentification
final AuthService authService = AuthService();

