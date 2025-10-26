// ========================================================================================
// BUSINESS SCREEN - ÉCRAN DE CRÉATION D'ENTREPRISE
// ========================================================================================
// Cet écran affiche toutes les options de création d'entreprise disponibles
// dans l'application FasoDocs. Il permet aux utilisateurs de choisir le type
// d'entreprise qu'ils souhaitent créer.
//
// Fonctionnalités :
// - Affichage des types d'entreprises en grille
// - Interface responsive et intuitive
// - Navigation vers les procédures spécialisées
// ========================================================================================

import 'package:flutter/material.dart';
import '../../locale/locale_helper.dart';

/// Écran de création d'entreprise
/// 
/// Affiche une grille des différents types d'entreprises que les utilisateurs
/// peuvent créer selon leurs besoins et la structure juridique souhaitée.
class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});

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
          LocaleHelper.getText(context, 'businessScreenTitle'),
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
                    // Entreprise individuel
                    _buildBusinessCard(
                      context: context,
                      icon: Icons.person,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Entreprise individuel',
                    ),
                    // Entreprise SARL
                    _buildBusinessCard(
                      context: context,
                      icon: Icons.business,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Entreprise SARL',
                    ),
                    // Entreprise unipersonnelle à responsabilité limitée
                    _buildBusinessCard(
                      context: context,
                      icon: Icons.business_center,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Entreprise unipersonnelle à responsabilité limitée (EURL, SARL unipersonnelle)',
                    ),
                    // Sociétés Anonymes
                    _buildBusinessCard(
                      context: context,
                      icon: Icons.account_balance,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Sociétés Anonymes (SA)',
                    ),
                    // Sociétés en Nom Collectif
                    _buildBusinessCard(
                      context: context,
                      icon: Icons.group,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Sociétés en Nom Collectif (SNC)',
                    ),
                    // Sociétés en Commandite Simple
                    _buildBusinessCard(
                      context: context,
                      icon: Icons.groups,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Sociétés en Commandite Simple (SCS)',
                    ),
                    // Sociétés par Actions Simplifiées
                    _buildBusinessCard(
                      context: context,
                      icon: Icons.trending_up,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Sociétés par Actions Simplifiées (SAS)',
                    ),
                    // Sociétés par Actions Simplifiées Unipersonnelle
                    _buildBusinessCard(
                      context: context,
                      icon: Icons.trending_flat,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Sociétés par Actions Simplifiées Unipersonnelle (SASU)',
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

  /// Construit une carte de type d'entreprise avec icône, couleur et titre
  ///
  /// [icon] : L'icône à afficher
  /// [backgroundColor] : Couleur de fond de l'icône
  /// [iconColor] : Couleur de l'icône
  /// [title] : Titre du type d'entreprise
  Widget _buildBusinessCard({
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