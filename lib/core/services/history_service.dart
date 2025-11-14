// ========================================================================================
// HISTORY SERVICE - Service pour gérer l'historique de navigation
// ========================================================================================

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class HistoryService {
  static const String _historyKey = 'user_navigation_history';
  static const int _maxHistoryItems = 50; // Limite d'éléments dans l'historique

  // Ajouter un élément à l'historique
  Future<void> addToHistory(HistoryItem item) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_historyKey);
      
      List<HistoryItem> history = [];
      if (historyJson != null) {
        final List<dynamic> decoded = json.decode(historyJson);
        history = decoded.map((e) => HistoryItem.fromJson(e)).toList();
      }
      
      // Supprimer l'élément s'il existe déjà (pour éviter les doublons)
      history.removeWhere((h) => 
        h.id == item.id && h.type == item.type
      );
      
      // Ajouter le nouvel élément en premier
      history.insert(0, item);
      
      // Limiter la taille de l'historique
      if (history.length > _maxHistoryItems) {
        history = history.sublist(0, _maxHistoryItems);
      }
      
      // Sauvegarder
      final encoded = json.encode(history.map((e) => e.toJson()).toList());
      await prefs.setString(_historyKey, encoded);
      
      debugPrint('✅ Historique mis à jour: ${item.title}');
    } catch (e) {
      debugPrint('❌ Erreur lors de l\'ajout à l\'historique: $e');
    }
  }

  // Récupérer tout l'historique
  Future<List<HistoryItem>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_historyKey);
      
      if (historyJson == null) {
        return [];
      }
      
      final List<dynamic> decoded = json.decode(historyJson);
      return decoded.map((e) => HistoryItem.fromJson(e)).toList();
    } catch (e) {
      debugPrint('❌ Erreur lors de la récupération de l\'historique: $e');
      return [];
    }
  }

  // Effacer tout l'historique
  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
      debugPrint('✅ Historique effacé');
    } catch (e) {
      debugPrint('❌ Erreur lors de l\'effacement de l\'historique: $e');
    }
  }

  // Supprimer un élément spécifique
  Future<void> removeItem(String id, HistoryType type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_historyKey);
      
      if (historyJson == null) return;
      
      final List<dynamic> decoded = json.decode(historyJson);
      List<HistoryItem> history = decoded.map((e) => HistoryItem.fromJson(e)).toList();
      
      history.removeWhere((h) => h.id == id && h.type == type);
      
      final encoded = json.encode(history.map((e) => e.toJson()).toList());
      await prefs.setString(_historyKey, encoded);
      
      debugPrint('✅ Élément supprimé de l\'historique');
    } catch (e) {
      debugPrint('❌ Erreur lors de la suppression: $e');
    }
  }
}

// Types d'éléments dans l'historique
enum HistoryType {
  procedure,
  category,
  search,
  report,
  notification,
  center,
}

// Modèle d'élément d'historique
class HistoryItem {
  final String id;
  final HistoryType type;
  final String title;
  final String? subtitle;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata; // Pour stocker des infos supplémentaires

  HistoryItem({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    DateTime? timestamp,
    this.metadata,
  }) : timestamp = timestamp ?? DateTime.now();

  // Convertir en JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString().split('.').last,
    'title': title,
    'subtitle': subtitle,
    'timestamp': timestamp.toIso8601String(),
    'metadata': metadata,
  };

  // Créer depuis JSON
  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'],
      type: HistoryType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => HistoryType.procedure,
      ),
      title: json['title'],
      subtitle: json['subtitle'],
      timestamp: DateTime.parse(json['timestamp']),
      metadata: json['metadata'],
    );
  }

  // Obtenir le temps relatif (ex: "Il y a 2h")
  String getRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Il y a $weeks sem';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Il y a $months mois';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

// Instance globale du service d'historique
final HistoryService historyService = HistoryService();

