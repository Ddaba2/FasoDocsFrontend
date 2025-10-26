// ========================================================================================
// AUTH SERVICE - Service pour la gestion de l'authentification
// ========================================================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../config/api_config.dart';
import '../../models/user_model.dart';

class AuthService {
  final ApiService _apiService = apiService;
  
  // Connexion (Login)
  Future<User> login(String phone, String password) async {
    try {
      final response = await _apiService.post(
        ApiConfig.auth + '/login',
        data: {
          'phone': phone,
          'password': password,
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = response.data['user'] ?? response.data;
        final token = response.data['token'];
        
        // Sauvegarder le token
        await _saveToken(token);
        
        // Créer et sauvegarder l'utilisateur
        final user = User.fromJson(userData);
        await _saveUser(user);
        
        return user;
      } else {
        throw Exception('Échec de la connexion');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
  
  // Inscription (Signup)
  Future<User> signup({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    String? email,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.auth + '/register',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone,
          'password': password,
          if (email != null) 'email': email,
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = response.data['user'] ?? response.data;
        final token = response.data['token'];
        
        // Sauvegarder le token
        await _saveToken(token);
        
        // Créer et sauvegarder l'utilisateur
        final user = User.fromJson(userData);
        await _saveUser(user);
        
        return user;
      } else {
        throw Exception('Échec de l\'inscription');
      }
    } catch (e) {
      throw Exception('Erreur d\'inscription: $e');
    }
  }
  
  // Déconnexion (Logout)
  Future<void> logout() async {
    try {
      // Appeler l'endpoint de déconnexion du backend (optionnel)
      await _apiService.post(ApiConfig.auth + '/logout');
    } catch (e) {
      // Ignorer l'erreur si le backend n'a pas d'endpoint de déconnexion
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

