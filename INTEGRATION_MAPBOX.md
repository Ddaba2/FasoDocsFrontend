# 🗺️ Intégration Mapbox - FasoDocs

Ce document décrit l'intégration de **Mapbox** dans l'application FasoDocs pour la géolocalisation et la recherche de centres de service à proximité.

## 📖 Vue d'ensemble

**Mapbox** est utilisé pour :
- 🗺️ Afficher des cartes interactives
- 📍 Localiser l'utilisateur en temps réel
- 🔍 Rechercher des lieux à proximité (mairies, commissariats, hôpitaux, etc.)
- 📏 Calculer les distances entre l'utilisateur et les centres
- 🧭 Afficher des itinéraires

## 🔑 Configuration

### Token d'accès Mapbox

Le token est défini dans `lib/core/services/mapbox_nearby_service.dart` :

```dart
static const String MAPBOX_ACCESS_TOKEN = 
  "pk.eyJ1IjoiYXNzaW10cmFwIiwiYSI6ImNtZjkxY25haTB5aHYyanM0djVzMWc1MHAifQ.dGi1jYLwKXbpGly4PFaLaA";
```

⚠️ **Important** : Ce token est propre au compte Mapbox. Pour la production, créez votre propre token sur [mapbox.com](https://account.mapbox.com/access-tokens/)

### Dépendances

Dans `pubspec.yaml` :
```yaml
dependencies:
  mapbox_maps_flutter: ^2.12.0    # SDK Mapbox pour Flutter
  geolocator: ^14.0.2             # Géolocalisation
  permission_handler: ^12.0.1     # Gestion des permissions
  http: ^1.2.0                    # Requêtes HTTP pour Geocoding API
```

### Permissions

#### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

#### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>FasoDocs a besoin d'accéder à votre position pour trouver les centres de service à proximité</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>FasoDocs a besoin d'accéder à votre position</string>
```

---

## 📁 Fichiers concernés

### 1. Service principal Mapbox

#### `lib/core/services/mapbox_nearby_service.dart`
**Rôle** : Service principal pour la recherche de lieux à proximité avec Mapbox

**Classe principale** : `MapBoxNearbyService`

**Méthodes disponibles** :

##### 🔍 Rechercher des lieux à proximité
```dart
static Future<List<NearbyPlace>> searchNearby({
  required String centerType,
  required double latitude,
  required double longitude,
  int limit = 5,
})
```

**Paramètres** :
- `centerType` : Type de centre recherché (mairie, commissariat, hôpital, etc.)
- `latitude` : Latitude de l'utilisateur
- `longitude` : Longitude de l'utilisateur
- `limit` : Nombre de résultats maximum (défaut: 5)

**Retour** : Liste d'objets `NearbyPlace` triés par distance

**Exemple d'utilisation** :
```dart
final places = await MapBoxNearbyService.searchNearby(
  centerType: 'mairie',
  latitude: 12.6392,
  longitude: -8.0029,
  limit: 5,
);
```

**Fonctionnement** :
1. Construit une requête de recherche adaptée au type de centre
2. Appelle l'API Geocoding de Mapbox
3. Filtre les résultats (exclut les routes, etc.)
4. Calcule la distance entre chaque lieu et l'utilisateur
5. Trie par distance croissante

##### 📍 Obtenir la position de l'utilisateur
```dart
static Future<Position?> getUserLocation()
```

**Fonctionnement** :
1. Vérifie que le service de localisation est activé
2. Demande les permissions si nécessaire
3. Récupère la position GPS en haute précision
4. Retourne un objet `Position` (de geolocator)

**Exemple** :
```dart
final position = await MapBoxNearbyService.getUserLocation();
if (position != null) {
  print('Lat: ${position.latitude}, Lon: ${position.longitude}');
}
```

---

### 2. Modèle de données

#### `NearbyPlace` (dans `mapbox_nearby_service.dart`)

**Propriétés** :
```dart
class NearbyPlace {
  final String name;          // Nom du lieu
  final String address;       // Adresse complète
  final double latitude;      // Latitude
  final double longitude;     // Longitude
  final double distance;      // Distance en km
  final String? category;     // Catégorie Mapbox (optionnel)
  final String? phone;        // Téléphone (optionnel)
}
```

**Méthode utile** :
```dart
String get distanceText  // Format lisible: "500 m" ou "2.5 km"
```

---

### 3. Widget carte interactive

#### `lib/core/widgets/nearby_center_map.dart`
**Rôle** : Widget pour afficher une carte Mapbox avec les centres à proximité

**Utilisation** :
```dart
NearbyCenterMap(
  userLatitude: 12.6392,
  userLongitude: -8.0029,
  places: nearbyPlaces,
  centerType: 'Mairie',
)
```

**Fonctionnalités** :
- Affiche la carte Mapbox centrée sur l'utilisateur
- Place un marqueur pour chaque centre
- Marqueur spécial pour la position de l'utilisateur
- Zoom automatique pour inclure tous les marqueurs
- Interaction tactile (zoom, déplacement)

---

## 🔄 Flux de recherche de centres

```
User clicks "Voir les centres" ──► centre_screen.dart
                                          │
                                          ▼
                        MapBoxNearbyService.getUserLocation()
                                          │
                                          ▼
                        Permission check ─► Granted?
                                          │
                                     Yes  │  No
                                          ▼
                              Get GPS coordinates
                                          │
                                          ▼
                        MapBoxNearbyService.searchNearby()
                                          │
                                          ▼
                    Build Mapbox Geocoding API URL
                                          │
                                          ▼
        GET https://api.mapbox.com/geocoding/v5/mapbox.places/...
                                          │
                                          ▼
                           Parse JSON response
                                          │
                                          ▼
                        Filter results (remove roads)
                                          │
                                          ▼
                      Calculate distances (Haversine)
                                          │
                                          ▼
                        Sort by distance (closest first)
                                          │
                                          ▼
                    Return List<NearbyPlace>
                                          │
                                          ▼
                  Display in NearbyCenterMap widget
```

---

## 🌐 API Mapbox Geocoding

### Endpoint utilisé
```
GET https://api.mapbox.com/geocoding/v5/mapbox.places/{search_query}.json
```

### Paramètres de requête
```dart
?proximity={longitude},{latitude}  // Position utilisateur (priorité de proximité)
&limit={limit}                     // Nombre de résultats
&language=fr                       // Langue des résultats
&types=poi                         // Seulement les POI (points of interest)
&access_token={MAPBOX_ACCESS_TOKEN}
```

### Exemple de requête
```
https://api.mapbox.com/geocoding/v5/mapbox.places/mairie%20bamako%20mali.json
?proximity=-8.0029,12.6392
&limit=5
&language=fr
&types=poi
&access_token=pk.eyJ1...
```

### Structure de réponse JSON
```json
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "text": "Mairie de la Commune I",
      "place_name": "Mairie de la Commune I, Bamako, Mali",
      "geometry": {
        "type": "Point",
        "coordinates": [-8.003, 12.654]  // [longitude, latitude]
      },
      "properties": {
        "category": "town_hall",
        "phone": "+223 XX XX XX XX"
      }
    }
  ]
}
```

---

## 📊 Mapping des types de centres

Le service convertit les types de centres français vers les catégories Mapbox :

```dart
static const Map<String, String> centerTypeToMapBoxCategory = {
  'mairie': 'town_hall',
  'commissariat': 'police',
  'hopital': 'hospital',
  'poste': 'post_office',
  'banque': 'bank',
  'école': 'school',
  'tribunal': 'courthouse',
  'préfecture': 'government',
};
```

### Requêtes de recherche optimisées

Le service construit des requêtes spécifiques pour chaque type :

```dart
if (lowerType.contains('mairie')) {
  searchQuery = 'mairie bamako mali';
} else if (lowerType.contains('commissariat')) {
  searchQuery = 'commissariat police bamako mali';
} else if (lowerType.contains('hôpital')) {
  searchQuery = 'hopital sante bamako mali';
} else if (lowerType.contains('somagep')) {
  searchQuery = 'somagep agence bamako mali';
} else if (lowerType.contains('edm')) {
  searchQuery = 'edm agence bamako mali';
}
```

---

## 📏 Calcul de distance

### Formule de Haversine

Le service utilise la formule de Haversine pour calculer la distance entre deux points GPS :

```dart
static double _calculateDistance(
  double lat1, double lon1,  // Position utilisateur
  double lat2, double lon2,  // Position du centre
) {
  const double earthRadius = 6371; // km
  
  final dLat = _toRadians(lat2 - lat1);
  final dLon = _toRadians(lon2 - lon1);
  
  final a = 
    sin(dLat / 2) * sin(dLat / 2) +
    cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
    sin(dLon / 2) * sin(dLon / 2);
  
  final c = 2 * asin(sqrt(a));
  
  return earthRadius * c;  // Distance en km
}
```

**Précision** : ±5 mètres pour des distances courtes

---

## 🎨 Affichage sur carte

### Widget `NearbyCenterMap`

**Fonctionnalités principales** :

1. **Initialisation de la carte**
```dart
MapboxMap(
  styleUri: MapboxStyles.MAPBOX_STREETS,  // Style de carte
  cameraOptions: CameraOptions(
    center: Point(
      coordinates: Position(userLongitude, userLatitude),
    ),
    zoom: 13.0,
  ),
)
```

2. **Ajout de marqueurs**
```dart
// Marqueur utilisateur (bleu)
PointAnnotation(
  point: userPosition,
  iconImage: 'user-marker',
  iconSize: 1.5,
)

// Marqueurs des centres (rouge)
for (final place in places) {
  PointAnnotation(
    point: Point(coordinates: Position(place.longitude, place.latitude)),
    iconImage: 'center-marker',
    textField: place.name,
  )
}
```

3. **Ajustement du zoom**
```dart
// Calcule les bounds pour inclure tous les marqueurs
final bounds = LatLngBounds(
  southwest: minPoint,
  northeast: maxPoint,
);
mapController.flyTo(bounds);
```

---

## 🗄️ Base de données locale de secours

### `lib/core/data/default_centers_bamako.dart`

**Rôle** : Fournit des centres par défaut en cas d'échec de Mapbox

⚠️ **Actuellement désactivé** : Le service utilise uniquement Mapbox pour garantir des coordonnées GPS précises.

**Structure** :
```dart
class DefaultCenter {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String type;
  final String? phone;
}

class DefaultCentersBamako {
  static List<DefaultCenter> getCentersByType(String type) {
    // Retourne les centres selon le type
  }
}
```

---

## 🧪 Exemple d'écran utilisant Mapbox

### `lib/views/home/centre_screen.dart`

**Flux complet** :

1. **Récupération de la position**
```dart
final position = await MapBoxNearbyService.getUserLocation();
if (position == null) {
  // Afficher erreur permission
  return;
}
```

2. **Recherche des centres**
```dart
final places = await MapBoxNearbyService.searchNearby(
  centerType: 'mairie',
  latitude: position.latitude,
  longitude: position.longitude,
  limit: 5,
);
```

3. **Affichage de la liste**
```dart
ListView.builder(
  itemCount: places.length,
  itemBuilder: (context, index) {
    final place = places[index];
    return ListTile(
      title: Text(place.name),
      subtitle: Text(place.address),
      trailing: Text(place.distanceText),
      onTap: () {
        // Ouvrir l'itinéraire dans Google Maps
        _openInMaps(place.latitude, place.longitude);
      },
    );
  },
)
```

4. **Affichage de la carte**
```dart
NearbyCenterMap(
  userLatitude: position.latitude,
  userLongitude: position.longitude,
  places: places,
  centerType: 'Mairie',
)
```

---

## 🚀 Ouvrir un itinéraire

### Fonction utilitaire avec `url_launcher`

```dart
Future<void> _openInMaps(double lat, double lon) async {
  final url = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon'
  );
  
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
```

Ouvre Google Maps avec l'itinéraire depuis la position actuelle vers le centre sélectionné.

---

## ⚠️ Gestion des erreurs

### Erreurs courantes

1. **Permission refusée**
```dart
if (position == null) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Permission requise'),
      content: Text('Veuillez autoriser l\'accès à votre position'),
    ),
  );
}
```

2. **Service de localisation désactivé**
```dart
bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
if (!serviceEnabled) {
  // Demander à l'utilisateur d'activer le GPS
}
```

3. **Aucun résultat trouvé**
```dart
if (places.isEmpty) {
  showSnackBar('Aucun centre trouvé à proximité');
}
```

4. **Erreur Mapbox API**
```dart
try {
  final places = await MapBoxNearbyService.searchNearby(...);
} catch (e) {
  print('❌ Erreur Mapbox: $e');
  showSnackBar('Impossible de rechercher les centres');
}
```

---

## 📊 Logs de debugging

Le service affiche des logs détaillés en mode debug :

```
🔍 Recherche de centres pour : "mairie"
📍 Position utilisateur : (12.6392, -8.0029)
🌐 Recherche MapBox uniquement (coordonnées GPS réelles)...
🔍 Recherche MapBox backup: "mairie bamako mali"
✅ MapBox a trouvé 8 résultats
✅ 7 résultats MapBox retenus
  📍 Mairie de la Commune I - 1.23 km
  📍 Mairie de la Commune II - 2.45 km
  📍 Mairie de la Commune III - 3.12 km
```

---

## 💰 Limites et tarification Mapbox

### Quotas gratuits
- **50 000 requêtes/mois** pour le Geocoding API
- **25 000 chargements de carte/mois** pour le SDK Maps

### Optimisations
- Cache les résultats localement (à implémenter)
- Limite le nombre de résultats (limit=5)
- Filtrage côté client pour réduire les appels

---

## 🔗 Ressources

- **Documentation Mapbox** : https://docs.mapbox.com/
- **Geocoding API** : https://docs.mapbox.com/api/search/geocoding/
- **Flutter SDK** : https://pub.dev/packages/mapbox_maps_flutter
- **Compte Mapbox** : https://account.mapbox.com/

---

## 📝 TODO / Améliorations futures

- [ ] Implémenter un cache local des résultats
- [ ] Ajouter des itinéraires turn-by-turn
- [ ] Mode hors-ligne avec base de données locale
- [ ] Clustering de marqueurs pour améliorer la performance
- [ ] Personnalisation des icônes de marqueurs
- [ ] Affichage du trafic en temps réel

---

**Auteur** : Équipe FasoDocs  
**Dernière mise à jour** : Novembre 2024

