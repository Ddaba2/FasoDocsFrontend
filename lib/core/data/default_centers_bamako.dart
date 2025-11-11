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
  // ⚠️ COORDONNÉES GPS VÉRIFIÉES SUR GOOGLE MAPS
  
  static const List<DefaultCenter> mairies = [];
  
  static const List<DefaultCenter> commissariats = [
    DefaultCenter(
      name: 'Commissariat de Police',
      type: 'commissariat',
      address: 'Bamako, Mali',
      latitude: 12.57838103514128,
      longitude: -7.987034250045301, 
      phone: null, // À compléter si disponible
      plusCode: 'H2H7+36M',
    ),
  ];
  
  static const List<DefaultCenter> tribunaux = [];
  static const List<DefaultCenter> somagep = [];
  static const List<DefaultCenter> edm = [];
  static const List<DefaultCenter> transports = [];
  static const List<DefaultCenter> ministeres = [];
  static const List<DefaultCenter> impots = [];
  
  /// Obtenir les centres selon le type
  static List<DefaultCenter> getCentersByType(String centerType) {
    final lowerType = centerType.toLowerCase();
    
    if (lowerType.contains('commissariat') || lowerType.contains('police')) {
      return commissariats;
    }
    if (lowerType.contains('mairie')) {
      return mairies;
    }
    if (lowerType.contains('tribunal')) {
      return tribunaux;
    }
    if (lowerType.contains('somagep') || lowerType.contains('eau')) {
      return somagep;
    }
    if (lowerType.contains('edm') || lowerType.contains('électricité')) {
      return edm;
    }
    if (lowerType.contains('transports') || lowerType.contains('transports')) {
      return transports;
    }
    if (lowerType.contains('ministère') || lowerType.contains('ministeres')) {
      return ministeres;
    }
    if (lowerType.contains('impôt') || lowerType.contains('impot')) {
      return impots;
    }
    
    return [];
  }
  
  /// Obtenir tous les centres (toutes catégories)
  static List<DefaultCenter> getAllCenters() {
    return [
      ...mairies,
      ...commissariats,
      ...tribunaux,
      ...somagep,
      ...edm,
      ...transports,
      ...ministeres,
      ...impots,
    ];
  }
}
