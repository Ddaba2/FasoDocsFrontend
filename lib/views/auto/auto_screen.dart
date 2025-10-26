// ========================================================================================
// AUTO SCREEN - ÉCRAN DES DOCUMENTS AUTO
// ========================================================================================
// Cet écran affiche toutes les procédures liées aux documents automobiles
// disponibles dans l'application FasoDocs. Il permet aux utilisateurs de gérer
// leurs documents de véhicules de manière simplifiée.
//
// Fonctionnalités :
// - Affichage des procédures auto en grille
// - Interface responsive et intuitive
// - Navigation vers les procédures spécialisées
// ========================================================================================

import 'package:flutter/material.dart';
import '../../locale/locale_helper.dart';

/// Écran des documents automobiles
/// 
/// Affiche une grille des différentes procédures liées aux véhicules
/// que les utilisateurs peuvent effectuer selon leurs besoins.
class AutoScreen extends StatelessWidget {
  const AutoScreen({super.key});

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
          LocaleHelper.getText(context, 'autoScreenTitle'),
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
                    // Permis de conduire
                    _buildAutoCard(
                      context: context,
                      icon: Icons.credit_card,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: LocaleHelper.getText(context, 'drivingLicense'),
                    ),
                    // Carte grise
                    _buildAutoCard(
                      context: context,
                      icon: Icons.credit_card,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: LocaleHelper.getText(context, 'vehicleCard'),
                    ),
                    // Visite technique
                    _buildAutoCard(
                      context: context,
                      icon: Icons.build,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: LocaleHelper.getText(context, 'technicalInspection'),
                    ),
                    // Vignette
                    _buildAutoCard(
                      context: context,
                      icon: Icons.label,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: LocaleHelper.getText(context, 'vignette'),
                    ),
                    // Changement de couleur de plaque
                    _buildAutoCard(
                      context: context,
                      icon: Icons.color_lens,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: LocaleHelper.getText(context, 'plateColorChange'),
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

  /// Construit une carte de procédure auto avec icône, couleur et titre
  ///
  /// [icon] : L'icône à afficher
  /// [backgroundColor] : Couleur de fond de l'icône
  /// [iconColor] : Couleur de l'icône
  /// [title] : Titre de la procédure
  Widget _buildAutoCard({
    required BuildContext context,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required String title,
  }) {
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
  }
}