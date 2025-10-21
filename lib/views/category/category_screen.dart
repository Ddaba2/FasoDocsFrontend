// ========================================================================================

// CATEGORY SCREEN - ÉCRAN DES CATÉGORIES DE DÉMARCHES ADMINISTRATIVES

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

class CategoryScreen extends StatelessWidget {

  const CategoryScreen({super.key});



// Définition de la couleur principale (Vert) de l'application

  final Color primaryColor = const Color(0xFF14B53A);



  @override

  Widget build(BuildContext context) {

// 1. Récupération des couleurs du thème global

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    final Color cardColor = Theme.of(context).cardColor;

// Utilisation de l'opérateur '!' car le color de bodyLarge est garanti non-null par notre ThemeData

    final Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    final Color iconColor = Theme.of(context).iconTheme.color!;



// NOUVELLE SOLUTION : Utiliser des couleurs du ColorScheme ou des couleurs solides

    final Color profileIconBg = isDarkMode

        ? Theme.of(context).colorScheme.surface

        : (Colors.grey[300] ?? const Color(0xFFCCCCCC));



    final Color profileIconColor = isDarkMode ? (Colors.grey[400] ?? Colors.white70) : (Colors.grey[600] ?? Colors.black54);





    return Scaffold(

      backgroundColor: backgroundColor,

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

                        'assets/images/FasoDocs 1.png',

                        width: 40,

                        height: 40,

                      ),

                      const SizedBox(width: 8),

                      Text(

                        'FasoDocs',

                        style: TextStyle(

                          fontSize: 18,

                          fontWeight: FontWeight.bold,

                          color: textColor,

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

                          color: profileIconBg,

                          shape: BoxShape.circle,

                        ),

                        child: Icon(

                          Icons.person,

                          color: profileIconColor,

                          size: 20,

                        ),

                      ),

                      const SizedBox(width: 12),

                      Stack(

                        children: [

                          Icon(

                            Icons.notifications_outlined,

                            color: iconColor,

                            size: 24,

                          ),

                          Positioned( // Constante

                            right: 0,

                            top: 0,

                            child: Container( // <--- CORRIGÉ : const ici

                              width: 16,

                              height: 16,

                              decoration: const BoxDecoration( // et ici

                                color: Colors.red,

                                shape: BoxShape.circle,

                              ),

                              child: const Center( // et ici

                                child: const Text( // et ici

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

                        child: Icon(

                          Icons.more_vert,

                          color: iconColor,

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

// Bouton de retour

                  GestureDetector(

                    onTap: () => Navigator.of(context).pop(),

                    child: Icon(

                      Icons.chevron_left,

                      color: primaryColor,

                      size: 32,

                    ),

                  ),

                  const SizedBox(width: 8),

                  Text(

                    'Catégories',

                    style: TextStyle(

                      fontSize: 20,

                      fontWeight: FontWeight.bold,

                      color: textColor,

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

                      context: context,

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

                      context: context,

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

                      context: context,

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

                      context: context,

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

                      context: context,

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

                      context: context,

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

                      context: context,

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

          color: cardColor,

          shape: BoxShape.circle,

          border: Border.all(color: iconColor, width: 1),

        ),

        child: Icon(

          Icons.headset_mic,

          color: iconColor,

          size: 24,

        ),

      ),

    );

  }



  /// Construit une carte de catégorie avec icône, couleur et titre

  Widget _buildCategoryCard({

    required BuildContext context,

    required IconData icon,

    required Color backgroundColor,

    required Color iconColor,

    required String title,

    VoidCallback? onTap,

  }) {

// Récupération des couleurs du thème

    final Color cardColor = Theme.of(context).cardColor;

    final Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;



// Définition de la couleur de bordure de la carte

    final Color borderColor = isDarkMode

        ? Theme.of(context).colorScheme.surface

        : (Colors.grey[300] ?? const Color(0xFFCCCCCC));



    return GestureDetector(

      onTap: onTap,

      child: Container(

        decoration: BoxDecoration(

          color: cardColor,

          borderRadius: BorderRadius.circular(12),

// Bordure dynamique

          border: Border.all(color: borderColor, width: 1),

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

                style: TextStyle(

                  fontSize: 14,

                  fontWeight: FontWeight.w500,

                  color: textColor,

                ),

              ),

            ),

          ],

        ),

      ),

    );

  }

}