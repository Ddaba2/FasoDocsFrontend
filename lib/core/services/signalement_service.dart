// ========================================================================================
// SIGNALEMENT SERVICE - Service pour la gestion des signalements
// ========================================================================================

import 'api_service.dart';
import '../config/api_config.dart';
import '../../models/api_models.dart';

class SignalementService {
  final ApiService _apiService = apiService;
  
  /// Récupérer les types de signalement depuis le backend
  Future<List<SignalementType>> getSignalementTypes() async {
    try {
      final response = await _apiService.get(ApiConfig.signalementTypes);
      if (response.statusCode == 200) {
        // Vérifier si la réponse est une liste
        if (response.data is List) {
          final List<dynamic> data = response.data;
          return data.map((e) => SignalementType.fromJson(e as Map<String, dynamic>)).toList();
        } 
        // Si c'est un objet avec une liste à l'intérieur
        else if (response.data is Map<String, dynamic> && response.data['data'] is List) {
          final List<dynamic> data = response.data['data'];
          return data.map((e) => SignalementType.fromJson(e as Map<String, dynamic>)).toList();
        }
        // Retourner une liste vide si le format n'est pas reconnu
        return [];
      }
      // Si le statut n'est pas 200, retourner une liste vide
      return [];
    } catch (e) {
      // En cas d'erreur (endpoint non trouvé, réseau, etc.), retourner une liste vide
      // Log the error for debugging (in production, you might want to use a proper logger)
      // print('Erreur lors du chargement des types de signalement: $e');
      return [];
    }
  }
  
  /// Créer un signalement
  Future<void> createSignalement(SignalementRequest request) async {
    try {
      final response = await _apiService.post(
        ApiConfig.signalements,
        data: request.toJson(),
      );
      
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erreur lors de la création du signalement');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Obtenir mes signalements
  Future<List<SignalementResponse>> getMySignalements() async {
    try {
      final response = await _apiService.get(ApiConfig.signalements);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => SignalementResponse.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des signalements');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Obtenir tous les signalements (visibles à tous les utilisateurs) - dépend du backend
  Future<List<SignalementResponse>> getAllSignalements() async {
    try {
      // Par défaut, on réutilise le même endpoint; ajustez côté backend si besoin
      final response = await _apiService.get(ApiConfig.signalements);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => SignalementResponse.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des signalements');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Obtenir un signalement par ID
  Future<SignalementResponse> getSignalementById(String id) async {
    try {
      final response = await _apiService.get(ApiConfig.signalementById(id));
      
      if (response.statusCode == 200) {
        return SignalementResponse.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de la récupération du signalement');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Modifier un signalement
  Future<MessageResponse> updateSignalement(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put(
        ApiConfig.signalementById(id),
        data: data,
      );
      
      if (response.statusCode == 200) {
        return MessageResponse.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de la modification du signalement');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Supprimer un signalement
  Future<MessageResponse> deleteSignalement(String id) async {
    try {
      final response = await _apiService.delete(ApiConfig.signalementById(id));
      
      if (response.statusCode == 200) {
        return MessageResponse.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de la suppression du signalement');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
}

// Instance globale du service de signalements
final SignalementService signalementService = SignalementService();