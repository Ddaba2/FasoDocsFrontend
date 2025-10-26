// ========================================================================================
// EMOJI TO ICON - Conversion des emojis du backend vers les icônes Material
// ========================================================================================

import 'package:flutter/material.dart';

class EmojiToIcon {
  /// Convertit un emoji ou nom de catégorie en IconData
  static IconData getIcon(String? emojiOrCategory) {
    // Si pas d'emoji, utilise l'icône par défaut
    if (emojiOrCategory == null || emojiOrCategory.isEmpty) {
      return Icons.category;
    }
    
    // Supprime les espaces
    final cleanEmoji = emojiOrCategory.trim();
    
    // Mapping direct des emojis
    switch (cleanEmoji) {
      case '🪪':
        return Icons.perm_identity;
      case '🏢':
        return Icons.business_center;
      case '🚗':
        return Icons.directions_car;
      case '🏗️':
        return Icons.construction;
      case '💡':
        return Icons.flash_on;
      case '⚖️':
        return Icons.balance;
      case '💰':
        return Icons.account_balance;
      default:
        // Si c'est un autre emoji ou texte, retourne l'icône par défaut
        return Icons.category;
    }
  }
  
  /// Convertit un emoji en nom de couleur de fond
  static Color getBackgroundColor(String? emoji) {
    if (emoji == null || emoji.isEmpty) return const Color(0xFFE8F5E8);
    
    switch (emoji.trim()) {
      case '🪪':
        return const Color(0xFFE8F5E8); // Vert clair
      case '🏢':
        return const Color(0xFFFFF9C4); // Jaune clair
      case '🚗':
        return const Color(0xFFFFEBEE); // Rose clair
      case '🏗️':
        return const Color(0xFFE8F5E8); // Vert clair
      case '💡':
        return const Color(0xFFFFF9C4); // Jaune clair
      case '⚖️':
        return const Color(0xFFFFEBEE); // Rose clair
      case '💰':
        return const Color(0xFFE3F2FD); // Bleu clair
      default:
        return const Color(0xFFE8F5E8);
    }
  }
  
  /// Convertit un emoji en couleur d'icône
  static Color getIconColor(String? emoji) {
    if (emoji == null || emoji.isEmpty) return const Color(0xFF4CAF50);
    
    switch (emoji.trim()) {
      case '🪪':
        return const Color(0xFF4CAF50); // Vert
      case '🏢':
        return const Color(0xFFFFB300); // Orange
      case '🚗':
        return const Color(0xFFE91E63); // Rose
      case '🏗️':
        return const Color(0xFF4CAF50); // Vert
      case '💡':
        return const Color(0xFFFFB300); // Orange
      case '⚖️':
        return const Color(0xFF424242); // Gris foncé
      case '💰':
        return const Color(0xFF2196F3); // Bleu
      default:
        return const Color(0xFF4CAF50);
    }
  }
}

