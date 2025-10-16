// ========================================================================================
// MODÈLE NOTIFICATION - MVC Pattern
// ========================================================================================
// Ce fichier contient le modèle de données pour les notifications
// Il définit la structure des notifications dans l'application FasoDocs
// ========================================================================================

enum NotificationType {
  info,        // Information générale
  success,     // Succès
  warning,     // Avertissement
  error,       // Erreur
  document,    // Notification liée à un document
  system,      // Notification système
}

enum NotificationPriority {
  low,         // Priorité faible
  medium,      // Priorité moyenne
  high,        // Priorité élevée
  urgent,      // Urgent
}

class NotificationModel {
  final String? id;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final String? userId;
  final String? documentId;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;
  final Map<String, dynamic>? metadata;

  NotificationModel({
    this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    this.userId,
    this.documentId,
    this.isRead = false,
    required this.createdAt,
    this.readAt,
    this.metadata,
  });

  // Méthode pour créer une notification depuis un Map (JSON)
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == 'NotificationType.${map['type']}',
        orElse: () => NotificationType.info,
      ),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.toString() == 'NotificationPriority.${map['priority']}',
        orElse: () => NotificationPriority.medium,
      ),
      userId: map['userId'],
      documentId: map['documentId'],
      isRead: map['isRead'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
      readAt: map['readAt'] != null ? DateTime.parse(map['readAt']) : null,
      metadata: map['metadata'],
    );
  }

  // Méthode pour convertir une notification en Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.toString().split('.').last,
      'priority': priority.toString().split('.').last,
      'userId': userId,
      'documentId': documentId,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  // Méthode pour créer une copie de la notification avec des modifications
  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    NotificationPriority? priority,
    String? userId,
    String? documentId,
    bool? isRead,
    DateTime? createdAt,
    DateTime? readAt,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      userId: userId ?? this.userId,
      documentId: documentId ?? this.documentId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      metadata: metadata ?? this.metadata,
    );
  }

  // Méthode pour marquer la notification comme lue
  NotificationModel markAsRead() {
    return copyWith(
      isRead: true,
      readAt: DateTime.now(),
    );
  }

  // Méthode pour obtenir le type en français
  String get typeInFrench {
    switch (type) {
      case NotificationType.info:
        return 'Information';
      case NotificationType.success:
        return 'Succès';
      case NotificationType.warning:
        return 'Avertissement';
      case NotificationType.error:
        return 'Erreur';
      case NotificationType.document:
        return 'Document';
      case NotificationType.system:
        return 'Système';
    }
  }

  // Méthode pour obtenir la priorité en français
  String get priorityInFrench {
    switch (priority) {
      case NotificationPriority.low:
        return 'Faible';
      case NotificationPriority.medium:
        return 'Moyenne';
      case NotificationPriority.high:
        return 'Élevée';
      case NotificationPriority.urgent:
        return 'Urgente';
    }
  }

  // Méthode pour obtenir la couleur selon le type
  String get colorHex {
    switch (type) {
      case NotificationType.info:
        return '#2196F3'; // Bleu
      case NotificationType.success:
        return '#4CAF50'; // Vert
      case NotificationType.warning:
        return '#FF9800'; // Orange
      case NotificationType.error:
        return '#F44336'; // Rouge
      case NotificationType.document:
        return '#9C27B0'; // Violet
      case NotificationType.system:
        return '#607D8B'; // Bleu-gris
    }
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, type: $type, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel &&
        other.id == id &&
        other.title == title &&
        other.type == type &&
        other.isRead == isRead;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        type.hashCode ^
        isRead.hashCode;
  }
}
