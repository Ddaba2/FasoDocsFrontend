// ========================================================================================
// CONTRÔLEUR DOCUMENT - MVC Pattern
// ========================================================================================
// Ce fichier contient la logique métier pour la gestion des documents
// Il gère les opérations CRUD et la logique de traitement des documents
// ========================================================================================

import '../models/document_model.dart';

class DocumentController {
  static final DocumentController _instance = DocumentController._internal();
  factory DocumentController() => _instance;
  DocumentController._internal();

  // Liste des documents de l'utilisateur
  List<DocumentModel> _userDocuments = [];
  
  // Getters
  List<DocumentModel> get userDocuments => List.unmodifiable(_userDocuments);
  List<DocumentModel> get pendingDocuments => _userDocuments.where((doc) => doc.status == DocumentStatus.pending).toList();
  List<DocumentModel> get processingDocuments => _userDocuments.where((doc) => doc.status == DocumentStatus.processing).toList();
  List<DocumentModel> get completedDocuments => _userDocuments.where((doc) => doc.status == DocumentStatus.completed).toList();

  // ========================================================================================
  // MÉTHODES DE GESTION DES DOCUMENTS
  // ========================================================================================

  /// Charge les documents de l'utilisateur
  Future<void> loadUserDocuments(String userId) async {
    try {
      // Simulation du chargement depuis une API
      await Future.delayed(const Duration(seconds: 1));
      
      // Données de test
      _userDocuments = [
        DocumentModel(
          id: 'doc_1',
          title: 'Carte Nationale d\'Identité',
          description: 'Demande de renouvellement de CNI',
          type: DocumentType.identity,
          status: DocumentStatus.processing,
          userId: userId,
          requiredDocuments: ['Photo d\'identité', 'Ancienne CNI', 'Justificatif de domicile'],
          uploadedDocuments: ['Photo d\'identité', 'Ancienne CNI'],
          submittedAt: DateTime.now().subtract(const Duration(days: 5)),
          fees: 2000.0,
          referenceNumber: 'CNI-2024-001',
        ),
        DocumentModel(
          id: 'doc_2',
          title: 'Permis de Conduire',
          description: 'Demande de permis de conduire catégorie B',
          type: DocumentType.auto,
          status: DocumentStatus.pending,
          userId: userId,
          requiredDocuments: ['Photo d\'identité', 'Certificat médical', 'Attestation de formation'],
          uploadedDocuments: ['Photo d\'identité'],
          submittedAt: DateTime.now().subtract(const Duration(days: 2)),
          fees: 15000.0,
          referenceNumber: 'PC-2024-002',
        ),
        DocumentModel(
          id: 'doc_3',
          title: 'Carte de Résident',
          description: 'Demande de carte de résident',
          type: DocumentType.residence,
          status: DocumentStatus.completed,
          userId: userId,
          requiredDocuments: ['Justificatif de domicile', 'Contrat de bail', 'Photo d\'identité'],
          uploadedDocuments: ['Justificatif de domicile', 'Contrat de bail', 'Photo d\'identité'],
          submittedAt: DateTime.now().subtract(const Duration(days: 30)),
          processedAt: DateTime.now().subtract(const Duration(days: 15)),
          completedAt: DateTime.now().subtract(const Duration(days: 10)),
          fees: 5000.0,
          referenceNumber: 'CR-2024-003',
        ),
      ];
    } catch (e) {
      print('Erreur lors du chargement des documents: $e');
    }
  }

  /// Crée un nouveau document
  Future<DocumentModel?> createDocument({
    required String title,
    required String description,
    required DocumentType type,
    required String userId,
    List<String>? requiredDocuments,
    double? fees,
  }) async {
    try {
      // Simulation de la création en base de données
      await Future.delayed(const Duration(seconds: 1));

      final newDocument = DocumentModel(
        id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        description: description,
        type: type,
        status: DocumentStatus.pending,
        userId: userId,
        requiredDocuments: requiredDocuments ?? [],
        uploadedDocuments: [],
        submittedAt: DateTime.now(),
        fees: fees,
        referenceNumber: '${type.toString().split('.').last.toUpperCase()}-2024-${_userDocuments.length + 1}',
      );

      _userDocuments.add(newDocument);
      return newDocument;
    } catch (e) {
      print('Erreur lors de la création du document: $e');
      return null;
    }
  }

  /// Met à jour un document
  Future<bool> updateDocument(String documentId, {
    String? title,
    String? description,
    DocumentStatus? status,
    List<String>? uploadedDocuments,
    String? notes,
  }) async {
    try {
      final index = _userDocuments.indexWhere((doc) => doc.id == documentId);
      if (index == -1) return false;

      // Simulation de la mise à jour en base de données
      await Future.delayed(const Duration(milliseconds: 500));

      _userDocuments[index] = _userDocuments[index].copyWith(
        title: title,
        description: description,
        status: status,
        uploadedDocuments: uploadedDocuments,
        notes: notes,
        processedAt: status == DocumentStatus.processing ? DateTime.now() : _userDocuments[index].processedAt,
        completedAt: status == DocumentStatus.completed ? DateTime.now() : _userDocuments[index].completedAt,
      );

      return true;
    } catch (e) {
      print('Erreur lors de la mise à jour du document: $e');
      return false;
    }
  }

  /// Supprime un document
  Future<bool> deleteDocument(String documentId) async {
    try {
      final index = _userDocuments.indexWhere((doc) => doc.id == documentId);
      if (index == -1) return false;

      // Simulation de la suppression en base de données
      await Future.delayed(const Duration(milliseconds: 500));

      _userDocuments.removeAt(index);
      return true;
    } catch (e) {
      print('Erreur lors de la suppression du document: $e');
      return false;
    }
  }

  /// Obtient un document par son ID
  DocumentModel? getDocumentById(String documentId) {
    try {
      return _userDocuments.firstWhere((doc) => doc.id == documentId);
    } catch (e) {
      return null;
    }
  }

  /// Obtient les documents par type
  List<DocumentModel> getDocumentsByType(DocumentType type) {
    return _userDocuments.where((doc) => doc.type == type).toList();
  }

  /// Obtient les documents par statut
  List<DocumentModel> getDocumentsByStatus(DocumentStatus status) {
    return _userDocuments.where((doc) => doc.status == status).toList();
  }

  // ========================================================================================
  // MÉTHODES DE STATISTIQUES
  // ========================================================================================

  /// Obtient le nombre total de documents
  int get totalDocuments => _userDocuments.length;

  /// Obtient le nombre de documents par statut
  Map<DocumentStatus, int> get documentsByStatus {
    Map<DocumentStatus, int> counts = {};
    for (DocumentStatus status in DocumentStatus.values) {
      counts[status] = _userDocuments.where((doc) => doc.status == status).length;
    }
    return counts;
  }

  /// Obtient le nombre de documents par type
  Map<DocumentType, int> get documentsByType {
    Map<DocumentType, int> counts = {};
    for (DocumentType type in DocumentType.values) {
      counts[type] = _userDocuments.where((doc) => doc.type == type).length;
    }
    return counts;
  }

  /// Obtient le montant total des frais
  double get totalFees {
    return _userDocuments.fold(0.0, (sum, doc) => sum + (doc.fees ?? 0.0));
  }

  /// Obtient le montant des frais payés
  double get paidFees {
    return _userDocuments
        .where((doc) => doc.status == DocumentStatus.completed)
        .fold(0.0, (sum, doc) => sum + (doc.fees ?? 0.0));
  }

  /// Obtient le montant des frais en attente
  double get pendingFees {
    return _userDocuments
        .where((doc) => doc.status == DocumentStatus.pending || doc.status == DocumentStatus.processing)
        .fold(0.0, (sum, doc) => sum + (doc.fees ?? 0.0));
  }

  // ========================================================================================
  // MÉTHODES UTILITAIRES
  // ========================================================================================

  /// Vérifie si un document peut être modifié
  bool canModifyDocument(String documentId) {
    final document = getDocumentById(documentId);
    if (document == null) return false;
    
    return document.status == DocumentStatus.pending;
  }

  /// Vérifie si un document peut être supprimé
  bool canDeleteDocument(String documentId) {
    final document = getDocumentById(documentId);
    if (document == null) return false;
    
    return document.status == DocumentStatus.pending;
  }

  /// Obtient le temps de traitement moyen
  Duration get averageProcessingTime {
    final completedDocs = _userDocuments
        .where((doc) => doc.status == DocumentStatus.completed && 
                       doc.submittedAt != null && 
                       doc.completedAt != null)
        .toList();
    
    if (completedDocs.isEmpty) return Duration.zero;
    
    final totalDays = completedDocs.fold(0, (sum, doc) {
      return sum + doc.completedAt!.difference(doc.submittedAt!).inDays;
    });
    
    return Duration(days: totalDays ~/ completedDocs.length);
  }

  /// Obtient les documents récents (derniers 7 jours)
  List<DocumentModel> get recentDocuments {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return _userDocuments
        .where((doc) => doc.submittedAt != null && doc.submittedAt!.isAfter(sevenDaysAgo))
        .toList();
  }
}
