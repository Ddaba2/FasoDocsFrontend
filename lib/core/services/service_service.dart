// ========================================================================================
// SERVICE SERVICE - Service pour la gestion des services de procédures
// ========================================================================================

import 'api_service.dart';
import '../config/api_config.dart';
import '../../models/service_models.dart';

class ServiceService {
  final ApiService _apiService = apiService;
  
  /// Récupère le tarif de service pour une procédure
  Future<TarifService> obtenirTarif({
    required String procedureId,
    required String commune,
  }) async {
    try {
      final response = await _apiService.get(
        ApiConfig.serviceTarif(int.tryParse(procedureId) ?? 0),
        queryParameters: {'commune': commune},
      );

      if (response.statusCode == 200) {
        return TarifService.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de la récupération du tarif: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération du tarif: $e');
    }
  }

  /// Crée une demande de service
  Future<DemandeService> creerDemande({
    required String procedureId,
    required String commune,
    String? quartier,
    String? adresseComplete,
    String? telephoneContact,
    DateTime? dateSouhaitee,
    String? commentaires,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.servicesDemandes,
        data: {
          'procedureId': int.tryParse(procedureId) ?? procedureId,
          'commune': commune,
          'quartier': quartier,
          'adresseComplete': adresseComplete,
          'telephoneContact': telephoneContact,
          'dateSouhaitee': dateSouhaitee?.toIso8601String().split('T')[0],
          'commentaires': commentaires,
          'accepteTarif': true,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DemandeService.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de la création de la demande: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la création de la demande: $e');
    }
  }

  /// Récupère les demandes de l'utilisateur
  Future<List<DemandeService>> obtenirMesDemandes() async {
    try {
      final response = await _apiService.get(ApiConfig.servicesMesDemandes);
      
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => DemandeService.fromJson(json))
            .toList();
      } else {
        throw Exception('Erreur lors de la récupération des demandes: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des demandes: $e');
    }
  }

  /// Récupère une demande de service par ID
  Future<DemandeService> obtenirDemandeParId(int id) async {
    try {
      final response = await _apiService.get(ApiConfig.serviceDemandeById(id));
      
      if (response.statusCode == 200) {
        return DemandeService.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de la récupération de la demande: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la demande: $e');
    }
  }

  /// Annule une demande de service
  Future<Map<String, dynamic>> annulerDemande(int id, {String? raison}) async {
    try {
      // L'endpoint utilise PUT avec un query parameter 'raison'
      // On doit construire l'URL avec le query parameter
      String endpoint = ApiConfig.serviceAnnulerDemande(id);
      if (raison != null) {
        endpoint += '?raison=${Uri.encodeComponent(raison)}';
      }
      
      final response = await _apiService.put(endpoint);
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Erreur lors de l\'annulation de la demande: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'annulation de la demande: $e');
    }
  }

  // ============================================================================
  // MÉTHODES ADMIN
  // ============================================================================

  /// Récupère toutes les demandes de service (Admin uniquement)
  Future<List<DemandeService>> obtenirToutesLesDemandes({String? statut}) async {
    try {
      final queryParams = statut != null ? {'statut': statut} : null;
      final response = await _apiService.get(
        ApiConfig.adminServicesDemandes,
        queryParameters: queryParams,
      );
      
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => DemandeService.fromJson(json))
            .toList();
      } else {
        throw Exception('Erreur lors de la récupération des demandes: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des demandes: $e');
    }
  }

  /// Récupère une demande de service par ID (Admin uniquement)
  Future<DemandeService> obtenirDemandeParIdAdmin(int id) async {
    try {
      final response = await _apiService.get(ApiConfig.adminServiceDemandeById(id));
      
      if (response.statusCode == 200) {
        return DemandeService.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de la récupération de la demande: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la demande: $e');
    }
  }

  /// Modifie le statut d'une demande de service (Admin uniquement)
  Future<DemandeService> modifierStatutDemande({
    required int id,
    required String statut,
    String? notes,
  }) async {
    try {
      final response = await _apiService.put(
        ApiConfig.adminServiceModifierStatut(id),
        data: {
          'statut': statut,
          if (notes != null) 'notes': notes,
        },
      );
      
      if (response.statusCode == 200) {
        return DemandeService.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de la modification du statut: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la modification du statut: $e');
    }
  }
}

// Instance globale du service de service
final ServiceService serviceService = ServiceService();

