// ========================================================================================
// API SERVICE - Service principal pour les appels HTTP vers Spring Boot
// ========================================================================================

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';

class ApiService {
  late Dio _dio;
  
  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    
    // Ajouter les interceptors pour logging (en développement)
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }
  }
  
  // GET request
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // POST request
  Future<Response> post(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // PUT request
  Future<Response> put(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // DELETE request
  Future<Response> delete(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.delete(
        endpoint,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // Méthode pour ajouter un token d'authentification
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
  
  // Méthode pour supprimer le token d'authentification
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
  
  // Gestion des erreurs
  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Timeout de connexion. Veuillez réessayer.';
      
      case DioExceptionType.badResponse:
        if (error.response != null) {
          switch (error.response!.statusCode) {
            case 400:
              return 'Requête invalide';
            case 401:
              return 'Non autorisé. Veuillez vous connecter.';
            case 403:
              return 'Accès refusé';
            case 404:
              return 'Ressource non trouvée';
            case 500:
              return 'Erreur serveur. Veuillez réessayer plus tard.';
            default:
              return 'Erreur: ${error.response!.statusCode}';
          }
        }
        return 'Erreur de réponse du serveur';
      
      case DioExceptionType.cancel:
        return 'Requête annulée';
      
      case DioExceptionType.unknown:
        return 'Erreur de connexion. Vérifiez votre connexion internet.';
      
      default:
        return 'Une erreur inattendue s\'est produite';
    }
  }
}

// Instance globale du service API
final ApiService apiService = ApiService();

