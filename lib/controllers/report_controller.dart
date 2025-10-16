// ========================================================================================
// CONTRÔLEUR SIGNALEMENT - MVC Pattern
// ========================================================================================
// Ce fichier contient la logique métier pour la gestion des signalements
// Il gère les fonctionnalités de signalement de problèmes
// ========================================================================================

import 'package:flutter/material.dart';
import '../views/report/report_problem_screen.dart';

class ReportController {
  static final ReportController _instance = ReportController._internal();
  factory ReportController() => _instance;
  ReportController._internal();

  // ========================================================================================
  // MÉTHODES DE SIGNALEMENT
  // ========================================================================================

  /// Affiche un dialogue de confirmation pour signaler un problème
  /// Cette méthode peut être appelée depuis n'importe quel écran de l'application
  /// 
  /// @param context Le contexte de l'écran appelant
  static void showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Titre du dialogue
          title: const Text('Signaler un problème'),
          // Message de confirmation
          content: const Text('Voulez-vous signaler un problème ou faire une suggestion ?'),
          actions: [
            // Bouton d'annulation - ferme le dialogue sans action
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le dialogue
              },
              child: const Text('Annuler'),
            ),
            // Bouton de confirmation - navigue vers l'écran de signalement
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le dialogue actuel
                // Navigue vers l'écran de signalement de problème
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ReportProblemScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,  // Couleur verte FasoDocs
                foregroundColor: Colors.white,
              ),
              child: const Text('Continuer'),
            ),
          ],
        );
      },
    );
  }

  /// Soumet un signalement de problème
  Future<bool> submitReport({
    required String title,
    required String description,
    required String category,
    String? userEmail,
    String? userPhone,
  }) async {
    try {
      // Simulation de la soumission du signalement
      await Future.delayed(const Duration(seconds: 2));
      
      // Dans une vraie application, vous feriez un appel API ici
      print('Signalement soumis: $title - $description');
      
      return true;
    } catch (e) {
      print('Erreur lors de la soumission du signalement: $e');
      return false;
    }
  }

  /// Valide les données du signalement
  bool validateReportData({
    required String title,
    required String description,
    required String category,
  }) {
    if (title.trim().isEmpty) return false;
    if (description.trim().isEmpty) return false;
    if (category.trim().isEmpty) return false;
    if (title.length < 5) return false;
    if (description.length < 10) return false;
    
    return true;
  }

  /// Obtient les catégories de signalement disponibles
  List<String> getReportCategories() {
    return [
      'Bug de l\'application',
      'Problème de navigation',
      'Erreur de données',
      'Problème de performance',
      'Suggestion d\'amélioration',
      'Problème d\'authentification',
      'Autre',
    ];
  }
}
