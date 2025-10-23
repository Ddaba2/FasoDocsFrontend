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
    automaticallyImplyLeading: false,
      centerTitle: true,
    title:  Text(

    'Signalement',

    style: TextStyle(

    fontSize: 20,

    fontWeight: FontWeight.bold,

    color: textColor,

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