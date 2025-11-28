// ========================================================================================
// LISTE QUIZ NIVEAU SCREEN - Écran pour choisir parmi les quiz disponibles d'un niveau
// Design inspiré de Duolingo
// ========================================================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/quiz_service.dart';
import '../../core/services/quiz_cache_service.dart';
import '../../models/quiz_models.dart';
import 'quiz_screen.dart';

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
}

class ListeQuizNiveauScreen extends StatefulWidget {
  final QuizNiveau niveau;
  final QuizNiveauStatut? statut;

  const ListeQuizNiveauScreen({
    super.key,
    required this.niveau,
    this.statut,
  });

  @override
  State<ListeQuizNiveauScreen> createState() => _ListeQuizNiveauScreenState();
}

class _ListeQuizNiveauScreenState extends State<ListeQuizNiveauScreen> {
  final QuizService _quizService = quizService;
  final QuizCacheService _cache = QuizCacheService.instance;

  List<QuizJournalierResponse> _quiz = [];
  QuizNiveauStatut? _statutActuel; // Statut local qui se met à jour
  bool _loading = true;
  bool _loadingFromCache = false; // Indique si on affiche des données en cache
  String? _errorMessage;
  
  // Debounce pour éviter les rechargements trop fréquents
  DateTime? _lastRefreshTime;
  static const Duration _minRefreshInterval = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _statutActuel = widget.statut; // Initialiser avec le statut passé
    _chargerQuiz();
  }

  Future<void> _chargerQuiz({bool forceRefresh = false}) async {
    // Charger depuis le cache d'abord si disponible
    if (!forceRefresh) {
      final cachedQuiz = _cache.getQuizParNiveau(widget.niveau.code);
      final cachedProgression = _cache.getProgression();
      
      if (cachedQuiz != null || cachedProgression != null) {
        // Mettre à jour le statut avec les données en cache
        if (cachedProgression != null) {
          final progressionNiveau = cachedProgression.getProgressionNiveau(widget.niveau);
          if (progressionNiveau != null) {
            _statutActuel = QuizNiveauStatut(
              niveau: widget.niveau,
              estDebloque: widget.niveau == QuizNiveau.facile || progressionNiveau.estDebloque,
              estComplete: progressionNiveau.estNiveauActuel,
              quizCompletes: progressionNiveau.quizCompletes,
              quizRequisPourDebloquer: 25,
              score: progressionNiveau.meilleurScore,
            );
          }
        }
        
        setState(() {
          _quiz = cachedQuiz ?? [];
          _loading = false;
          _loadingFromCache = true; // On affiche les données en cache
        });
        
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
        _quizService.obtenirQuizParNiveau(widget.niveau.code),
        _quizService.obtenirProgression(),
      ]);

      final quiz = results[0] as List<QuizJournalierResponse>;
      final progression = results[1] as QuizProgressionResponse?;

      // Mettre en cache
      _cache.setQuizParNiveau(widget.niveau.code, quiz);
      _cache.setProgression(progression);

      // Mettre à jour le statut avec les nouvelles données de progression
      if (progression != null) {
        final progressionNiveau = progression.getProgressionNiveau(widget.niveau);
        if (progressionNiveau != null) {
          _statutActuel = QuizNiveauStatut(
            niveau: widget.niveau,
            estDebloque: widget.niveau == QuizNiveau.facile || progressionNiveau.estDebloque,
            estComplete: progressionNiveau.estNiveauActuel,
            quizCompletes: progressionNiveau.quizCompletes,
            quizRequisPourDebloquer: 25,
            score: progressionNiveau.meilleurScore,
          );
        }
      }

      setState(() {
        _quiz = quiz;
        _loading = false;
        _loadingFromCache = false;
      });
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
          _quizService.obtenirQuizParNiveau(widget.niveau.code),
          _quizService.obtenirProgression(),
        ]).timeout(const Duration(seconds: 10));
      } on TimeoutException {
        // En cas de timeout, garder les données actuelles
        return;
      }

      final quiz = results[0] as List<QuizJournalierResponse>;
      final progression = results[1] as QuizProgressionResponse?;

      // Mettre en cache seulement si les données sont valides
      if (quiz.isNotEmpty) {
        _cache.setQuizParNiveau(widget.niveau.code, quiz);
      }
      if (progression != null) {
        _cache.setProgression(progression);
      }

      // Mettre à jour le statut
      if (progression != null) {
        final progressionNiveau = progression.getProgressionNiveau(widget.niveau);
        if (progressionNiveau != null) {
          _statutActuel = QuizNiveauStatut(
            niveau: widget.niveau,
            estDebloque: widget.niveau == QuizNiveau.facile || progressionNiveau.estDebloque,
            estComplete: progressionNiveau.estNiveauActuel,
            quizCompletes: progressionNiveau.quizCompletes,
            quizRequisPourDebloquer: 25,
            score: progressionNiveau.meilleurScore,
          );
        }
      }

      // Mettre à jour silencieusement si le widget est toujours monté
      if (mounted) {
        setState(() {
          if (quiz.isNotEmpty) _quiz = quiz;
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

  void _selectionnerQuiz(QuizJournalierResponse quiz) async {
    HapticFeedback.lightImpact();
    
    // Attendre le retour du quiz et recharger les données
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          niveau: widget.niveau,
          quiz: quiz,
        ),
      ),
    );
    
    // Si un quiz a été complété, recharger la progression
    if (result == 'quiz_completed') {
      HapticFeedback.mediumImpact();
      
      // Invalider seulement la progression (pas tous les quiz)
      _cache.invalidateProgression();
      
      // Recharger uniquement la progression en arrière-plan (plus rapide)
      _chargerProgressionSeulement();
      
      // Afficher un message de succès immédiatement
      if (mounted && _statutActuel != null) {
        final ancienCompletes = _statutActuel!.quizCompletes ?? 0;
        final nouveauCompletes = ancienCompletes + 1; // Estimation
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Progression: $nouveauCompletes/25 quiz complétés',
                  ),
                ),
              ],
            ),
            backgroundColor: DuolingoColors.primaryGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // Recharger uniquement la progression (plus rapide que tout recharger)
  Future<void> _chargerProgressionSeulement() async {
    try {
      final progression = await _quizService.obtenirProgression();
      _cache.setProgression(progression);
      
      if (progression != null && mounted) {
        final progressionNiveau = progression.getProgressionNiveau(widget.niveau);
        if (progressionNiveau != null) {
          setState(() {
            _statutActuel = QuizNiveauStatut(
              niveau: widget.niveau,
              estDebloque: widget.niveau == QuizNiveau.facile || progressionNiveau.estDebloque,
              estComplete: progressionNiveau.estNiveauActuel,
              quizCompletes: progressionNiveau.quizCompletes,
              quizRequisPourDebloquer: 25,
              score: progressionNiveau.meilleurScore,
            );
          });
        }
      }
    } catch (e) {
      // Erreur silencieuse, on garde les données actuelles
    }
  }

  Color _getCouleurNiveau() {
    switch (widget.niveau) {
      case QuizNiveau.facile:
        return DuolingoColors.primaryGreen;
      case QuizNiveau.moyen:
        return DuolingoColors.primaryBlue;
      case QuizNiveau.difficile:
        return DuolingoColors.primaryOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final couleur = _getCouleurNiveau();

    if (_loading) {
      return Scaffold(
        backgroundColor: DuolingoColors.backgroundLight,
        appBar: AppBar(
          title: Text('Quiz ${widget.niveau.label}'),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: DuolingoColors.textDark),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(couleur),
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
        appBar: AppBar(
          title: Text('Quiz ${widget.niveau.label}'),
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
                  onPressed: _chargerQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: couleur,
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

    return Scaffold(
      backgroundColor: DuolingoColors.backgroundLight,
      appBar: AppBar(
        title: Text('Quiz ${widget.niveau.label}'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: DuolingoColors.textDark),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header avec progression (utilise le statut mis à jour)
            if (_statutActuel != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progression',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: DuolingoColors.textDark,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${_statutActuel!.quizCompletes ?? 0}/25',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: couleur,
                              ),
                            ),
                            if (_loadingFromCache) ...[
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(couleur),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _statutActuel!.pourcentageProgression,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(couleur),
                        minHeight: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${((_statutActuel!.pourcentageProgression) * 100).round()}% complété',
                      style: TextStyle(
                        fontSize: 14,
                        color: DuolingoColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Liste des quiz
            Expanded(
              child: _quiz.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.quiz_outlined,
                              size: 80,
                              color: DuolingoColors.textLight,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Aucun quiz disponible',
                              style: TextStyle(
                                color: DuolingoColors.textDark,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _quiz.length,
                      itemBuilder: (context, index) {
                        final quiz = _quiz[index];
                        return _buildQuizCard(quiz, couleur, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard(
    QuizJournalierResponse quiz,
    Color couleur,
    int index,
  ) {
    final nombreQuestions = quiz.questions?.length ?? 0;
    final totalPoints = quiz.questions
            ?.fold(0, (sum, q) => sum + (q.points ?? 0)) ??
        0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectionnerQuiz(quiz),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: couleur.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: couleur.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Numéro du quiz
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: couleur.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: couleur,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Informations
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (quiz.procedureNom != null)
                        Text(
                          quiz.procedureNom!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: DuolingoColors.textDark,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      else if (quiz.categorieTitre != null)
                        Text(
                          quiz.categorieTitre!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: DuolingoColors.textDark,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.help_outline,
                            size: 16,
                            color: DuolingoColors.textLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$nombreQuestions questions',
                            style: TextStyle(
                              fontSize: 14,
                              color: DuolingoColors.textLight,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.star,
                            size: 16,
                            color: DuolingoColors.primaryOrange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$totalPoints points',
                            style: TextStyle(
                              fontSize: 14,
                              color: DuolingoColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Flèche
                Icon(
                  Icons.arrow_forward_ios,
                  color: couleur,
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

