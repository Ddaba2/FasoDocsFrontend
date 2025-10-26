// ========================================================================================
// CATEGORY MAPPING - Mapping des catégories de la base de données vers les UI
// ========================================================================================

import 'package:flutter/material.dart';

class CategoryMapping {
  /// Obtient l'icône correspondant au nom de la catégorie
  static IconData getIcon(String categoryName) {
    final lowerName = categoryName.toLowerCase();
    
    print('🔍 Recherche icône pour: "$categoryName" (lowercase: "$lowerName")');
    
    // Catégories basées sur la table "categories" de la base de données
    switch (lowerName) {
      case 'identité et citoyenneté':
        print('✅ Icône trouvée: perm_identity');
        return Icons.perm_identity;
      case 'création d\'entreprise':
        print('✅ Icône trouvée: business_center');
        return Icons.business_center;
      case 'documents auto':
        print('✅ Icône trouvée: directions_car');
        return Icons.directions_car;
      case 'service fonciers':
        print('✅ Icône trouvée: construction');
        return Icons.construction;
      case 'eau et électricité':
        print('✅ Icône trouvée: bolt');
        return Icons.bolt;
      case 'justice':
        print('✅ Icône trouvée: balance');
        return Icons.balance;
      case 'impôt et douane':
        print('✅ Icône trouvée: account_balance');
        return Icons.account_balance;
      default:
        print('⚠️ Icône par défaut utilisée (category)');
        return Icons.category; // Icône par défaut
    }
  }
  
  /// Obtient les couleurs correspondant au nom de la catégorie
  static Map<String, Color> getColors(String categoryName, int index) {
    final lowerName = categoryName.toLowerCase();
    
    // Palette de couleurs pour chaque catégorie
    Map<String, Map<String, Color>> categoryColors = {
      'identité et citoyenneté': {
        'backgroundColor': const Color(0xFFE8F5E8),
        'iconColor': const Color(0xFF4CAF50),
      },
      'création d\'entreprise': {
        'backgroundColor': const Color(0xFFFFF9C4),
        'iconColor': const Color(0xFFFFB300),
      },
      'documents auto': {
        'backgroundColor': const Color(0xFFFFEBEE),
        'iconColor': const Color(0xFFE91E63),
      },
      'service fonciers': {
        'backgroundColor': const Color(0xFFE8F5E8),
        'iconColor': const Color(0xFF4CAF50),
      },
      'eau et électricité': {
        'backgroundColor': const Color(0xFFFFF9C4),
        'iconColor': const Color(0xFFFFB300),
      },
      'justice': {
        'backgroundColor': const Color(0xFFFFEBEE),
        'iconColor': const Color(0xFF424242),
      },
      'impôt et douane': {
        'backgroundColor': const Color(0xFFE3F2FD),
        'iconColor': const Color(0xFF2196F3),
      },
    };
    
    // Retourner les couleurs spécifiques ou par défaut
    return categoryColors[lowerName] ?? _getDefaultColors(index);
  }
  
  /// Couleurs par défaut selon l'index
  static Map<String, Color> _getDefaultColors(int index) {
    final colors = [
      {'backgroundColor': const Color(0xFFE8F5E8), 'iconColor': const Color(0xFF4CAF50)},
      {'backgroundColor': const Color(0xFFFFF9C4), 'iconColor': const Color(0xFFFFB300)},
      {'backgroundColor': const Color(0xFFFFEBEE), 'iconColor': const Color(0xFFE91E63)},
      {'backgroundColor': const Color(0xFFE8F5E8), 'iconColor': const Color(0xFF4CAF50)},
      {'backgroundColor': const Color(0xFFFFF9C4), 'iconColor': const Color(0xFFFFB300)},
      {'backgroundColor': const Color(0xFFFFEBEE), 'iconColor': const Color(0xFF424242)},
      {'backgroundColor': const Color(0xFFE3F2FD), 'iconColor': const Color(0xFF2196F3)},
    ];
    return colors[index % colors.length];
  }
  
  /// Liste des catégories attendues de la base de données
  static const List<String> expectedCategories = [
    'Identité et citoyenneté',
    'Création d\'entreprise',
    'Documents auto',
    'Service fonciers',
    'Eau et électricité',
    'Justice',
    'Impôt et Douane',
  ];
}

