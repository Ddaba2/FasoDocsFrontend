// ========================================================================================
// SELECTION NIVEAU QUIZ SCREEN - Écran de sélection du niveau de quiz
// Design inspiré de Duolingo avec système de déblocage progressif
// ========================================================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/quiz_service.dart';
import '../../core/services/quiz_cache_service.dart';
import '../../models/quiz_models.dart';
import 'liste_quiz_niveau_screen.dart';
import 'progression_quiz_screen.dart';

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

class SelectionNiveauQuizScreen extends StatefulWidget {
  const SelectionNiveauQuizScreen({super.key});

  @override
  State<SelectionNiveauQuizScreen> createState() => _SelectionNiveauQuizScreenState();
}

class _SelectionNiveauQuizScreenState extends State<SelectionNiveauQuizScreen>
    with TickerProviderStateMixin {
  final QuizService _quizService = quizService;
  final QuizCacheService _cache = QuizCacheService.instance;

  QuizAujourdhuiResponse? _quizData;
  QuizProgressionResponse? _progression;
  bool _loading = true;
  bool _loadingFromCache = false; // Indique si on affiche des données en cache
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

    // Animations en cascade pour les 3 cartes
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

    _chargerQuiz();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _chargerQuiz({bool forceRefresh = false}) async {
    // Charger depuis le cache d'abord si disponible
    if (!forceRefresh) {
      final cachedQuizData = _cache.getQuizData();
      final cachedProgression = _cache.getProgression();
      
      if (cachedQuizData != null || cachedProgression != null) {
        setState(() {
          _quizData = cachedQuizData;
          _progression = cachedProgression;
          _loading = false;
          _loadingFromCache = true; // On affiche les données en cache
        });
        
        if (_quizData != null || _progression != null) {
          _animationController.forward();
        }
        
        // Recharger en arrière-plan pour mettre à jour
        _chargerQuizEnArrierePlan();
        return;
      }
    }

    // Pas de cache ou refresh forcé
    setState(() {
      _loading = true;
      _loadingFromCache = false;
      _errorMessage = null;
    });

    try {
      // Charger les quiz et la progression en parallèle
      final results = await Future.wait([
        _quizService.obtenirTousQuizAujourdhui(),
        _quizService.obtenirProgression(),
      ]);

      final quizData = results[0] as QuizAujourdhuiResponse?;
      final progression = results[1] as QuizProgressionResponse?;

      // Mettre en cache
      _cache.setQuizData(quizData);
      _cache.setProgression(progression);

      setState(() {
        _quizData = quizData;
        _progression = progression;
        _loading = false;
        _loadingFromCache = false;
      });
      
      if (_quizData != null || _progression != null) {
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

  // Recharger en arrière-plan sans bloquer l'UI (avec debounce)
  Future<void> _chargerQuizEnArrierePlan() async {
    // Debounce : éviter les rechargements trop fréquents
    final now = DateTime.now();
    if (_lastRefreshTime != null && 
        now.difference(_lastRefreshTime!) < _minRefreshInterval) {
      return; // Ignorer si le dernier refresh était trop récent
    }
    _lastRefreshTime = now;
    
    try {
      // Utiliser un timeout plus court pour les rechargements en arrière-plan
      List<dynamic> results;
      try {
        results = await Future.wait([
          _quizService.obtenirTousQuizAujourdhui(),
          _quizService.obtenirProgression(),
        ]).timeout(const Duration(seconds: 10));
      } on TimeoutException {
        // En cas de timeout, garder les données actuelles
        return;
      }

      final quizData = results[0] as QuizAujourdhuiResponse?;
      final progression = results[1] as QuizProgressionResponse?;

      // Mettre en cache seulement si les données sont valides
      if (quizData != null) {
        _cache.setQuizData(quizData);
      }
      if (progression != null) {
        _cache.setProgression(progression);
      }

      // Mettre à jour silencieusement si le widget est toujours monté
      if (mounted) {
        setState(() {
          if (quizData != null) _quizData = quizData;
          if (progression != null) _progression = progression;
          _loadingFromCache = false;
        });
      }
    } catch (e) {
      // Erreur silencieuse en arrière-plan - on garde les données en cache
      if (kDebugMode) {
        print('⚠️ Erreur lors du rechargement en arrière-plan: $e');
      }
    }
  }

  /// Vérifie si un niveau est débloqué
  /// FACILE est TOUJOURS débloqué (hardcodé)
  bool _estNiveauDebloque(QuizNiveau niveau) {
    // FACILE est TOUJOURS débloqué - hardcoder true
    if (niveau == QuizNiveau.facile) {
      return true; // ← Toujours true
    }
    
    // Pour MOYEN et DIFFICILE, vérifier dans la progression
    final statut = _getStatutNiveau(niveau);
    return statut?.estDebloque ?? false;
  }

  QuizNiveauStatut? _getStatutNiveau(QuizNiveau niveau) {
    // Priorité 1: Utiliser les données de progression si disponibles
    if (_progression != null) {
      final progressionNiveau = _progression!.getProgressionNiveau(niveau);
      if (progressionNiveau != null) {
        // S'assurer que FACILE est toujours débloqué
        if (niveau == QuizNiveau.facile) {
          return QuizNiveauStatut(
            niveau: niveau,
            estDebloque: true, // Force FACILE à être débloqué
            estComplete: progressionNiveau.estNiveauActuel,
            quizCompletes: progressionNiveau.quizCompletes,
            quizRequisPourDebloquer: 25,
          );
        }
        return QuizNiveauStatut(
          niveau: niveau,
          estDebloque: progressionNiveau.estDebloque,
          estComplete: progressionNiveau.estNiveauActuel,
          quizCompletes: progressionNiveau.quizCompletes,
          quizRequisPourDebloquer: 25,
          score: progressionNiveau.meilleurScore, // Utiliser 'score' au lieu de 'meilleurScore'
        );
      }
    }
    
    // Priorité 2: Utiliser les données des quiz
    if (_quizData?.niveauxStatuts != null) {
      final statut = _quizData!.niveauxStatuts!.firstWhere(
        (s) => s.niveau == niveau,
        orElse: () => QuizNiveauStatut(
          niveau: niveau,
          estDebloque: niveau == QuizNiveau.facile, // Facile toujours débloqué
          estComplete: false,
        ),
      );
      
      // S'assurer que FACILE est toujours débloqué
      if (niveau == QuizNiveau.facile && !statut.estDebloque) {
        return QuizNiveauStatut(
          niveau: niveau,
          estDebloque: true, // Force FACILE à être débloqué
          estComplete: statut.estComplete,
          score: statut.score,
          nombreBonnesReponses: statut.nombreBonnesReponses,
          nombreQuestions: statut.nombreQuestions,
          quizCompletes: statut.quizCompletes,
          quizRequisPourDebloquer: statut.quizRequisPourDebloquer ?? 25,
        );
      }
      
      return statut;
    }
    
    // Par défaut: FACILE est toujours débloqué
    if (niveau == QuizNiveau.facile) {
      return QuizNiveauStatut(
        niveau: niveau,
        estDebloque: true,
        estComplete: false,
        quizRequisPourDebloquer: 25,
      );
    }
    
    return null;
  }

  void _selectionnerNiveau(QuizNiveau niveau) async {
    // Vérifier le déblocage avec la méthode dédiée
    if (!_estNiveauDebloque(niveau)) {
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.lock, color: Colors.white),
              SizedBox(width: 12),
              Text('Ce niveau est verrouillé. Complétez le niveau précédent !'),
            ],
          ),
          backgroundColor: DuolingoColors.primaryOrange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    HapticFeedback.lightImpact();
    
    // Récupérer le statut pour l'afficher
    final statut = _getStatutNiveau(niveau);
    
    // Naviguer vers la liste des quiz du niveau
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListeQuizNiveauScreen(
          niveau: niveau,
          statut: statut,
        ),
      ),
    ).then((_) {
      // Recharger après retour pour mettre à jour les statuts
      _chargerQuiz();
    });
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(DuolingoColors.primaryGreen),
              ),
              const SizedBox(height: 24),
              Text(
                'Chargement des quiz...',
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
                  onPressed: _chargerQuiz,
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

    if (_quizData == null) {
      return Scaffold(
        backgroundColor: DuolingoColors.backgroundLight,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.quiz_outlined,
                  size: 80,
                  color: DuolingoColors.primaryBlue,
                ),
                const SizedBox(height: 24),
                Text(
                  'Aucun quiz disponible aujourd\'hui',
                  style: TextStyle(
                    color: DuolingoColors.textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _chargerQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DuolingoColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Actualiser'),
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
          'Quiz du Jour',
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
            icon: const Icon(Icons.trending_up),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProgressionQuizScreen(),
                ),
              ).then((_) {
                // Recharger après retour pour mettre à jour les statuts
                _chargerQuiz();
              });
            },
            tooltip: 'Voir ma progression',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre
              Text(
                'Choisissez votre niveau',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: DuolingoColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Complétez chaque niveau pour débloquer le suivant',
                style: TextStyle(
                  fontSize: 16,
                  color: DuolingoColors.textLight,
                ),
              ),
              const SizedBox(height: 32),

              // Cartes des niveaux
              ...QuizNiveau.values.asMap().entries.map((entry) {
                final index = entry.key;
                final niveau = entry.value;
                final statut = _getStatutNiveau(niveau);
                final estDebloque = _estNiveauDebloque(niveau); // Utiliser la méthode dédiée
                final estComplete = statut?.estComplete ?? false;
                final couleur = _getCouleurNiveau(niveau);

                return AnimatedBuilder(
                  animation: _cardAnimations[index],
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - _cardAnimations[index].value)),
                      child: Opacity(
                        opacity: _cardAnimations[index].value,
                        child: _buildNiveauCard(
                          niveau: niveau,
                          statut: statut,
                          estDebloque: estDebloque,
                          estComplete: estComplete,
                          couleur: couleur,
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
    );
  }

  Widget _buildNiveauCard({
    required QuizNiveau niveau,
    required QuizNiveauStatut? statut,
    required bool estDebloque,
    required bool estComplete,
    required Color couleur,
  }) {
    final icon = _getIconNiveau(niveau);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: estDebloque ? () => _selectionnerNiveau(niveau) : null,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: estDebloque ? Colors.white : DuolingoColors.lockedGray.withOpacity(0.3),
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
            child: Row(
              children: [
                // Icône du niveau
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: estDebloque
                        ? couleur.withOpacity(0.15)
                        : DuolingoColors.lockedGray.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    estDebloque ? icon : Icons.lock,
                    size: 35,
                    color: estDebloque ? couleur : DuolingoColors.lockedGray,
                  ),
                ),
                const SizedBox(width: 20),
                // Informations
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
                          if (estComplete) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.check_circle,
                              size: 20,
                              color: DuolingoColors.primaryGreen,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (estDebloque && statut != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (statut.quizCompletes != null) ...[
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 16,
                                    color: couleur,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${statut.quizCompletes}/25 quiz complétés',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: DuolingoColors.textLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: statut.pourcentageProgression,
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation<Color>(couleur),
                                  minHeight: 6,
                                ),
                              ),
                            ] else if (statut.score != null) ...[
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: DuolingoColors.primaryOrange,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${statut.score} points',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: DuolingoColors.textLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        )
                      else if (!estDebloque)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Verrouillé',
                              style: TextStyle(
                                fontSize: 14,
                                color: DuolingoColors.lockedGray,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Complétez 25 quiz du niveau précédent',
                              style: TextStyle(
                                fontSize: 12,
                                color: DuolingoColors.lockedGray,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                // Flèche ou cadenas
                Icon(
                  estDebloque ? Icons.arrow_forward_ios : Icons.lock,
                  color: estDebloque ? couleur : DuolingoColors.lockedGray,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

