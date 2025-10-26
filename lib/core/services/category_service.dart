// ========================================================================================
// CATEGORY SERVICE - Service pour la gestion des catégories
// ========================================================================================

import 'api_service.dart';
import '../config/api_config.dart';
import '../../models/api_models.dart';

class CategoryService {
  final ApiService _apiService = apiService;
  
  /// Obtenir toutes les catégories
  Future<List<CategorieResponse>> getAllCategories() async {
    try {
      print('🔍 Chargement des catégories depuis l\'API...');
      
      final response = await _apiService.get(ApiConfig.categories);
      
      print('📦 Réponse reçue - Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        print('✅ ${data.length} catégorie(s) reçue(s) du backend');
        return data.map((json) => CategorieResponse.fromJson(json)).toList();
      } else {
        throw Exception('Erreur HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des catégories: $e');
      throw Exception('Erreur: $e');
    }
  }
  
  /// Obtenir une catégorie par ID
  Future<CategorieResponse> getCategoryById(String id) async {
    try {
      final response = await _apiService.get(ApiConfig.categoryById(id));
      
      if (response.statusCode == 200) {
        return CategorieResponse.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de la récupération de la catégorie');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Obtenir les sous-catégories d'une catégorie
  Future<List<SousCategorieResponse>> getSousCategoriesByCategorie(String categorieId) async {
    try {
      final response = await _apiService.get(ApiConfig.sousCategorieByCategorie(categorieId));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => SousCategorieResponse.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des sous-catégories');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  /// Obtenir une sous-catégorie par ID
  Future<SousCategorieResponse> getSousCategorieById(String id) async {
    try {
      final response = await _apiService.get(ApiConfig.sousCategorieById(id));
      
      if (response.statusCode == 200) {
        return SousCategorieResponse.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de la récupération de la sous-catégorie');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
}

// Instance globale du service de catégories
final CategoryService categoryService = CategoryService();

