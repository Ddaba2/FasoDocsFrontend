// ========================================================================================
// SUBCATEGORY LIST SCREEN - Écran de liste des sous-catégories d'une catégorie
// ========================================================================================

import 'package:flutter/material.dart';
import '../../core/services/category_service.dart';
import '../../core/services/procedure_service.dart';
import '../../models/api_models.dart';
import '../procedure/procedure_list_screen.dart';
import '../procedure/procedure_detail_screen.dart';

class SubcategoryListScreen extends StatefulWidget {
  final String categorieId;
  final String categorieNom;
  final String? categorieEmoji;
  final CategorieResponse? category;
  
  const SubcategoryListScreen({
    super.key,
    required this.categorieId,
    required this.categorieNom,
    this.categorieEmoji,
    this.category,
  });

  @override
  State<SubcategoryListScreen> createState() => _SubcategoryListScreenState();
}

class _SubcategoryListScreenState extends State<SubcategoryListScreen> {
  List<SousCategorieResponse> _sousCategories = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  // Override d'ID pour certaines sous-catégories lorsque l'API renvoie des IDs inconsistants
  // Clés et valeurs sont comparées sur des noms canonicalisés
  final Map<String, String> _sousCategorieNameToIdOverride = const {
    'carte nationale d\'identite biometrigue': '7',
    'carte nationale d\'identite biometriguee': '7',
    'carte nationale d\'identite biometrieque': '7',
    'carte nationale d\'identite biometrque': '7',
    'carte nationale d\'identite biometr ique': '7',
    'carte nationale d\'identite biometr iquee': '7',
    'demande de liberation conditionnelle': '54',
    'entreprise individuelle': '15',
    'entreprise sarl': '16',
    'fiche individuelle': '8',
    'logements sociaux': '35',
    'passeport malien': '9',
    'permis de construire a usage industriel': '33',
    'permis de construire a usage personnel': '32',
    'reglement d\'un litige': '51',
    'societes anonymes (sa)': '18',
    'societes en nom collectif (snc)': '19',
    'societes par actions simplifiees (sas)': '21',
    'taxe sur l\'acces au reseau des telecommunications ouvert au public (tartop)': '83',
    'verification des titres de proprietes': '37',
  };
  
  @override
  void initState() {
    super.initState();
    _loadSousCategories();
  }
  
  /// Charger les sous-catégories depuis l'API
  Future<void> _loadSousCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('🔍 Chargement des sous-catégories pour catégorie: ${widget.categorieId}');
      
      // Vérifier si la catégorie contient déjà les sous-catégories
      // (cas où elles sont incluses dans la réponse de l'API des catégories)
      if (widget.category != null && widget.category!.sousCategories.isNotEmpty) {
        print('✅ Utilisation des sous-catégories déjà chargées (${widget.category!.sousCategories.length})');
        setState(() {
          _sousCategories = widget.category!.sousCategories;
          _isLoading = false;
        });
        return;
      }
      
      // Sinon, charger depuis l'API
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
          childAspectRatio: 0.9,
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
        onTap: () async {
          print('📋 Clic sur sous-catégorie: ${sousCategorie.nom} (ID: ${sousCategorie.id})');
          
          try {
            // Charger les procédures de cette sous-catégorie
            print('🔍 Appel API: GET /procedures/sous-categorie/${sousCategorie.id}');
            final procedures = await procedureService.getProceduresBySousCategorie(sousCategorie.id);
            print('✅ ${procedures.length} procédure(s) trouvée(s) pour cette sous-catégorie');
            
            // Debug: afficher les détails des procédures
            if (procedures.isNotEmpty) {
              for (var proc in procedures) {
                print('  - ${proc.nom} (ID: ${proc.id}, Sous-cat: ${proc.sousCategorie?.nom ?? "null"})');
                print('    Références légales: ${proc.referencesLegales?.length ?? 0}');
              }
            }
            
            // Si aucune procédure, essayer un override d'ID basé sur le nom
            if (procedures.isEmpty) {
              final canonicalName = _canonicalizeName(sousCategorie.nom);
              final overrideId = _sousCategorieNameToIdOverride[canonicalName];
              if (overrideId != null && overrideId.toString() != sousCategorie.id.toString()) {
                print('🔁 Aucun résultat avec ID ${sousCategorie.id}. Tentative avec override ID=$overrideId pour "$canonicalName"');
                try {
                  final altProcedures = await procedureService.getProceduresBySousCategorie(overrideId);
                  print('✅ ${altProcedures.length} procédure(s) trouvée(s) via override ID');
                  if (altProcedures.isNotEmpty) {
                    _navigateToProcedures(altProcedures, sousCategorie.nom);
                    return;
                  }
                } catch (e) {
                  print('❌ Échec override ID: $e');
                }
              }

              // Si toujours vide, essayer de charger toutes les procédures de la catégorie et filtrer
              print('⚠️ Aucune procédure via endpoint sous-catégorie, tentative avec toutes les procédures de la catégorie');
              print('🔍 Sous-catégorie recherchée - ID: "${sousCategorie.id}" (${sousCategorie.id.runtimeType}), Nom: "${sousCategorie.nom}"');
              
              try {
                final allProcedures = await procedureService.getProceduresByCategorie(widget.categorieId);
                print('📋 ${allProcedures.length} procédure(s) trouvée(s) au total dans la catégorie "${widget.categorieNom}"');
                
                // Log détaillé de toutes les procédures avec leur sous-catégorie
                print('\n📊 Analyse des procédures:');
                for (var i = 0; i < allProcedures.length; i++) {
                  final proc = allProcedures[i];
                  if (proc.sousCategorie != null) {
                    print('  [$i] ${proc.nom}');
                    print('      Sous-cat ID: "${proc.sousCategorie!.id}" (${proc.sousCategorie!.id.runtimeType})');
                    print('      Sous-cat Nom: "${proc.sousCategorie!.nom}"');
                    print('      Correspond ID? ${proc.sousCategorie!.id.toString() == sousCategorie.id.toString()}');
                    print('      Correspond Nom? ${_normalizeString(proc.sousCategorie!.nom) == _normalizeString(sousCategorie.nom)}');
                  } else {
                    print('  [$i] ${proc.nom} - ❌ PAS DE SOUS-CATÉGORIE');
                  }
                }
                print('');
                
                // Fonction helper pour normaliser les strings (supprimer accents, espaces multiples, etc.)
                String normalizeString(String str) {
                  return str
                      .toLowerCase()
                      .replaceAll(RegExp(r'\s+'), ' ') // Espaces multiples -> un seul
                      .trim()
                      .replaceAll(RegExp(r'[àáâãäå]'), 'a')
                      .replaceAll(RegExp(r'[èéêë]'), 'e')
                      .replaceAll(RegExp(r'[ìíîï]'), 'i')
                      .replaceAll(RegExp(r'[òóôõö]'), 'o')
                      .replaceAll(RegExp(r'[ùúûü]'), 'u')
                      .replaceAll(RegExp(r'[ç]'), 'c');
                }
                
                // Filtrer par sous-catégorie (par nom ou ID) avec normalisation améliorée
                final filteredProcedures = allProcedures.where((proc) {
                  if (proc.sousCategorie == null) {
                    return false;
                  }
                  
                  // Correspondance par ID (string ou int)
                  final procSousCatId = proc.sousCategorie!.id.toString().trim();
                  final clickedSousCatId = sousCategorie.id.toString().trim();
                  final idMatch = procSousCatId == clickedSousCatId;
                  
                  // Correspondance par nom avec normalisation + canonisation
                  final procSousCatNom = _canonicalizeName(proc.sousCategorie!.nom);
                  final clickedSousCatNom = _canonicalizeName(sousCategorie.nom);
                  final nomMatch = procSousCatNom == clickedSousCatNom;
                  
                  // Correspondance partielle si le nom contient la sous-catégorie
                  final nomContains = procSousCatNom.contains(clickedSousCatNom) || 
                                       clickedSousCatNom.contains(procSousCatNom);
                  
                  final matches = idMatch || nomMatch || nomContains;
                  
                  if (matches) {
                    print('✅ Match trouvé: "${proc.nom}" (Sous-cat: "${proc.sousCategorie!.nom}")');
                  }
                  
                  return matches;
                }).toList();
                
                print('✅ ${filteredProcedures.length} procédure(s) filtrée(s) pour "${sousCategorie.nom}"');
                
                // Si toujours vide, essayer de charger TOUTES les procédures (pas seulement celles de la catégorie)
                if (filteredProcedures.isEmpty) {
                  print('⚠️ Aucune correspondance dans la catégorie, tentative avec TOUTES les procédures');
                  try {
                    final allProceduresAllCategories = await procedureService.getAllProcedures();
                    print('📋 ${allProceduresAllCategories.length} procédure(s) trouvée(s) au total (toutes catégories)');
                    
                    final filteredAll = allProceduresAllCategories.where((proc) {
                      if (proc.sousCategorie == null) return false;
                      
                      final procSousCatId = proc.sousCategorie!.id.toString().trim();
                      final clickedSousCatId = sousCategorie.id.toString().trim();
                      final idMatch = procSousCatId == clickedSousCatId;
                      
                      final procSousCatNom = _canonicalizeName(proc.sousCategorie!.nom);
                      final clickedSousCatNom = _canonicalizeName(sousCategorie.nom);
                      final nomMatch = procSousCatNom == clickedSousCatNom;
                      final nomContains = procSousCatNom.contains(clickedSousCatNom) || 
                                           clickedSousCatNom.contains(procSousCatNom);
                      
                      return idMatch || nomMatch || nomContains;
                    }).toList();
                    
                    print('✅ ${filteredAll.length} procédure(s) trouvée(s) dans toutes les catégories');
                    
                    if (filteredAll.isNotEmpty) {
                      _navigateToProcedures(filteredAll, sousCategorie.nom);
                      return;
                    }
                  } catch (e) {
                    print('❌ Erreur lors du chargement de toutes les procédures: $e');
                  }
                  
                  // Aucune procédure trouvée même après tous les essais
                  print('❌ AUCUNE CORRESPONDANCE TROUVÉE pour sous-catégorie "${sousCategorie.nom}" (ID: ${sousCategorie.id})');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Aucune procédure disponible pour "${sousCategorie.nom}"'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                  return;
                }
                
                // Utiliser les procédures filtrées
                _navigateToProcedures(filteredProcedures, sousCategorie.nom);
                
              } catch (e) {
                print('❌ Erreur lors du fallback: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Aucune procédure disponible pour cette sous-catégorie'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            } else {
              // Utiliser les procédures trouvées
              _navigateToProcedures(procedures, sousCategorie.nom);
            }
          } catch (e) {
            print('❌ Erreur lors du chargement des procédures: $e');
            print('❌ Stack trace: ${StackTrace.current}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erreur: $e'),
                duration: const Duration(seconds: 3),
              ),
            );
          }
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper pour normaliser les strings (supprimer accents, espaces multiples, etc.)
  String _normalizeString(String str) {
    return str
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ') // Espaces multiples -> un seul
        .trim()
        .replaceAll(RegExp(r'[àáâãäå]'), 'a')
        .replaceAll(RegExp(r'[èéêë]'), 'e')
        .replaceAll(RegExp(r'[ìíîï]'), 'i')
        .replaceAll(RegExp(r'[òóôõö]'), 'o')
        .replaceAll(RegExp(r'[ùúûü]'), 'u')
        .replaceAll(RegExp(r'[ç]'), 'c');
  }

  // Canonicalise des variantes fréquentes de libellés provenant de la BDD
  String _canonicalizeName(String input) {
    String s = _normalizeString(input);
    // Variantes connues
    final replacements = <String, String>{
      'entreprise individuel': 'entreprise individuelle',
      'entreprise sarl': 'entreprise sarl',
      'societes anonymes (sa)': 'societes anonymes (sa)',
      'societes par actions simplifiees (sas)': 'societes par actions simplifiees (sas)',
      'societes en nom collectif (snc)': 'societes en nom collectif (snc)',
      'permis de construire a usage personnelle': 'permis de construire a usage personnel',
      'logement sociaux': 'logements sociaux',
      'verifications des titres de proprietes': 'verification des titres de proprietes',
      'verification des titres de propriete': 'verification des titres de proprietes',
      'fiche individuelle': 'fiche individuelle',
      'passeport malien': 'passeport malien',
    };

    // Remplacements exacts
    if (replacements.containsKey(s)) return replacements[s]!;

    // Corrections simples de pluriels/espaces
    s = s.replaceAll("  ", " ");
    if (s.endsWith('  ')) s = s.trim();
    return s;
  }

  // Méthode helper pour naviguer vers les procédures
  void _navigateToProcedures(List<ProcedureResponse> procedures, String title) {
    if (procedures.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune procédure disponible'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (procedures.length == 1) {
      // Une seule procédure, afficher directement le détail
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProcedureDetailScreen(procedure: procedures[0]),
        ),
      );
    } else {
      // Plusieurs procédures, afficher la liste
      // Note: ProcedureListScreen attend un categorieId, mais on peut créer un écran spécialisé
      // Pour l'instant, on utilise ProcedureListScreen avec le widget.categorieId
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProcedureListScreen(
            categorieId: widget.categorieId,
            categorieNom: title,
            procedures: procedures, // Passer les procédures directement
          ),
        ),
      );
    }
  }
}
