// ========================================================================================
// RESULTAT QUIZ SCREEN - Écran affichant les résultats du quiz
// Design inspiré de Duolingo avec animations et couleurs vives
// ========================================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/quiz_models.dart';
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
}

class ResultatQuizScreen extends StatefulWidget {
  final QuizParticipationResponse resultat;

  const ResultatQuizScreen({
    super.key,
    required this.resultat,
  });

  @override
  State<ResultatQuizScreen> createState() => _ResultatQuizScreenState();
}

class _ResultatQuizScreenState extends State<ResultatQuizScreen>
    with TickerProviderStateMixin {
  late AnimationController _scoreController;
  late AnimationController _progressController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animation du score
    _scoreController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scoreAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _scoreController,
        curve: Curves.elasticOut,
      ),
    );

    // Animation de la barre de progression
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeOut,
      ),
    );

    // Démarrer les animations
    _scoreController.forward();
    _progressController.forward();
    
    // Vibration de succès
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Color _getScoreColor(int pourcentage) {
    if (pourcentage >= 80) return DuolingoColors.primaryGreen;
    if (pourcentage >= 60) return DuolingoColors.primaryBlue;
    if (pourcentage >= 40) return DuolingoColors.primaryOrange;
    return DuolingoColors.primaryRed;
  }

  String _getMessage(int pourcentage) {
    if (pourcentage >= 80) return 'Excellent travail ! 🎉';
    if (pourcentage >= 60) return 'Bon score ! 👍';
    if (pourcentage >= 40) return 'Pas mal, continuez ! 💪';
    return 'Continuez à vous améliorer ! 📚';
  }

  IconData _getIcon(int pourcentage) {
    if (pourcentage >= 80) return Icons.emoji_events;
    if (pourcentage >= 60) return Icons.thumb_up;
    if (pourcentage >= 40) return Icons.trending_up;
    return Icons.school;
  }

  @override
  Widget build(BuildContext context) {
    final nombreQuestions = widget.resultat.nombreQuestions ?? 0;
    final nombreBonnesReponses = widget.resultat.nombreBonnesReponses ?? 0;
    final pourcentage = nombreQuestions > 0
        ? (nombreBonnesReponses / nombreQuestions * 100).round()
        : 0;

    final scoreColor = _getScoreColor(pourcentage);
    final message = _getMessage(pourcentage);
    final icon = _getIcon(pourcentage);

    return Scaffold(
      backgroundColor: DuolingoColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header avec bouton fermer
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: DuolingoColors.textLight),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Icône de résultat animée
              AnimatedBuilder(
                animation: _scoreAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scoreAnimation.value,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: scoreColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 70,
                        color: scoreColor,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Message
              Text(
                message,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: DuolingoColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Score principal avec animation
              AnimatedBuilder(
                animation: _scoreAnimation,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: scoreColor.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${widget.resultat.score ?? 0}',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: scoreColor,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'points',
                          style: TextStyle(
                            fontSize: 18,
                            color: DuolingoColors.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),

              // Barre de progression Duolingo style
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Score',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: DuolingoColors.textDark,
                          ),
                        ),
                        Text(
                          '$pourcentage%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: scoreColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: (pourcentage / 100) * _progressAnimation.value,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                            minHeight: 12,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Détails dans des cartes Duolingo style
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildDetailCard(
                      icon: Icons.check_circle,
                      label: 'Bonnes réponses',
                      value: '$nombreBonnesReponses/$nombreQuestions',
                      color: DuolingoColors.primaryGreen,
                    ),
                    const SizedBox(height: 16),
                    if (widget.resultat.tempsSecondes != null)
                      _buildDetailCard(
                        icon: Icons.timer,
                        label: 'Temps',
                        value: _formatTemps(widget.resultat.tempsSecondes!),
                        color: DuolingoColors.primaryOrange,
                      ),
                  ],
                ),
              ),

              // Détails des réponses si disponibles
              if (widget.resultat.reponses != null &&
                  widget.resultat.reponses!.isNotEmpty) ...[
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Détails des réponses',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: DuolingoColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...widget.resultat.reponses!.map((reponse) {
                        return _buildReponseDetailCard(reponse);
                      }).toList(),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Boutons d'action
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Bouton voir progression
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProgressionQuizScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.trending_up),
                        label: const Text(
                          'Voir ma progression',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DuolingoColors.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Bouton retour
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: DuolingoColors.primaryGreen,
                          side: BorderSide(color: DuolingoColors.primaryGreen, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
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
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: DuolingoColors.textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReponseDetailCard(QuizReponseUtilisateurResponse reponse) {
    final isCorrect = reponse.estCorrecte == true;
    final color = isCorrect ? DuolingoColors.primaryGreen : DuolingoColors.primaryRed;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCorrect ? Icons.check : Icons.close,
                  color: color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  reponse.question ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: DuolingoColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Votre réponse:',
                  style: TextStyle(
                    fontSize: 12,
                    color: DuolingoColors.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reponse.reponseChoisie ?? 'N/A',
                  style: TextStyle(
                    fontSize: 14,
                    color: DuolingoColors.textDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (!isCorrect && reponse.reponseCorrecte != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: DuolingoColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bonne réponse:',
                    style: TextStyle(
                      fontSize: 12,
                      color: DuolingoColors.textLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reponse.reponseCorrecte!,
                    style: TextStyle(
                      fontSize: 14,
                      color: DuolingoColors.primaryGreen,
                      fontWeight: FontWeight.bold,
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

  String _formatTemps(int secondes) {
    final minutes = secondes ~/ 60;
    final secs = secondes % 60;
    if (minutes > 0) {
      return '${minutes}m ${secs}s';
    }
    return '${secs}s';
  }
}
