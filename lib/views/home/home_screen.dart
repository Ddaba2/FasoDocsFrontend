// Fichier: home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../locale/locale_helper.dart';
import '../../core/services/procedure_service.dart';
import '../../core/services/category_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/profil_service.dart';
import '../../core/services/photo_service.dart';
import '../../core/config/emoji_to_icon.dart';
import '../../core/config/api_config.dart';
import '../../core/widgets/profile_avatar.dart';
import '../../models/api_models.dart';

// Importations des autres vues (ajustez les chemins selon votre structure)
import '../profile/profile_screen.dart';
import '../notifications/notifications_screen.dart';
import '../history/history_screen.dart';
import '../identity/identity_screen.dart';
import '../category/category_screen.dart';
import '../procedure/procedure_list_screen.dart';
import '../procedure/procedure_detail_screen.dart';
import '../report/report_screen.dart';
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
  List<Widget> get _widgetOptions => const <Widget>[
    // 0. Accueil
    _HomeContent(),

    // 1. Catégorie
    CategoryScreen(),

    // 2. Alerte/Problème
    ReportScreen(),

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
                label: LocaleHelper.getText(context, 'home'),
                index: 0,
                selectedIndex: _selectedIndex,
                activeColor: primaryColor,
                inactiveColor: inactiveColor,
                onTap: () => _onItemTapped(0),
              ),
              // 1: Catégorie
              _buildNavItem(
                icon: Icons.grid_view_outlined,
                label: LocaleHelper.getText(context, 'category'),
                index: 1,
                selectedIndex: _selectedIndex,
                activeColor: primaryColor,
                inactiveColor: inactiveColor,
                onTap: () => _onItemTapped(1),
              ),
              // 2: Alerte
              _buildNavItem(
                icon: Icons.warning_amber_outlined,
                label: LocaleHelper.getText(context, 'alert'),
                index: 2,
                selectedIndex: _selectedIndex,
                activeColor: primaryColor,
                inactiveColor: inactiveColor,
                onTap: () => _onItemTapped(2),
              ),
              // 3: Communiqués
              _buildNavItem(
                icon: Icons.record_voice_over,
                label: LocaleHelper.getText(context, 'announcements'),
                index: 3,
                selectedIndex: _selectedIndex,
                activeColor: primaryColor,
                inactiveColor: inactiveColor,
                onTap: () => _onItemTapped(3),
              ),
              // 4: Options
              _buildNavItem(
                icon: Icons.settings_outlined,
                label: LocaleHelper.getText(context, 'options'),
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

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  // Service d'authentification pour charger le profil
  final AuthService _authService = authService;
  final ProfilService _profilService = profilService;
  
  // Données utilisateur pour afficher la photo de profil
  User? _user;
  bool _isLoadingProfile = true;
  bool _isUploadingPhoto = false;

  final TextEditingController _searchController = TextEditingController();
  List<ProcedureResponse> _allProcedures = [];
  List<ProcedureResponse> _popularProcedures = []; // Procédures populaires depuis l'API
  bool _isLoadingProcedures = false;

  @override
  void initState() {
    super.initState();
    _loadAllProcedures();
    _loadUserProfile();
  }
  
  /// Charge le profil utilisateur pour afficher la photo
  Future<void> _loadUserProfile() async {
    try {
      final user = await _authService.getProfil();
      if (mounted) {
        setState(() {
          _user = user;
          _isLoadingProfile = false;
        });
        debugPrint('✅ Profil chargé dans HomeScreen: ${user.nomComplet}');
        debugPrint('📸 Photo de profil: ${user.photoProfil != null ? "${user.photoProfil!.length} caractères" : "NULL"}');
      }
    } catch (e) {
      debugPrint('❌ Erreur chargement profil dans HomeScreen: $e');
      if (mounted) {
        setState(() {
          _isLoadingProfile = false;
        });
      }
    }
  }
  
  /// Upload immédiat de la photo de profil (comme Test Upload Photo Simple)
  Future<void> _uploadProfilePhoto() async {
    try {
      setState(() => _isUploadingPhoto = true);
      
      // Récupérer le token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null || token.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Token d\'authentification manquant'),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() => _isUploadingPhoto = false);
        return;
      }
      
      // Utiliser le service simple (comme Test Upload Photo Simple)
      // Cette fonction sélectionne l'image et l'upload directement
      await uploadPhotoProfil(token, ApiConfig.baseUrl);
      
      // Recharger le profil pour voir la nouvelle photo
      await _loadUserProfile();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo uploadée avec succès !'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Erreur upload photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploadingPhoto = false);
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Charge toutes les procédures pour les suggestions et les procédures populaires
  /// Les procédures populaires sont sélectionnées de manière cohérente avec les catégories
  Future<void> _loadAllProcedures() async {
    setState(() => _isLoadingProcedures = true);
    try {
      final procedureService = ProcedureService();
      final procedures = await procedureService.getAllProcedures();
      
      // Charger les catégories pour sélectionner les procédures de manière cohérente
      List<ProcedureResponse> popularProcedures = [];
      try {
        final categories = await categoryService.getAllCategories();
        debugPrint('📂 ${categories.length} catégorie(s) chargée(s)');
        
        // Pour chaque catégorie, prendre la première procédure disponible
        for (final category in categories.take(6)) { // Limiter à 6 catégories
          final categoryProcedures = procedures.where((proc) {
            return proc.categorie?.id == category.id;
          }).toList();
          
          if (categoryProcedures.isNotEmpty) {
            // Prendre la première procédure de cette catégorie
            popularProcedures.add(categoryProcedures.first);
            debugPrint('  ✅ Catégorie "${category.titre}": ${categoryProcedures.first.titre}');
          }
        }
        
        // Si on n'a pas assez de procédures (moins de 6 catégories avec procédures),
        // compléter avec les premières procédures restantes
        if (popularProcedures.length < 6) {
          final remainingProcedures = procedures.where((proc) {
            return !popularProcedures.any((p) => p.id == proc.id);
          }).take(6 - popularProcedures.length).toList();
          
          popularProcedures.addAll(remainingProcedures);
          debugPrint('  ➕ ${remainingProcedures.length} procédure(s) supplémentaire(s) ajoutée(s)');
        }
      } catch (e) {
        debugPrint('⚠️ Erreur chargement catégories, utilisation des 6 premières procédures: $e');
        // Fallback: utiliser les 6 premières procédures si le chargement des catégories échoue
        popularProcedures = procedures.take(6).toList();
      }
      
      setState(() {
        _allProcedures = procedures;
        _popularProcedures = popularProcedures;
        _isLoadingProcedures = false;
      });
      debugPrint('✅ ${procedures.length} procédures chargées, ${_popularProcedures.length} affichées comme populaires (cohérentes avec les catégories)');
    } catch (e) {
      setState(() => _isLoadingProcedures = false);
      debugPrint('❌ Erreur chargement procédures pour suggestions: $e');
    }
  }

  /// Filtre les procédures pour les suggestions basées sur la saisie
  Iterable<ProcedureResponse> _getSuggestions(String query) {
    if (query.isEmpty || _isLoadingProcedures) {
      return [];
    }
    
    final queryLower = query.toLowerCase();
    return _allProcedures.where((procedure) {
      final titre = procedure.titre.toLowerCase();
      final description = procedure.description?.toLowerCase() ?? '';
      return titre.contains(queryLower) || description.contains(queryLower);
    }).take(5); // Limiter à 5 suggestions
  }

  // Fonction pour gérer la recherche
  void _performSearch(BuildContext context, String query) async {
    if (query.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un terme de recherche'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Afficher un indicateur de chargement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Appel du service de procédures
      final procedureService = ProcedureService();
      final procedures = await procedureService.searchProcedures(query);
      
      // Fermer le dialog de chargement
      if (context.mounted) Navigator.pop(context);

      if (procedures.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Aucune procédure trouvée pour "$query"'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        // Naviguer vers l'écran des résultats de recherche
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProcedureListScreen(
                procedures: procedures,
                title: 'Résultats de recherche',
              ),
            ),
          );
        }
      }
    } catch (e) {
      // Fermer le dialog de chargement
      if (context.mounted) Navigator.pop(context);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la recherche: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Fonction pour obtenir l'icône et les couleurs selon la procédure
  /// Priorité : 1) Icône de la sous-catégorie, 2) Icône de la catégorie, 3) Mapping par titre, 4) Par défaut
  Map<String, dynamic> _getProcedureStyle(ProcedureResponse procedure) {
    // 1. Essayer d'utiliser l'icône de la sous-catégorie (si disponible)
    if (procedure.sousCategorie?.iconeUrl != null && procedure.sousCategorie!.iconeUrl!.isNotEmpty) {
      return {
        'icon': EmojiToIcon.getIcon(procedure.sousCategorie!.iconeUrl),
        'bgColor': EmojiToIcon.getBackgroundColor(procedure.sousCategorie!.iconeUrl),
        'iconColor': EmojiToIcon.getIconColor(procedure.sousCategorie!.iconeUrl),
      };
    }
    
    // 2. Essayer d'utiliser l'icône de la catégorie (si disponible)
    if (procedure.categorie?.iconeUrl != null && procedure.categorie!.iconeUrl!.isNotEmpty) {
      return {
        'icon': EmojiToIcon.getIcon(procedure.categorie!.iconeUrl),
        'bgColor': EmojiToIcon.getBackgroundColor(procedure.categorie!.iconeUrl),
        'iconColor': EmojiToIcon.getIconColor(procedure.categorie!.iconeUrl),
      };
    }
    
    // 3. Fallback : Mapping basé sur le titre de la procédure
    final titreLower = procedure.titre.toLowerCase();
    
    if (titreLower.contains('certificat') && titreLower.contains('résidence')) {
      return {
        'icon': Icons.description_outlined,
        'bgColor': const Color(0xFFE8F5E8),
        'iconColor': const Color(0xFF4CAF50),
      };
    } else if (titreLower.contains('passeport')) {
      return {
        'icon': Icons.contact_mail_outlined,
        'bgColor': const Color(0xFFFFFDE7),
        'iconColor': const Color(0xFFFFC107),
      };
    } else if (titreLower.contains('acte') && titreLower.contains('naissance')) {
      return {
        'icon': Icons.person_outline,
        'bgColor': const Color(0xFFFFEBEE),
        'iconColor': const Color(0xFFE91E63),
      };
    } else if (titreLower.contains('permis') && titreLower.contains('conduire')) {
      return {
        'icon': Icons.directions_car_outlined,
        'bgColor': const Color(0xFFE8F5E8),
        'iconColor': const Color(0xFF4CAF50),
      };
    } else if (titreLower.contains('carte') && (titreLower.contains('identité') || titreLower.contains('nationale'))) {
      return {
        'icon': Icons.credit_card,
        'bgColor': const Color(0xFFE3F2FD),
        'iconColor': const Color(0xFF2196F3),
      };
    } else if (titreLower.contains('mariage') || titreLower.contains('extrait')) {
      return {
        'icon': Icons.favorite_border,
        'bgColor': const Color(0xFFFBEFF5),
        'iconColor': const Color(0xFFF06292),
      };
    }
    
    // 4. Icône et couleurs par défaut pour les autres procédures
    final defaultColors = [
      {'bgColor': const Color(0xFFE8F5E8), 'iconColor': const Color(0xFF4CAF50)},
      {'bgColor': const Color(0xFFFFFDE7), 'iconColor': const Color(0xFFFFC107)},
      {'bgColor': const Color(0xFFFFEBEE), 'iconColor': const Color(0xFFE91E63)},
      {'bgColor': const Color(0xFFE3F2FD), 'iconColor': const Color(0xFF2196F3)},
      {'bgColor': const Color(0xFFFBEFF5), 'iconColor': const Color(0xFFF06292)},
      {'bgColor': const Color(0xFFF3E5F5), 'iconColor': const Color(0xFF9C27B0)},
    ];
    
    // Utiliser un hash du titre pour sélectionner une couleur de manière cohérente
    final colorIndex = procedure.titre.hashCode.abs() % defaultColors.length;
    final selectedColor = defaultColors[colorIndex];
    
    return {
      'icon': Icons.description_outlined, // Icône par défaut
      'bgColor': selectedColor['bgColor'] as Color,
      'iconColor': selectedColor['iconColor'] as Color,
    };
  }

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
                        'FasoDocs',
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
                      // Photo de profil avec icône caméra pour upload immédiat
                      GestureDetector(
                        onLongPress: () async {
                          // Long press pour uploader une photo
                          await _uploadProfilePhoto();
                        },
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                // Tap pour ouvrir le profil
                                await _loadUserProfile();
                                if (mounted) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                                  ).then((_) {
                                    // Recharger le profil après retour de l'écran de profil
                                    _loadUserProfile();
                                  });
                                }
                              },
                              // Photo de profil avec ProfileAvatar
                              child: _isLoadingProfile || _isUploadingPhoto
                                  ? Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isDarkMode ? (Colors.grey[700] ?? const Color(0xFF333333)) : (Colors.grey[300] ?? const Color(0xFFCCCCCC)),
                                      ),
                                      child: Center(
                                        child: SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              isDarkMode ? Colors.white70 : Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : ProfileAvatar(
                                      photoBase64: _user?.photoProfil,
                                      radius: 16,
                                      backgroundColor: isDarkMode ? (Colors.grey[700] ?? const Color(0xFF333333)) : (Colors.grey[300] ?? const Color(0xFFCCCCCC)),
                                      defaultIcon: Icons.person,
                                      defaultIconSize: 20,
                                    ),
                            ),
                            // Icône caméra en bas à droite de la photo
                            if (!_isLoadingProfile && !_isUploadingPhoto)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () async {
                                    await _uploadProfilePhoto();
                                  },
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 1.5),
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 7,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
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
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
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
                      // Icône historique (trois points)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const HistoryScreen()),
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
          // 2. BARRE DE RECHERCHE AVEC AUTOCOMPLETE
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
                child: Autocomplete<ProcedureResponse>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<ProcedureResponse>.empty();
                    }
                    return _getSuggestions(textEditingValue.text);
                  },
                  displayStringForOption: (ProcedureResponse procedure) => procedure.titre,
                  onSelected: (ProcedureResponse procedure) {
                    // Naviguer directement vers la procédure sélectionnée
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProcedureDetailScreen(procedure: procedure),
                      ),
                    );
                  },
                  fieldViewBuilder: (
                    BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted,
                  ) {
                    // Synchroniser avec le controller existant
                    if (_searchController.text != textEditingController.text) {
                      _searchController.text = textEditingController.text;
                    }
                    
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: LocaleHelper.getText(context, 'searchProcedure'),
                        hintStyle: TextStyle(
                          color: isDarkMode ? (Colors.grey[500] ?? Colors.white54) : (Colors.grey[600] ?? Colors.black54),
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDarkMode ? (Colors.grey[500] ?? Colors.white54) : (Colors.grey[600] ?? Colors.black54),
                          size: 24,
                        ),
                        suffixIcon: textEditingController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: isDarkMode ? (Colors.grey[500] ?? Colors.white54) : (Colors.grey[600] ?? Colors.black54),
                                ),
                                onPressed: () {
                                  textEditingController.clear();
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      textInputAction: TextInputAction.search,
                      onChanged: (value) {
                        _searchController.text = value;
                        setState(() {}); // Pour afficher/cacher le bouton clear
                      },
                      onSubmitted: (query) {
                        _performSearch(context, query);
                      },
                    );
                  },
                  optionsViewBuilder: (
                    BuildContext context,
                    AutocompleteOnSelected<ProcedureResponse> onSelected,
                    Iterable<ProcedureResponse> options,
                  ) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          width: MediaQuery.of(context).size.width - 40, // Largeur de la barre de recherche
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final ProcedureResponse procedure = options.elementAt(index);
                              return InkWell(
                                onTap: () => onSelected(procedure),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.search,
                                        size: 18,
                                        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              procedure.titre,
                                              style: TextStyle(
                                                color: textColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            if (procedure.description != null && procedure.description!.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: Text(
                                                  procedure.description!,
                                                  style: TextStyle(
                                                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
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
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Builder(
                        builder: (context) => Text(
                          LocaleHelper.getText(context, 'welcomeMessage'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Builder(
                        builder: (context) => Text(
                          LocaleHelper.getText(context, 'subtitleMessage'),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
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
                    LocaleHelper.getText(context, 'popularProcedures'),
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

                        SizedBox(width: 4),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ========================================================================
          // 5. CARTES VERTICALES EN GRILLE (Procédures depuis l'API)
          // ========================================================================
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: SliverToBoxAdapter(
              child: _isLoadingProcedures
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _popularProcedures.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              'Aucune procédure disponible',
                              style: TextStyle(
                                color: textColor.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      : Wrap(
                          spacing: 15, // Espace horizontal entre les cartes
                          runSpacing: 15, // Espace vertical entre les lignes
                          children: _popularProcedures.map((procedure) {
                            double cardWidth = (MediaQuery.of(context).size.width - 55) / 2;
                            final style = _getProcedureStyle(procedure); // Passer la procédure complète

                            return SizedBox(
                              width: cardWidth,
                              child: _buildPopularCard(
                                context: context,
                                procedure: procedure,
                                icon: style['icon'] as IconData,
                                backgroundColor: style['bgColor'] as Color,
                                iconColor: style['iconColor'] as Color,
                                title: procedure.titre,
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
    required ProcedureResponse procedure,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required String title,
  }) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = Theme.of(context).cardColor;
    final Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    return GestureDetector(
      onTap: () {
        // Navigation vers la page de détail de la procédure depuis l'API
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProcedureDetailScreen(procedure: procedure),
          ),
        );
      },
      child: Container(
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