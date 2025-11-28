// ========================================================================================
// STATISTIQUES QUIZ SCREEN - Écran affichant les statistiques de l'utilisateur
// ========================================================================================

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/quiz_service.dart';
import '../../models/quiz_models.dart';

class StatistiquesQuizScreen extends StatefulWidget {
  const StatistiquesQuizScreen({super.key});

  @override
  State<StatistiquesQuizScreen> createState() => _StatistiquesQuizScreenState();
}

class _StatistiquesQuizScreenState extends State<StatistiquesQuizScreen> {
  final QuizService _quizService = quizService;

  QuizStatistiqueResponse? _stats;
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _chargerStatistiques();
  }

  Future<void> _chargerStatistiques() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final stats = await _quizService.obtenirStatistiques();
      setState(() {
        _stats = stats;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = 'Erreur lors du chargement des statistiques: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    if (_loading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text('Mes Statistiques'),
          backgroundColor: backgroundColor,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text('Mes Statistiques'),
          backgroundColor: backgroundColor,
          elevation: 0,
        ),
        body: Center(
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
                style: TextStyle(color: textColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _chargerStatistiques,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    if (_stats == null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text('Mes Statistiques'),
          backgroundColor: backgroundColor,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart_outlined,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'Aucune statistique disponible',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Mes Statistiques'),
        backgroundColor: backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _chargerStatistiques,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _chargerStatistiques,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec nom
              if (_stats!.citoyenNom != null || _stats!.citoyenPrenom != null)
                Card(
                  color: Colors.blue.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child: Text(
                            '${_stats!.citoyenNom?.substring(0, 1) ?? ''}${_stats!.citoyenPrenom?.substring(0, 1) ?? ''}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_stats!.citoyenNom ?? ''} ${_stats!.citoyenPrenom ?? ''}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              if (_stats!.positionClassement != null)
                                Text(
                                  'Position: #${_stats!.positionClassement}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Statistiques principales
              Text(
                'Statistiques',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),

              _buildStatCard(
                context,
                'Points totaux',
                '${_stats!.totalPoints ?? 0}',
                Icons.stars,
                Colors.amber,
              ),
              _buildStatCard(
                context,
                'Quiz complétés',
                '${_stats!.totalQuizCompletes ?? 0}',
                Icons.quiz,
                Colors.blue,
              ),
              _buildStatCard(
                context,
                'Streak actuel',
                '${_stats!.streakJours ?? 0} jours',
                Icons.local_fire_department,
                Colors.orange,
              ),
              _buildStatCard(
                context,
                'Meilleur streak',
                '${_stats!.meilleurStreak ?? 0} jours',
                Icons.emoji_events,
                Colors.purple,
              ),

              // Badges
              if (_stats!.badgeExpert == true || _stats!.badgeStreakMaster == true) ...[
                const SizedBox(height: 24),
                Text(
                  'Badges',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 16),
                if (_stats!.badgeExpert == true)
                  _buildBadgeCard(
                    context,
                    '🏆 Expert',
                    'Vous avez débloqué le badge Expert!',
                    Colors.amber,
                  ),
                if (_stats!.badgeStreakMaster == true)
                  _buildBadgeCard(
                    context,
                    '🔥 Streak Master',
                    'Vous avez débloqué le badge Streak Master!',
                    Colors.orange,
                  ),
              ],

              // Dernière participation
              if (_stats!.derniereParticipation != null) ...[
                const SizedBox(height: 24),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text('Dernière participation'),
                    subtitle: Text(_formatDate(_stats!.derniereParticipation!)),
                  ),
                ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          label,
          style: TextStyle(color: textColor),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeCard(
    BuildContext context,
    String titre,
    String description,
    Color color,
  ) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.verified,
              color: color,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titre,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
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

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}



