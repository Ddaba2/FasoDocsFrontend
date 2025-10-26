// ========================================================================================
// PROCEDURE SERVICE - Service pour la gestion des procédures
// ========================================================================================

import 'api_service.dart';
import '../config/api_config.dart';
import '../../models/api_models.dart';

class ProcedureService {
  final ApiService _apiService = apiService;
  
  /// Obtenir toutes les procédures
  Future<List<ProcedureResponse>> getAllProcedures() async {
    try {
      final response = await _apiService.get(ApiConfig.procedures);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ProcedureResponse.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des procédures');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Obtenir une procédure par ID
  Future<ProcedureResponse> getProcedureById(String id) async {
    try {
      final response = await _apiService.get(ApiConfig.procedureById(id));
      
      if (response.statusCode == 200) {
        return ProcedureResponse.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de la récupération de la procédure');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Obtenir les procédures par catégorie
  Future<List<ProcedureResponse>> getProceduresByCategorie(String categorieId) async {
    try {
      final response = await _apiService.get(ApiConfig.procedureByCategorie(categorieId));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ProcedureResponse.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des procédures');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Obtenir les procédures par sous-catégorie
  Future<List<ProcedureResponse>> getProceduresBySousCategorie(String sousCategorieId) async {
    try {
      final response = await _apiService.get(ApiConfig.procedureBySousCategorie(sousCategorieId));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ProcedureResponse.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des procédures');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Rechercher des procédures
  Future<List<ProcedureResponse>> searchProcedures(String query) async {
    try {
      final response = await _apiService.get(
        ApiConfig.procedureRechercher,
        queryParameters: {'q': query},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ProcedureResponse.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la recherche');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
}

// Instance globale du service de procédures
final ProcedureService procedureService = ProcedureService();

