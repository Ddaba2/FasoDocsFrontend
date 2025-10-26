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
import '../../locale/locale_helper.dart';
import '../../core/services/category_service.dart';
import '../../core/services/procedure_service.dart';
import '../../models/api_models.dart';
import '../procedure/procedure_list_screen.dart';
import '../subcategory/subcategory_list_screen.dart';
import '../../core/config/category_mapping.dart';
import '../../core/config/emoji_to_icon.dart';

/// Écran des catégories de démarches administratives

class CategoryScreen extends StatefulWidget {

  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // Définition de la couleur principale (Vert) de l'application
  final Color primaryColor = const Color(0xFF14B53A);
  
  // Liste des catégories récupérées du backend
  List<CategorieResponse> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _loadCategories();
  }
  
  // Charger les catégories depuis l'API
  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      print('🔍 Chargement des catégories depuis l\'API...');
      final categories = await categoryService.getAllCategories();
      print('✅ ${categories.length} catégorie(s) chargée(s) depuis la base de données');
      
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Erreur lors du chargement des catégories: $e');
      setState(() {
        _errorMessage = 'Impossible de charger les catégories depuis le serveur. Vérifiez que votre backend Spring Boot est en cours d\'exécution.';
        _isLoading = false;
      });
    }
  }



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

      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title:  Text(

          LocaleHelper.getText(context, 'categories'),

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

// Header avec logo FasoDocs et profil utilisateur





// Grille des catégories

            Expanded(

              child: _buildCategoryContent(),

            ),

          ],

        ),

      ),

// Bouton flottant de support

      floatingActionButton: Container(

        width: 50,

        height: 50,

        decoration: BoxDecoration(

          color: cardColor,

          shape: BoxShape.circle,

          border: Border.all(color: iconColor, width: 1),
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

          Icons.support_agent,

          color: iconColor,

          size: 24,

        ),

      ),

    );

  }
  
  /// Construit le contenu des catégories (chargement, erreur ou liste)
  Widget _buildCategoryContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCategories,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }
    
    if (_categories.isEmpty) {
      return const Center(
        child: Text('Aucune catégorie disponible'),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          
          // Utiliser les couleurs et icônes basées sur l'emoji du backend
          final IconData icon = EmojiToIcon.getIcon(category.iconeUrl);
          final Color backgroundColor = EmojiToIcon.getBackgroundColor(category.iconeUrl);
          final Color iconColor = EmojiToIcon.getIconColor(category.iconeUrl);
          
          print('📦 Catégorie ${index + 1}: ${category.titre} - Emoji: ${category.iconeUrl}');
          
          return _buildCategoryCard(
            context: context,
            icon: icon,
            backgroundColor: backgroundColor,
            iconColor: iconColor,
            title: category.titre, // Utiliser titre au lieu de nom
            emoji: category.iconeUrl, // Passer l'emoji du backend
            onTap: () => _onCategoryTap(category),
          );
        },
      ),
    );
  }
  
  /// Détermine les couleurs selon la catégorie et l'index
  Map<String, Color> _getCategoryColors(String categoryName, int index) {
    return CategoryMapping.getColors(categoryName, index);
  }
  
  /// Détermine l'icône selon le nom exact de la catégorie
  IconData _getCategoryIcon(String categoryName) {
    return CategoryMapping.getIcon(categoryName);
  }
  
  /// Gère le tap sur une catégorie
  void _onCategoryTap(CategorieResponse category) {
    // Charger les sous-catégories de cette catégorie
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SubcategoryListScreen(
          categorieId: category.id,
          categorieNom: category.titre,
          categorieEmoji: category.iconeUrl,
        ),
      ),
    );
  }



  /// Construit une carte de catégorie avec emoji, couleur et titre

  Widget _buildCategoryCard({

    required BuildContext context,

    required IconData icon, // Gardé pour compatibilité mais pas utilisé

    required Color backgroundColor,

    required Color iconColor,

    required String title,
    
    String? emoji, // Nouvel argument pour l'emoji

    VoidCallback? onTap,

  }) {

// Récupération des couleurs du thème

    final Color cardColor = Theme.of(context).cardColor;

    final Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;



// Définition de la couleur de bordure de la carte

    final Color borderColor = isDarkMode

        ? Colors.grey.shade700

        : (Colors.grey[300] ?? const Color(0xFFCCCCCC));



    return GestureDetector(

      onTap: onTap,

      child: Container(

        decoration: BoxDecoration(

          color: cardColor,

          borderRadius: BorderRadius.circular(12),

// Bordure dynamique

          border: Border.all(color: borderColor, width: 1),
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

              width: 60,

              height: 60,

              decoration: BoxDecoration(

                color: isDarkMode ? backgroundColor.withOpacity(0.2) : backgroundColor,

                borderRadius: BorderRadius.circular(30),

              ),

              child: Center(

                child: Text(

                  emoji ?? '📋', // Afficher l'emoji ou un emoji par défaut

                  style: TextStyle(

                    fontSize: 30,

                    color: iconColor,

                  ),

                ),

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