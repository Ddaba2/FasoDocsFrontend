// ========================================================================================
// SERVICE MODELS - Modèles de données pour le système de service de procédures
// ========================================================================================

/// Modèle pour un tarif de service
class TarifService {
  final int procedureId;
  final String procedureNom;
  final double tarifService;
  final double? coutLegal;
  final double tarifTotal;
  final String commune;
  final String description;
  final String delaiEstime;

  TarifService({
    required this.procedureId,
    required this.procedureNom,
    required this.tarifService,
    this.coutLegal,
    required this.tarifTotal,
    required this.commune,
    required this.description,
    required this.delaiEstime,
  });

  factory TarifService.fromJson(Map<String, dynamic> json) {
    return TarifService(
      procedureId: json['procedureId'] ?? json['procedure']['id'],
      procedureNom: json['procedureNom'] ?? json['procedure']['nom'] ?? json['procedure']['titre'] ?? '',
      tarifService: (json['tarifService'] as num?)?.toDouble() ?? 0.0,
      coutLegal: json['coutLegal'] != null 
          ? (json['coutLegal'] as num).toDouble() 
          : null,
      tarifTotal: (json['tarifTotal'] as num?)?.toDouble() ?? 0.0,
      commune: json['commune'] ?? '',
      description: json['description'] ?? '',
      delaiEstime: json['delaiEstime'] ?? json['delai'] ?? '',
    );
  }
}

/// Modèle pour une demande de service
class DemandeService {
  final int id;
  final ProcedureSimple procedure;
  final String statut;
  final double tarif;
  final double tarifService;
  final double? coutLegal;
  final String commune;
  final String? quartier;
  final String? adresseComplete;
  final DateTime dateCreation;

  DemandeService({
    required this.id,
    required this.procedure,
    required this.statut,
    required this.tarif,
    required this.tarifService,
    this.coutLegal,
    required this.commune,
    this.quartier,
    this.adresseComplete,
    required this.dateCreation,
  });

  factory DemandeService.fromJson(Map<String, dynamic> json) {
    return DemandeService(
      id: json['id'] ?? 0,
      procedure: ProcedureSimple.fromJson(json['procedure'] ?? {}),
      statut: json['statut'] ?? json['status'] ?? 'EN_ATTENTE',
      tarif: (json['tarif'] as num?)?.toDouble() ?? 0.0,
      tarifService: (json['tarifService'] as num?)?.toDouble() ?? 0.0,
      coutLegal: json['coutLegal'] != null 
          ? (json['coutLegal'] as num).toDouble() 
          : null,
      commune: json['commune'] ?? '',
      quartier: json['quartier'],
      adresseComplete: json['adresseComplete'] ?? json['adresse'],
      dateCreation: DateTime.tryParse(json['dateCreation'] ?? json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

/// Modèle simplifié pour une procédure (utilisé dans les demandes)
class ProcedureSimple {
  final int id;
  final String nom;
  final String titre;

  ProcedureSimple({
    required this.id,
    required this.nom,
    required this.titre,
  });

  factory ProcedureSimple.fromJson(Map<String, dynamic> json) {
    return ProcedureSimple(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      nom: json['nom'] ?? '',
      titre: json['titre'] ?? '',
    );
  }
}


