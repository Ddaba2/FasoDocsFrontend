// ========================================================================================
// PROCEDURE DETAIL SCREEN - Écran détaillé d'une procédure avec onglets
// ========================================================================================

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/api_models.dart';
import '../../core/services/chatbot_service.dart';

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
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoadingAudio = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _audioPlayer.dispose();
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
          if (_isLoadingAudio)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause_circle_outline : Icons.volume_up,
                color: Colors.green,
              ),
              onPressed: _isPlaying ? _stopAudio : _playAudioBambara,
            ),
        ],
      ),
      body: Column(
        children: [
          // Sous-titre
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              widget.procedure.description ?? 'Détails de la procédure',
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.7),
              ),
            ),
          ),

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
                  icon: Icons.monetization_on,
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
          Expanded(
            child: IndexedStack(
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
          ),
        ],
      ),
      floatingActionButton: widget.procedure.urlFormulaire != null &&
              widget.procedure.urlFormulaire!.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _openUrl(widget.procedure.urlFormulaire!),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Formulaire en ligne'),
              backgroundColor: Colors.green,
            )
          : null,
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required IconData icon,
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
            Icon(
              icon,
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
      return 'Gratuit';
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
      return Center(
        child: Text(
          'Aucune étape disponible',
          style: TextStyle(color: textColor.withOpacity(0.5)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.procedure.etapes!.length,
      itemBuilder: (context, index) {
        final etape = widget.procedure.etapes![index];
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
                    Text(
                      etape.nom,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (etape.description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        etape.description,
                        style: TextStyle(
                          color: textColor.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCostTab(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;

    if (widget.procedure.couts == null || widget.procedure.couts!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monetization_on, size: 64, color: Colors.green),
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

    return ListView(
      padding: const EdgeInsets.all(16),
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
                      Text(
                        widget.procedure.delai!,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
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
                            Text(
                              cout.nom,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (cout.description != null &&
                                cout.description!.isNotEmpty)
                              Text(
                                cout.description!,
                                style: TextStyle(
                                  color: textColor.withOpacity(0.7),
                                  fontSize: 12,
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
    );
  }

  Widget _buildDocumentsTab(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;

    if (widget.procedure.documentsRequis.isEmpty) {
      return Center(
        child: Text(
          'Aucun document requis',
          style: TextStyle(color: textColor.withOpacity(0.5)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.procedure.documentsRequis.length,
      itemBuilder: (context, index) {
        final doc = widget.procedure.documentsRequis[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: doc.obligatoire ? Colors.red.shade50 : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: doc.obligatoire ? Colors.red.shade200 : Colors.blue.shade200,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: doc.obligatoire ? Colors.red : Colors.blue,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
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
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: doc.obligatoire
                                ? Colors.red.shade100
                                : Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            doc.obligatoire ? 'Obligatoire' : 'Optionnel',
                            style: TextStyle(
                              color: doc.obligatoire
                                  ? Colors.red.shade700
                                  : Colors.blue.shade700,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (doc.description != null && doc.description!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        doc.description!,
                        style: TextStyle(
                          color: textColor.withOpacity(0.7),
                          fontSize: 13,
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
          ),
        );
      },
    );
  }

  Widget _buildLegalReferencesTab(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;

    if (widget.procedure.referencesLegales == null ||
        widget.procedure.referencesLegales!.isEmpty) {
      return Center(
        child: Text(
          'Aucune référence légale disponible',
          style: TextStyle(color: textColor.withOpacity(0.5)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.procedure.referencesLegales!.length,
      itemBuilder: (context, index) {
        final ref = widget.procedure.referencesLegales![index];
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
                ],
              ),
              if (ref.article.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  ref.article,
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
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
      },
    );
  }

  Widget _buildCentersTab(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;

    if (widget.procedure.centres.isEmpty) {
      return Center(
        child: Text(
          'Aucun centre disponible',
          style: TextStyle(color: textColor.withOpacity(0.5)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.procedure.centres.length,
      itemBuilder: (context, index) {
        final centre = widget.procedure.centres[index];
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
                ],
              ),
              const SizedBox(height: 12),
              if (centre.adresse.isNotEmpty)
                _buildInfoRow(context, Icons.place, centre.adresse),
              if (centre.horaires != null && centre.horaires!.isNotEmpty)
                _buildInfoRow(context, Icons.access_time, centre.horaires!),
              if (centre.telephone != null && centre.telephone!.isNotEmpty)
                _buildInfoRow(context, Icons.phone, centre.telephone!),
              if (centre.email != null && centre.email!.isNotEmpty)
                _buildInfoRow(context, Icons.email, centre.email!),
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
      },
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

  Future<void> _playAudioBambara() async {
    try {
      setState(() {
        _isLoadingAudio = true;
      });

      // Construire le texte complet de la procédure
      final StringBuffer texte = StringBuffer();
      
      texte.writeln(widget.procedure.titre);
      
      if (widget.procedure.description != null && 
          widget.procedure.description!.isNotEmpty) {
        texte.writeln(widget.procedure.description);
      }
      
      if (widget.procedure.delai != null && widget.procedure.delai!.isNotEmpty) {
        texte.writeln('Délai: ${widget.procedure.delai}');
      }
      
      // Ajouter les étapes si disponibles
      if (widget.procedure.etapes != null && widget.procedure.etapes!.isNotEmpty) {
        texte.writeln('Les étapes à suivre:');
        for (var etape in widget.procedure.etapes!) {
          texte.writeln('${etape.niveauOrdre}. ${etape.nom}: ${etape.description}');
        }
      }
      
      // Ajouter les documents requis
      if (widget.procedure.documentsRequis.isNotEmpty) {
        texte.writeln('Documents requis:');
        for (var doc in widget.procedure.documentsRequis) {
          texte.writeln('- ${doc.nom}');
        }
      }
      
      // Ajouter les centres de traitement
      if (widget.procedure.centres.isNotEmpty) {
        texte.writeln('Centres de traitement:');
        for (var centre in widget.procedure.centres) {
          texte.writeln('- ${centre.nom}, ${centre.adresse}');
        }
      }

      final texteFinal = texte.toString();
      
      print('🔊 Texte à lire en Bambara (${texteFinal.length} caractères)');
      
      // ÉTAPE 1: Traduire le contenu en Bambara avec Djelia AI
      print('🌐 Traduction en Bambara...');
      final translated = await chatbotService.translateFrToBm(texteFinal);
      
      if (mounted) {
        setState(() {
          _isLoadingAudio = false;
        });
        
        if (translated.texteTraduit != null && translated.texteTraduit!.isNotEmpty) {
          final preview = translated.texteTraduit!.length > 100 
              ? translated.texteTraduit!.substring(0, 100) 
              : translated.texteTraduit!;
          print('✅ Texte traduit en Bambara: $preview...');
          
          // ÉTAPE 2: Utiliser la synthèse vocale de Djelia AI
          print('🎵 Génération audio avec Djelia AI...');
          final speakResponse = await chatbotService.speak(
            translated.texteTraduit!,
            'bm',
          );
          
          print('🎵 URL audio de Djelia AI: ${speakResponse.audioUrl}');
          
          if (speakResponse.audioUrl != null && speakResponse.audioUrl!.isNotEmpty) {
            // L'URL audio générée par Djelia AI
            var audioUrl = speakResponse.audioUrl!;
            
            // Remplacer localhost par 10.0.2.2 pour l'émulateur Android
            if (audioUrl.contains('localhost')) {
              audioUrl = audioUrl.replaceAll('localhost', '10.0.2.2');
              print('🔄 URL corrigée pour émulateur: $audioUrl');
            }
            
            try {
              // Jouer l'audio généré par Djelia AI
              await _audioPlayer.setUrl(audioUrl);
              setState(() {
                _isPlaying = true;
              });
              
              // Écouter la fin de la lecture
              _audioPlayer.playerStateStream.listen((state) {
                if (state.processingState == ProcessingState.completed) {
                  setState(() {
                    _isPlaying = false;
                  });
                }
              });
              
              await _audioPlayer.play();
            } catch (e) {
              print('❌ Erreur lecture audio URL: $e');
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur lecture audio: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          } else {
            print('❌ Pas d\'URL audio dans la réponse de Djelia AI');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Erreur: Djelia AI n\'a pas retourné d\'URL audio'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } else {
          print('❌ Traduction échouée ou vide');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Erreur: impossible de traduire en Bambara'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      print('❌ Erreur lecture audio: $e');
      if (mounted) {
        setState(() {
          _isLoadingAudio = false;
          _isPlaying = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la lecture: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }
}