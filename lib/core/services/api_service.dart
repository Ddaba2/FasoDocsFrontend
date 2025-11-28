// ========================================================================================
// API SERVICE - Service principal pour les appels HTTP vers Spring Boot
// ========================================================================================

import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  late Dio _dio;
  
  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json; charset=utf-8',
        },
        connectTimeout: const Duration(seconds: 10), // Réduit de 30 à 10 secondes
        receiveTimeout: const Duration(seconds: 15), // Réduit de 120 à 15 secondes pour les quiz (audio files utilisent getAudio avec timeout étendu)
        sendTimeout: const Duration(seconds: 10), // Réduit de 30 à 10 secondes
        validateStatus: (status) => status! < 500, // Accepter les codes < 500
      ),
    );
    
    // 🔥 AJOUT: Intercepteur pour ajouter Accept-Language automatiquement
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Récupérer la langue depuis SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final language = prefs.getString('language') ?? 'fr';
        
        // Ajouter le header Accept-Language
        options.headers['Accept-Language'] = language;
        
        print('🌐 Accept-Language: $language');
        return handler.next(options);
      },
    ));
    
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
      print('🌐 Appel API: GET $endpoint');
      
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      
      print('✅ Réponse API: ${response.statusCode} - ${response.statusMessage}');
      return response;
    } catch (e) {
      print('❌ Erreur API GET $endpoint: $e');
      rethrow;
    }
  }
  
  // POST request
  Future<Response> post(String endpoint, {dynamic data, Options? options}) async {
    try {
      print('🌐 ===== DÉBUT APPEL API POST =====');
      print('🌐 Endpoint: POST $endpoint');
      print('🌐 URL complète: ${ApiConfig.baseUrl}$endpoint');
      
      // Log des données si c'est une photo
      if (data is Map && data.containsKey('photoProfil')) {
        final photoData = data['photoProfil'] as String;
        print('📸 Upload photo détecté');
        print('📸 Photo longueur: ${photoData.length} caractères');
        print('📸 Photo préfixe: ${photoData.substring(0, math.min(30, photoData.length))}...');
      }
      
      final response = await _dio.post(
        endpoint,
        data: data,
        options: options,
      );
      
      print('✅ Réponse API: ${response.statusCode} - ${response.statusMessage}');
      print('🌐 ===== FIN APPEL API POST =====');
      return response;
    } catch (e) {
      print('❌ Erreur API POST $endpoint: $e');
      if (e is DioException) {
        print('   Type: ${e.type}');
        print('   Message: ${e.message}');
        if (e.response != null) {
          print('   Status: ${e.response?.statusCode}');
          print('   Data: ${e.response?.data}');
        }
      }
      print('🌐 ===== FIN APPEL API POST (ERREUR) =====');
      rethrow;
    }
  }
  
  // PUT request
  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      print('🌐 Appel API: PUT $endpoint');
      
      final response = await _dio.put(
        endpoint,
        data: data,
      );
      
      print('✅ Réponse API: ${response.statusCode} - ${response.statusMessage}');
      return response;
    } catch (e) {
      print('❌ Erreur API PUT $endpoint: $e');
      rethrow;
    }
  }
  
  // DELETE request
  Future<Response> delete(String endpoint) async {
    try {
      print('🌐 Appel API: DELETE $endpoint');
      
      final response = await _dio.delete(endpoint);
      
      print('✅ Réponse API: ${response.statusCode} - ${response.statusMessage}');
      return response;
    } catch (e) {
      print('❌ Erreur API DELETE $endpoint: $e');
      rethrow;
    }
  }
  
  // GET audio file with extended timeout
  Future<Response> getAudio(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      print('🎵 Appel API Audio: GET $endpoint');
      
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(
          receiveTimeout: const Duration(seconds: 180), // Extended timeout for audio files
          sendTimeout: const Duration(seconds: 30),
          responseType: ResponseType.bytes, // For audio file download
        ),
      );
      
      print('✅ Réponse API Audio: ${response.statusCode} - ${response.statusMessage}');
      return response;
    } catch (e) {
      print('❌ Erreur API GET Audio $endpoint: $e');
      rethrow;
    }
  }
  
  // Set auth token in headers
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
  
  // Remove auth token from headers
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}

// Instance globale du service API
final ApiService apiService = ApiService();