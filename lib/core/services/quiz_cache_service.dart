// ========================================================================================
// QUIZ CACHE SERVICE - Cache simple pour les données de quiz
// ========================================================================================

import '../../models/quiz_models.dart';

class QuizCacheService {
  static QuizCacheService? _instance;
  static QuizCacheService get instance => _instance ??= QuizCacheService._();
  
  QuizCacheService._();

  // Cache des données
  QuizAujourdhuiResponse? _quizDataCache;
  QuizProgressionResponse? _progressionCache;
  Map<String, List<QuizJournalierResponse>> _quizParNiveauCache = {};
  
  // Timestamps pour expiration
  DateTime? _quizDataTimestamp;
  DateTime? _progressionTimestamp;
  Map<String, DateTime> _quizParNiveauTimestamps = {};
  
  // Durée de validité du cache (10 minutes pour améliorer les performances)
  static const Duration _cacheValidity = Duration(minutes: 10);

  // Obtenir les quiz du jour (avec cache)
  QuizAujourdhuiResponse? getQuizData() {
    if (_quizDataCache != null && _quizDataTimestamp != null) {
      if (DateTime.now().difference(_quizDataTimestamp!) < _cacheValidity) {
        return _quizDataCache;
      }
    }
    return null;
  }

  // Mettre en cache les quiz du jour
  void setQuizData(QuizAujourdhuiResponse? data) {
    _quizDataCache = data;
    _quizDataTimestamp = DateTime.now();
  }

  // Obtenir la progression (avec cache)
  QuizProgressionResponse? getProgression() {
    if (_progressionCache != null && _progressionTimestamp != null) {
      if (DateTime.now().difference(_progressionTimestamp!) < _cacheValidity) {
        return _progressionCache;
      }
    }
    return null;
  }

  // Mettre en cache la progression
  void setProgression(QuizProgressionResponse? data) {
    _progressionCache = data;
    _progressionTimestamp = DateTime.now();
  }

  // Obtenir les quiz d'un niveau (avec cache)
  List<QuizJournalierResponse>? getQuizParNiveau(String niveau) {
    final key = niveau.toUpperCase();
    if (_quizParNiveauCache.containsKey(key)) {
      final timestamp = _quizParNiveauTimestamps[key];
      if (timestamp != null && DateTime.now().difference(timestamp) < _cacheValidity) {
        return _quizParNiveauCache[key];
      }
    }
    return null;
  }

  // Mettre en cache les quiz d'un niveau
  void setQuizParNiveau(String niveau, List<QuizJournalierResponse> quiz) {
    final key = niveau.toUpperCase();
    _quizParNiveauCache[key] = quiz;
    _quizParNiveauTimestamps[key] = DateTime.now();
  }

  // Invalider le cache (appelé après un quiz complété)
  void invalidateCache() {
    _quizDataCache = null;
    _progressionCache = null;
    _quizParNiveauCache.clear();
    _quizDataTimestamp = null;
    _progressionTimestamp = null;
    _quizParNiveauTimestamps.clear();
  }

  // Invalider seulement la progression (plus rapide)
  void invalidateProgression() {
    _progressionCache = null;
    _progressionTimestamp = null;
  }
}

