// ========================================================================================
// CONTRÔLEUR NOTIFICATION - MVC Pattern
// ========================================================================================
// Ce fichier contient la logique métier pour la gestion des notifications
// Il gère les opérations CRUD et la logique de notification
// ========================================================================================

import '../models/notification_model.dart';

class NotificationController {
  static final NotificationController _instance = NotificationController._internal();
  factory NotificationController() => _instance;
  NotificationController._internal();

  // Liste des notifications
  List<NotificationModel> _notifications = [];
  
  // Getters
  List<NotificationModel> get notifications => List.unmodifiable(_notifications);
  List<NotificationModel> get unreadNotifications => _notifications.where((notif) => !notif.isRead).toList();
  List<NotificationModel> get readNotifications => _notifications.where((notif) => notif.isRead).toList();

  // ========================================================================================
  // MÉTHODES DE GESTION DES NOTIFICATIONS
  // ========================================================================================

  /// Charge les notifications de l'utilisateur
  Future<void> loadUserNotifications(String userId) async {
    try {
      // Simulation du chargement depuis une API
      await Future.delayed(const Duration(seconds: 1));
      
      // Données de test
      _notifications = [
        NotificationModel(
          id: 'notif_1',
          title: 'Document approuvé',
          message: 'Votre demande de Carte Nationale d\'Identité a été approuvée.',
          type: NotificationType.success,
          priority: NotificationPriority.high,
          userId: userId,
          documentId: 'doc_1',
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          metadata: {'documentTitle': 'Carte Nationale d\'Identité'},
        ),
        NotificationModel(
          id: 'notif_2',
          title: 'Nouvelle mise à jour',
          message: 'Une nouvelle version de l\'application FasoDocs est disponible.',
          type: NotificationType.system,
          priority: NotificationPriority.medium,
          userId: userId,
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          metadata: {'version': '2.1.0'},
        ),
        NotificationModel(
          id: 'notif_3',
          title: 'Document en cours de traitement',
          message: 'Votre demande de Permis de Conduire est en cours de traitement.',
          type: NotificationType.document,
          priority: NotificationPriority.medium,
          userId: userId,
          documentId: 'doc_2',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          readAt: DateTime.now().subtract(const Duration(hours: 5)),
          metadata: {'documentTitle': 'Permis de Conduire'},
        ),
        NotificationModel(
          id: 'notif_4',
          title: 'Rappel de paiement',
          message: 'N\'oubliez pas de payer les frais pour votre demande de Carte de Résident.',
          type: NotificationType.warning,
          priority: NotificationPriority.high,
          userId: userId,
          documentId: 'doc_3',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          readAt: DateTime.now().subtract(const Duration(days: 1)),
          metadata: {'amount': 5000.0, 'currency': 'FCFA'},
        ),
        NotificationModel(
          id: 'notif_5',
          title: 'Bienvenue sur FasoDocs',
          message: 'Merci d\'avoir rejoint FasoDocs. Commencez vos démarches administratives dès maintenant.',
          type: NotificationType.info,
          priority: NotificationPriority.low,
          userId: userId,
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          readAt: DateTime.now().subtract(const Duration(days: 6)),
        ),
      ];
    } catch (e) {
      print('Erreur lors du chargement des notifications: $e');
    }
  }

  /// Crée une nouvelle notification
  Future<NotificationModel?> createNotification({
    required String title,
    required String message,
    required NotificationType type,
    required NotificationPriority priority,
    required String userId,
    String? documentId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Simulation de la création en base de données
      await Future.delayed(const Duration(milliseconds: 500));

      final newNotification = NotificationModel(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        message: message,
        type: type,
        priority: priority,
        userId: userId,
        documentId: documentId,
        isRead: false,
        createdAt: DateTime.now(),
        metadata: metadata,
      );

      _notifications.insert(0, newNotification); // Ajouter au début de la liste
      return newNotification;
    } catch (e) {
      print('Erreur lors de la création de la notification: $e');
      return null;
    }
  }

  /// Marque une notification comme lue
  Future<bool> markAsRead(String notificationId) async {
    try {
      final index = _notifications.indexWhere((notif) => notif.id == notificationId);
      if (index == -1) return false;

      // Simulation de la mise à jour en base de données
      await Future.delayed(const Duration(milliseconds: 300));

      _notifications[index] = _notifications[index].markAsRead();
      return true;
    } catch (e) {
      print('Erreur lors du marquage de la notification comme lue: $e');
      return false;
    }
  }

  /// Marque toutes les notifications comme lues
  Future<bool> markAllAsRead() async {
    try {
      // Simulation de la mise à jour en base de données
      await Future.delayed(const Duration(milliseconds: 500));

      for (int i = 0; i < _notifications.length; i++) {
        if (!_notifications[i].isRead) {
          _notifications[i] = _notifications[i].markAsRead();
        }
      }
      return true;
    } catch (e) {
      print('Erreur lors du marquage de toutes les notifications comme lues: $e');
      return false;
    }
  }

  /// Supprime une notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      final index = _notifications.indexWhere((notif) => notif.id == notificationId);
      if (index == -1) return false;

      // Simulation de la suppression en base de données
      await Future.delayed(const Duration(milliseconds: 300));

      _notifications.removeAt(index);
      return true;
    } catch (e) {
      print('Erreur lors de la suppression de la notification: $e');
      return false;
    }
  }

  /// Supprime toutes les notifications lues
  Future<bool> deleteAllReadNotifications() async {
    try {
      // Simulation de la suppression en base de données
      await Future.delayed(const Duration(milliseconds: 500));

      _notifications.removeWhere((notif) => notif.isRead);
      return true;
    } catch (e) {
      print('Erreur lors de la suppression des notifications lues: $e');
      return false;
    }
  }

  /// Obtient une notification par son ID
  NotificationModel? getNotificationById(String notificationId) {
    try {
      return _notifications.firstWhere((notif) => notif.id == notificationId);
    } catch (e) {
      return null;
    }
  }

  /// Obtient les notifications par type
  List<NotificationModel> getNotificationsByType(NotificationType type) {
    return _notifications.where((notif) => notif.type == type).toList();
  }

  /// Obtient les notifications par priorité
  List<NotificationModel> getNotificationsByPriority(NotificationPriority priority) {
    return _notifications.where((notif) => notif.priority == priority).toList();
  }

  /// Obtient les notifications liées à un document
  List<NotificationModel> getNotificationsByDocument(String documentId) {
    return _notifications.where((notif) => notif.documentId == documentId).toList();
  }

  // ========================================================================================
  // MÉTHODES DE STATISTIQUES
  // ========================================================================================

  /// Obtient le nombre total de notifications
  int get totalNotifications => _notifications.length;

  /// Obtient le nombre de notifications non lues
  int get unreadCount => unreadNotifications.length;

  /// Obtient le nombre de notifications par type
  Map<NotificationType, int> get notificationsByType {
    Map<NotificationType, int> counts = {};
    for (NotificationType type in NotificationType.values) {
      counts[type] = _notifications.where((notif) => notif.type == type).length;
    }
    return counts;
  }

  /// Obtient le nombre de notifications par priorité
  Map<NotificationPriority, int> get notificationsByPriority {
    Map<NotificationPriority, int> counts = {};
    for (NotificationPriority priority in NotificationPriority.values) {
      counts[priority] = _notifications.where((notif) => notif.priority == priority).length;
    }
    return counts;
  }

  // ========================================================================================
  // MÉTHODES UTILITAIRES
  // ========================================================================================

  /// Obtient les notifications récentes (dernières 24 heures)
  List<NotificationModel> get recentNotifications {
    final oneDayAgo = DateTime.now().subtract(const Duration(hours: 24));
    return _notifications
        .where((notif) => notif.createdAt.isAfter(oneDayAgo))
        .toList();
  }

  /// Obtient les notifications urgentes non lues
  List<NotificationModel> get urgentUnreadNotifications {
    return _notifications
        .where((notif) => !notif.isRead && notif.priority == NotificationPriority.urgent)
        .toList();
  }

  /// Vérifie s'il y a de nouvelles notifications
  bool get hasNewNotifications => unreadCount > 0;

  /// Obtient la notification la plus récente
  NotificationModel? get latestNotification {
    if (_notifications.isEmpty) return null;
    return _notifications.first;
  }

  /// Obtient les notifications triées par priorité et date
  List<NotificationModel> get sortedNotifications {
    final sorted = List<NotificationModel>.from(_notifications);
    sorted.sort((a, b) {
      // Trier d'abord par priorité (urgent en premier)
      final priorityOrder = {
        NotificationPriority.urgent: 0,
        NotificationPriority.high: 1,
        NotificationPriority.medium: 2,
        NotificationPriority.low: 3,
      };
      
      final priorityComparison = priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!);
      if (priorityComparison != 0) return priorityComparison;
      
      // Ensuite par date (plus récent en premier)
      return b.createdAt.compareTo(a.createdAt);
    });
    return sorted;
  }
}
