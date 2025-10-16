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

/// Écran de création d'entreprise
/// 
/// Affiche une grille des différents types d'entreprises que les utilisateurs
/// peuvent créer selon leurs besoins et la structure juridique souhaitée.
class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});

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
                    'Création d\'entreprise',
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
                    // Entreprise individuel
                    _buildBusinessCard(
                      icon: Icons.person,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Entreprise individuel',
                    ),
                    // Entreprise SARL
                    _buildBusinessCard(
                      icon: Icons.business,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Entreprise SARL',
                    ),
                    // Entreprise unipersonnelle à responsabilité limitée
                    _buildBusinessCard(
                      icon: Icons.business_center,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Entreprise unipersonnelle à responsabilité limitée (EURL, SARL unipersonnelle)',
                    ),
                    // Sociétés Anonymes
                    _buildBusinessCard(
                      icon: Icons.account_balance,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Sociétés Anonymes (SA)',
                    ),
                    // Sociétés en Nom Collectif
                    _buildBusinessCard(
                      icon: Icons.group,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Sociétés en Nom Collectif (SNC)',
                    ),
                    // Sociétés en Commandite Simple
                    _buildBusinessCard(
                      icon: Icons.groups,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Sociétés en Commandite Simple (SCS)',
                    ),
                    // Sociétés par Actions Simplifiées
                    _buildBusinessCard(
                      icon: Icons.trending_up,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Sociétés par Actions Simplifiées (SAS)',
                    ),
                    // Sociétés par Actions Simplifiées Unipersonnelle
                    _buildBusinessCard(
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

  /// Construit une carte de type d'entreprise avec icône, couleur et titre
  /// 
  /// [icon] : L'icône à afficher
  /// [backgroundColor] : Couleur de fond de l'icône
  /// [iconColor] : Couleur de l'icône
  /// [title] : Titre du type d'entreprise
  Widget _buildBusinessCard({
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
