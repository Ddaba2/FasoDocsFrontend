// ========================================================================================
// CLASSEMENT QUIZ SCREEN - Écran affichant le classement des utilisateurs
// ========================================================================================

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/quiz_service.dart';
import '../../models/quiz_models.dart';

class ClassementQuizScreen extends StatefulWidget {
  const ClassementQuizScreen({super.key});

  @override
  State<ClassementQuizScreen> createState() => _ClassementQuizScreenState();
}

class _ClassementQuizScreenState extends State<ClassementQuizScreen> {
  final QuizService _quizService = quizService;

  ClassementResponse? _classementHebdo;
  ClassementResponse? _classementMensuel;
  bool _loading = true;
  bool _showHebdo = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _chargerClassements();
  }

  Future<void> _chargerClassements() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final hebdo = await _quizService.obtenirClassementHebdomadaire();
      final mensuel = await _quizService.obtenirClassementMensuel();
      setState(() {
        _classementHebdo = hebdo;
        _classementMensuel = mensuel;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = 'Erreur lors du chargement du classement: $e';
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
          title: const Text('Classement'),
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
          title: const Text('Classement'),
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
                onPressed: _chargerClassements,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    final classement = _showHebdo ? _classementHebdo : _classementMensuel;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Classement'),
        backgroundColor: backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _chargerClassements,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: Column(
        children: [
          // Toggle hebdo/mensuel
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _showHebdo = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _showHebdo ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Hebdomadaire',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _showHebdo ? Colors.white : textColor,
                          fontWeight: _showHebdo ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _showHebdo = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_showHebdo ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Mensuel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !_showHebdo ? Colors.white : textColor,
                          fontWeight: !_showHebdo ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Liste du classement
          Expanded(
            child: classement == null || classement.classement == null || classement.classement!.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.leaderboard_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun classement disponible',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _chargerClassements,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: classement.classement!.length,
                      itemBuilder: (context, index) {
                        final stat = classement.classement![index];
                        final position = index + 1;

                        // Couleur pour le podium
                        Color? positionColor;
                        if (position == 1) {
                          positionColor = Colors.amber;
                        } else if (position == 2) {
                          positionColor = Colors.grey[400];
                        } else if (position == 3) {
                          positionColor = Colors.brown[300];
                        }

                        // Mettre en évidence la position de l'utilisateur
                        final isUserPosition = classement.positionUtilisateur != null &&
                            position == classement.positionUtilisateur;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          color: isUserPosition
                              ? Colors.blue.withOpacity(0.1)
                              : null,
                          elevation: isUserPosition ? 4 : 1,
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: positionColor ?? Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '$position',
                                  style: TextStyle(
                                    color: position <= 3 ? Colors.white : textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              '${stat.citoyenNom ?? ''} ${stat.citoyenPrenom ?? ''}',
                              style: TextStyle(
                                fontWeight: isUserPosition ? FontWeight.bold : FontWeight.normal,
                                color: textColor,
                              ),
                            ),
                            subtitle: Text(
                              '${stat.totalPoints ?? 0} points',
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.local_fire_department,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${stat.streakJours ?? 0}',
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (isUserPosition) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'Vous',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}



