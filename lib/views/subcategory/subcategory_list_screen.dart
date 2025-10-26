// ========================================================================================
// SUBCATEGORY LIST SCREEN - Écran de liste des sous-catégories d'une catégorie
// ========================================================================================

import 'package:flutter/material.dart';
import '../../core/services/category_service.dart';
import '../../core/services/procedure_service.dart';
import '../../models/api_models.dart';
import '../procedure/procedure_list_screen.dart';

class SubcategoryListScreen extends StatefulWidget {
  final String categorieId;
  final String categorieNom;
  final String? categorieEmoji;
  
  const SubcategoryListScreen({
    super.key,
    required this.categorieId,
    required this.categorieNom,
    this.categorieEmoji,
  });

  @override
  State<SubcategoryListScreen> createState() => _SubcategoryListScreenState();
}

class _SubcategoryListScreenState extends State<SubcategoryListScreen> {
  List<SousCategorieResponse> _sousCategories = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _loadSousCategories();
  }
  
  // Charger les sous-catégories depuis l'API
  Future<void> _loadSousCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      print('🔍 Chargement des sous-catégories pour catégorie: ${widget.categorieId}');
      
      // Essayer d'abord de charger les sous-catégories
      try {
        final sousCategories = await categoryService.getSousCategoriesByCategorie(widget.categorieId);
        print('✅ ${sousCategories.length} sous-catégorie(s) reçue(s) du backend');
        
        setState(() {
          _sousCategories = sousCategories;
          _isLoading = false;
        });
      } catch (e) {
        // Si l'endpoint des sous-catégories ne fonctionne pas (StackOverflowError côté backend),
        // charger directement les procédures de cette catégorie
        print('⚠️ Erreur sous-catégories (StackOverflow backend), chargement direct des procédures');
        
        // Afficher un message temporaire
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('⚠️ Affichage direct des procédures (bug backend sur sous-catégories)'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        
        try {
          final procedures = await procedureService.getProceduresByCategorie(widget.categorieId);
          print('✅ ${procedures.length} procédure(s) trouvée(s) directement');
          
          // Naviguer directement vers les procédures
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => ProcedureListScreen(
                  categorieId: widget.categorieId,
                  categorieNom: widget.categorieNom,
                ),
              ),
            );
          }
        } catch (e2) {
          setState(() {
            _errorMessage = 'Impossible de charger les données. Erreur backend: StackOverflowError';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('❌ Erreur finale: $e');
      setState(() {
        _errorMessage = 'Erreur de chargement: $e';
        _isLoading = false;
      });
    }
  }
  
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
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.chevron_left, color: Colors.green),
        ),
        title: Row(
          children: [
            if (widget.categorieEmoji != null) ...[
              Text(
                widget.categorieEmoji!,
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                widget.categorieNom,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _buildContent(),
      ),
    );
  }
  
  Widget _buildContent() {
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
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSousCategories,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }
    
    if (_sousCategories.isEmpty) {
      return const Center(
        child: Text('Aucune sous-catégorie disponible'),
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
        itemCount: _sousCategories.length,
        itemBuilder: (context, index) {
          return _buildSubcategoryCard(_sousCategories[index], index);
        },
      ),
    );
  }
  
  Widget _buildSubcategoryCard(SousCategorieResponse sousCategorie, int index) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final borderColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;
    
    // Couleurs dynamiques selon l'index
    final colors = [
      {'backgroundColor': const Color(0xFFE8F5E8), 'iconColor': const Color(0xFF4CAF50)},
      {'backgroundColor': const Color(0xFFFFF9C4), 'iconColor': const Color(0xFFFFB300)},
      {'backgroundColor': const Color(0xFFFFEBEE), 'iconColor': const Color(0xFFE91E63)},
      {'backgroundColor': const Color(0xFFE3F2FD), 'iconColor': const Color(0xFF2196F3)},
    ];
    final colorIndex = index % colors.length;
    final backgroundColor = colors[colorIndex]['backgroundColor']! as Color;
    final iconColor = colors[colorIndex]['iconColor']! as Color;
    
    // Debug
    print('🔍 Sous-catégorie: ${sousCategorie.nom} - Emoji: ${sousCategorie.iconeUrl}');
    
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        boxShadow: isDarkMode ? null : [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigation vers les procédures de cette sous-catégorie
          print('📋 Clic sur sous-catégorie: ${sousCategorie.nom}');
          // TODO: Naviguer vers les procédures de cette sous-catégorie
        },
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
              child: Center(
                child: Text(
                  sousCategorie.iconeUrl ?? '📋',
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                sousCategorie.nom,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

