// ========================================================================================
// JUSTICE SCREEN - ÉCRAN DE JUSTICE
// ========================================================================================
// Cet écran affiche toutes les procédures liées à la justice
// disponibles dans l'application FasoDocs. Il permet aux utilisateurs de gérer
// leurs affaires judiciaires de manière simplifiée.
//
// Fonctionnalités :
// - Affichage des procédures judiciaires en grille
// - Interface responsive et intuitive
// - Navigation vers les procédures spécialisées
// ========================================================================================

import 'package:flutter/material.dart';

/// Écran des procédures judiciaires
/// 
/// Affiche une grille des différentes procédures liées à la justice
/// que les utilisateurs peuvent effectuer selon leurs besoins.
class JusticeScreen extends StatelessWidget {
  const JusticeScreen({super.key});

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
          'Justice',
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
                    // Déclaration de vol
                    _buildJusticeCard(
                      icon: Icons.report,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Déclaration de vol',
                    ),
                    // Déclaration de perte
                    _buildJusticeCard(
                      icon: Icons.search,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Déclaration de perte',
                    ),
                    // Règlement d'un litige
                    _buildJusticeCard(
                      icon: Icons.gavel,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Règlement d\'un litige',
                    ),
                    // Demande de visite d'un prisonnier
                    _buildJusticeCard(
                      icon: Icons.person,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Demande de visite d\'un prisonnier',
                    ),
                    // Demande d'appel d'une décision de jugement
                    _buildJusticeCard(
                      icon: Icons.call_made,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Demande d\'appel d\'une décision de jugement',
                    ),
                    // Demande de libération conditionnelle
                    _buildJusticeCard(
                      icon: Icons.exit_to_app,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Demande de libération conditionnelle',
                    ),
                    // Demande de libération provisoire
                    _buildJusticeCard(
                      icon: Icons.free_breakfast,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Demande de libération provisoire',
                    ),
                    // Autorisation d'achat d'armes et munitions
                    _buildJusticeCard(
                      icon: Icons.security,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Autorisation d\'achat d\'armes et munitions',
                    ),
                    // Autorisation de vente des biens d'un mineur
                    _buildJusticeCard(
                      icon: Icons.child_care,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Autorisation de vente des biens d\'un mineur',
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

  /// Construit une carte de procédure judiciaire avec icône, couleur et titre
  ///
  /// [icon] : L'icône à afficher
  /// [backgroundColor] : Couleur de fond de l'icône
  /// [iconColor] : Couleur de l'icône
  /// [title] : Titre de la procédure
  Widget _buildJusticeCard({
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