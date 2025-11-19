import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart' as geo;
import '../data/default_centers_bamako.dart';
import '../../models/api_models.dart';

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
          print('⚠️ Aucun résultat MapBox, utilisation des centres par défaut');
          // ✅ FALLBACK : Retourner des centres par défaut
          return await _useDefaultCenters(centerType, latitude, longitude, limit);
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
          final distance = calculateDistance(
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
        print('⚠️ Erreur MapBox: ${response.statusCode}, utilisation des centres par défaut');
        // ✅ FALLBACK : Retourner des centres par défaut
        return await _useDefaultCenters(centerType, latitude, longitude, limit);
      }
    } catch (e) {
      print('⚠️ Erreur lors de la recherche MapBox: $e, utilisation des centres par défaut');
      // ✅ FALLBACK : Retourner des centres par défaut
      return await _useDefaultCenters(centerType, latitude, longitude, limit);
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
        final distance = calculateDistance(
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
  static double calculateDistance(
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

  /// Trouver le centre le plus proche parmi les centres du backend
  /// Utilise les noms du backend et les coordonnées GPS de default_centers_bamako.dart
  static Future<NearbyPlace?> findNearestCenterFromBackend({
    required List<CentreDeTraitement> backendCenters,
    required double userLatitude,
    required double userLongitude,
  }) async {
    try {
      if (backendCenters.isEmpty) {
        print('⚠️ Aucun centre du backend fourni');
        return null;
      }

      print('🔍 Recherche du centre le plus proche parmi ${backendCenters.length} centres du backend');
      print('📍 Position utilisateur : ($userLatitude, $userLongitude)');

      // Obtenir tous les centres par défaut
      final allDefaultCenters = DefaultCentersBamako.getAllCenters();
      print('📋 ${allDefaultCenters.length} centres dans default_centers_bamako.dart');

      // Pour chaque centre du backend, trouver le centre correspondant dans default_centers_bamako
      final List<NearbyPlace> matchedPlaces = [];

      for (final backendCenter in backendCenters) {
        final backendCenterName = backendCenter.nom.toLowerCase().trim();
        print('🔍 Recherche correspondance pour: "${backendCenter.nom}"');

        // ✅ AMÉLIORATION : D'abord filtrer par type, puis faire le matching par nom
        // Si le nom du backend contient un type de centre (tribunal, commissariat, etc.)
        // on filtre d'abord par type pour avoir TOUS les centres de ce type
        String? detectedType;
        if (backendCenterName.contains('tribunal') || backendCenterName.contains('justice') || backendCenterName.contains('cour')) {
          detectedType = 'tribunal';
        } else if (backendCenterName.contains('commissariat') || backendCenterName.contains('police')) {
          detectedType = 'commissariat';
        } else if (backendCenterName.contains('mairie')) {
          detectedType = 'mairie';
        } else if (backendCenterName.contains('somagep') || backendCenterName.contains('eau')) {
          detectedType = 'somagep';
        } else if (backendCenterName.contains('edm') || backendCenterName.contains('électricité') || backendCenterName.contains('electricite')) {
          detectedType = 'edm';
        } else if (backendCenterName.contains('douane')) {
          detectedType = 'douanes';
        } else if (backendCenterName.contains('impôt') || backendCenterName.contains('impot')) {
          detectedType = 'impots';
        }

        // Si un type a été détecté, filtrer par type d'abord
        List<DefaultCenter> centersToSearch = allDefaultCenters;
        if (detectedType != null) {
          final filteredByType = DefaultCentersBamako.getCentersByType(detectedType);
          if (filteredByType.isNotEmpty) {
            centersToSearch = filteredByType;
            print('  ✅ Type détecté: "$detectedType" -> ${filteredByType.length} centres trouvés');
          }
        }

        // ✅ NOUVEAU : Trouver TOUTES les correspondances potentielles avec un score de similarité
        final Map<DefaultCenter, double> candidateMatches = {};

        for (final defaultCenter in centersToSearch) {
          final defaultName = defaultCenter.name.toLowerCase().trim();
          double similarity = 0.0;

          // 1. Recherche exacte (score = 1.0)
          if (defaultName == backendCenterName) {
            similarity = 1.0;
            candidateMatches[defaultCenter] = similarity;
            print('  ✅ Correspondance exacte trouvée: "${defaultCenter.name}"');
            break; // Si correspondance exacte trouvée, on s'arrête là
          }

          // 2. Recherche par contenu (score selon la longueur du match)
          if (defaultName.contains(backendCenterName) || backendCenterName.contains(defaultName)) {
            // Score basé sur la proportion de mots correspondants
            final backendWords = backendCenterName.split(' ').where((w) => w.length > 2).toList();
            final defaultWords = defaultName.split(' ').where((w) => w.length > 2).toList();
            final matchingWords = backendWords.where((word) => defaultWords.any((dw) => dw.contains(word) || word.contains(dw))).length;
            similarity = matchingWords / math.max(backendWords.length, defaultWords.length);
            
            // Bonus si "kalaban" ou "coura" est présent dans les deux
            if (backendCenterName.contains('kalaban') && defaultName.contains('kalaban')) {
              similarity += 0.3;
            }
            if (backendCenterName.contains('coura') && defaultName.contains('coura')) {
              similarity += 0.3;
            }
            
            // Bonus si les mots-clés spécifiques sont présents
            if (backendCenterName.contains('kalaban coura') && defaultName.contains('kalaban') && defaultName.contains('coura')) {
              similarity += 0.5; // Grand bonus pour match exact de zone
            }
            
            // Garder seulement le meilleur score pour ce centre
            if (similarity > 0.3) {
              final existingScore = candidateMatches[defaultCenter] ?? 0.0;
              if (similarity > existingScore) {
                candidateMatches[defaultCenter] = similarity;
                print('  ✅ Correspondance partielle (similarité: ${similarity.toStringAsFixed(2)}): "${defaultCenter.name}"');
              }
            }
          }

          // 3. Recherche par similarité de mots-clés (seulement si pas déjà trouvé avec un bon score)
          final currentScore = candidateMatches[defaultCenter] ?? 0.0;
          if (currentScore < 0.6 && _areNamesSimilar(backendCenterName, defaultName)) {
            final backendKeywords = backendCenterName.split(' ').where((w) => w.length > 3).toSet();
            final defaultKeywords = defaultName.split(' ').where((w) => w.length > 3).toSet();
            final commonKeywords = backendKeywords.intersection(defaultKeywords);
            similarity = commonKeywords.length / math.max(backendKeywords.length, defaultKeywords.length);
            
            if (similarity > 0.4 && similarity > currentScore) {
              candidateMatches[defaultCenter] = similarity;
              print('  ✅ Correspondance par mots-clés (similarité: ${similarity.toStringAsFixed(2)}): "${defaultCenter.name}"');
            }
          }
        }
        
        // ✅ MODIFIÉ : Si un type a été détecté mais aucune correspondance trouvée,
        // utiliser TOUS les centres de ce type (pour avoir le plus proche)
        List<DefaultCenter> finalCandidates = [];
        if (candidateMatches.isNotEmpty) {
          // Si on a des correspondances par nom, utiliser celles-ci
          finalCandidates = candidateMatches.keys.toList();
          print('  📍 ${finalCandidates.length} candidat(s) trouvé(s) par matching de nom');
        } else if (detectedType != null && centersToSearch.isNotEmpty) {
          // Sinon, si un type a été détecté, utiliser TOUS les centres de ce type
          finalCandidates = centersToSearch;
          print('  📍 Aucune correspondance par nom, utilisation de TOUS les ${finalCandidates.length} centres de type "$detectedType"');
        }

        // Calculer la distance pour TOUS les candidats et sélectionner le plus proche
        if (finalCandidates.isNotEmpty) {
          print('  📐 Calcul des distances pour ${finalCandidates.length} candidat(s)...');
          
          // Calculer la distance pour chaque candidat
          final List<({DefaultCenter center, double distance})> candidatesWithDistance = [];
          
          for (final center in finalCandidates) {
            // Calculer la distance depuis la position de l'utilisateur
            final distance = calculateDistance(
              userLatitude,
              userLongitude,
              center.latitude,
              center.longitude,
            );
            
            candidatesWithDistance.add((
              center: center,
              distance: distance,
            ));
            
            print('     - "${center.name}" (distance: ${distance.toStringAsFixed(2)} km)');
          }
          
          // ✅ Trier par DISTANCE (le plus proche en premier)
          candidatesWithDistance.sort((a, b) => a.distance.compareTo(b.distance));
          
          // Prendre le plus proche géographiquement
          final nearestCandidate = candidatesWithDistance.first;
          
          print('  ✅ Plus proche sélectionné: "${nearestCandidate.center.name}"');
          print('     📏 Distance: ${nearestCandidate.distance.toStringAsFixed(2)} km');
          
          // Afficher les autres candidats proches pour debug
          if (candidatesWithDistance.length > 1) {
            print('  📋 Autres candidats proches:');
            for (var i = 1; i < math.min(4, candidatesWithDistance.length); i++) {
              final candidate = candidatesWithDistance[i];
              print('     ${i + 1}. "${candidate.center.name}" (${candidate.distance.toStringAsFixed(2)} km)');
            }
          }

          // Utiliser le nom du backend mais les coordonnées du default_center le plus proche
          matchedPlaces.add(NearbyPlace(
            name: backendCenter.nom, // ✅ Nom du backend
            address: backendCenter.adresse.isNotEmpty 
                ? backendCenter.adresse 
                : nearestCandidate.center.address,
            latitude: nearestCandidate.center.latitude, // ✅ Coordonnées GPS vérifiées
            longitude: nearestCandidate.center.longitude,
            distance: nearestCandidate.distance, // ✅ Distance depuis l'utilisateur
            category: nearestCandidate.center.type,
            phone: backendCenter.telephone ?? nearestCandidate.center.phone,
          ));
        } else {
          print('⚠️ Aucune correspondance trouvée pour: "${backendCenter.nom}"');
          
          // Si le backend a des coordonnées GPS, les utiliser en fallback
          if (backendCenter.latitude != null && backendCenter.longitude != null) {
            try {
              final lat = double.parse(backendCenter.latitude!);
              final lon = double.parse(backendCenter.longitude!);
              final distance = calculateDistance(userLatitude, userLongitude, lat, lon);
              
              print('📌 Utilisation des coordonnées GPS du backend pour: "${backendCenter.nom}"');
              
              matchedPlaces.add(NearbyPlace(
                name: backendCenter.nom,
                address: backendCenter.adresse,
                latitude: lat,
                longitude: lon,
                distance: distance,
                category: null,
                phone: backendCenter.telephone,
              ));
            } catch (e) {
              print('❌ Erreur parsing coordonnées GPS du backend: $e');
            }
          }
        }
      }

      if (matchedPlaces.isEmpty) {
        print('⚠️ Aucun centre correspondant trouvé, retour du premier centre du backend');
        
        // ✅ FALLBACK : Retourner le premier centre du backend
        final firstBackendCenter = backendCenters.first;
        
        // Essayer d'utiliser les coordonnées GPS du backend
        if (firstBackendCenter.latitude != null && firstBackendCenter.longitude != null) {
          try {
            final lat = double.parse(firstBackendCenter.latitude!);
            final lon = double.parse(firstBackendCenter.longitude!);
            final distance = calculateDistance(userLatitude, userLongitude, lat, lon);
            
            print('📌 Utilisation du premier centre du backend: "${firstBackendCenter.nom}"');
            
            return NearbyPlace(
              name: firstBackendCenter.nom,
              address: firstBackendCenter.adresse,
              latitude: lat,
              longitude: lon,
              distance: distance,
              category: null,
              phone: firstBackendCenter.telephone,
            );
          } catch (e) {
            print('❌ Erreur parsing coordonnées GPS du backend: $e');
          }
        }
        
        // Si pas de coordonnées GPS, utiliser un centre par défaut de Bamako
        final allDefaultCenters = DefaultCentersBamako.getAllCenters();
        if (allDefaultCenters.isNotEmpty) {
          final defaultCenter = allDefaultCenters.first;
          final distance = calculateDistance(
            userLatitude,
            userLongitude,
            defaultCenter.latitude,
            defaultCenter.longitude,
          );
          
          print('📌 Utilisation d\'un centre par défaut: "${defaultCenter.name}"');
          
          return NearbyPlace(
            name: firstBackendCenter.nom,
            address: firstBackendCenter.adresse.isNotEmpty 
                ? firstBackendCenter.adresse 
                : defaultCenter.address,
            latitude: defaultCenter.latitude,
            longitude: defaultCenter.longitude,
            distance: distance,
            category: defaultCenter.type,
            phone: firstBackendCenter.telephone ?? defaultCenter.phone,
          );
        }
        
        // Dernier recours : retourner null
        return null;
      }

      // Trier par distance et retourner le plus proche
      matchedPlaces.sort((a, b) => a.distance.compareTo(b.distance));
      final nearestPlace = matchedPlaces.first;

      print('✅ Centre le plus proche trouvé: "${nearestPlace.name}"');
      print('   📏 Distance: ${nearestPlace.distanceText}');
      print('   📍 Coordonnées: (${nearestPlace.latitude}, ${nearestPlace.longitude})');

      return nearestPlace;
    } catch (e) {
      print('❌ Erreur lors de la recherche du centre le plus proche: $e');
      return null;
    }
  }

  /// Vérifier si deux noms sont similaires (matching approximatif)
  static bool _areNamesSimilar(String name1, String name2) {
    // Normaliser les noms (enlever accents, espaces multiples, etc.)
    final normalized1 = name1
        .toLowerCase()
        .replaceAll(RegExp(r'[àáâãäå]'), 'a')
        .replaceAll(RegExp(r'[èéêë]'), 'e')
        .replaceAll(RegExp(r'[ìíîï]'), 'i')
        .replaceAll(RegExp(r'[òóôõö]'), 'o')
        .replaceAll(RegExp(r'[ùúûü]'), 'u')
        .replaceAll(RegExp(r'[ç]'), 'c')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final normalized2 = name2
        .toLowerCase()
        .replaceAll(RegExp(r'[àáâãäå]'), 'a')
        .replaceAll(RegExp(r'[èéêë]'), 'e')
        .replaceAll(RegExp(r'[ìíîï]'), 'i')
        .replaceAll(RegExp(r'[òóôõö]'), 'o')
        .replaceAll(RegExp(r'[ùúûü]'), 'u')
        .replaceAll(RegExp(r'[ç]'), 'c')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    // Vérifier si un nom contient l'autre (au moins 70% de similarité)
    if (normalized1.contains(normalized2) || normalized2.contains(normalized1)) {
      return true;
    }

    // Extraire les mots-clés importants (commune, mairie, etc.)
    final keywords1 = normalized1.split(' ').where((word) => word.length > 3).toSet();
    final keywords2 = normalized2.split(' ').where((word) => word.length > 3).toSet();

    // Calculer le ratio de mots-clés en commun
    final commonKeywords = keywords1.intersection(keywords2);
    if (keywords1.isEmpty || keywords2.isEmpty) return false;

    final similarity = commonKeywords.length / math.max(keywords1.length, keywords2.length);
    return similarity >= 0.5; // Au moins 50% de mots-clés en commun
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

