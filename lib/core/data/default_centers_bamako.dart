/// Centres essentiels de Bamako (fallback si MapBox ne trouve rien)
/// ⚠️ ATTENTION : Toutes les coordonnées GPS doivent être VÉRIFIÉES sur Google Maps
/// Pour ajouter un centre : Cherchez-le sur Google Maps, récupérez ses vraies coordonnées
class DefaultCenter {
  final String name;
  final String type;
  final String address;
  final double latitude;
  final double longitude;
  final String? phone;
  final String? plusCode; // Code Plus de Google Maps (ex: "H2H7+76R")
  
  const DefaultCenter({
    required this.name,
    required this.type,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.phone,
    this.plusCode,
  });
}

/// Liste des centres principaux de Bamako
class DefaultCentersBamako {
  // ⚠️ TOUTES LES LISTES SONT VIDES POUR FORCER L'UTILISATION DE MAPBOX
  // Les coordonnées générées automatiquement étaient incorrectes
  // MapBox retournera les VRAIES coordonnées depuis OpenStreetMap
  
  static const List<DefaultCenter> mairies = [];
  static const List<DefaultCenter> commissariats = [];
  static const List<DefaultCenter> tribunaux = [];
  static const List<DefaultCenter> hopitaux = [];
  static const List<DefaultCenter> somagep = [];
  static const List<DefaultCenter> edm = [];
  static const List<DefaultCenter> administrations = [];
  static const List<DefaultCenter> ministeres = [];
  static const List<DefaultCenter> impots = [];
  
  /// Obtenir les centres selon le type
  static List<DefaultCenter> getCentersByType(String centerType) {
    // Retourner liste vide pour forcer MapBox
    return [];
  }
  
  /// Obtenir tous les centres (toutes catégories)
  static List<DefaultCenter> getAllCenters() {
    return [];
  }
}
