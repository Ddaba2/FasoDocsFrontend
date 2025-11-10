import 'package:flutter/material.dart';
import 'report_problem_screen.dart';
import '../../core/services/signalement_service.dart';
import '../../models/api_models.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  // Couleur principale (Verte)
  static const Color primaryColor = Color(0xFF14B53A);
  
  final SignalementService _signalementService = signalementService;
  List<SignalementResponse> _signalements = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSignalements();
  }

  Future<void> _loadSignalements() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final signalements = await _signalementService.getAllSignalements();
      setState(() {
        _signalements = signalements;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Erreur chargement signalements: $e');
      setState(() {
        _errorMessage = 'Erreur de chargement des signalements';
        _isLoading = false;
      });
    }
  }

  @override
  void didUpdateWidget(ReportScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recharger les signalements quand on revient sur l'écran
    _loadSignalements();
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'À l\'instant';
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Récupération des couleurs du thème
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Utilise la couleur de fond du thème, qui est blanc en mode clair.
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final Color iconColor = Theme.of(context).iconTheme.color!;
    final Color cardColor = Theme.of(context).cardColor;

    return Scaffold(
      // Le fond du Scaffold est la couleur du thème (blanc par défaut)
      backgroundColor: backgroundColor,
      appBar: _buildCustomAppBar(context, textColor, iconColor),

      // 2. Bouton flottant pour signaler un nouveau problème
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_report_btn',
        onPressed: () async {
          // Ouvrir le formulaire puis recharger la liste au retour
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ReportProblemScreen()),
          );
          if (mounted) {
            _loadSignalements();
          }
        },
        backgroundColor: primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        elevation: 4.0, // Ajout de l'élévation pour coller à l'image
      ),

      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primaryColor),
                  const SizedBox(height: 20),
                  Text(
                    'Chargement des signalements...',
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadSignalements,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : _signalements.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun signalement',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Vous n\'avez encore aucun signalement',
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _signalements.map((signalement) {
                          // Use the structure field directly from the model
                          String source = signalement.structure.isNotEmpty 
                            ? signalement.structure 
                            : 'Structure non spécifiée';
                          
                          return _buildReportCard(
                            context,
                            signalement.titre, // Use titre instead of type for the title
                            signalement.description,
                            _formatTime(signalement.dateCreation),
                            source,
                            cardColor,
                            textColor,
                            isDarkMode,
                          );
                        }).toList(),
                      ),
                    ),
    );
  }

  // ===========================================================================
  // WIDGETS DE COMPOSITION
  // ===========================================================================

  PreferredSizeWidget _buildCustomAppBar(
      BuildContext context, Color textColor, Color iconColor) {
    // Le fond de la barre d'application doit être la couleur de fond du Scaffold (blanc dans le mode clair)
    final Color appBarBgColor = Theme.of(context).scaffoldBackgroundColor;

    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
    automaticallyImplyLeading: false,
      centerTitle: true,
    title:  Text(

    'Signalement',

    style: TextStyle(

    fontSize: 20,

    fontWeight: FontWeight.bold,

    color: textColor,

    ),

    ),
    );
  }

  // Widget pour le Logo du Mali (Vert-Jaune-Rouge)
  Widget _buildMaliLogo(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Row(
          children: [
            // Vert
            Container(width: size / 3, color: primaryColor),
            // Jaune
            Container(width: size / 3, color: const Color(0xFFFFD700)),
            // Rouge
            Container(width: size / 3, color: const Color(0xFFDC143C)),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(
      BuildContext context,
      String type,
      String description,
      String time,
      String source,
      Color cardColor,
      Color textColor,
      bool isDarkMode) {

    // Couleurs spécifiques pour le texte de la source
    final sourceColor = isDarkMode ? primaryColor.withOpacity(0.8) : primaryColor;
    final timeColor = isDarkMode ? Colors.grey[400] : (Colors.grey[600] ?? Colors.black54);
    // Les cartes sont blanches dans l'image (légèrement ombragées)
    final cardBgColor = isDarkMode ? cardColor : Colors.white;
    final shadowColor = isDarkMode ? Colors.black.withOpacity(0.5) : Colors.grey.withOpacity(0.15);
    final borderColor = isDarkMode ? (Colors.grey[700] ?? const Color(0xFF333333)) : Colors.black12;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: textColor.withOpacity(0.8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 13,
                  color: timeColor,
                ),
              ),
              Text(
                source,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: sourceColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}