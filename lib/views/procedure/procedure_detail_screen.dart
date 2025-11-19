// ========================================================================================
// PROCEDURE DETAIL SCREEN - Écran détaillé d'une procédure avec onglets
// ========================================================================================

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/api_models.dart';
import '../../core/widgets/icone_haut_parleur.dart';
import '../../core/widgets/nearby_center_map.dart';
import '../../core/services/history_service.dart';
import '../../core/services/service_service.dart';
import '../../core/widgets/tarif_service_modal.dart';
import '../../core/widgets/formulaire_service.dart';

class ProcedureDetailScreen extends StatefulWidget {
  final ProcedureResponse procedure;

  const ProcedureDetailScreen({
    super.key,
    required this.procedure,
  });

  @override
  State<ProcedureDetailScreen> createState() => _ProcedureDetailScreenState();
}

class _ProcedureDetailScreenState extends State<ProcedureDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;
  late AnimationController _floatingAnimationController;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
    
    // Animation de flottement pour le bouton de service
    _floatingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatingAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _floatingAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Enregistrer cette procédure dans l'historique
    _addToHistory();
  }
  
  /// Ajoute cette procédure à l'historique de navigation
  Future<void> _addToHistory() async {
    try {
      final historyItem = HistoryItem(
        id: widget.procedure.id,
        type: HistoryType.procedure,
        title: widget.procedure.titre,
        subtitle: widget.procedure.description,
        metadata: {
          'categorie': widget.procedure.categorie?.nom,
          'sousCategorie': widget.procedure.sousCategorie?.nom,
        },
      );
      
      await historyService.addToHistory(historyItem);
    } catch (e) {
      debugPrint('❌ Erreur lors de l\'ajout à l\'historique: $e');
    }
  }
  
  /// Construit le texte COMPLET de la procédure pour Djelia AI
  String _buildFullProcedureText() {
    debugPrint('🔨 Construction du texte complet de la procédure...');
    final buffer = StringBuffer();
    
    // 1. Titre
    buffer.writeln('Procédure : ${widget.procedure.titre}.');
    buffer.writeln();
    
    // 2. Description
    if (widget.procedure.description != null && widget.procedure.description!.isNotEmpty) {
      buffer.writeln('Description : ${widget.procedure.description}');
      buffer.writeln();
    }
    
    // 3. Délai
    if (widget.procedure.delai != null && widget.procedure.delai!.isNotEmpty) {
      buffer.writeln('Délai : ${widget.procedure.delai}.');
      buffer.writeln();
    }
    
    // 4. Étapes
    if (widget.procedure.etapes != null && widget.procedure.etapes!.isNotEmpty) {
      buffer.writeln('Étapes à suivre :');
      for (var i = 0; i < widget.procedure.etapes!.length; i++) {
        final etape = widget.procedure.etapes![i];
        buffer.writeln('Étape ${i + 1} : ${etape.nom}. ${etape.description}');
      }
      buffer.writeln();
    }
    
    // 5. Documents requis
    if (widget.procedure.documentsRequis.isNotEmpty) {
      buffer.writeln('Documents requis :');
      for (var i = 0; i < widget.procedure.documentsRequis.length; i++) {
        final doc = widget.procedure.documentsRequis[i];
        buffer.writeln('${i + 1}. ${doc.nom}');
      }
      buffer.writeln();
    }
    
    // 6. Coûts
    if (widget.procedure.couts != null && widget.procedure.couts!.isNotEmpty) {
      buffer.writeln('Coûts :');
      for (var cout in widget.procedure.couts!) {
        buffer.writeln('${cout.nom} : ${cout.prix} francs CFA');
      }
      buffer.writeln();
    }
    
    // 7. Centres
    if (widget.procedure.centres.isNotEmpty) {
      buffer.writeln('Centres où effectuer la démarche :');
      for (var centre in widget.procedure.centres) {
        buffer.writeln('${centre.nom}, ${centre.adresse}');
      }
    }
    
    final fullText = buffer.toString();
    debugPrint('✅ Texte complet construit : ${fullText.length} caractères');
    debugPrint('📄 Aperçu : ${fullText.substring(0, fullText.length > 200 ? 200 : fullText.length)}...');
    
    return fullText;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _floatingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.green),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.procedure.titre,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          // 🎤 Haut-parleur pour lire TOUTE la procédure
          IconeHautParleur(
            texteFrancais: _buildFullProcedureText(),
            couleur: Colors.orange,
            taille: 24,
            procedureId: int.tryParse(widget.procedure.id), // Active le fallback audio
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [
          // Résumé avec compteurs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryCard(
                  context,
                  icon: Icons.list,
                  iconColor: Colors.orange,
                  label: 'Etapes',
                  value: widget.procedure.etapes?.length.toString() ?? '0',
                  isSelected: _selectedTab == 0,
                ),
                _buildSummaryCard(
                  context,
                  imagePath: 'assets/images/fcfa.png',
                  iconColor: Colors.green,
                  label: 'Montant',
                  value: _getAmountSummary(),
                  isSelected: _selectedTab == 1,
                ),
                _buildSummaryCard(
                  context,
                  icon: Icons.folder,
                  iconColor: Colors.blue,
                  label: 'Documents',
                  value: widget.procedure.documentsRequis.length.toString(),
                  isSelected: _selectedTab == 2,
                ),
                _buildSummaryCard(
                  context,
                  icon: Icons.gavel,
                  iconColor: Colors.amber,
                  label: 'Loi(s)',
                  value: widget.procedure.referencesLegales?.length.toString() ?? '0',
                  isSelected: _selectedTab == 3,
                ),
                _buildSummaryCard(
                  context,
                  icon: Icons.location_on,
                  iconColor: Colors.red,
                  label: 'Centres',
                  value: widget.procedure.centres.length.toString(),
                  isSelected: _selectedTab == 4,
                ),
              ],
            ),
          ),

          // Contenu des onglets
            IndexedStack(
              index: _selectedTab,
              children: [
                // Onglet Étapes
                _buildStepsTab(context),
                // Onglet Montant
                _buildCostTab(context),
                // Onglet Documents
                _buildDocumentsTab(context),
                // Onglet Lois
                _buildLegalReferencesTab(context),
                // Onglet Centres
                _buildCentersTab(context),
              ],
            ),
          ],
          ),
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    IconData? icon,
    String? imagePath,
    required Color iconColor,
    required String label,
    required String value,
    required bool isSelected,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = _getTabIndex(label);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.green : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Utiliser l'image si fournie, sinon utiliser l'icône
            if (imagePath != null)
              Image.asset(
                imagePath,
                width: 24,
                height: 24,
                // Retirer le color pour afficher l'image dans ses couleurs d'origine
                errorBuilder: (context, error, stackTrace) {
                  // Si l'image n'existe pas, fallback vers l'icône
                  return Icon(
                    icon ?? Icons.monetization_on,
                    color: iconColor,
                    size: 24,
                  );
                },
              )
            else
              Icon(
                icon ?? Icons.help_outline,
                color: iconColor,
                size: 24,
              ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: textColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getTabIndex(String label) {
    switch (label) {
      case 'Etapes':
        return 0;
      case 'Montant':
        return 1;
      case 'Documents':
        return 2;
      case 'Loi(s)':
        return 3;
      case 'Centres':
        return 4;
      default:
        return 0;
    }
  }

  String _getAmountSummary() {
    if (widget.procedure.couts == null || widget.procedure.couts!.isEmpty) {
      return 'g';
    }
    final total = widget.procedure.couts!
        .fold<double>(0, (sum, cout) => sum + cout.prix);
    if (total == 0) {
      return 'Gratuit';
    }
    return '${total.toStringAsFixed(0)} FCFA';
  }

  Widget _buildStepsTab(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;

    if (widget.procedure.etapes == null || widget.procedure.etapes!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
        child: Text(
          'Aucune étape disponible',
          style: TextStyle(color: textColor.withOpacity(0.5)),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: widget.procedure.etapes!.map((etape) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.green,
                child: Text(
                  '${etape.niveauOrdre}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            etape.nom,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconeHautParleur(
                          texteFrancais: etape.nom,
                          couleur: Colors.orange,
                          taille: 20,
                          procedureId: int.tryParse(widget.procedure.id), // Active le fallback audio
                        ),
                      ],
                    ),
                    if (etape.description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              etape.description,
                              style: TextStyle(
                                color: textColor.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          IconeHautParleur(
                            texteFrancais: etape.description,
                            couleur: Colors.orange,
                            taille: 20,
                            procedureId: int.tryParse(widget.procedure.id), // Active le fallback audio
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
        }).toList(),
      ),
    );
  }

  Widget _buildCostTab(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;

    if (widget.procedure.couts == null || widget.procedure.couts!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/fcfa.png',
              width: 64,
              height: 64,
              // Retirer le color pour afficher l'image dans ses couleurs d'origine
              errorBuilder: (context, error, stackTrace) {
                // Si l'image n'existe pas, fallback vers l'icône
                return const Icon(Icons.monetization_on, size: 64, color: Colors.green);
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Gratuit',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      );
    }

    double total = widget.procedure.couts!.fold<double>(
        0, (sum, cout) => sum + cout.prix);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
      children: [
        if (widget.procedure.delai != null && widget.procedure.delai!.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.timer, color: Colors.green),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Délai de traitement',
                        style: TextStyle(
                          color: textColor.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.procedure.delai!,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconeHautParleur(
                            texteFrancais: widget.procedure.delai!,
                            couleur: Colors.orange,
                            taille: 20,
                            procedureId: int.tryParse(widget.procedure.id), // Active le fallback audio
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ...widget.procedure.couts!.map((cout) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    cout.nom,
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                IconeHautParleur(
                                  texteFrancais: cout.nom,
                                  couleur: Colors.orange,
                                  taille: 20,
                                  procedureId: int.tryParse(widget.procedure.id), // Active le fallback audio
                                ),
                              ],
                            ),
                            if (cout.description != null &&
                                cout.description!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        cout.description!,
                                        style: TextStyle(
                                          color: textColor.withOpacity(0.7),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    IconeHautParleur(
                                      texteFrancais: cout.description!,
                                      couleur: Colors.orange,
                                      taille: 20,
                                      procedureId: int.tryParse(widget.procedure.id), // Active le fallback audio
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        '${cout.prix.toStringAsFixed(0)} FCFA',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              Divider(height: 1),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${total.toStringAsFixed(0)} FCFA',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      ),
    );
  }

  Widget _buildDocumentsTab(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;
    final borderColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;

    if (widget.procedure.documentsRequis.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
        child: Text(
          'Aucun document requis',
          style: TextStyle(color: textColor.withOpacity(0.5)),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
          color: cardColor,
            borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            for (int i = 0; i < widget.procedure.documentsRequis.length; i++) ...[
              _buildDocumentItem(
                doc: widget.procedure.documentsRequis[i],
                textColor: textColor,
              ),
              if (i < widget.procedure.documentsRequis.length - 1)
                const SizedBox(height: 16),
            ],
          ],
            ),
          ),
    );
  }

  Widget _buildDocumentItem({
    required doc,
    required Color textColor,
  }) {
    return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        // Case à cocher
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF14B53A),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(4),
                ),
          child: const Icon(
                  Icons.check,
            color: Color(0xFF14B53A),
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      doc.nom,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                  IconeHautParleur(
                    texteFrancais: doc.nom,
                    couleur: Colors.orange,
                    taille: 20,
                    procedureId: int.tryParse(widget.procedure.id), // Active le fallback audio
                  ),
                ],
              ),
              if (doc.description != null && doc.description!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        doc.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                    ),
                    IconeHautParleur(
                      texteFrancais: doc.description!,
                      couleur: Colors.orange,
                      taille: 20,
                      procedureId: int.tryParse(widget.procedure.id), // Active le fallback audio
                    ),
                  ],
                ),
                      ],
              if (doc.obligatoire) ...[
                const SizedBox(height: 4),
                      Text(
                  'Obligatoire',
                        style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFFF44336),
                    fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    if (doc.modeleUrl != null && doc.modeleUrl!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () => _openUrl(doc.modeleUrl!),
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text('Télécharger le modèle'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
    );
  }

  Widget _buildLegalReferencesTab(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;

    if (widget.procedure.referencesLegales == null ||
        widget.procedure.referencesLegales!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
        child: Text(
          'Aucune référence légale disponible',
          style: TextStyle(color: textColor.withOpacity(0.5)),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: widget.procedure.referencesLegales!.map((ref) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.gavel, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ref.description,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconeHautParleur(
                    texteFrancais: ref.description,
                    couleur: Colors.orange,
                    taille: 20,
                    procedureId: int.tryParse(widget.procedure.id), // Active le fallback audio
                  ),
                ],
              ),
              if (ref.article.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        ref.article,
                        style: TextStyle(
                          color: textColor.withOpacity(0.7),
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    IconeHautParleur(
                      texteFrancais: ref.article,
                      couleur: Colors.orange,
                      taille: 20,
                      procedureId: int.tryParse(widget.procedure.id), // Active le fallback audio
                    ),
                  ],
                ),
              ],
              if (ref.audioUrl != null && ref.audioUrl!.isNotEmpty) ...[
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _openUrl(ref.audioUrl!),
                  icon: const Icon(Icons.volume_up, size: 18),
                  label: const Text('Écouter en Bambara'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                  ),
                ),
              ],
            ],
          ),
        );
        }).toList(),
      ),
    );
  }

  Widget _buildCentersTab(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;

    // Si la procédure a des centres avec coordonnées GPS
    if (widget.procedure.centres.isNotEmpty && 
        widget.procedure.centres.any((c) => c.latitude != null && c.longitude != null)) {
      // Afficher la liste classique des centres
      return Padding(
      padding: const EdgeInsets.all(16),
        child: Column(
          children: widget.procedure.centres.map((centre) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.business, color: Colors.green, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      centre.nom,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconeHautParleur(
                    texteFrancais: centre.nom,
                    couleur: Colors.orange,
                    taille: 20,
                    procedureId: int.tryParse(widget.procedure.id), // Active le fallback audio
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (centre.adresse.isNotEmpty)
                _buildInfoRowWithAudio(context, Icons.place, centre.adresse),
              if (centre.horaires != null && centre.horaires!.isNotEmpty)
                _buildInfoRowWithAudio(context, Icons.access_time, centre.horaires!),
              if (centre.telephone != null && centre.telephone!.isNotEmpty)
                _buildInfoRowWithAudio(context, Icons.phone, centre.telephone!),
              if (centre.email != null && centre.email!.isNotEmpty)
                _buildInfoRowWithAudio(context, Icons.email, centre.email!),
              if (centre.latitude != null && centre.longitude != null) ...[
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () =>
                      _openMap(centre.latitude!, centre.longitude!),
                  icon: const Icon(Icons.map, size: 18),
                  label: const Text('Voir sur la carte'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green),
                  ),
                ),
              ],
            ],
          ),
        );
          }).toList(),
        ),
      );
    }

    // Sinon, utiliser MapBox pour trouver le centre le plus proche
    // Extraire le type de centre du premier centre ou utiliser un type par défaut
    String centerType = 'Mairie'; // Type par défaut
    
    if (widget.procedure.centres.isNotEmpty) {
      // Utiliser le nom du premier centre comme type
      centerType = widget.procedure.centres.first.nom;
    } else if (widget.procedure.titre.toLowerCase().contains('mairie')) {
      centerType = 'Mairie';
    } else if (widget.procedure.titre.toLowerCase().contains('commissariat') ||
               widget.procedure.titre.toLowerCase().contains('police')) {
      centerType = 'Commissariat';
    } else if (widget.procedure.titre.toLowerCase().contains('hôpital') ||
               widget.procedure.titre.toLowerCase().contains('hopital') ||
               widget.procedure.titre.toLowerCase().contains('santé')) {
      centerType = 'Hôpital';
    }

    // Afficher la carte MapBox interactive avec les centres du backend
    return SingleChildScrollView(
      child: NearbyCenterMap(
        centerType: centerType,
        backendCenters: widget.procedure.centres.isNotEmpty 
            ? widget.procedure.centres 
            : null, // ✅ Passer les centres du backend pour utiliser leurs noms avec les coordonnées de default_centers_bamako.dart
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRowWithAudio(BuildContext context, IconData icon, String text) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: 14),
            ),
          ),
          IconeHautParleur(
            texteFrancais: text,
            couleur: Colors.orange,
            taille: 20,
            procedureId: int.tryParse(widget.procedure.id), // Active le fallback audio
          ),
        ],
      ),
    );
  }

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openMap(String latitude, String longitude) async {
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // Removed _playAudioBambara method that used chatbot service
  // Removed _playStepAudio method that used chatbot service  // Removed _playStepAudioBambara method that used chatbot service
  // Removed _playDescriptionAudio method that used chatbot service

  /// Affiche le modal de tarif de service
  Future<void> _afficherModalTarif() async {
    // 1. Demander la commune à l'utilisateur
    final commune = await _demanderCommune();
    if (commune == null || commune.isEmpty) return;

    try {
      // 2. Récupérer le tarif
      final tarif = await serviceService.obtenirTarif(
        procedureId: widget.procedure.id,
        commune: commune,
      );

      // 3. Afficher le modal de tarif
      if (!mounted) return;
      
      final continuer = await showDialog<bool>(
        context: context,
        builder: (context) => TarifServiceModal(
          tarif: tarif,
          onContinuer: () => Navigator.of(context).pop(true),
          onAnnuler: () => Navigator.of(context).pop(false),
        ),
      );

      // 4. Si l'utilisateur continue, afficher le formulaire
      if (continuer == true) {
        if (!mounted) return;
        
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FormulaireService(
              procedureId: widget.procedure.id,
              procedureNom: widget.procedure.titre,
              tarifTotal: tarif.tarifTotal,
              communeInitiale: commune,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Demande la commune à l'utilisateur
  Future<String?> _demanderCommune() async {
    return await showDialog<String>(
      context: context,
      builder: (context) {
        String commune = '';
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
        
        return AlertDialog(
          title: Text(
            'Votre commune',
            style: TextStyle(color: textColor),
          ),
          content: TextField(
            decoration: const InputDecoration(
              labelText: 'Commune',
              hintText: 'Ex: Commune I, Kati, etc.',
            ),
            onChanged: (value) => commune = value,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (commune.isNotEmpty) {
                  Navigator.of(context).pop(commune);
                }
              },
              child: const Text('Continuer'),
            ),
          ],
        );
      },
    );
  }

  /// Construit les boutons flottants (service + formulaire en ligne si disponible)
  Widget _buildFloatingActionButtons() {
    final hasFormulaire = widget.procedure.urlFormulaire != null &&
        widget.procedure.urlFormulaire!.isNotEmpty;
    final hasService = widget.procedure.peutEtreDelegatee;

    // Si les deux boutons existent, utiliser un Stack
    if (hasFormulaire && hasService) {
      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          // Bouton formulaire en ligne (en haut)
          Padding(
            padding: const EdgeInsets.only(bottom: 80, right: 0),
            child: FloatingActionButton.extended(
              onPressed: () => _openUrl(widget.procedure.urlFormulaire!),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Formulaire en ligne'),
              backgroundColor: Colors.green,
            ),
          ),
          // Bouton demabder un service avec animation flottante (en bas)
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              final imagePath = 'assets/images/livreur_sombre.png';
              return Transform.translate(
                offset: Offset(0, -_floatingAnimation.value),
                child: FloatingActionButton(
                  onPressed: _afficherModalTarif,
                  backgroundColor: Colors.orange,
                  tooltip: "Faire à ma place",
                  child: _buildLivreurIcon(imagePath),
                ),
              );
            },
          ),
        ],
      );
    }

    // Si seulement le formulaire existe
    if (hasFormulaire) {
      return FloatingActionButton.extended(
        onPressed: () => _openUrl(widget.procedure.urlFormulaire!),
        icon: const Icon(Icons.open_in_new),
        label: const Text('Formulaire en ligne'),
        backgroundColor: Colors.green,
      );
    }

    // Si seulement le service existe
    if (hasService) {
      return AnimatedBuilder(
        animation: _floatingAnimation,
        builder: (context, child) {
          final imagePath = 'assets/images/livreur_sombre.png';
          return Transform.translate(
            offset: Offset(0, -_floatingAnimation.value),
            child: FloatingActionButton(
              onPressed: _afficherModalTarif,
              backgroundColor: Colors.orange,
              tooltip: "Faire à ma place",
              child: _buildLivreurIcon(imagePath),
            ),
          );
        },
      );
    }

    // Aucun bouton
    return const SizedBox.shrink();
  }

  /// Construit l'icône du livreur avec gestion d'erreur
  Widget _buildLivreurIcon(String imagePath) {
    debugPrint('🖼️ [LIVREUR] Chargement image: $imagePath');
    
    return Image.asset(
      imagePath,
      width: 24,
      height: 24,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('❌ [LIVREUR] ERREUR chargement image: $imagePath');
        debugPrint('   Type erreur: ${error.runtimeType}');
        debugPrint('   Message: $error');
        debugPrint('   StackTrace: $stackTrace');
        
        // Essayer avec différentes variantes du nom
        final variants = [
          imagePath,
          imagePath.replaceAll('livreur_sombre.png', 'Livreur_sombre.png'),
          imagePath.replaceAll('livreur_sombre.png', 'livreur.png'),
          'assets/images/livreur_sombre.png',
        ];
        
        // Retourner l'icône de secours
        return const Icon(
          FontAwesomeIcons.motorcycle,
          color: Colors.white,
          size: 24,
        );
      },
    );
  }

}