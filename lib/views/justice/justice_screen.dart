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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec logo FasoDocs et profil utilisateur
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Logo FasoDocs
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/FasoDocs.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'FasoDocs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Profil utilisateur et notifications
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Stack(
                        children: [
                          const Icon(
                            Icons.notifications_outlined,
                            color: Colors.black,
                            size: 24,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.more_vert,
                        color: Colors.black,
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Titre de la section avec bouton retour
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14B53A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Justice',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

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
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: const Icon(
          Icons.headset_mic,
          color: Colors.black,
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 1),
        boxShadow: [
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
              color: backgroundColor,
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
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
