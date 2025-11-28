// ========================================================================================
// QUIZ SERVICE - Service pour la gestion des quiz
// ========================================================================================

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_service.dart';
import '../config/api_config.dart';
import '../../models/quiz_models.dart';

class QuizService {
  final ApiService _apiService = apiService;

  // 1. Récupérer tous les quiz du jour avec statuts de déblocage
  Future<QuizAujourdhuiResponse?> obtenirTousQuizAujourdhui() async {
    try {
      if (kDebugMode) {
        print('🔍 Récupération de tous les quiz du jour avec statuts...');
      }

      final response = await _apiService.get(
        ApiConfig.quizAujourdhui,
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('✅ Quiz du jour récupérés avec succès');
        }
        return QuizAujourdhuiResponse.fromJson(response.data);
      } else {
        final errorMsg = response.data?['message'] ?? 'Erreur lors de la récupération des quiz';
        if (kDebugMode) {
          print('❌ Erreur: $errorMsg');
        }
        throw Exception(errorMsg);
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Erreur Dio lors de la récupération des quiz: $e');
      }
      if (e.response?.statusCode == 404) {
        // Pas de quiz disponible aujourd'hui
        return null;
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur lors de la récupération des quiz: $e');
      }
      rethrow;
    }
  }

  // 2. Récupérer la liste des quiz d'un niveau spécifique
  Future<List<QuizJournalierResponse>> obtenirQuizParNiveau(String niveau) async {
    try {
      if (kDebugMode) {
        print('🔍 Récupération des quiz niveau $niveau...');
      }

      final response = await _apiService.get(
        ApiConfig.quizAujourdhuiParNiveau(niveau.toUpperCase()),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('✅ Quiz niveau $niveau récupérés avec succès');
        }
        
        // Le backend retourne maintenant une liste
        if (response.data is List) {
          return (response.data as List)
              .map((q) => QuizJournalierResponse.fromJson(q))
              .toList();
        } else if (response.data is Map) {
          // Compatibilité avec l'ancien format (un seul quiz)
          return [QuizJournalierResponse.fromJson(response.data)];
        } else {
          return [];
        }
      } else {
        final errorMsg = response.data?['message'] ?? 'Erreur lors de la récupération des quiz';
        if (kDebugMode) {
          print('❌ Erreur: $errorMsg');
        }
        throw Exception(errorMsg);
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Erreur Dio lors de la récupération des quiz: $e');
      }
      if (e.response?.statusCode == 404) {
        // Pas de quiz disponible pour ce niveau
        return [];
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur lors de la récupération des quiz: $e');
      }
      rethrow;
    }
  }

  // Méthode de compatibilité (ancienne méthode)
  @Deprecated('Utilisez obtenirTousQuizAujourdhui() ou obtenirQuizParNiveau()')
  Future<QuizJournalierResponse?> obtenirQuizAujourdhui() async {
    final quizList = await obtenirQuizParNiveau('FACILE');
    return quizList.isNotEmpty ? quizList.first : null;
  }

  // 3. Participer à un quiz
  Future<QuizParticipationResponse?> participerAuQuiz(
    QuizParticipationRequest request,
  ) async {
    try {
      if (kDebugMode) {
        print('📝 Participation au quiz: ${request.quizJournalierId}');
      }

      final response = await _apiService.post(
        ApiConfig.quizParticiper,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print('✅ Participation enregistrée avec succès');
        }
        return QuizParticipationResponse.fromJson(response.data);
      } else {
        // Extraire le message d'erreur du backend
        String errorMsg = 'Erreur lors de la participation';
        if (response.data != null) {
          if (response.data is Map) {
            errorMsg = response.data['message'] ?? 
                      response.data['error'] ?? 
                      errorMsg;
          } else if (response.data is String) {
            errorMsg = response.data;
          }
        }
        
        if (kDebugMode) {
          print('❌ Erreur: $errorMsg (Status: ${response.statusCode})');
        }
        throw Exception(errorMsg);
      }
    } on DioException catch (e) {
      // Gérer les erreurs Dio spécifiquement
      String errorMsg = 'Erreur lors de la participation';
      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          errorMsg = e.response!.data['message'] ?? 
                    e.response!.data['error'] ?? 
                    errorMsg;
        }
      } else if (e.message != null) {
        errorMsg = e.message!;
      }
      
      if (kDebugMode) {
        print('❌ Erreur Dio lors de la participation: $errorMsg');
      }
      throw Exception(errorMsg);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur lors de la participation: $e');
      }
      rethrow;
    }
  }

  // 4. Récupérer les statistiques
  Future<QuizStatistiqueResponse?> obtenirStatistiques() async {
    try {
      if (kDebugMode) {
        print('📊 Récupération des statistiques...');
      }

      final response = await _apiService.get(
        ApiConfig.quizStatistiques,
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('✅ Statistiques récupérées avec succès');
        }
        return QuizStatistiqueResponse.fromJson(response.data);
      } else {
        final errorMsg = response.data?['message'] ?? 'Erreur lors de la récupération des statistiques';
        if (kDebugMode) {
          print('❌ Erreur: $errorMsg');
        }
        throw Exception(errorMsg);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur lors de la récupération des stats: $e');
      }
      rethrow;
    }
  }

  // 5. Classement hebdomadaire
  Future<ClassementResponse?> obtenirClassementHebdomadaire() async {
    try {
      if (kDebugMode) {
        print('🏆 Récupération du classement hebdomadaire...');
      }

      final response = await _apiService.get(
        ApiConfig.quizClassementHebdomadaire,
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('✅ Classement hebdomadaire récupéré avec succès');
        }
        return ClassementResponse.fromJson(response.data);
      } else {
        final errorMsg = response.data?['message'] ?? 'Erreur lors de la récupération du classement';
        if (kDebugMode) {
          print('❌ Erreur: $errorMsg');
        }
        throw Exception(errorMsg);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur lors de la récupération du classement: $e');
      }
      rethrow;
    }
  }

  // 6. Classement mensuel
  Future<ClassementResponse?> obtenirClassementMensuel() async {
    try {
      if (kDebugMode) {
        print('🏆 Récupération du classement mensuel...');
      }

      final response = await _apiService.get(
        ApiConfig.quizClassementMensuel,
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('✅ Classement mensuel récupéré avec succès');
        }
        return ClassementResponse.fromJson(response.data);
      } else {
        final errorMsg = response.data?['message'] ?? 'Erreur lors de la récupération du classement';
        if (kDebugMode) {
          print('❌ Erreur: $errorMsg');
        }
        throw Exception(errorMsg);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur lors de la récupération du classement: $e');
      }
      rethrow;
    }
  }

  // 7. Récupérer la progression complète de l'utilisateur
  Future<QuizProgressionResponse?> obtenirProgression() async {
    try {
      if (kDebugMode) {
        print('📊 Récupération de la progression...');
      }

      final response = await _apiService.get(
        ApiConfig.quizProgression,
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('✅ Progression récupérée avec succès');
        }
        return QuizProgressionResponse.fromJson(response.data);
      } else {
        final errorMsg = response.data?['message'] ?? 'Erreur lors de la récupération de la progression';
        if (kDebugMode) {
          print('❌ Erreur: $errorMsg');
        }
        throw Exception(errorMsg);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur lors de la récupération de la progression: $e');
      }
      rethrow;
    }
  }

  // 8. Générer manuellement les quiz (test/admin)
  Future<bool> genererQuiz() async {
    try {
      if (kDebugMode) {
        print('🔧 Génération manuelle des quiz...');
      }

      final response = await _apiService.post(
        ApiConfig.quizGenerer,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print('✅ Quiz générés avec succès');
        }
        return true;
      } else {
        final errorMsg = response.data?['message'] ?? 'Erreur lors de la génération des quiz';
        if (kDebugMode) {
          print('❌ Erreur: $errorMsg');
        }
        throw Exception(errorMsg);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur lors de la génération des quiz: $e');
      }
      rethrow;
    }
  }
}

// Instance globale du service
final quizService = QuizService();


