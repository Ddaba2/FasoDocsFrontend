import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart' as geo;
import '../data/default_centers_bamako.dart';

/// Service pour rechercher des lieux à proximité avec MapBox
class MapBoxNearbyService {
  static const String MAPBOX_ACCESS_TOKEN = 
    "pk.eyJ1IjoiYXNzaW10cmFwIiwiYSI6ImNtZjkxY25haTB5aHYyanM0djVzMWc1MHAifQ.dGi1jYLwKXbpGly4PFaLaA";
  
  /// Mapping des types de centres vers les catégories MapBox
  static const Map<String, String> centerTypeToMapBoxCategory = {
    'mairie': 'town_hall',
    'commissariat': 'police',
    'hopital': 'hospital',
    'poste': 'post_office',
    'banque': 'bank',
    'école': 'school',
    'ecole': 'school',
    'tribunal': 'courthouse',
    'préfecture': 'government',
    'prefecture': 'government',
  };

  /// Rechercher des lieux à proximité
  static Future<List<NearbyPlace>> searchNearby({
    required String centerType,
    required double latitude,
    required double longitude,
    int limit = 5,
  }) async {
    try {
      print('🔍 Recherche de centres pour : "$centerType"');
      print('📍 Position utilisateur : ($latitude, $longitude)');
      
      // ⚠️ DÉSACTIVÉ : Base de données locale avec coordonnées incorrectes
      // ✅ UTILISE UNIQUEMENT MAPBOX pour avoir les vraies coordonnées
      
      print('🌐 Recherche MapBox uniquement (coordonnées GPS réelles)...');
      
      // Construire une requête MapBox
      String searchQuery;
      final lowerType = centerType.toLowerCase();
      
      if (lowerType.contains('mairie')) {
        searchQuery = 'mairie bamako mali';
      } else if (lowerType.contains('commissariat') || lowerType.contains('police')) {
        searchQuery = 'commissariat police bamako mali';
      } else if (lowerType.contains('tribunal') || lowerType.contains('justice')) {
        searchQuery = 'tribunal justice bamako mali';
      } else if (lowerType.contains('hôpital') || lowerType.contains('hopital') || lowerType.contains('santé')) {
        searchQuery = 'hopital sante bamako mali';
      } else if (lowerType.contains('somagep') || lowerType.contains('eau')) {
        searchQuery = 'somagep agence bamako mali';
      } else if (lowerType.contains('edm') || lowerType.contains('électricité') || lowerType.contains('electricite')) {
        searchQuery = 'edm agence bamako mali';
      } else {
        searchQuery = '$centerType bamako mali';
      }
      
      final String url = 
        'https://api.mapbox.com/geocoding/v5/mapbox.places/${Uri.encodeComponent(searchQuery)}.json'
        '?proximity=$longitude,$latitude'
        '&limit=$limit'
        '&language=fr'
        '&types=poi'  // Seulement les POI (points d'intérêt), pas les routes
        '&access_token=$MAPBOX_ACCESS_TOKEN';
      
      print('🔍 Recherche MapBox backup: "$searchQuery"');
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List;
        
        print('✅ MapBox a trouvé ${features.length} résultats');
        
        if (features.isEmpty) {
          print('❌ Aucun résultat MapBox');
          return [];
        }
        
        // ✅ FILTRAGE LÉGER : Exclure seulement les routes évidentes
        final filteredFeatures = features.where((feature) {
          final text = (feature['text'] ?? '').toString().toLowerCase();
          
          // Exclure SEULEMENT les routes nationales évidentes (RN1, RN2, etc.)
          final isRoute = RegExp(r'^rn\d+$').hasMatch(text);
          if (isRoute) {
            print('⚠️  Route ignorée: $text');
            return false;
          }
          
          return true;
        }).toList();
        
        // ✅ Garder tous les résultats même si filtrés (pas de fallback à la base locale)
        final featuresToUse = filteredFeatures.isNotEmpty ? filteredFeatures : features;
        
        print('✅ ${featuresToUse.length} résultats MapBox retenus');
        
        // Convertir les résultats en objets NearbyPlace
        final places = featuresToUse.map((feature) {
          final coordinates = feature['geometry']['coordinates'] as List;
          final properties = feature['properties'] ?? {};
          
          // Calculer la distance
          final distance = _calculateDistance(
            latitude,
            longitude,
            coordinates[1], // latitude
            coordinates[0], // longitude
          );
          
          final name = feature['text'] ?? feature['place_name'] ?? 'Lieu inconnu';
          final address = feature['place_name'] ?? '';
          
          print('  📍 ${name} - ${distance.toStringAsFixed(2)} km');
          
          return NearbyPlace(
            name: name,
            address: address,
            latitude: coordinates[1],
            longitude: coordinates[0],
            distance: distance,
            category: properties['category']?.toString(),
            phone: properties['phone']?.toString(),
          );
        }).toList();
        
        // Trier par distance
        places.sort((a, b) => a.distance.compareTo(b.distance));
        
        return places;
      } else {
        print('❌ Erreur MapBox: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Erreur lors de la recherche MapBox: $e');
      return [];
    }
  }
  
  /// Utiliser les centres par défaut de Bamako
  static Future<List<NearbyPlace>> _useDefaultCenters(
    String centerType,
    double userLatitude,
    double userLongitude,
    int limit,
  ) async {
    try {
      // Obtenir les centres par défaut selon le type
      final defaultCenters = DefaultCentersBamako.getCentersByType(centerType);
      
      if (defaultCenters.isEmpty) {
        print('❌ Aucun centre par défaut pour le type: $centerType');
        return [];
      }
      
      print('✅ ${defaultCenters.length} centres par défaut trouvés pour: $centerType');
      
      // Convertir en NearbyPlace et calculer les distances
      final places = defaultCenters.map((center) {
        final distance = _calculateDistance(
          userLatitude,
          userLongitude,
          center.latitude,
          center.longitude,
        );
        
        return NearbyPlace(
          name: center.name,
          address: center.address,
          latitude: center.latitude,
          longitude: center.longitude,
          distance: distance,
          category: center.type,
          phone: center.phone,
        );
      }).toList();
      
      // Trier par distance
      places.sort((a, b) => a.distance.compareTo(b.distance));
      
      // Retourner les "limit" plus proches
      return places.take(limit).toList();
      
    } catch (e) {
      print('❌ Erreur lors de l\'utilisation des centres par défaut: $e');
      return [];
    }
  }

  /// Calculer la distance entre deux points GPS (formule de Haversine)
  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // km
    
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    
    final a = 
      math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) *
      math.sin(dLon / 2) * math.sin(dLon / 2);
    
    final c = 2 * math.asin(math.sqrt(a));
    
    return earthRadius * c;
  }

  static double _toRadians(double degree) {
    return degree * (math.pi / 180);
  }

  /// Obtenir la position actuelle de l'utilisateur
  static Future<geo.Position?> getUserLocation() async {
    try {
      // Vérifier les permissions
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('❌ Service de localisation désactivé');
        return null;
      }

      geo.LocationPermission permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) {
          print('❌ Permission de localisation refusée');
          return null;
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        print('❌ Permission de localisation refusée définitivement');
        return null;
      }

      // Obtenir la position
      print('📍 Récupération de la position GPS...');
      final position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
      );
      
      print('✅ Position obtenue: (${position.latitude}, ${position.longitude})');
      return position;
    } catch (e) {
      print('❌ Erreur lors de la récupération de la position: $e');
      return null;
    }
  }
}

/// Modèle pour un lieu à proximité
class NearbyPlace {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distance; // en km
  final String? category;
  final String? phone;

  NearbyPlace({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
    this.category,
    this.phone,
  });

  String get distanceText {
    if (distance < 1) {
      return '${(distance * 1000).round()} m';
    } else {
      return '${distance.toStringAsFixed(1)} km';
    }
  }
}

