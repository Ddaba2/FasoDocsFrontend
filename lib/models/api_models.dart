// ========================================================================================
// API MODELS - Modèles de données pour l'API FasoDocs
// ========================================================================================

/// Modèle pour les requêtes d'inscription
class InscriptionRequest {
  final String nomComplet;
  final String telephone;
  final String email;
  final String motDePasse;

  InscriptionRequest({
    required this.nomComplet,
    required this.telephone,
    required this.email,
    required this.motDePasse,
  });

  Map<String, dynamic> toJson() => {
    'nomComplet': nomComplet,
    'telephone': telephone,
    'email': email,
    'motDePasse': motDePasse,
  };
}

/// Modèle pour l'utilisateur
class User {
  final String id;
  final String nomComplet;
  final String telephone;
  final String email;
  final String? adresse;
  final String? dateNaissance;
  final String? genre;
  final String? photoUrl;
  final String? photoProfil; // Photo de profil en Base64 depuis le backend

  User({
    required this.id,
    required this.nomComplet,
    required this.telephone,
    required this.email,
    this.adresse,
    this.dateNaissance,
    this.genre,
    this.photoUrl,
    this.photoProfil,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id']?.toString() ?? '',
    nomComplet: json['nomComplet'] ?? json['fullName'] ?? '',
    telephone: json['telephone'] ?? json['phoneNumber'] ?? '',
    email: json['email'] ?? '',
    adresse: json['adresse'],
    dateNaissance: json['dateNaissance'],
    genre: json['genre'],
    photoUrl: json['photoUrl'],
    // Le backend envoie photoProfil en Base64
    photoProfil: json['photoProfil'] ?? json['photoUrl'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nomComplet': nomComplet,
    'telephone': telephone,
    'email': email,
    'adresse': adresse,
    'dateNaissance': dateNaissance,
    'genre': genre,
    'photoUrl': photoUrl,
    'photoProfil': photoProfil,
  };
  
  // Getter pour obtenir la photo (priorité à photoProfil Base64)
  String? get photo => photoProfil ?? photoUrl;
}

/// Modèle pour la connexion par téléphone
class ConnexionTelephoneRequest {
  final String telephone;

  ConnexionTelephoneRequest({required this.telephone});

  Map<String, dynamic> toJson() => {'telephone': telephone};
}

/// Modèle pour la vérification SMS
class VerificationSmsRequest {
  final String telephone;
  final String code;

  VerificationSmsRequest({required this.telephone, required this.code});

  Map<String, dynamic> toJson() => {
    'telephone': telephone,
    'code': code,
  };
}

/// Modèle pour la réponse JWT
class JwtResponse {
  final String token;
  final String message;

  JwtResponse({required this.token, required this.message});

  factory JwtResponse.fromJson(Map<String, dynamic> json) => JwtResponse(
    token: json['token'] ?? '',
    message: json['message'] ?? '',
  );
}

/// Modèle pour une réponse de message
class MessageResponse {
  final String message;

  MessageResponse({required this.message});

  factory MessageResponse.fromJson(Map<String, dynamic> json) => MessageResponse(
    message: json['message'] ?? '',
  );
}

/// Modèle pour une catégorie
class CategorieResponse {
  final String id;
  final String titre;
  final String? description;
  final String? iconeUrl;
  final String? nomCategorie;
  final int nombreProcedures; // Ajout du champ pour le nombre de procédures
  final List<SousCategorieResponse> sousCategories; // Ajout des sous-catégories

  CategorieResponse({
    required this.id,
    required this.titre,
    this.description,
    this.iconeUrl,
    this.nomCategorie,
    this.nombreProcedures = 0, // Valeur par défaut
    this.sousCategories = const [], // Valeur par défaut
  });

  // Getter pour compatibilité (utilisé dans le code existant)
  String get nom => titre;

  factory CategorieResponse.fromJson(Map<String, dynamic> json) => CategorieResponse(
    id: json['id']?.toString() ?? '',
    titre: json['titre'] ?? '',
    description: json['description'],
    iconeUrl: json['iconeUrl'] ?? json['icone'],
    nomCategorie: json['nomCategorie'],
    nombreProcedures: json['nombreProcedures'] ?? json['nombreProcedure'] ?? 0, // Support both formats
    // Parser les sous-catégories si elles sont présentes
    sousCategories: (json['sousCategories'] as List?)
        ?.map((e) => SousCategorieResponse.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [],
  );
}

/// Modèle pour une sous-catégorie
class SousCategorieResponse {
  final String id;
  final String titre;
  final String? description;
  final String? iconeUrl;
  final String? nomSousCategorie;
  final String categorieId;
  final int nombreProcedures; // Ajout du champ pour le nombre de procédures

  SousCategorieResponse({
    required this.id,
    required this.titre,
    this.description,
    this.iconeUrl,
    this.nomSousCategorie,
    required this.categorieId,
    this.nombreProcedures = 0, // Valeur par défaut
  });
  
  // Getter pour compatibilité avec le code existant
  String get nom => titre;
  String? get icone => iconeUrl;

  factory SousCategorieResponse.fromJson(Map<String, dynamic> json) => SousCategorieResponse(
    id: json['id']?.toString() ?? '',
    titre: json['titre'] ?? json['nom'] ?? '',
    description: json['description'],
    iconeUrl: json['iconeUrl'] ?? json['icone'],
    nomSousCategorie: json['nomSousCategorie'],
    categorieId: json['categorieId']?.toString() ?? '',
    nombreProcedures: json['nombreProcedures'] ?? json['nombreProcedure'] ?? 0, // Support both formats
  );
}

/// Modèle pour une référence légale
class ReferenceLegale {
  final String description;
  final String article;
  final String? audioUrl;

  ReferenceLegale({
    required this.description,
    required this.article,
    this.audioUrl,
  });

  factory ReferenceLegale.fromJson(Map<String, dynamic> json) => ReferenceLegale(
    description: json['description'] ?? '',
    article: json['article'] ?? '',
    audioUrl: json['audioUrl'],
  );
}

/// Modèle pour une étape de procédure
class EtapeProcedure {
  final String nom;
  final String description;
  final int niveauOrdre;

  EtapeProcedure({
    required this.nom,
    required this.description,
    required this.niveauOrdre,
  });

  factory EtapeProcedure.fromJson(Map<String, dynamic> json) => EtapeProcedure(
    nom: json['titre'] ?? json['nom'] ?? '',
    description: json['description'] ?? '',
    niveauOrdre: json['ordre'] ?? json['niveauOrdre'] ?? 0,
  );
}

/// Modèle pour un document requis
class DocumentRequis {
  final String nom;
  final String? description;
  final bool obligatoire;
  final String? modeleUrl;

  DocumentRequis({
    required this.nom,
    this.description,
    required this.obligatoire,
    this.modeleUrl,
  });

  factory DocumentRequis.fromJson(Map<String, dynamic> json) => DocumentRequis(
    nom: json['nom'] ?? '',
    description: json['description'],
    obligatoire: json['obligatoire'] ?? true,
    modeleUrl: json['urlModele'] ?? json['modeleUrl'],
  );
}

/// Modèle pour un centre de traitement
class CentreDeTraitement {
  final String nom;
  final String adresse;
  final String? horaires;
  final String? latitude;
  final String? longitude;
  final String? telephone;
  final String? email;

  CentreDeTraitement({
    required this.nom,
    required this.adresse,
    this.horaires,
    this.latitude,
    this.longitude,
    this.telephone,
    this.email,
  });

  factory CentreDeTraitement.fromJson(Map<String, dynamic> json) => CentreDeTraitement(
    nom: json['nom'] ?? '',
    adresse: json['adresse'] ?? '',
    horaires: json['horaires'],
    latitude: json['coordonneesGPS']?.toString() ?? json['latitude']?.toString(),
    longitude: json['coordonneesGPS']?.toString() ?? json['longitude']?.toString(),
    telephone: json['telephone'],
    email: json['email'],
  );
}

/// Modèle pour un coût
class Cout {
  final String nom;
  final double prix;
  final String? description;

  Cout({
    required this.nom,
    required this.prix,
    this.description,
  });

  factory Cout.fromJson(Map<String, dynamic> json) => Cout(
    nom: json['nom'] ?? '',
    prix: (json['prix'] ?? 0).toDouble(),
    description: json['description'],
  );
}

// Helper pour parser les références légales avec différents noms de champs possibles
List<ReferenceLegale>? _parseReferencesLegales(Map<String, dynamic> json) {
  // Essayer différents noms de champs possibles
  dynamic loisData = json['loisArticles'] ?? 
                     json['referencesLegales'] ?? 
                     json['lois'] ?? 
                     json['references'] ?? 
                     json['legalReferences'];
  
  if (loisData == null) return null;
  
  // Si c'est une liste, la mapper directement
  if (loisData is List) {
    return loisData.map((e) => ReferenceLegale.fromJson(e as Map<String, dynamic>)).toList();
  }
  
  // Si c'est un objet unique, le convertir en liste
  if (loisData is Map<String, dynamic>) {
    return [ReferenceLegale.fromJson(loisData)];
  }
  
  return null;
}

/// Modèle pour une procédure
class ProcedureResponse {
  final String id;
  final String nom;
  final String titre;
  final String? description;
  final String? delai;
  final String? urlFormulaire;
  final CategorieResponse? categorie;
  final SousCategorieResponse? sousCategorie;
  final List<CentreDeTraitement> centres;
  final List<Cout>? couts;
  final List<DocumentRequis> documentsRequis;
  final List<EtapeProcedure>? etapes;
  final List<ReferenceLegale>? referencesLegales;
  final bool peutEtreDelegatee; // ⚠️ IMPORTANT: Indique si la procédure peut être déléguée

  ProcedureResponse({
    required this.id,
    required this.nom,
    required this.titre,
    this.description,
    this.delai,
    this.urlFormulaire,
    this.categorie,
    this.sousCategorie,
    required this.centres,
    this.couts,
    required this.documentsRequis,
    this.etapes,
    this.referencesLegales,
    this.peutEtreDelegatee = false, // Par défaut, une procédure n'est pas déléguable
  });

  factory ProcedureResponse.fromJson(Map<String, dynamic> json) => ProcedureResponse(
    id: json['id']?.toString() ?? '',
    nom: json['nom'] ?? '',
    titre: json['titre'] ?? '',
    description: json['description'],
    delai: json['delai'],
    urlFormulaire: json['urlVersFormulaire'],
    categorie: json['categorie'] != null ? CategorieResponse.fromJson(json['categorie']) : null,
    sousCategorie: json['sousCategorie'] != null 
      ? SousCategorieResponse.fromJson(json['sousCategorie']) 
      : null,
    centres: json['centre'] != null 
      ? [CentreDeTraitement.fromJson(json['centre'])] 
      : (json['centres'] as List?)?.map((e) => CentreDeTraitement.fromJson(e)).toList() ?? [],
    couts: json['cout'] != null 
      ? (json['cout'] is double || json['cout'] is int)
        ? [Cout(nom: json['coutDescription'] ?? 'Coût', prix: (json['cout'] as num).toDouble())]
        : null
      : (json['couts'] as List?)?.map((e) => Cout.fromJson(e)).toList() ?? null,
    documentsRequis: (json['documentsRequis'] as List?)
      ?.map((e) => DocumentRequis.fromJson(e))
      .toList() ?? [],
    etapes: json['etapes'] != null
      ? (json['etapes'] as List).map((e) => EtapeProcedure.fromJson(e)).toList()
      : null,
    referencesLegales: _parseReferencesLegales(json),
    peutEtreDelegatee: json['peutEtreDelegatee'] ?? false, // ⚠️ IMPORTANT
  );
}

/// Modèle pour les notifications

/// Modèle pour les notifications
class NotificationResponse {
  final String id;
  final String titre;
  final String message;
  final bool lue;
  final DateTime dateCreation;

  NotificationResponse({
    required this.id,
    required this.titre,
    required this.message,
    required this.lue,
    required this.dateCreation,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) => NotificationResponse(
    id: json['id']?.toString() ?? '',
    titre: json['titre'] ?? json['title'] ?? '',
    // ✅ Gérer plusieurs champs possibles : message, description, contenu
    message: json['message'] ?? json['description'] ?? json['contenu'] ?? json['content'] ?? '',
    lue: json['lue'] ?? json['read'] ?? false,
    dateCreation: DateTime.tryParse(json['dateCreation'] ?? json['createdAt'] ?? json['date_creation'] ?? '') ?? DateTime.now(),
  );
}

/// Modèle pour les signalements
class SignalementRequest {
  final String titre;
  final String description;
  final String type;
  final String structure;

  SignalementRequest({
    required this.titre,
    required this.description,
    required this.type,
    required this.structure,
  });

  Map<String, dynamic> toJson() => {
    'titre': titre,
    'description': description,
    'type': type,
    'structure': structure,
  };
}

class SignalementResponse {
  final String id;
  final String titre;
  final String description;
  final String type;
  final String structure;
  final DateTime dateCreation;
  final String? statut;

  SignalementResponse({
    required this.id,
    required this.titre,
    required this.description,
    required this.type,
    required this.structure,
    required this.dateCreation,
    this.statut,
  });

  factory SignalementResponse.fromJson(Map<String, dynamic> json) => SignalementResponse(
    id: json['id']?.toString() ?? '',
    titre: json['titre'] ?? '',
    description: json['description'] ?? '',
    type: json['type'] ?? '',
    structure: json['structure'] ?? '',
    dateCreation: DateTime.tryParse(json['dateCreation'] ?? '') ?? DateTime.now(),
    statut: json['statut'],
  );
}

/// Modèle pour les types de signalements
class SignalementType {
  final String id;
  final String nom;
  final String? description;

  SignalementType({
    required this.id,
    required this.nom,
    this.description,
  });

  factory SignalementType.fromJson(Map<String, dynamic> json) => SignalementType(
    id: json['id']?.toString() ?? '',
    nom: json['nom'] ?? json['name'] ?? '',
    description: json['description'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'description': description,
  };
}
