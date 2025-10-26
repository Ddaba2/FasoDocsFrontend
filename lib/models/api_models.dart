// ========================================================================================
// API MODELS - Modèles de données pour l'API FasoDocs
// ========================================================================================

import 'dart:convert';
import 'dart:math';

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

  User({
    required this.id,
    required this.nomComplet,
    required this.telephone,
    required this.email,
    this.adresse,
    this.dateNaissance,
    this.genre,
    this.photoUrl,
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
  };
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

  CategorieResponse({
    required this.id,
    required this.titre,
    this.description,
    this.iconeUrl,
    this.nomCategorie,
  });

  // Getter pour compatibilité (utilisé dans le code existant)
  String get nom => titre;

  factory CategorieResponse.fromJson(Map<String, dynamic> json) => CategorieResponse(
    id: json['id']?.toString() ?? '',
    titre: json['titre'] ?? '',
    description: json['description'],
    iconeUrl: json['iconeUrl'] ?? json['icone'],
    nomCategorie: json['nomCategorie'],
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

  SousCategorieResponse({
    required this.id,
    required this.titre,
    this.description,
    this.iconeUrl,
    this.nomSousCategorie,
    required this.categorieId,
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
    referencesLegales: json['loisArticles'] != null
      ? (json['loisArticles'] as List).map((e) => ReferenceLegale.fromJson(e)).toList()
      : null,
  );
}

/// Modèle pour les requêtes de chatbot
class ChatRequest {
  final String question;
  final String langue;

  ChatRequest({required this.question, required this.langue});

  Map<String, dynamic> toJson() => {
    'question': question,
    'langue': langue,
  };
}

/// Modèle pour la réponse du chatbot
class ChatResponse {
  final String reponse;
  final String? audioUrl;
  final String langue;

  ChatResponse({
    required this.reponse,
    this.audioUrl,
    required this.langue,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
    reponse: json['reponse'] ?? '',
    audioUrl: json['audioUrl'],
    langue: json['langue'] ?? 'fr',
  );
}

/// Modèle pour la traduction
class TranslationRequest {
  final String texte;
  final String fromLang;
  final String toLang;

  TranslationRequest({
    required this.texte,
    required this.fromLang,
    required this.toLang,
  });

  Map<String, dynamic> toJson() => {
    'texte': texte,
    'fromLang': fromLang,
    'toLang': toLang,
  };
}

class TranslationResponse {
  final String texteOriginal;
  final String texteTraduit;

  TranslationResponse({
    required this.texteOriginal,
    required this.texteTraduit,
  });

  factory TranslationResponse.fromJson(Map<String, dynamic> json) {
    print('🔍 Parsing TranslationResponse: $json');
    
    // Le backend retourne 'originalText' et 'texte'
    // Mais originalText semble être une string JSON encodée
    final originalText = json['originalText'];
    final texteTraduit = json['texte'];
    
    final origLen = originalText != null ? originalText.toString().length : 0;
    final tradLen = texteTraduit != null ? texteTraduit.toString().length : 0;
    print('🔍 originalText: ${originalText != null ? originalText.toString().substring(0, min(origLen, 100)) : 'NULL'}');
    print('🔍 texteTraduit: ${texteTraduit != null ? texteTraduit.toString().substring(0, min(tradLen, 100)) : 'NULL'}');
    
    // Le backend retourne la traduction dans 'originalText' comme string JSON
    // Format: "{\"texte\":\"texte traduit\"}"
    String finalTexteTraduit = '';
    
    if (texteTraduit != null && texteTraduit.toString().isNotEmpty) {
      finalTexteTraduit = texteTraduit.toString();
    } else if (originalText != null && originalText.toString().startsWith('{')) {
      // Essayer de parser originalText comme JSON pour extraire la traduction
      try {
        final decoded = jsonDecode(originalText.toString()) as Map<String, dynamic>;
        finalTexteTraduit = decoded['texte']?.toString() ?? '';
        print('✅ Texte traduit extrait du JSON: ${finalTexteTraduit.substring(0, min(finalTexteTraduit.length, 100))}');
      } catch (e) {
        print('❌ Erreur parsing originalText: $e');
      }
    }
    
    return TranslationResponse(
      texteOriginal: json['texteOriginal']?.toString() ?? '',
      texteTraduit: finalTexteTraduit.isNotEmpty ? finalTexteTraduit : (json['texteTraduit']?.toString() ?? ''),
    );
  }
}

/// Modèle pour la synthèse vocale
class SpeakRequest {
  final String texte;
  final String langue;

  SpeakRequest({required this.texte, required this.langue});

  Map<String, dynamic> toJson() => {
    'texte': texte,
    'langue': langue,
  };
}

class SpeakResponse {
  final String audioUrl;
  final String texte;

  SpeakResponse({
    required this.audioUrl,
    required this.texte,
  });

  factory SpeakResponse.fromJson(Map<String, dynamic> json) => SpeakResponse(
    audioUrl: json['audioUrl'] ?? '',
    texte: json['texte'] ?? '',
  );
}

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
    titre: json['titre'] ?? '',
    message: json['message'] ?? '',
    lue: json['lue'] ?? false,
    dateCreation: DateTime.tryParse(json['dateCreation'] ?? '') ?? DateTime.now(),
  );
}

/// Modèle pour les signalements
class SignalementRequest {
  final String type;
  final String message;
  final String? procedureId;

  SignalementRequest({
    required this.type,
    required this.message,
    this.procedureId,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'message': message,
    if (procedureId != null) 'procedureId': procedureId,
  };
}

class SignalementResponse {
  final String id;
  final String type;
  final String message;
  final DateTime dateCreation;
  final String? statut;

  SignalementResponse({
    required this.id,
    required this.type,
    required this.message,
    required this.dateCreation,
    this.statut,
  });

  factory SignalementResponse.fromJson(Map<String, dynamic> json) => SignalementResponse(
    id: json['id']?.toString() ?? '',
    type: json['type'] ?? '',
    message: json['message'] ?? '',
    dateCreation: DateTime.tryParse(json['dateCreation'] ?? '') ?? DateTime.now(),
    statut: json['statut'],
  );
}

