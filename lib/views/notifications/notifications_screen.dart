// ÉCRAN: NOTIFICATIONS - CENTRE DE NOTIFICATIONS
import 'package:flutter/material.dart';
import '../history/history_screen.dart';
import '../../controllers/report_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    // Notification 1: Mise à jour passeport
                    _buildNotificationCard(
                      context,
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                      title: 'Mise à jour de la procédure de passport',
                      description: 'Le prix du passeport a été révisé à 50 000F CFA à partir du 15 Novembre 2025',
                      time: 'Il y a 2 heures',
                    ),

                    const SizedBox(height: 16),

                    // Notification 2: Nouveau centre
                    _buildNotificationCard(
                      context,
                      icon: Icons.info,
                      iconColor: Colors.blue,
                      title: 'Nouveau centre pour les cartes biométriques',
                      description: 'Un nouveau centre de délivrance des carte biométrique est désormais ouvert à Kalaban Coro',
                      time: 'Il y a 1 jour',
                    ),

                    const SizedBox(height: 16),

                    // Notification 3: Perturbation service
                    _buildNotificationCard(
                      context,
                      icon: Icons.warning,
                      iconColor: Colors.red,
                      title: 'Perturbation de service',
                      description: 'Le service de délivrance des permis de conduire sera temporairement indisponible jusqu\'au 30 Novembre 2025',
                      time: 'Il y a 3 jours',
                    ),

                    const SizedBox(height: 16),
                  ],
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

  Widget _buildNotificationCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String time,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;
    
    return Container(
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
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey.shade400 : Colors.grey[600],
                        height: 1.4,
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
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey.shade500 : Colors.grey[500],
                ),
              ),
              const Spacer(),
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
    );
  }
}