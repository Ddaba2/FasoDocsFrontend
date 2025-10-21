// Fichier: home_screen.dart







import 'package:flutter/material.dart';







// Import du ThemeModeProvider (CHEMIN RELATIF pour la compatibilité)



import '../../main.dart';











// Importations des vues



import '../profile/profile_screen.dart';



import '../notifications/notifications_screen.dart';



import '../history/history_screen.dart';



import '../identity/identity_screen.dart';



import '../category/category_screen.dart';



// Changement d'importation : Ajout de ReportScreen



import '../report/report_problem_screen.dart';



import '../report/report_screen.dart'; // <--- NOUVEL IMPORT : La page de liste



import '../settings/settings_screen.dart';



import '../communiquee_global/com_global.dart';











// Conversion en StatefulWidget pour gérer la sélection de la BottomNavigationBar



class HomeScreen extends StatefulWidget {



  const HomeScreen({super.key});







  @override



  State<HomeScreen> createState() => _HomeScreenState();



}







class _HomeScreenState extends State<HomeScreen> {



// Index de l'onglet actuellement sélectionné.



  int _selectedIndex = 0;







// Liste des écrans correspondant à la BottomNavigationBar



  final List<Widget> _widgetOptions = const <Widget>[



// 0. Accueil



    _HomeContent(),







// 1. Catégorie



    CategoryScreen(),







// 2. Alerte/Problème (DOIT MAINTENANT POINTER VERS LA PAGE DE LISTE)



    ReportScreen(), // <--- CORRECTION APPLIQUÉE ICI : Utilise ReportScreen (Liste)







// 3. Communiqués



    ComGlobalScreen(),







// 4. Options/Paramètres



    SettingsScreen(),



  ];







  void _onItemTapped(int index) {



    setState(() {



      _selectedIndex = index;



    });



  }







  @override



  Widget build(BuildContext context) {



    const Color primaryColor = Color(0xFF14B53A); // Couleur d'accentuation fixe







// Récupération dynamique des couleurs du thème



    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;



    final Color navBarColor = Theme.of(context).cardColor;



    final Color defaultIconColor = Theme.of(context).iconTheme.color!;



    final Color inactiveColor = defaultIconColor;







    final Widget currentBody = _widgetOptions.elementAt(_selectedIndex);







    return Scaffold(



// Utilisation du scaffoldBackgroundColor dynamique



      backgroundColor: Theme.of(context).scaffoldBackgroundColor,







// Le corps change en fonction de l'onglet sélectionné



      body: currentBody,







// Le Bouton Flottant (Affiché uniquement sur l'écran d'Accueil)



      floatingActionButton: _selectedIndex == 0 ? Padding(



        padding: const EdgeInsets.only(bottom: 75, right: 0),



        child: Container(



          width: 50,



          height: 50,



          decoration: BoxDecoration(



            color: navBarColor,



            shape: BoxShape.circle,



            border: Border.all(color: defaultIconColor, width: 1),



            boxShadow: [



              BoxShadow(



                color: Colors.grey.withOpacity(isDarkMode ? 0.8 : 0.5),



                spreadRadius: 1,



                blurRadius: 5,



                offset: const Offset(0, 3),



              ),



            ],



          ),



          child: Icon(



            Icons.headset_mic_outlined,



            color: defaultIconColor,



            size: 24,



          ),



        ),



      ) : null, // Cache le bouton sur les autres pages







// Bottom Navigation Bar



      bottomNavigationBar: Container(



        decoration: BoxDecoration(



          color: navBarColor,



          border: Border(



            top: BorderSide(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300, width: 0.5),



          ),



        ),



        child: Padding(



          padding: const EdgeInsets.symmetric(vertical: 8),



          child: Row(



            mainAxisAlignment: MainAxisAlignment.spaceAround,



            children: [



// 0: Accueil



              _buildNavItem(



                icon: Icons.home_outlined,



                label: 'Accueil',



                index: 0,



                selectedIndex: _selectedIndex,



                activeColor: primaryColor,



                inactiveColor: inactiveColor,



                onTap: () => _onItemTapped(0),



              ),



// 1: Catégorie



              _buildNavItem(



                icon: Icons.grid_view_outlined,



                label: 'Catégorie',



                index: 1,



                selectedIndex: _selectedIndex,



                activeColor: primaryColor,



                inactiveColor: inactiveColor,



                onTap: () => _onItemTapped(1),



              ),



// 2: Alerte



              _buildNavItem(



                icon: Icons.warning_amber_outlined,



                label: 'Alerte',



                index: 2,



                selectedIndex: _selectedIndex,



                activeColor: primaryColor,



                inactiveColor: inactiveColor,



                onTap: () => _onItemTapped(2),



              ),



// 3: Communiqués



              _buildNavItem(



                icon: Icons.public,



                label: 'Communiqués',



                index: 3,



                selectedIndex: _selectedIndex,



                activeColor: primaryColor,



                inactiveColor: inactiveColor,



                onTap: () => _onItemTapped(3),



              ),



// 4: Options



              _buildNavItem(



                icon: Icons.settings_outlined,



                label: 'Options',



                index: 4,



                selectedIndex: _selectedIndex,



                activeColor: primaryColor,



                inactiveColor: inactiveColor,



                onTap: () => _onItemTapped(4),



              ),



            ],



          ),



        ),



      ),



    );



  }



}











// ==============================================================================



// WIDGET SÉPARÉ POUR LE CONTENU D'ACCUEIL ORIGINAL (Sensible au thème)



// ==============================================================================







class _HomeContent extends StatelessWidget {



  const _HomeContent();







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



    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;



    final Color cardColor = Theme.of(context).cardColor;



    final Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;



    final Color iconColor = Theme.of(context).iconTheme.color!;











    return SafeArea(



      child: CustomScrollView(



        slivers: [



// ========================================================================



// 1. HEADER (Logo, Profil, Notifications, Options)



// ========================================================================



          SliverAppBar(



            backgroundColor: Theme.of(context).scaffoldBackgroundColor,



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



                      Text(



                        'FacoDocs',



                        style: TextStyle(



                          fontSize: 18,



                          fontWeight: FontWeight.bold,



                          color: textColor,



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



// Utilisation d'un secours non-nullable pour Colors.grey[xxx]



                            color: isDarkMode ? (Colors.grey[700] ?? const Color(0xFF333333)) : (Colors.grey[300] ?? const Color(0xFFCCCCCC)),



                          ),



                          child: Icon(



                            Icons.person,



                            color: isDarkMode ? (Colors.grey[400] ?? Colors.white70) : (Colors.grey[600] ?? Colors.black54),



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



                            Icon(



                              Icons.notifications_none,



                              color: iconColor,



                              size: 28,



                            ),



                            Positioned(



                              right: 0,



                              top: 0,



// Rendu constant pour l'optimisation



                              child: const SizedBox(



                                width: 10,



                                height: 10,



                                child: const DecoratedBox(



                                  decoration: const BoxDecoration(



                                    color: Colors.red,



                                    shape: BoxShape.circle,



                                  ),



                                ),



                              ),



                            ),



                          ],



                        ),



                      ),



                      const SizedBox(width: 12),



// Icône d'options (trois points)



                      GestureDetector(



                        onTap: () {



                          Navigator.of(context).push(



                            MaterialPageRoute(builder: (_) => const SettingsScreen()),



                          );



                        },



                        child: Icon(



                          Icons.more_vert,



                          color: iconColor,



                          size: 28,



                        ),



                      ),



                    ],



                  ),



                ],



              ),



            ),



          ),







// ========================================================================



// 2. BARRE DE RECHERCHE



// ========================================================================



          SliverToBoxAdapter(



            child: Padding(



              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),



              child: Container(



                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),



                decoration: BoxDecoration(



                  color: cardColor,



                  borderRadius: BorderRadius.circular(10),



                  border: Border.all(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300, width: 1),



                ),



                child: TextField(



                  style: TextStyle(color: textColor),



                  decoration: InputDecoration(



                    hintText: 'Rechercher une procedure',



// Utilisation d'un secours non-nullable pour Colors.grey[xxx]



                    hintStyle: TextStyle(color: isDarkMode ? (Colors.grey[500] ?? Colors.white54) : (Colors.grey[600] ?? Colors.black54), fontSize: 16),



                    border: InputBorder.none,



                    prefixIcon: Icon(Icons.search, color: isDarkMode ? (Colors.grey[500] ?? Colors.white54) : (Colors.grey[600] ?? Colors.black54), size: 24),



                    contentPadding: const EdgeInsets.symmetric(vertical: 12),



                  ),



                  enabled: true,



                  readOnly: false,



                ),



              ),



            ),



          ),







// ========================================================================



// 3. BANNIÈRE PRINCIPALE (Image fixe, mais texte dynamique)



// ========================================================================



          SliverToBoxAdapter(



            child: Container(



              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),



              height: MediaQuery.of(context).size.height * 0.28,



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



                  Text(



                    'Démarches Populaires',



                    style: TextStyle(



                      fontSize: 18,



                      fontWeight: FontWeight.bold,



                      color: textColor,



                    ),



                  ),



                  const Spacer(),



                  GestureDetector(



                    onTap: () {



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



                  double cardWidth = (MediaQuery.of(context).size.width - 55) / 2;



                  return SizedBox(



                    width: cardWidth,



                    child: _buildPopularCard(



                      context: context,



                      icon: step['icon'] as IconData, // Sûr après vérification du type



                      backgroundColor: step['bgColor'] as Color, // Sûr



                      iconColor: step['iconColor'] as Color, // Sûr



                      title: step['title'] as String, // Sûr



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



    );



  }







// Fonction pour construire une carte populaire (format carré/icône)



  Widget _buildPopularCard({



    required BuildContext context,



    required IconData icon,



    required Color backgroundColor,



    required Color iconColor,



    required String title,



  }) {



    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;



    final Color cardColor = Theme.of(context).cardColor;



    final Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;







    return Container(



      height: 120,



      decoration: BoxDecoration(



        color: cardColor,



        borderRadius: BorderRadius.circular(12),



        border: Border.all(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300, width: 1),



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



              style: TextStyle(



                fontSize: 12,



                fontWeight: FontWeight.w500,



                color: textColor,



              ),



              maxLines: 2,



              overflow: TextOverflow.ellipsis,



            ),



          ),



        ],



      ),



    );



  }



}











// ==============================================================================



// FONCTION DE CONSTRUCTION D'UN ÉLÉMENT DE NAVIGATION



// ==============================================================================







Widget _buildNavItem({



  required IconData icon,



  required String label,



  required int index,



  required int selectedIndex,



  required Color activeColor,



  required Color inactiveColor,



  VoidCallback? onTap,



}) {



  bool isActive = index == selectedIndex;



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



              color: isActive ? activeColor : inactiveColor,



              size: 24,



            ),



          ),



          const SizedBox(height: 2),



          Text(



            label,



            style: TextStyle(



              fontSize: 10,



              color: isActive ? activeColor : inactiveColor,



              fontWeight: FontWeight.w500,



            ),



          ),



        ],



      ),



    ),



  );



} 