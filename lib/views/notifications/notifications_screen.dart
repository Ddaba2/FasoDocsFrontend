// ÉCRAN: NOTIFICATIONS - CENTRE DE NOTIFICATIONS
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../history/history_screen.dart';
import '../../controllers/report_controller.dart';
import '../../core/services/notification_service.dart';
import '../../models/api_models.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = notificationService;
  List<NotificationResponse> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  /// Charge les notifications depuis l'API
  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final notifications = await _notificationService.getAllNotifications();
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de chargement: $e';
        _isLoading = false;
      });
      debugPrint('❌ Erreur chargement notifications: $e');
    }
  }

  /// Marque une notification comme lue
  Future<void> _marquerCommeLue(String id) async {
    try {
      await _notificationService.marquerCommeLue(id);
      // Recharger les notifications
      await _loadNotifications();
    } catch (e) {
      debugPrint('❌ Erreur marquage notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.green,

          ),),
        title:  Text(

          'Notification',

          style: TextStyle(

            fontSize: 20,

            fontWeight: FontWeight.bold,

            color: textColor,

          ),

        ),
      ),
      body: SafeArea(
        child: Column(
          children: [


            // Titre de la page avec bouton retour

            const SizedBox(height: 24),

            // Liste des notifications
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _errorMessage!,
                                style: TextStyle(color: textColor),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadNotifications,
                                child: const Text('Réessayer'),
                              ),
                            ],
                          ),
                        )
                      : _notifications.isEmpty
                          ? Center(
                              child: Text(
                                'Aucune notification',
                                style: TextStyle(
                                  color: textColor.withOpacity(0.5),
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadNotifications,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: ListView(
                                  children: [
                                    ..._notifications.map((notification) {
                                      return Column(
                                        children: [
                                          _buildNotificationCard(
                                            context,
                                            notification: notification,
                                            onTap: () => _marquerCommeLue(notification.id),
                                          ),
                                          const SizedBox(height: 16),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ),
            ),

            // Indicateur de navigation en bas
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: textColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Détermine l'icône et la couleur selon le type de notification
  IconData _getNotificationIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'info':
      case 'information':
        return Icons.info;
      case 'warning':
      case 'alerte':
        return Icons.warning;
      case 'success':
      case 'succès':
        return Icons.check_circle;
      case 'error':
      case 'erreur':
        return Icons.error;
      case 'mise_a_jour':
      case 'mise à jour':
        return Icons.update;
      default:
        return Icons.notifications;
    }
  }

  /// Détermine la couleur selon le type de notification
  Color _getNotificationColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'info':
      case 'information':
        return Colors.blue;
      case 'warning':
      case 'alerte':
        return Colors.orange;
      case 'success':
      case 'succès':
        return Colors.green;
      case 'error':
      case 'erreur':
        return Colors.red;
      case 'mise_a_jour':
      case 'mise à jour':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  /// Formate la date en texte relatif (ex: "Il y a 2 heures")
  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return 'Date inconnue';
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'À l\'instant';
    }
  }

  Widget _buildNotificationCard(
    BuildContext context, {
    required NotificationResponse notification,
    VoidCallback? onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;
    
    // Utiliser le type de la notification si disponible
    final icon = _getNotificationIcon(notification.type);
    final iconColor = _getNotificationColor(notification.type);
    final isLue = notification.lue;
    final dateTime = notification.dateCreation;
    final timeText = _formatTime(dateTime);
    final isMiseAJour = notification.isMiseAJour;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? cardColor : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: isDarkMode ? Border.all(color: Colors.grey.shade700, width: 1) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icône de notification
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                // Contenu principal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.titre,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // ✅ Afficher le message s'il n'est pas vide, sinon afficher un message par défaut
                      Text(
                        notification.message.isNotEmpty 
                            ? notification.message 
                            : 'Aucune description disponible',
                        style: TextStyle(
                          fontSize: 14,
                          color: notification.message.isNotEmpty
                              ? (isDarkMode ? Colors.grey.shade400 : Colors.grey[600])
                              : (isDarkMode ? Colors.grey.shade600 : Colors.grey[500]),
                          height: 1.4,
                          fontStyle: notification.message.isEmpty ? FontStyle.italic : FontStyle.normal,
                        ),
                      ),
                      // Afficher les détails des changements pour les notifications de mise à jour
                      if (isMiseAJour && notification.changements != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: iconColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: iconColor.withOpacity(0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Changements :',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: iconColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ...notification.changements!.entries.map((entry) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '• ${entry.key}: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: textColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            entry.value.toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: textColor.withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Bas de la carte avec timestamp et tag
            Row(
              children: [
                Text(
                  timeText,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.grey.shade500 : Colors.grey[500],
                  ),
                ),
                const Spacer(),
                if (!isLue)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Nouveau',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}