// ========================================================================================
// NOTIFICATION SERVICE - Service pour la gestion des notifications
// ========================================================================================

import 'api_service.dart';
import '../config/api_config.dart';
import '../../models/api_models.dart';

class NotificationService {
  final ApiService _apiService = apiService;
  
  /// Obtenir toutes les notifications
  Future<List<NotificationResponse>> getAllNotifications() async {
    try {
      final response = await _apiService.get(ApiConfig.notifications);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => NotificationResponse.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des notifications');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Obtenir les notifications non lues
  Future<List<NotificationResponse>> getNonLuesNotifications() async {
    try {
      final response = await _apiService.get(ApiConfig.notificationsNonLues);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => NotificationResponse.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des notifications');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Compter les notifications non lues
  Future<int> countNonLues() async {
    try {
      final response = await _apiService.get(ApiConfig.notificationsCountNonLues);
      
      if (response.statusCode == 200) {
        return response.data as int;
      } else {
        throw Exception('Erreur lors du comptage');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Marquer une notification comme lue
  Future<NotificationResponse> marquerCommeLue(String id) async {
    try {
      final response = await _apiService.put(ApiConfig.notificationLire(id));
      
      if (response.statusCode == 200) {
        return NotificationResponse.fromJson(response.data);
      } else {
        throw Exception('Erreur lors du marquage comme lu');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Marquer toutes les notifications comme lues
  Future<void> marquerToutCommeLue() async {
    try {
      await _apiService.put(ApiConfig.notificationsLireTout);
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
}

// Instance globale du service de notifications
final NotificationService notificationService = NotificationService();

