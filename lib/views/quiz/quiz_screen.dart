// ========================================================================================
// QUIZ SCREEN - Écran principal pour participer au quiz du jour
// Design inspiré de Duolingo avec couleurs vives et animations fluides
// ========================================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/quiz_service.dart';
import '../../models/quiz_models.dart';
import 'resultat_quiz_screen.dart';

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

class QuizScreen extends StatefulWidget {
  final QuizNiveau? niveau;
  final QuizJournalierResponse? quiz;

  const QuizScreen({
    super.key,
    this.niveau,
    this.quiz,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  final QuizService _quizService = quizService;

  QuizJournalierResponse? _quiz;
  bool _loading = true;
  int _currentQuestionIndex = 0;
  Map<int, int> _reponsesChoisies = {}; // questionId -> reponseId
  DateTime? _startTime;
  String? _errorMessage;
  bool _quizDejaComplete = false; // Flag pour indiquer si le quiz est déjà complété
  
  // Animations
  late AnimationController _progressController;
  late AnimationController _buttonController;
  late Animation<double> _buttonScaleAnimation;
  
  // Couleurs pour les boutons de réponse
  final List<Color> _answerColors = [
    DuolingoColors.primaryBlue,
    DuolingoColors.primaryGreen,
    DuolingoColors.primaryOrange,
    DuolingoColors.primaryPurple,
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
    
    // Si un quiz est passé en paramètre, l'utiliser directement
    if (widget.quiz != null) {
      setState(() {
        _quiz = widget.quiz;
        _loading = false;
        _startTime = DateTime.now();
      });
      _progressController.forward();
    } else {
      _chargerQuiz();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> _chargerQuiz() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final quiz = await _quizService.obtenirQuizAujourdhui();
      setState(() {
        _quiz = quiz;
        _loading = false;
        if (quiz != null) {
          _startTime = DateTime.now();
          _progressController.forward();
        }
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = 'Erreur lors du chargement du quiz: $e';
      });
    }
  }

  void _selectionnerReponse(int questionId, int reponseId) {
    // Vibration haptique pour feedback
    HapticFeedback.lightImpact();
    
    setState(() {
      _reponsesChoisies[questionId] = reponseId;
    });
    
    // Animation du bouton
    _buttonController.forward().then((_) {
      _buttonController.reverse();
    });
  }

  Future<void> _soumettreQuiz() async {
    if (_quiz == null) return;

    final questions = _quiz!.questions ?? [];
    if (_reponsesChoisies.length != questions.length) {
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text('Veuillez répondre à toutes les questions'),
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

    if (_startTime == null) return;

    final tempsSecondes = DateTime.now().difference(_startTime!).inSeconds;

    final request = QuizParticipationRequest(
      quizJournalierId: _quiz!.id!,
      reponses: _reponsesChoisies.entries.map((e) => ReponseQuestion(
        questionId: e.key,
        reponseChoisieId: e.value,
      )).toList(),
      tempsSecondes: tempsSecondes,
    );

    try {
      // Afficher un indicateur de chargement avec style Duolingo
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(DuolingoColors.primaryGreen),
                ),
                const SizedBox(height: 16),
                Text(
                  'Calcul de votre score...',
                  style: TextStyle(
                    color: DuolingoColors.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final resultat = await _quizService.participerAuQuiz(request);

      if (!mounted) return;

      Navigator.of(context).pop(); // Fermer le dialog de chargement

      if (resultat != null) {
        HapticFeedback.mediumImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultatQuizScreen(resultat: resultat),
          ),
        ).then((value) {
          // Retourner un signal pour indiquer que le quiz a été complété
          // Cela permettra de mettre à jour la progression
          Navigator.pop(context, 'quiz_completed');
        });
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Fermer le dialog de chargement
      
      // Vérifier si c'est l'erreur "quiz déjà complété"
      final errorMessage = e.toString();
      if (errorMessage.contains('déjà complété') || 
          errorMessage.contains('déjà complété ce quiz')) {
        setState(() {
          _quizDejaComplete = true;
        });
        HapticFeedback.mediumImpact();
        return;
      }
      
      // Autre erreur
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('Erreur lors de la soumission: $e')),
            ],
          ),
          backgroundColor: DuolingoColors.primaryRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _naviguerQuestion(int direction) {
    HapticFeedback.selectionClick();
    setState(() {
      _currentQuestionIndex += direction;
      _progressController.animateTo(
        (_currentQuestionIndex + 1) / (_quiz!.questions!.length),
      );
    });
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
                'Chargement du quiz...',
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
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: DuolingoColors.primaryRed.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: 40,
                    color: DuolingoColors.primaryRed,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: DuolingoColors.textDark,
                    fontSize: 16,
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
                    elevation: 0,
                  ),
                  child: const Text(
                    'Réessayer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Écran si le quiz est déjà complété
    if (_quizDejaComplete) {
      return Scaffold(
        backgroundColor: DuolingoColors.backgroundLight,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icône de succès
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: DuolingoColors.primaryGreen.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 70,
                      color: DuolingoColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Message
                  Text(
                    'Quiz déjà complété ! 🎉',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: DuolingoColors.textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Vous avez déjà complété le quiz du jour.\nRevenez demain pour un nouveau défi !',
                    style: TextStyle(
                      fontSize: 16,
                      color: DuolingoColors.textLight,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  
                  // Bouton pour voir les statistiques
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                        // TODO: Naviguer vers les statistiques si nécessaire
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DuolingoColors.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Retour',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (_quiz == null || _quiz!.questions == null || _quiz!.questions!.isEmpty) {
      return Scaffold(
        backgroundColor: DuolingoColors.backgroundLight,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: DuolingoColors.primaryBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.quiz_outlined,
                    size: 50,
                    color: DuolingoColors.primaryBlue,
                  ),
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
                    elevation: 0,
                  ),
                  child: const Text(
                    'Actualiser',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final questions = _quiz!.questions!;
    final question = questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      backgroundColor: DuolingoColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec barre de progression Duolingo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                children: [
                  // Compteur de questions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: DuolingoColors.textLight),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: DuolingoColors.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_currentQuestionIndex + 1}/${questions.length}',
                          style: TextStyle(
                            color: DuolingoColors.primaryGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // Espace pour équilibrer
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Barre de progression Duolingo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(DuolingoColors.primaryGreen),
                          minHeight: 8,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Contenu de la question
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge catégorie/procédure (style Duolingo)
                    if (_quiz!.categorieTitre != null || _quiz!.procedureNom != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: DuolingoColors.primaryBlue.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: DuolingoColors.primaryBlue.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.school,
                              size: 18,
                              color: DuolingoColors.primaryBlue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _quiz!.procedureNom ?? _quiz!.categorieTitre ?? '',
                              style: TextStyle(
                                color: DuolingoColors.primaryBlue,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Question (grande et claire)
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // En-tête avec numéro de question et points
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Numéro de question
                              if (question.ordre != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: DuolingoColors.primaryGreen.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        size: 16,
                                        color: DuolingoColors.primaryGreen,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Question ${question.ordre}',
                                        style: TextStyle(
                                          color: DuolingoColors.primaryGreen,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              // Points
                              if (question.points != null)
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 18,
                                      color: DuolingoColors.primaryOrange,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${question.points} pts',
                                      style: TextStyle(
                                        color: DuolingoColors.primaryOrange,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Texte de la question
                          Text(
                            question.question ?? '',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: DuolingoColors.textDark,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Réponses (boutons Duolingo style)
                    ...(question.reponses ?? []).asMap().entries.map((entry) {
                      final index = entry.key;
                      final reponse = entry.value;
                      final isSelected = _reponsesChoisies[question.id] == reponse.id;
                      final color = _answerColors[index % _answerColors.length];

                      return AnimatedBuilder(
                        animation: _buttonScaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: isSelected ? _buttonScaleAnimation.value : 1.0,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _selectionnerReponse(
                                    question.id!,
                                    reponse.id!,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? color
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected
                                            ? color
                                            : Colors.grey[300]!,
                                        width: isSelected ? 3 : 2,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: color.withOpacity(0.3),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.05),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            reponse.reponse ?? '',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? Colors.white
                                                  : DuolingoColors.textDark,
                                            ),
                                          ),
                                        ),
                                        if (isSelected)
                                          Container(
                                            margin: const EdgeInsets.only(left: 12),
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.3),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
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

            // Barre de navigation Duolingo
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bouton précédent
                  if (_currentQuestionIndex > 0)
                    ElevatedButton.icon(
                      onPressed: () => _naviguerQuestion(-1),
                      icon: const Icon(Icons.arrow_back, size: 20),
                      label: const Text('Précédent'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: DuolingoColors.textDark,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  
                  // Bouton suivant/terminer
                  if (_currentQuestionIndex < questions.length - 1)
                    ElevatedButton.icon(
                      onPressed: () => _naviguerQuestion(1),
                      icon: const Icon(Icons.arrow_forward, size: 20),
                      label: const Text('Suivant'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DuolingoColors.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: _soumettreQuiz,
                      icon: const Icon(Icons.check_circle, size: 20),
                      label: const Text('Terminer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DuolingoColors.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
