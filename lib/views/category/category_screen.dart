// ========================================================================================
// CATEGORY SCREEN - ÉCRAN DES CATÉGORIES DE DÉMARCHES ADMINISTRATIVES
// ========================================================================================
// Cet écran affiche toutes les catégories de démarches administratives disponibles
// dans l'application FasoDocs. Il permet aux utilisateurs de naviguer vers les
// différentes sections selon leurs besoins.
//
// Fonctionnalités :
// - Affichage des catégories en grille
// - Navigation vers les écrans spécialisés
// - Interface responsive et intuitive
// ========================================================================================

import 'package:flutter/material.dart';
import '../history/history_screen.dart';
import '../identity/identity_screen.dart';
import '../business/business_screen.dart';
import '../auto/auto_screen.dart';
import '../land/land_screen.dart';
import '../utilities/utilities_screen.dart';
import '../justice/justice_screen.dart';
import '../tax/tax_screen.dart';

/// Écran des catégories de démarches administratives
/// 
/// Affiche une grille de catégories permettant aux utilisateurs de naviguer
/// vers les différentes sections de l'application selon leurs besoins.
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

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
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const HistoryScreen()),
                          );
                        },
                        child: const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                          size: 24,
                        ),
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
                    'Catégories',
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

            // Grille des catégories
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    // Identité et citoyenneté
                    _buildCategoryCard(
                      icon: Icons.perm_identity,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Identité et citoyenneté',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const IdentityScreen(),
                          ),
                        );
                      },
                    ),
                    // Création d'entreprise
                    _buildCategoryCard(
                      icon: Icons.business,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Création d\'entreprise',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const BusinessScreen(),
                          ),
                        );
                      },
                    ),
                    // Documents auto
                    _buildCategoryCard(
                      icon: Icons.directions_car,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Documents auto',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AutoScreen(),
                          ),
                        );
                      },
                    ),
                    // Services fonciers
                    _buildCategoryCard(
                      icon: Icons.home,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Services fonciers',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LandScreen(),
                          ),
                        );
                      },
                    ),
                    // Eau et électricité
                    _buildCategoryCard(
                      icon: Icons.flash_on,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Eau et électricité',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const UtilitiesScreen(),
                          ),
                        );
                      },
                    ),
                    // Justice
                    _buildCategoryCard(
                      icon: Icons.balance,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFF424242),
                      title: 'Justice',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const JusticeScreen(),
                          ),
                        );
                      },
                    ),
                    // Impôt et douane
                    _buildCategoryCard(
                      icon: Icons.account_balance,
                      backgroundColor: const Color(0xFFE3F2FD),
                      iconColor: const Color(0xFF2196F3),
                      title: 'Impôt et douane',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const TaxScreen(),
                          ),
                        );
                      },
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

  /// Construit une carte de catégorie avec icône, couleur et titre
  /// 
  /// [icon] : L'icône à afficher
  /// [backgroundColor] : Couleur de fond de l'icône
  /// [iconColor] : Couleur de l'icône
  /// [title] : Titre de la catégorie
  /// [onTap] : Callback appelé lors du tap
  Widget _buildCategoryCard({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required String title,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                icon,
                size: 30,
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
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}