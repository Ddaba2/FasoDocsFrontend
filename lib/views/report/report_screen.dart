import 'package:flutter/material.dart';

// Import du fichier de destination pour la navigation
import 'report_problem_screen.dart'; // ASSUREZ-VOUS QUE LE CHEMIN EST CORRECT

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  // Couleur principale (Verte)
  static const Color primaryColor = Color(0xFF14B53A);

  // Données de démonstration basées sur l'image Signalement.png
  final List<Map<String, String>> reports = const [
    {
      'type': 'Latence du service',
      'description': 'Le service est top lent sous prétexte qu\'il y a pas de réseau j\'ai fais deux(2) d\'attente',
      'time': 'Il y a 2 heures',
      'source': 'EDM kalaban',
    },
    {
      'type': 'Fraude',
      'description': 'On m\'a facturé 20 000F CFA pour une carte biométrique',
      'time': 'Il y a 20 minutes',
      'source': 'Commissariat de l\'ACI 200',
    },
    // Ajoutez plus de signalements ici si nécessaire
  ];

  @override
  Widget build(BuildContext context) {
    // 1. Récupération des couleurs du thème
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Utilise la couleur de fond du thème, qui est blanc en mode clair.
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final Color iconColor = Theme.of(context).iconTheme.color!;
    final Color cardColor = Theme.of(context).cardColor;

    return Scaffold(
      // Le fond du Scaffold est la couleur du thème (blanc par défaut)
      backgroundColor: backgroundColor,
      appBar: _buildCustomAppBar(context, textColor, iconColor),

      // 2. Bouton flottant pour signaler un nouveau problème
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_report_btn',
        onPressed: () {
          // REDIRECTION VERS report_problem_screen.dart
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ReportProblemScreen()),
          );
        },
        backgroundColor: primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        elevation: 4.0, // Ajout de l'élévation pour coller à l'image
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: reports.map((report) {
            return _buildReportCard(
              context,
              report['type']!,
              report['description']!,
              report['time']!,
              report['source']!,
              cardColor,
              textColor,
              isDarkMode,
            );
          }).toList(),
        ),
      ),
    );
  }

  // ===========================================================================
  // WIDGETS DE COMPOSITION
  // ===========================================================================

  PreferredSizeWidget _buildCustomAppBar(
      BuildContext context, Color textColor, Color iconColor) {
    // Le fond de la barre d'application doit être la couleur de fond du Scaffold (blanc dans le mode clair)
    final Color appBarBgColor = Theme.of(context).scaffoldBackgroundColor;

    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: appBarBgColor,
      elevation: 0,
      titleSpacing: 0,
      automaticallyImplyLeading: false,

      title: Padding(
        // Padding adapté pour le contenu de l'AppBar
        padding: const EdgeInsets.only(left: 16.0, right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo FacoDocs avec drapeau du Mali (comme sur l'image)
            Row(
              children: [
                _buildMaliLogo(screenWidth * 0.08),
                const SizedBox(width: 8),
                Text(
                  'FacoDocs',
                  style: TextStyle(
                    color: textColor,
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // Profil, Notification, Menu
            Row(
              children: [
                // Photo de profil (simulée comme sur la photo)
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // Simulateur de la photo de profil
                    color: Colors.grey[300],
                    border: Border.all(color: iconColor.withOpacity(0.3)),
                  ),
                  // Placeholder pour la photo si non disponible
                  child: ClipOval(
                      child: Image.network(
                          'https://picsum.photos/36/36?random=1',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.person, color: Colors.grey[600], size: 20)
                      )
                  ),
                ),
                const SizedBox(width: 10),
                // Icône de notification (avec badge rouge '3')
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications_none, color: iconColor),
                      onPressed: () {},
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      // CORRECTION CLÉ : Le widget interne doit être const si Positioned est const,
                      // mais Positioned lui-même ne peut pas être const si son 'child' ne l'est pas.
                      // Ici on retire le const devant Positioned et on s'assure que le Container est const
                      // ou que ses propriétés le sont.
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        // Ajout du texte '3' dans le badge comme sur la photo
                        child: const Text(
                          '3',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Icône de menu (trois points)
                IconButton(
                  icon: Icon(Icons.more_vert, color: iconColor),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
      // Le grand titre "Signalement" est placé dans un PreferredSize
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Signalement',
              style: TextStyle(
                fontSize: screenWidth * 0.07,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget pour le Logo du Mali (Vert-Jaune-Rouge)
  Widget _buildMaliLogo(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Row(
          children: [
            // Vert
            Container(width: size / 3, color: primaryColor),
            // Jaune
            Container(width: size / 3, color: const Color(0xFFFFD700)),
            // Rouge
            Container(width: size / 3, color: const Color(0xFFDC143C)),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(
      BuildContext context,
      String type,
      String description,
      String time,
      String source,
      Color cardColor,
      Color textColor,
      bool isDarkMode) {

    // Couleurs spécifiques pour le texte de la source
    final sourceColor = isDarkMode ? primaryColor.withOpacity(0.8) : primaryColor;
    final timeColor = isDarkMode ? Colors.grey[400] : (Colors.grey[600] ?? Colors.black54);
    // Les cartes sont blanches dans l'image (légèrement ombragées)
    final cardBgColor = isDarkMode ? cardColor : Colors.white;
    final shadowColor = isDarkMode ? Colors.black.withOpacity(0.5) : Colors.grey.withOpacity(0.15);
    final borderColor = isDarkMode ? (Colors.grey[700] ?? const Color(0xFF333333)) : Colors.black12;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: textColor.withOpacity(0.8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 13,
                  color: timeColor,
                ),
              ),
              Text(
                source,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: sourceColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}