import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';
import '../notifications/notifications_screen.dart';
import '../history/history_screen.dart';
import '../identity/identity_screen.dart';
import '../category/category_screen.dart'; // Import pour la navigation
import '../report/report_problem_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Liste des démarches populaires pour l'affichage en grille
  final List<Map<String, dynamic>> popularSteps = const [
    {
      'title': 'Certificat de residence',
      'icon': Icons.description_outlined,
      'bgColor': Color(0xFFE8F5E8),
      'iconColor': Color(0xFF4CAF50),
    },
    {
      'title': 'Passeport',
      'icon': Icons.contact_mail_outlined,
      'bgColor': Color(0xFFFFFDE7),
      'iconColor': Color(0xFFFFC107),
    },
    {
      'title': 'Acte de naissance',
      'icon': Icons.person_outline,
      'bgColor': Color(0xFFFFEBEE),
      'iconColor': Color(0xFFE91E63),
    },
    {
      'title': 'Permis de conduire',
      'icon': Icons.directions_car_outlined,
      'bgColor': Color(0xFFE8F5E8),
      'iconColor': Color(0xFF4CAF50),
    },
    {
      'title': 'Carte Nationale d\'Identité',
      'icon': Icons.credit_card,
      'bgColor': Color(0xFFE3F2FD),
      'iconColor': Color(0xFF2196F3),
    },
    {
      'title': 'Extrait de mariage',
      'icon': Icons.favorite_border,
      'bgColor': Color(0xFFFBEFF5),
      'iconColor': Color(0xFFF06292),
    },
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF14B53A);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // CustomScrollView assure que toute la page est scrollable
        child: CustomScrollView(
          slivers: [
            // ========================================================================
            // 1. HEADER (Logo, Profil, Notifications, Options)
            // ========================================================================
            SliverAppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              floating: true,
              pinned: false,
              toolbarHeight: 70,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo FasoDocs
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/FasoDocs 1.png',
                          width: 32,
                          height: 32,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'FacoDocs',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    // Profil utilisateur et notifications
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const ProfileScreen()),
                            );
                          },
                          // Icône de profil
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                            ),
                            child: const Icon(
                              Icons.person, // Icône demandée
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Notifications avec badge rouge
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                            );
                          },
                          child: Stack(
                            children: [
                              const Icon(
                                Icons.notifications_none,
                                color: Colors.black,
                                size: 28,
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Icône d'options (trois points)
                        // Note: Vous devriez ajouter un onTap ici pour un menu d'options
                        const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                          size: 28,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ========================================================================
            // 2. BARRE DE RECHERCHE (Active)
            // ========================================================================
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: const TextField( // Rendu actif
                    decoration: InputDecoration(
                      hintText: 'Rechercher une procedure',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.grey, size: 24),
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    enabled: true,
                    readOnly: false,
                  ),
                ),
              ),
            ),

            // ========================================================================
            // 3. BANNIÈRE PRINCIPALE
            // ========================================================================
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                height: MediaQuery.of(context).size.height * 0.28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // Assurez-vous que 'assets/images/Acceuil.png' est correct et existe
                  //
                  // J'utilise le nom de fichier que vous avez mentionné dans le contexte
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
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Bienvenue sur FasoDocs',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
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
            ),

            // ========================================================================
            // 4. SECTION DÉMARCHES POPULAIRES (Titre et Tout voir)
            // ========================================================================
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    // CHANGEMENT ICI : NAVIGUE VERS CATEGORYSCREEN
                    GestureDetector(
                      onTap: () {
                        // Navigue vers l'écran qui liste toutes les catégories
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CategoryScreen()),
                        );
                      },
                      child: const Row(
                        children: [
                          Text(
                            'Tout voir',
                            style: TextStyle(
                              fontSize: 14,
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ========================================================================
            // 5. CARTES VERTICALES EN GRILLE
            // ========================================================================
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              sliver: SliverToBoxAdapter(
                child: Wrap(
                  spacing: 15, // Espace horizontal entre les cartes
                  runSpacing: 15, // Espace vertical entre les lignes
                  children: popularSteps.map((step) {
                    // Calcule la largeur pour 2 colonnes : (Largeur de l'écran - Marges totales / 2)
                    double cardWidth = (MediaQuery.of(context).size.width - 55) / 2;
                    return SizedBox(
                      width: cardWidth,
                      child: _buildPopularCard(
                        icon: step['icon'],
                        backgroundColor: step['bgColor'],
                        iconColor: step['iconColor'],
                        title: step['title'],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Ajouter un espace pour le BottomNavigationBar
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),

      // ========================================================================
      // BOUTON FLOTTANT D'ASSISTANCE (L'icône du casque)
      // ========================================================================
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 75, right: 0),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.headset_mic_outlined,
            color: Colors.black,
            size: 24,
          ),
        ),
      ),

      // ========================================================================
      // BARRE DE NAVIGATION INFÉRIEURE (BottomNavigationBar)
      // ========================================================================
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                label: 'Accueil',
                isActive: true,
                activeColor: primaryColor,
              ),
              _buildNavItem(
                icon: Icons.grid_view_outlined,
                label: 'Catégorie',
                isActive: false,
                activeColor: primaryColor,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CategoryScreen()),
                  );
                },
              ),
              _buildNavItem(
                icon: Icons.warning_amber_outlined,
                label: 'Alerte',
                isActive: false,
                activeColor: primaryColor,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ReportProblemScreen()),
                  );
                },
              ),
              _buildNavItem(
                icon: Icons.campaign_outlined,
                label: 'Communiqués',
                isActive: false,
                activeColor: primaryColor,
                onTap: () { /* Action pour Communiqués */ },
              ),
              _buildNavItem(
                icon: Icons.settings_outlined,
                label: 'Options',
                isActive: false,
                activeColor: primaryColor,
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
    );
  }

  // Fonction pour construire une carte populaire (format carré/icône)
  Widget _buildPopularCard({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required String title,
  }) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 24,
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
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour construire un élément de la barre de navigation
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color activeColor,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isActive ? activeColor.withOpacity(0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(19),
              ),
              child: Icon(
                icon,
                color: isActive ? activeColor : Colors.black,
                size: 24,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? activeColor : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}