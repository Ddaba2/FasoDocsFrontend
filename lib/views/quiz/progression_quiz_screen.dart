// ========================================================================================
// PROGRESSION QUIZ SCREEN - Écran affichant la progression complète de l'utilisateur
// Design inspiré de Duolingo avec progression par niveau
// ========================================================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/quiz_service.dart';
import '../../core/services/quiz_cache_service.dart';
import '../../models/quiz_models.dart';

// Couleurs Duolingo
class DuolingoColors {
  static const Color primaryGreen = Color(0xFF58CC02);
  static const Color primaryBlue = Color(0xFF1CB0F6);
  static const Color primaryOrange = Color(0xFFFF9600);
  static const Color primaryPurple = Color(0xFFCE82FF);
  static const Color primaryRed = Color(0xFFFF4B4B);
  static const Color backgroundLight = Color(0xFFF7F7F7);
  static const Color textDark = Color(0xFF3C3C3C);
  static const Color textLight = Color(0xFF8E8E93);
  static const Color lockedGray = Color(0xFFD3D3D3);
}

class ProgressionQuizScreen extends StatefulWidget {
  const ProgressionQuizScreen({super.key});

  @override
  State<ProgressionQuizScreen> createState() => _ProgressionQuizScreenState();
}

class _ProgressionQuizScreenState extends State<ProgressionQuizScreen>
    with TickerProviderStateMixin {
  final QuizService _quizService = quizService;
  final QuizCacheService _cache = QuizCacheService.instance;

  QuizProgressionResponse? _progression;
  bool _loading = true;
  bool _loadingFromCache = false;
  String? _errorMessage;
  
  // Debounce pour éviter les rechargements trop fréquents
  DateTime? _lastRefreshTime;
  static const Duration _minRefreshInterval = Duration(seconds: 2);

  late AnimationController _animationController;
  late List<Animation<double>> _cardAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Animations en cascade pour les 3 niveaux
    _cardAnimations = [
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.0, 0.33, curve: Curves.easeOut),
        ),
      ),
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.33, 0.66, curve: Curves.easeOut),
        ),
      ),
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.66, 1.0, curve: Curves.easeOut),
        ),
      ),
    ];

    _chargerProgression();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _chargerProgression({bool forceRefresh = false}) async {
    // Charger depuis le cache d'abord si disponible
    if (!forceRefresh) {
      final cachedProgression = _cache.getProgression();
      if (cachedProgression != null) {
        setState(() {
          _progression = cachedProgression;
          _loading = false;
          _loadingFromCache = true;
        });
        if (cachedProgression != null) {
          _animationController.forward();
        }
        
        // Recharger en arrière-plan
        _chargerProgressionEnArrierePlan();
        return;
      }
    }

    setState(() {
      _loading = true;
      _loadingFromCache = false;
      _errorMessage = null;
    });

    try {
      final progression = await _quizService.obtenirProgression();
      _cache.setProgression(progression);
      
      setState(() {
        _progression = progression;
        _loading = false;
        _loadingFromCache = false;
      });
      if (progression != null) {
        _animationController.forward();
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _loadingFromCache = false;
        _errorMessage = 'Erreur lors du chargement: $e';
      });
    }
  }

  // Recharger en arrière-plan (avec debounce)
  Future<void> _chargerProgressionEnArrierePlan() async {
    // Debounce : éviter les rechargements trop fréquents
    final now = DateTime.now();
    if (_lastRefreshTime != null && 
        now.difference(_lastRefreshTime!) < _minRefreshInterval) {
      return; // Ignorer si le dernier refresh était trop récent
    }
    _lastRefreshTime = now;
    
    try {
      // Utiliser un timeout plus court pour les rechargements en arrière-plan
      QuizProgressionResponse? progression;
      try {
        progression = await _quizService.obtenirProgression()
            .timeout(const Duration(seconds: 10));
      } on TimeoutException {
        // En cas de timeout, garder les données actuelles
        return;
      }
      
      if (progression != null) {
        _cache.setProgression(progression);
        
        if (mounted) {
          setState(() {
            _progression = progression;
            _loadingFromCache = false;
          });
        }
      }
    } catch (e) {
      // Erreur silencieuse - on garde les données en cache
      if (kDebugMode) {
        print('⚠️ Erreur lors du rechargement en arrière-plan: $e');
      }
    }
  }

  Color _getCouleurNiveau(QuizNiveau niveau) {
    switch (niveau) {
      case QuizNiveau.facile:
        return DuolingoColors.primaryGreen;
      case QuizNiveau.moyen:
        return DuolingoColors.primaryBlue;
      case QuizNiveau.difficile:
        return DuolingoColors.primaryOrange;
    }
  }

  IconData _getIconNiveau(QuizNiveau niveau) {
    switch (niveau) {
      case QuizNiveau.facile:
        return Icons.star;
      case QuizNiveau.moyen:
        return Icons.stars;
      case QuizNiveau.difficile:
        return Icons.emoji_events;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: DuolingoColors.backgroundLight,
        appBar: AppBar(
          title: const Text('Ma Progression'),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: DuolingoColors.textDark),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(DuolingoColors.primaryGreen),
              ),
              const SizedBox(height: 24),
              Text(
                'Chargement de votre progression...',
                style: TextStyle(
                  color: DuolingoColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: DuolingoColors.backgroundLight,
        appBar: AppBar(
          title: const Text('Ma Progression'),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: DuolingoColors.textDark),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: DuolingoColors.primaryRed,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: DuolingoColors.textDark,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _chargerProgression,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DuolingoColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_progression == null) {
      return Scaffold(
        backgroundColor: DuolingoColors.backgroundLight,
        appBar: AppBar(
          title: const Text('Ma Progression'),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: DuolingoColors.textDark),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.trending_up,
                  size: 80,
                  color: DuolingoColors.primaryBlue,
                ),
                const SizedBox(height: 24),
                Text(
                  'Aucune progression disponible',
                  style: TextStyle(
                    color: DuolingoColors.textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: DuolingoColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Ma Progression',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: DuolingoColors.textDark),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _chargerProgression,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _chargerProgression,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête avec statistiques globales
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Nom utilisateur
                      if (_progression!.utilisateurNom != null ||
                          _progression!.utilisateurPrenom != null)
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: DuolingoColors.primaryGreen.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person,
                                size: 30,
                                color: DuolingoColors.primaryGreen,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_progression!.utilisateurPrenom ?? ''} ${_progression!.utilisateurNom ?? ''}',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: DuolingoColors.textDark,
                                    ),
                                  ),
                                  if (_progression!.niveauActuel != null)
                                    Text(
                                      'Niveau actuel: ${_progression!.niveauActuel!.label}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: DuolingoColors.textLight,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      // Statistiques globales
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatMini(
                            'Points',
                            '${_progression!.totalPoints}',
                            Icons.star,
                            DuolingoColors.primaryOrange,
                          ),
                          _buildStatMini(
                            'Quiz',
                            '${_progression!.totalQuizCompletes}',
                            Icons.quiz,
                            DuolingoColors.primaryBlue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Titre
                Text(
                  'Progression par niveau',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: DuolingoColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Complétez 25 quiz pour débloquer le niveau suivant',
                  style: TextStyle(
                    fontSize: 14,
                    color: DuolingoColors.textLight,
                  ),
                ),
                const SizedBox(height: 24),

                // Cartes des niveaux
                ...QuizNiveau.values.asMap().entries.map((entry) {
                  final index = entry.key;
                  final niveau = entry.value;
                  final progressionNiveau = _progression!.getProgressionNiveau(niveau);
                  final couleur = _getCouleurNiveau(niveau);
                  final icon = _getIconNiveau(niveau);

                  // FACILE est toujours débloqué
                  final estDebloque = niveau == QuizNiveau.facile ||
                      (progressionNiveau?.estDebloque ?? false);
                  final quizCompletes = progressionNiveau?.quizCompletes ?? 0;
                  final meilleurScore = progressionNiveau?.meilleurScore;
                  final pourcentage = (quizCompletes / 25).clamp(0.0, 1.0);

                  return AnimatedBuilder(
                    animation: _cardAnimations[index],
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 50 * (1 - _cardAnimations[index].value)),
                        child: Opacity(
                          opacity: _cardAnimations[index].value,
                          child: _buildNiveauCard(
                            niveau: niveau,
                            estDebloque: estDebloque,
                            quizCompletes: quizCompletes,
                            meilleurScore: meilleurScore,
                            pourcentage: pourcentage,
                            couleur: couleur,
                            icon: icon,
                            estNiveauActuel: progressionNiveau?.estNiveauActuel ?? false,
                            dateDeblocage: progressionNiveau?.dateDeblocage,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatMini(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: DuolingoColors.textDark,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: DuolingoColors.textLight,
          ),
        ),
      ],
    );
  }

  Widget _buildNiveauCard({
    required QuizNiveau niveau,
    required bool estDebloque,
    required int quizCompletes,
    required int? meilleurScore,
    required double pourcentage,
    required Color couleur,
    required IconData icon,
    required bool estNiveauActuel,
    String? dateDeblocage,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: estDebloque
              ? couleur
              : DuolingoColors.lockedGray,
          width: estDebloque ? 3 : 2,
        ),
        boxShadow: estDebloque
            ? [
                BoxShadow(
                  color: couleur.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête du niveau
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: estDebloque
                      ? couleur.withOpacity(0.15)
                      : DuolingoColors.lockedGray.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  estDebloque ? icon : Icons.lock,
                  size: 30,
                  color: estDebloque ? couleur : DuolingoColors.lockedGray,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          niveau.label,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: estDebloque
                                ? DuolingoColors.textDark
                                : DuolingoColors.lockedGray,
                          ),
                        ),
                        if (estNiveauActuel) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: DuolingoColors.primaryGreen.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Actuel',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: DuolingoColors.primaryGreen,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (dateDeblocage != null && estDebloque)
                      Text(
                        'Débloqué le ${_formatDate(dateDeblocage)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: DuolingoColors.textLight,
                        ),
                      )
                    else if (!estDebloque)
                      Text(
                        'Verrouillé',
                        style: TextStyle(
                          fontSize: 14,
                          color: DuolingoColors.lockedGray,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Barre de progression
          if (estDebloque) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progression',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: DuolingoColors.textDark,
                  ),
                ),
                Text(
                  '$quizCompletes/25',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: couleur,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: pourcentage,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(couleur),
                minHeight: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(pourcentage * 100).round()}% complété',
              style: TextStyle(
                fontSize: 12,
                color: DuolingoColors.textLight,
              ),
            ),
          ],
          // Meilleur score
          if (estDebloque && meilleurScore != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: couleur.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 20,
                    color: couleur,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Meilleur score: $meilleurScore points',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: couleur,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}

