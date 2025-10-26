// ========================================================================================
// DOCUMENT SERVICE - Service pour la gestion des documents
// ========================================================================================

import 'api_service.dart';
import '../config/api_config.dart';
import '../../models/document_model.dart';

class DocumentService {
  final ApiService _apiService = apiService;
  
  // Obtenir tous les documents
  Future<List<Document>> getAllDocuments() async {
    try {
      final response = await _apiService.get(ApiConfig.documents);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Document.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des documents');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  // Obtenir un document par ID
  Future<Document> getDocumentById(String id) async {
    try {
      final response = await _apiService.get('${ApiConfig.documents}/$id');
      
      if (response.statusCode == 200) {
        return Document.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de la récupération du document');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  // Créer un nouveau document
  Future<Document> createDocument(Map<String, dynamic> documentData) async {
    try {
      final response = await _apiService.post(
        ApiConfig.documents,
        data: documentData,
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Document.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de la création du document');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  // Mettre à jour un document
  Future<Document> updateDocument(String id, Map<String, dynamic> documentData) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.documents}/$id',
        data: documentData,
      );
      
      if (response.statusCode == 200) {
        return Document.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de la mise à jour du document');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  // Supprimer un document
  Future<void> deleteDocument(String id) async {
    try {
      await _apiService.delete('${ApiConfig.documents}/$id');
    } catch (e) {
      throw Exception('Erreur lors de la suppression du document: $e');
    }
  }
  
  // Obtenir les documents par catégorie
  Future<List<Document>> getDocumentsByCategory(String categoryId) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.documents}/category/$categoryId',
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Document.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des documents');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
}

// Instance globale du service de documents
final DocumentService documentService = DocumentService();

