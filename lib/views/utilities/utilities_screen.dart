// ========================================================================================
// UTILITIES SCREEN - ÉCRAN EAU ET ÉLECTRICITÉ
// ========================================================================================
// Cet écran affiche toutes les procédures liées aux services d'eau et d'électricité
// disponibles dans l'application FasoDocs. Il permet aux utilisateurs de gérer
// leurs compteurs et services publics de manière simplifiée.
//
// Fonctionnalités :
// - Affichage des procédures utilitaires en grille
// - Interface responsive et intuitive
// - Navigation vers les procédures spécialisées
// ========================================================================================

import 'package:flutter/material.dart';

/// Écran des services d'eau et d'électricité
/// 
/// Affiche une grille des différentes procédures liées aux services publics
/// que les utilisateurs peuvent effectuer selon leurs besoins.
class UtilitiesScreen extends StatelessWidget {
  const UtilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;
    final iconColor = Theme.of(context).iconTheme.color!;
    
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
          ),
        ),
        title: Text(
          'Eau et Électricité',
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
            const SizedBox(height: 20),

            // Grille des sous-catégories
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    // Demande d'un compteur d'eau
                    _buildUtilityCard(
                      icon: Icons.water_drop,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Demande d\'un compteur d\'eau',
                    ),
                    // Demande d'un compteur d'électricité
                    _buildUtilityCard(
                      icon: Icons.flash_on,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Demande d\'un compteur d\'électricité',
                    ),
                    // Récupérer un compteur d'eau suspendue
                    _buildUtilityCard(
                      icon: Icons.water_drop_outlined,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Récupérer un compteur d\'eau suspendue',
                    ),
                    // Récupérer un compteur d'électricité suspendue
                    _buildUtilityCard(
                      icon: Icons.power_off,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Récupérer un compteur d\'électricité suspendue',
                    ),
                    // Demande de transférer d'un compteur d'eau
                    _buildUtilityCard(
                      icon: Icons.swap_horiz,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Demande de transférer d\'un compteur d\'eau',
                    ),
                    // Demande de transférer d'un compteur d'électricité
                    _buildUtilityCard(
                      icon: Icons.swap_vert,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Demande de transférer d\'un compteur d\'électricité',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Bouton flottant de support
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: cardColor,
          shape: BoxShape.circle,
          border: Border.all(color: isDarkMode ? Colors.grey.shade700 : Colors.black, width: 1),
        ),
        child: Icon(
          Icons.headset_mic,
          color: iconColor,
          size: 24,
        ),
      ),
    );
  }

  /// Construit une carte de procédure utilitaire avec icône, couleur et titre
  ///
  /// [icon] : L'icône à afficher
  /// [backgroundColor] : Couleur de fond de l'icône
  /// [iconColor] : Couleur de l'icône
  /// [title] : Titre de la procédure
  Widget _buildUtilityCard({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required String title,
  }) {
    return Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final cardColor = Theme.of(context).cardColor;
        final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
        
        return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDarkMode ? Colors.grey.shade700 : Colors.black, width: 1),
            boxShadow: isDarkMode ? null : [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isDarkMode ? backgroundColor.withOpacity(0.2) : backgroundColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: iconColor,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}