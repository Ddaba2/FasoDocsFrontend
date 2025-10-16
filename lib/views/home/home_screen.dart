// ========================================================================================
// ÉCRAN 5: HOME SCREEN - PAGE D'ACCUEIL PRINCIPALE
// ========================================================================================
// Écran principal de l'application FasoDocs qui contient :
// - Header avec logo FasoDocs, profil utilisateur et notifications
// - Bannière principale avec image et message de bienvenue
// - Section "Démarches Populaires" avec cartes scrollables
// - Barre de navigation inférieure avec 4 onglets principaux
// - Bouton flottant d'assistance client
// ========================================================================================

import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';
import '../notifications/notifications_screen.dart';
import '../history/history_screen.dart';
import '../identity/identity_screen.dart';
import '../category/category_screen.dart';
import '../report/report_problem_screen.dart';
import '../settings/settings_screen.dart';
import '../../controllers/report_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Construit l'interface utilisateur de la page d'accueil
  /// Utilise un design responsive qui s'adapte à différentes tailles d'écran
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Fond blanc pour l'écran d'accueil
      body: SafeArea(  // Zone sûre qui évite les encoches et la barre de statut
        child: Column(
          children: [
            // ========================================================================================
            // HEADER AVEC LOGO FASODOCS ET PROFIL UTILISATEUR
            // ========================================================================================
            // Contient le logo FasoDocs, le nom de l'application, l'avatar utilisateur,
            // l'icône de notifications avec badge, et le menu options
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
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ProfileScreen()),
                          );
                        },
                        child: Container(
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
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                          );
                        },
                        child: Stack(
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
                      ),
                      const SizedBox(width: 12),
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                          size: 24,
                        ),
                        onSelected: (String value) {
                          if (value == 'history') {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const HistoryScreen()),
                            );
                          } else if (value == 'report') {
                            ReportController.showReportDialog(context);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'history',
                            child: Row(
                              children: [
                                Icon(Icons.history, color: Colors.grey),
                                SizedBox(width: 8),
                                Text('Historique'),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'report',
                            child: Row(
                              children: [
                                Icon(Icons.report_problem, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Signaler un problème'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Bannière principale
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/images/Acceuil.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Bienvenue sur FasoDocs',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Vos démarches administratives simplifiées',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Section Démarches Populaires
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Démarches Populaires',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const IdentityScreen(),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Text(
                          'Tout voir',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF14B53A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Color(0xFF14B53A),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Cartes horizontales des démarches populaires
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildPopularCard(
                    icon: Icons.home_outlined,
                    backgroundColor: const Color(0xFFE8F5E8),
                    iconColor: const Color(0xFF4CAF50),
                    title: 'Certificat de residence',
                  ),
                  const SizedBox(width: 12),
                  _buildPopularCard(
                    icon: Icons.credit_card,
                    backgroundColor: const Color(0xFFFFF9C4),
                    iconColor: const Color(0xFFFFB300),
                    title: 'Passeport',
                  ),
                  const SizedBox(width: 12),
                  _buildPopularCard(
                    icon: Icons.person_outline,
                    backgroundColor: const Color(0xFFFFEBEE),
                    iconColor: const Color(0xFFE91E63),
                    title: 'Acte de naissance',
                  ),
                  const SizedBox(width: 12),
                  _buildPopularCard(
                    icon: Icons.directions_car_outlined,
                    backgroundColor: const Color(0xFFE8F5E8),
                    iconColor: const Color(0xFF4CAF50),
                    title: 'Permis de conduire',
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // Barre de navigation inférieure
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, -2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      icon: Icons.home,
                      label: 'Accueil',
                      isActive: true,
                    ),
                    _buildNavItem(
                      icon: Icons.grid_view,
                      label: 'Catégorie',
                      isActive: false,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CategoryScreen(),
                          ),
                        );
                      },
                    ),
                    _buildNavItem(
                      icon: Icons.warning_outlined,
                      label: 'Alerte',
                      isActive: false,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ReportProblemScreen()),
                        );
                      },
                    ),
                    _buildNavItem(
                      icon: Icons.settings_outlined,
                      label: 'Options',
                      isActive: false,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SettingsScreen()),
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
        margin: const EdgeInsets.only(bottom: 80, right: 16),
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.headset_mic,
          color: Colors.black,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildPopularCard({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required String title,
  }) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF14B53A).withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: isActive ? const Color(0xFF14B53A) : Colors.black,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF14B53A) : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}