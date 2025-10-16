import 'package:flutter/material.dart';
import '../../views/report/report_problem_screen.dart';

/// Classe globale pour la gestion du signalement
/// 
/// Cette classe permet d'accéder aux fonctionnalités de signalement 
/// depuis n'importe où dans l'application via une méthode statique.
class GlobalReportAccess {
  /// Affiche un dialogue de confirmation pour signaler un problème
  /// 
  /// Cette méthode peut être appelée depuis n'importe quel écran de l'application
  /// 
  /// [context] Le contexte de l'écran appelant
  static void showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Signaler un problème'),
          content: const Text('Voulez-vous signaler un problème ou faire une suggestion ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ReportProblemScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Continuer'),
            ),
          ],
        );
      },
    );
  }
}

