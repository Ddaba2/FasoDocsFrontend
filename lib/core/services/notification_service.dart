// ========================================================================================
// NOTIFICATION SERVICE - Service pour la gestion des notifications
// ========================================================================================

import 'package:flutter/foundation.dart';
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
        
        // 🔍 LOGS DE DÉBOGAGE : Voir ce que le backend envoie
        if (data.isNotEmpty) {
          debugPrint('📬 Nombre de notifications: ${data.length}');
          debugPrint('📬 Première notification brute: ${data[0]}');
          debugPrint('📬 Champs disponibles: ${(data[0] as Map).keys.toList()}');
        }
        
        return data.map((json) {
          // 🔍 LOG pour chaque notification parsée
          final notification = NotificationResponse.fromJson(json);
          debugPrint('📬 Notification parsée - titre: "${notification.titre}", message: "${notification.message}", message vide: ${notification.message.isEmpty}');
          return notification;
        }).toList();
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
  
  /// Obtenir les notifications de mise à jour (type MISE_A_JOUR)
  Future<List<NotificationResponse>> getNotificationsMiseAJour() async {
    try {
      final allNotifications = await getAllNotifications();
      return allNotifications.where((notif) => notif.isMiseAJour).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des notifications de mise à jour: $e');
    }
  }
  
  /// Obtenir les notifications de mise à jour pour une procédure spécifique
  Future<List<NotificationResponse>> getNotificationsMiseAJourPourProcedure(String procedureId) async {
    try {
      final allNotifications = await getAllNotifications();
      return allNotifications.where((notif) => 
        notif.isMiseAJour && notif.procedureId == procedureId
      ).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des notifications de mise à jour: $e');
    }
  }
  
  /// Obtenir les notifications non lues de type mise à jour
  Future<List<NotificationResponse>> getNotificationsMiseAJourNonLues() async {
    try {
      final allNotifications = await getAllNotifications();
      return allNotifications.where((notif) => 
        notif.isMiseAJour && !notif.lue
      ).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des notifications de mise à jour: $e');
    }
  }
}

// Instance globale du service de notifications
final NotificationService notificationService = NotificationService();

