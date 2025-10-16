// ========================================================================================
// MODÈLE DOCUMENT - MVC Pattern
// ========================================================================================
// Ce fichier contient le modèle de données pour les documents administratifs
// Il définit la structure des documents dans l'application FasoDocs
// ========================================================================================

enum DocumentStatus {
  pending,    // En attente
  processing, // En cours de traitement
  approved,   // Approuvé
  rejected,   // Rejeté
  completed,  // Terminé
}

enum DocumentType {
  identity,     // Documents d'identité
  residence,    // Documents de résidence
  business,     // Documents commerciaux
  auto,         // Documents automobiles
  land,         // Documents fonciers
  utilities,    // Documents utilitaires
  justice,      // Documents judiciaires
  tax,          // Documents fiscaux
}

class DocumentModel {
  final String? id;
  final String? title;
  final String? description;
  final DocumentType type;
  final DocumentStatus status;
  final String? userId;
  final List<String>? requiredDocuments;
  final List<String>? uploadedDocuments;
  final DateTime? submittedAt;
  final DateTime? processedAt;
  final DateTime? completedAt;
  final String? notes;
  final double? fees;
  final String? referenceNumber;

  DocumentModel({
    this.id,
    this.title,
    this.description,
    required this.type,
    required this.status,
    this.userId,
    this.requiredDocuments,
    this.uploadedDocuments,
    this.submittedAt,
    this.processedAt,
    this.completedAt,
    this.notes,
    this.fees,
    this.referenceNumber,
  });

  // Méthode pour créer un document depuis un Map (JSON)
  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      type: DocumentType.values.firstWhere(
        (e) => e.toString() == 'DocumentType.${map['type']}',
        orElse: () => DocumentType.identity,
      ),
      status: DocumentStatus.values.firstWhere(
        (e) => e.toString() == 'DocumentStatus.${map['status']}',
        orElse: () => DocumentStatus.pending,
      ),
      userId: map['userId'],
      requiredDocuments: map['requiredDocuments'] != null 
          ? List<String>.from(map['requiredDocuments']) 
          : null,
      uploadedDocuments: map['uploadedDocuments'] != null 
          ? List<String>.from(map['uploadedDocuments']) 
          : null,
      submittedAt: map['submittedAt'] != null ? DateTime.parse(map['submittedAt']) : null,
      processedAt: map['processedAt'] != null ? DateTime.parse(map['processedAt']) : null,
      completedAt: map['completedAt'] != null ? DateTime.parse(map['completedAt']) : null,
      notes: map['notes'],
      fees: map['fees']?.toDouble(),
      referenceNumber: map['referenceNumber'],
    );
  }

  // Méthode pour convertir un document en Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'userId': userId,
      'requiredDocuments': requiredDocuments,
      'uploadedDocuments': uploadedDocuments,
      'submittedAt': submittedAt?.toIso8601String(),
      'processedAt': processedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'notes': notes,
      'fees': fees,
      'referenceNumber': referenceNumber,
    };
  }

  // Méthode pour créer une copie du document avec des modifications
  DocumentModel copyWith({
    String? id,
    String? title,
    String? description,
    DocumentType? type,
    DocumentStatus? status,
    String? userId,
    List<String>? requiredDocuments,
    List<String>? uploadedDocuments,
    DateTime? submittedAt,
    DateTime? processedAt,
    DateTime? completedAt,
    String? notes,
    double? fees,
    String? referenceNumber,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      requiredDocuments: requiredDocuments ?? this.requiredDocuments,
      uploadedDocuments: uploadedDocuments ?? this.uploadedDocuments,
      submittedAt: submittedAt ?? this.submittedAt,
      processedAt: processedAt ?? this.processedAt,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      fees: fees ?? this.fees,
      referenceNumber: referenceNumber ?? this.referenceNumber,
    );
  }

  // Méthode pour obtenir le statut en français
  String get statusInFrench {
    switch (status) {
      case DocumentStatus.pending:
        return 'En attente';
      case DocumentStatus.processing:
        return 'En cours de traitement';
      case DocumentStatus.approved:
        return 'Approuvé';
      case DocumentStatus.rejected:
        return 'Rejeté';
      case DocumentStatus.completed:
        return 'Terminé';
    }
  }

  // Méthode pour obtenir le type en français
  String get typeInFrench {
    switch (type) {
      case DocumentType.identity:
        return 'Identité';
      case DocumentType.residence:
        return 'Résidence';
      case DocumentType.business:
        return 'Commerce';
      case DocumentType.auto:
        return 'Automobile';
      case DocumentType.land:
        return 'Foncier';
      case DocumentType.utilities:
        return 'Utilitaires';
      case DocumentType.justice:
        return 'Justice';
      case DocumentType.tax:
        return 'Fiscal';
    }
  }

  @override
  String toString() {
    return 'DocumentModel(id: $id, title: $title, type: $type, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentModel &&
        other.id == id &&
        other.title == title &&
        other.type == type &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        type.hashCode ^
        status.hashCode;
  }
}
