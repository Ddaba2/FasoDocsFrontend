// ========================================================================================
// QUIZ MODELS - Modèles de données pour le système de quiz
// ========================================================================================

/// Niveaux de quiz
enum QuizNiveau {
  facile('FACILE', 'Facile'),
  moyen('MOYEN', 'Moyen'),
  difficile('DIFFICILE', 'Difficile');

  final String code;
  final String label;

  const QuizNiveau(this.code, this.label);

  static QuizNiveau? fromString(String? niveau) {
    if (niveau == null) return null;
    return QuizNiveau.values.firstWhere(
      (n) => n.code.toUpperCase() == niveau.toUpperCase(),
      orElse: () => QuizNiveau.facile,
    );
  }
}

/// Statut de déblocage d'un niveau
class QuizNiveauStatut {
  final QuizNiveau niveau;
  final bool estDebloque;
  final bool estComplete;
  final int? score;
  final int? nombreBonnesReponses;
  final int? nombreQuestions;
  final int? quizCompletes; // Nombre de quiz complétés à ce niveau
  final int? quizRequisPourDebloquer; // Nombre requis pour débloquer (30)

  QuizNiveauStatut({
    required this.niveau,
    required this.estDebloque,
    this.estComplete = false,
    this.score,
    this.nombreBonnesReponses,
    this.nombreQuestions,
    this.quizCompletes,
    this.quizRequisPourDebloquer,
  });

  factory QuizNiveauStatut.fromJson(Map<String, dynamic> json) {
    return QuizNiveauStatut(
      niveau: QuizNiveau.fromString(json['niveau']) ?? QuizNiveau.facile,
      estDebloque: json['estDebloque'] ?? false,
      estComplete: json['estComplete'] ?? false,
      score: json['score'],
      nombreBonnesReponses: json['nombreBonnesReponses'],
      nombreQuestions: json['nombreQuestions'],
      quizCompletes: json['quizCompletes'],
      quizRequisPourDebloquer: json['quizRequisPourDebloquer'] ?? 25, // Par défaut 25
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'niveau': niveau.code,
      'estDebloque': estDebloque,
      'estComplete': estComplete,
      'score': score,
      'nombreBonnesReponses': nombreBonnesReponses,
      'nombreQuestions': nombreQuestions,
      'quizCompletes': quizCompletes,
      'quizRequisPourDebloquer': quizRequisPourDebloquer,
    };
  }

  /// Pourcentage de progression vers le déblocage du niveau suivant
  double get pourcentageProgression {
    if (quizRequisPourDebloquer == null || quizRequisPourDebloquer == 0) return 0.0;
    final completes = quizCompletes ?? 0;
    return (completes / quizRequisPourDebloquer!).clamp(0.0, 1.0);
  }
}

/// Réponse pour tous les quiz avec statuts de déblocage
class QuizAujourdhuiResponse {
  final String? dateQuiz;
  final List<QuizNiveauStatut>? niveauxStatuts;
  final Map<String, List<QuizJournalierResponse>>? quizParNiveau; // Liste de quiz par niveau

  QuizAujourdhuiResponse({
    this.dateQuiz,
    this.niveauxStatuts,
    this.quizParNiveau,
  });

  factory QuizAujourdhuiResponse.fromJson(Map<String, dynamic> json) {
    final niveauxStatuts = (json['niveauxStatuts'] as List?)
        ?.map((s) => QuizNiveauStatut.fromJson(s))
        .toList();

    final quizParNiveau = <String, List<QuizJournalierResponse>>{};
    if (json['quiz'] != null && json['quiz'] is Map) {
      (json['quiz'] as Map<String, dynamic>).forEach((key, value) {
        if (value != null) {
          if (value is List) {
            // Liste de quiz
            quizParNiveau[key] = (value as List)
                .map((q) => QuizJournalierResponse.fromJson(q as Map<String, dynamic>))
                .toList();
          } else if (value is Map) {
            // Un seul quiz (compatibilité)
            quizParNiveau[key] = [QuizJournalierResponse.fromJson(value as Map<String, dynamic>)];
          }
        }
      });
    }

    return QuizAujourdhuiResponse(
      dateQuiz: json['dateQuiz'],
      niveauxStatuts: niveauxStatuts,
      quizParNiveau: quizParNiveau,
    );
  }
}

/// Réponse pour le quiz journalier
class QuizJournalierResponse {
  final int? id;
  final String? dateQuiz; // Format: "2025-01-15"
  final String? niveau; // FACILE, MOYEN, DIFFICILE
  final int? procedureId;
  final String? procedureNom;
  final int? categorieId;
  final String? categorieTitre;
  final bool? estActif;
  final List<QuizQuestionResponse>? questions;

  QuizJournalierResponse({
    this.id,
    this.dateQuiz,
    this.niveau,
    this.procedureId,
    this.procedureNom,
    this.categorieId,
    this.categorieTitre,
    this.estActif,
    this.questions,
  });

  factory QuizJournalierResponse.fromJson(Map<String, dynamic> json) {
    return QuizJournalierResponse(
      id: json['id'],
      dateQuiz: json['dateQuiz'],
      niveau: json['niveau'],
      procedureId: json['procedureId'],
      procedureNom: json['procedureNom'],
      categorieId: json['categorieId'],
      categorieTitre: json['categorieTitre'],
      estActif: json['estActif'],
      questions: (json['questions'] as List?)
          ?.map((q) => QuizQuestionResponse.fromJson(q))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateQuiz': dateQuiz,
      'niveau': niveau,
      'procedureId': procedureId,
      'procedureNom': procedureNom,
      'categorieId': categorieId,
      'categorieTitre': categorieTitre,
      'estActif': estActif,
      'questions': questions?.map((q) => q.toJson()).toList(),
    };
  }
}

/// Réponse pour une question de quiz
class QuizQuestionResponse {
  final int? id;
  final String? question; // Déjà traduit selon la langue (fr ou en)
  final String? typeQuestion;
  final int? points;
  final String? niveau;
  final int? ordre; // Ordre de la question dans le quiz (1, 2, 3, 4, 5)
  final bool? estDebloquee; // Si la question est débloquée pour l'utilisateur
  final List<QuizReponseResponse>? reponses;

  QuizQuestionResponse({
    this.id,
    this.question,
    this.typeQuestion,
    this.points,
    this.niveau,
    this.ordre,
    this.estDebloquee,
    this.reponses,
  });

  factory QuizQuestionResponse.fromJson(Map<String, dynamic> json) {
    return QuizQuestionResponse(
      id: json['id'],
      question: json['question'], // Déjà dans la langue demandée
      typeQuestion: json['typeQuestion'],
      points: json['points'],
      niveau: json['niveau'],
      ordre: json['ordre'],
      estDebloquee: json['estDebloquee'] ?? true, // Par défaut true pour compatibilité
      reponses: (json['reponses'] as List?)
          ?.map((r) => QuizReponseResponse.fromJson(r))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'typeQuestion': typeQuestion,
      'points': points,
      'niveau': niveau,
      'ordre': ordre,
      'estDebloquee': estDebloquee,
      'reponses': reponses?.map((r) => r.toJson()).toList(),
    };
  }
}

/// Réponse pour une réponse de quiz
class QuizReponseResponse {
  final int? id;
  final String? reponse; // Déjà traduit selon la langue (fr ou en)
  final bool? estCorrecte; // NULL avant soumission (pour ne pas révéler)
  final int? ordre;

  QuizReponseResponse({
    this.id,
    this.reponse,
    this.estCorrecte,
    this.ordre,
  });

  factory QuizReponseResponse.fromJson(Map<String, dynamic> json) {
    return QuizReponseResponse(
      id: json['id'],
      reponse: json['reponse'], // Déjà dans la langue demandée
      estCorrecte: json['estCorrecte'], // null avant soumission
      ordre: json['ordre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reponse': reponse,
      'estCorrecte': estCorrecte,
      'ordre': ordre,
    };
  }
}

/// Requête pour participer à un quiz
class QuizParticipationRequest {
  final int quizJournalierId;
  final List<ReponseQuestion> reponses;
  final int? tempsSecondes;

  QuizParticipationRequest({
    required this.quizJournalierId,
    required this.reponses,
    this.tempsSecondes,
  });

  Map<String, dynamic> toJson() {
    return {
      'quizJournalierId': quizJournalierId,
      'reponses': reponses.map((r) => r.toJson()).toList(),
      if (tempsSecondes != null) 'tempsSecondes': tempsSecondes,
    };
  }
}

/// Réponse d'une question dans la participation
class ReponseQuestion {
  final int questionId;
  final int reponseChoisieId;

  ReponseQuestion({
    required this.questionId,
    required this.reponseChoisieId,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'reponseChoisieId': reponseChoisieId,
    };
  }
}

/// Réponse après participation à un quiz
class QuizParticipationResponse {
  final int? id;
  final int? quizJournalierId;
  final String? dateQuiz;
  final int? score;
  final int? nombreBonnesReponses;
  final int? nombreQuestions;
  final int? tempsSecondes;
  final bool? estComplete;
  final String? dateParticipation;
  final List<QuizReponseUtilisateurResponse>? reponses;

  QuizParticipationResponse({
    this.id,
    this.quizJournalierId,
    this.dateQuiz,
    this.score,
    this.nombreBonnesReponses,
    this.nombreQuestions,
    this.tempsSecondes,
    this.estComplete,
    this.dateParticipation,
    this.reponses,
  });

  factory QuizParticipationResponse.fromJson(Map<String, dynamic> json) {
    return QuizParticipationResponse(
      id: json['id'],
      quizJournalierId: json['quizJournalierId'],
      dateQuiz: json['dateQuiz'],
      score: json['score'],
      nombreBonnesReponses: json['nombreBonnesReponses'],
      nombreQuestions: json['nombreQuestions'],
      tempsSecondes: json['tempsSecondes'],
      estComplete: json['estComplete'],
      dateParticipation: json['dateParticipation'],
      reponses: (json['reponses'] as List?)
          ?.map((r) => QuizReponseUtilisateurResponse.fromJson(r))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizJournalierId': quizJournalierId,
      'dateQuiz': dateQuiz,
      'score': score,
      'nombreBonnesReponses': nombreBonnesReponses,
      'nombreQuestions': nombreQuestions,
      'tempsSecondes': tempsSecondes,
      'estComplete': estComplete,
      'dateParticipation': dateParticipation,
      'reponses': reponses?.map((r) => r.toJson()).toList(),
    };
  }
}

/// Réponse d'une réponse utilisateur dans la participation
class QuizReponseUtilisateurResponse {
  final int? questionId;
  final String? question;
  final int? reponseChoisieId;
  final String? reponseChoisie;
  final bool? estCorrecte;
  final int? reponseCorrecteId;
  final String? reponseCorrecte;

  QuizReponseUtilisateurResponse({
    this.questionId,
    this.question,
    this.reponseChoisieId,
    this.reponseChoisie,
    this.estCorrecte,
    this.reponseCorrecteId,
    this.reponseCorrecte,
  });

  factory QuizReponseUtilisateurResponse.fromJson(Map<String, dynamic> json) {
    return QuizReponseUtilisateurResponse(
      questionId: json['questionId'],
      question: json['question'],
      reponseChoisieId: json['reponseChoisieId'],
      reponseChoisie: json['reponseChoisie'],
      estCorrecte: json['estCorrecte'],
      reponseCorrecteId: json['reponseCorrecteId'],
      reponseCorrecte: json['reponseCorrecte'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'question': question,
      'reponseChoisieId': reponseChoisieId,
      'reponseChoisie': reponseChoisie,
      'estCorrecte': estCorrecte,
      'reponseCorrecteId': reponseCorrecteId,
      'reponseCorrecte': reponseCorrecte,
    };
  }
}

/// Réponse pour les statistiques de quiz
class QuizStatistiqueResponse {
  final int? citoyenId;
  final String? citoyenNom;
  final String? citoyenPrenom;
  final int? totalPoints;
  final int? totalQuizCompletes;
  final int? streakJours;
  final int? meilleurStreak;
  final String? derniereParticipation;
  final bool? badgeExpert;
  final bool? badgeStreakMaster;
  final int? positionClassement;

  QuizStatistiqueResponse({
    this.citoyenId,
    this.citoyenNom,
    this.citoyenPrenom,
    this.totalPoints,
    this.totalQuizCompletes,
    this.streakJours,
    this.meilleurStreak,
    this.derniereParticipation,
    this.badgeExpert,
    this.badgeStreakMaster,
    this.positionClassement,
  });

  factory QuizStatistiqueResponse.fromJson(Map<String, dynamic> json) {
    return QuizStatistiqueResponse(
      citoyenId: json['citoyenId'],
      citoyenNom: json['citoyenNom'],
      citoyenPrenom: json['citoyenPrenom'],
      totalPoints: json['totalPoints'],
      totalQuizCompletes: json['totalQuizCompletes'],
      streakJours: json['streakJours'],
      meilleurStreak: json['meilleurStreak'],
      derniereParticipation: json['derniereParticipation'],
      badgeExpert: json['badgeExpert'],
      badgeStreakMaster: json['badgeStreakMaster'],
      positionClassement: json['positionClassement'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'citoyenId': citoyenId,
      'citoyenNom': citoyenNom,
      'citoyenPrenom': citoyenPrenom,
      'totalPoints': totalPoints,
      'totalQuizCompletes': totalQuizCompletes,
      'streakJours': streakJours,
      'meilleurStreak': meilleurStreak,
      'derniereParticipation': derniereParticipation,
      'badgeExpert': badgeExpert,
      'badgeStreakMaster': badgeStreakMaster,
      'positionClassement': positionClassement,
    };
  }
}

/// Réponse pour le classement
class ClassementResponse {
  final String? periode; // "HEBDOMADAIRE" ou "MENSUEL"
  final List<QuizStatistiqueResponse>? classement;
  final int? positionUtilisateur;

  ClassementResponse({
    this.periode,
    this.classement,
    this.positionUtilisateur,
  });

  factory ClassementResponse.fromJson(Map<String, dynamic> json) {
    return ClassementResponse(
      periode: json['periode'],
      classement: (json['classement'] as List?)
          ?.map((s) => QuizStatistiqueResponse.fromJson(s))
          .toList(),
      positionUtilisateur: json['positionUtilisateur'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'periode': periode,
      'classement': classement?.map((s) => s.toJson()).toList(),
      'positionUtilisateur': positionUtilisateur,
    };
  }
}

/// Progression d'un niveau spécifique
class QuizProgressionNiveau {
  final QuizNiveau niveau;
  final bool estDebloque;
  final String? dateDeblocage;
  final int quizCompletes;
  final int? meilleurScore;
  final bool estNiveauActuel;

  QuizProgressionNiveau({
    required this.niveau,
    required this.estDebloque,
    this.dateDeblocage,
    this.quizCompletes = 0,
    this.meilleurScore,
    this.estNiveauActuel = false,
  });

  factory QuizProgressionNiveau.fromJson(Map<String, dynamic> json) {
    return QuizProgressionNiveau(
      niveau: QuizNiveau.fromString(json['niveau']) ?? QuizNiveau.facile,
      estDebloque: json['estDebloque'] ?? false,
      dateDeblocage: json['dateDeblocage'],
      quizCompletes: json['quizCompletes'] ?? 0,
      meilleurScore: json['meilleurScore'],
      estNiveauActuel: json['estNiveauActuel'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'niveau': niveau.code,
      'estDebloque': estDebloque,
      'dateDeblocage': dateDeblocage,
      'quizCompletes': quizCompletes,
      'meilleurScore': meilleurScore,
      'estNiveauActuel': estNiveauActuel,
    };
  }
}

/// Réponse complète de progression de l'utilisateur
class QuizProgressionResponse {
  final int? utilisateurId;
  final String? utilisateurNom;
  final String? utilisateurPrenom;
  final int totalQuizCompletes;
  final int totalPoints;
  final QuizNiveau? niveauActuel;
  final List<QuizProgressionNiveau>? progressionParNiveau;

  QuizProgressionResponse({
    this.utilisateurId,
    this.utilisateurNom,
    this.utilisateurPrenom,
    this.totalQuizCompletes = 0,
    this.totalPoints = 0,
    this.niveauActuel,
    this.progressionParNiveau,
  });

  factory QuizProgressionResponse.fromJson(Map<String, dynamic> json) {
    return QuizProgressionResponse(
      utilisateurId: json['utilisateurId'],
      utilisateurNom: json['utilisateurNom'],
      utilisateurPrenom: json['utilisateurPrenom'],
      totalQuizCompletes: json['totalQuizCompletes'] ?? 0,
      totalPoints: json['totalPoints'] ?? 0,
      niveauActuel: QuizNiveau.fromString(json['niveauActuel']),
      progressionParNiveau: (json['progressionParNiveau'] as List?)
          ?.map((p) => QuizProgressionNiveau.fromJson(p))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'utilisateurId': utilisateurId,
      'utilisateurNom': utilisateurNom,
      'utilisateurPrenom': utilisateurPrenom,
      'totalQuizCompletes': totalQuizCompletes,
      'totalPoints': totalPoints,
      'niveauActuel': niveauActuel?.code,
      'progressionParNiveau': progressionParNiveau?.map((p) => p.toJson()).toList(),
    };
  }

  /// Obtenir la progression d'un niveau spécifique
  QuizProgressionNiveau? getProgressionNiveau(QuizNiveau niveau) {
    return progressionParNiveau?.firstWhere(
      (p) => p.niveau == niveau,
      orElse: () => QuizProgressionNiveau(
        niveau: niveau,
        estDebloque: niveau == QuizNiveau.facile,
        quizCompletes: 0,
      ),
    );
  }
}


