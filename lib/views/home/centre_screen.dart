// Fichier: home/centres_screen.dart

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

const String MAPBOX_ACCESS_TOKEN = "pk.eyJ1IjoiYXNzaW10cmFwIiwiYSI6ImNtZjkxY25haTB5aHYyanM0djVzMWc1MHAifQ.dGi1jYLwKXbpGly4PFaLaA";

final Point BAMAKO_COORDS_1 = Point(coordinates: Position(-7.9890, 12.6392));
final Point BAMAKO_COORDS_2 = Point(coordinates: Position(-7.9710, 12.6500));

class CentresScreen extends StatefulWidget {
  const CentresScreen({super.key});

  @override
  State<CentresScreen> createState() => _CentresScreenState();
}

class _CentresScreenState extends State<CentresScreen> {
  geolocator.Position? _currentPosition;
  bool _isLoadingLocation = false;
  String _locationError = '';

  final Map<String, MapboxMap?> _mapControllers = {};
  final Map<String, PointAnnotationManager?> _annotationManagers = {};
  final Map<String, List<PolylineAnnotation>> _routeLines = {};

  final Map<String, bool> _isCalculatingRoute = {};
  final Map<String, Map<String, dynamic>> _routeInfo = {};
  final Map<String, bool> _showRoute = {};

  // Stocker les IDs des annotations utilisateur pour pouvoir les supprimer
  final Map<String, List<PointAnnotation>> _userAnnotations = {};

  @override
  void initState() {
    super.initState();
    _initializeMapbox();
    _checkAndRequestLocationPermission();

    _isCalculatingRoute['commissariat_1'] = false;
    _isCalculatingRoute['commissariat_13'] = false;
    _showRoute['commissariat_1'] = false;
    _showRoute['commissariat_13'] = false;

    _userAnnotations['commissariat_1'] = [];
    _userAnnotations['commissariat_13'] = [];
  }

  void _initializeMapbox() {
    try {
      if (MAPBOX_ACCESS_TOKEN.isNotEmpty) {
        MapboxOptions.setAccessToken(MAPBOX_ACCESS_TOKEN);
        print("Token Mapbox initialisé avec succès");
      }
    } catch (e) {
      print("Erreur initialisation Mapbox: $e");
    }
  }

  Future<void> _checkAndRequestLocationPermission() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = '';
    });

    try {
      bool serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'Les services de localisation sont désactivés';
          _isLoadingLocation = false;
        });
        return;
      }

      geolocator.LocationPermission permission = await geolocator.Geolocator.checkPermission();
      if (permission == geolocator.LocationPermission.denied) {
        permission = await geolocator.Geolocator.requestPermission();
        if (permission == geolocator.LocationPermission.denied) {
          setState(() {
            _locationError = 'Permission de localisation refusée';
            _isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == geolocator.LocationPermission.deniedForever) {
        setState(() {
          _locationError = 'Permission définitivement refusée. Activez-la dans les paramètres.';
          _isLoadingLocation = false;
        });
        return;
      }

      geolocator.Position position = await geolocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.best,
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });

      _updateAllMapsWithUserLocation();

    } catch (e) {
      setState(() {
        _locationError = 'Erreur: $e';
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _openInGoogleMaps(Point destination) async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Localisation non disponible')),
      );
      return;
    }

    final startLat = _currentPosition!.latitude;
    final startLng = _currentPosition!.longitude;
    final endLat = destination.coordinates.lat;
    final endLng = destination.coordinates.lng;

    final url = 'https://www.google.com/maps/dir/?api=1'
        '&origin=$startLat,$startLng'
        '&destination=$endLat,$endLng'
        '&travelmode=driving';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'ouvrir Google Maps')),
      );
    }
  }

  Future<void> _calculateRoute(String mapKey, Point destination, String title) async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Localisation non disponible')),
      );
      return;
    }

    setState(() {
      _isCalculatingRoute[mapKey] = true;
    });

    try {
      final startLng = _currentPosition!.longitude;
      final startLat = _currentPosition!.latitude;
      final endLng = destination.coordinates.lng;
      final endLat = destination.coordinates.lat;

      final coordinatesString = '$startLng,$startLat;$endLng,$endLat';

      final url = Uri.parse(
          'https://api.mapbox.com/directions/v5/mapbox/driving/$coordinatesString'
              '?alternatives=false'
              '&geometries=geojson'
              '&steps=true'
              '&overview=full'
              '&access_token=$MAPBOX_ACCESS_TOKEN'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['routes'] == null || data['routes'].isEmpty) {
          throw Exception('Aucun itinéraire trouvé');
        }

        final route = data['routes'][0];
        final legs = route['legs'][0];

        final distance = (route['distance'] / 1000).toStringAsFixed(1);
        final duration = (route['duration'] / 60).toStringAsFixed(0);
        final geometry = route['geometry']['coordinates'];

        setState(() {
          _routeInfo[mapKey] = {
            'distance': distance,
            'duration': duration,
            'geometry': geometry,
          };
          _showRoute[mapKey] = true;
        });

        // Ouvrir la vue plein écran avec l'itinéraire
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FullScreenMapRoute(
                title: title,
                startPosition: _currentPosition!,
                destination: destination,
                geometry: geometry,
                distance: distance,
                duration: duration,
              ),
            ),
          );
        }

      } else {
        throw Exception('Erreur API: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isCalculatingRoute[mapKey] = false;
      });
    }
  }

  void _displayRouteOnMap(String mapKey, List<dynamic> geometry) async {
    final mapboxMap = _mapControllers[mapKey];
    if (mapboxMap == null) return;

    _clearRoute(mapKey);

    final lineCoordinates = geometry.map<Position>((coord) {
      return Position(
          (coord[0] as num).toDouble(),
          (coord[1] as num).toDouble()
      );
    }).toList();

    final polylineAnnotationManager = await mapboxMap.annotations.createPolylineAnnotationManager();
    final lineString = LineString(coordinates: lineCoordinates);

    final polylineAnnotation = await polylineAnnotationManager.create(
      PolylineAnnotationOptions(
        geometry: lineString,
        lineColor: Colors.blue.value,
        lineWidth: 6.0,
        lineOpacity: 0.8,
      ),
    );

    if (!_routeLines.containsKey(mapKey)) {
      _routeLines[mapKey] = [];
    }
    _routeLines[mapKey]!.add(polylineAnnotation);

    _fitCameraToRoute(mapKey, lineCoordinates);
  }

  void _fitCameraToRoute(String mapKey, List<Position> coordinates) {
    final mapboxMap = _mapControllers[mapKey];
    if (mapboxMap == null || coordinates.isEmpty) return;

    double minLng = coordinates.first.lng.toDouble();
    double maxLng = coordinates.first.lng.toDouble();
    double minLat = coordinates.first.lat.toDouble();
    double maxLat = coordinates.first.lat.toDouble();

    for (final coord in coordinates) {
      final lng = coord.lng.toDouble();
      final lat = coord.lat.toDouble();

      if (lng < minLng) minLng = lng;
      if (lng > maxLng) maxLng = lng;
      if (lat < minLat) minLat = lat;
      if (lat > maxLat) maxLat = lat;
    }

    final centerLng = (minLng + maxLng) / 2;
    final centerLat = (minLat + maxLat) / 2;

    final cameraOptions = CameraOptions(
      center: Point(coordinates: Position(centerLng, centerLat)),
      zoom: 13.0,
      padding: MbxEdgeInsets(
        top: 50.0,
        left: 50.0,
        bottom: 50.0,
        right: 50.0,
      ),
    );

    mapboxMap.flyTo(cameraOptions, MapAnimationOptions(duration: 1500));
  }

  void _clearRoute(String mapKey) {
    final routes = _routeLines[mapKey];
    if (routes != null) {
      _routeLines[mapKey]?.clear();
    }
    setState(() {
      _showRoute[mapKey] = false;
      _routeInfo.remove(mapKey);
    });
  }

  void _updateAllMapsWithUserLocation() {
    if (_currentPosition == null) return;

    final userLocation = Point(
      coordinates: Position(_currentPosition!.longitude, _currentPosition!.latitude),
    );

    _annotationManagers.forEach((mapKey, manager) async {
      if (manager != null) {
        // Méthode simplifiée : supprimer toutes les anciennes annotations utilisateur
        _removeUserAnnotations(mapKey);

        // Ajouter la nouvelle annotation utilisateur
        final annotation = await manager.create(PointAnnotationOptions(
          geometry: userLocation,
          iconColor: Colors.blue.value,
          iconSize: 1.5,
          textField: "Vous êtes ici",
          textColor: Colors.blue.value,
          textOffset: [0.0, -2.0],
        ));

        // Stocker l'annotation elle-même
        _userAnnotations[mapKey]!.add(annotation);
      }
    });
  }

  // Nouvelle méthode pour supprimer les annotations utilisateur
  void _removeUserAnnotations(String mapKey) {
    final manager = _annotationManagers[mapKey];
    final userAnnotations = _userAnnotations[mapKey];

    if (manager != null && userAnnotations != null && userAnnotations.isNotEmpty) {
      for (final annotation in userAnnotations) {
        try {
          manager.delete(annotation);
        } catch (e) {
          print("Erreur lors de la suppression de l'annotation: $e");
        }
      }
      userAnnotations.clear();
    }
  }

  void _onMapCreated(String mapKey, MapboxMap mapboxMap) async {
    _mapControllers[mapKey] = mapboxMap;
    final pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();
    _annotationManagers[mapKey] = pointAnnotationManager;

    Point coordinates = mapKey.contains('commissariat_1') ? BAMAKO_COORDS_1 : BAMAKO_COORDS_2;

    // Ajouter le marqueur de destination
    final destinationAnnotation = await pointAnnotationManager.create(PointAnnotationOptions(
      geometry: coordinates,
      iconColor: Colors.red.value,
      iconSize: 1.5,
      textField: "Destination",
      textColor: Colors.red.value,
      textOffset: [0.0, -2.0],
    ));

    // Stocker l'annotation de destination si nécessaire
    // _userAnnotations[mapKey]!.add(destinationAnnotation);

    if (_currentPosition != null) {
      _updateAllMapsWithUserLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;
    final borderColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade700
        : Colors.grey.shade300;

    // Adaptation pour les grands écrans
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Centres de démarche'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _checkAndRequestLocationPermission,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: isLargeScreen
            ? _buildLargeScreenLayout(textColor, cardColor, borderColor)
            : _buildNormalScreenLayout(textColor, cardColor, borderColor),
      ),
    );
  }

  // Layout pour les grands écrans
  Widget _buildLargeScreenLayout(Color textColor, Color cardColor, Color borderColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Colonne de gauche - Status et informations
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildLocationStatusWidget(textColor),
              const SizedBox(height: 16),
              _buildCommissariatInfoCard(
                title: 'Commissariat du 1er arrondissement',
                address: 'Korofina, Bamako',
                coordinates: BAMAKO_COORDS_1,
                cardColor: cardColor,
                borderColor: borderColor,
                textColor: textColor,
                mapKey: 'commissariat_1',
              ),
              const SizedBox(height: 16),
              _buildCommissariatInfoCard(
                title: 'Commissariat du 13ième arrondissement',
                address: 'Djélibougou, Bamako',
                coordinates: BAMAKO_COORDS_2,
                cardColor: cardColor,
                borderColor: borderColor,
                textColor: textColor,
                mapKey: 'commissariat_13',
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Colonne de droite - Cartes
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildMapCard(
                'Commissariat du 1er arrondissement',
                'commissariat_1',
                BAMAKO_COORDS_1,
                cardColor,
                borderColor,
                textColor,
              ),
              const SizedBox(height: 16),
              _buildMapCard(
                'Commissariat du 13ième arrondissement',
                'commissariat_13',
                BAMAKO_COORDS_2,
                cardColor,
                borderColor,
                textColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Layout normal pour petits écrans
  Widget _buildNormalScreenLayout(Color textColor, Color cardColor, Color borderColor) {
    return Column(
      children: [
        _buildLocationStatusWidget(textColor),
        const SizedBox(height: 16),
        _buildCommissariatCard(
          title: 'Commissariat du 1er arrondissement',
          address: 'Korofina, Bamako',
          coordinates: BAMAKO_COORDS_1,
          cardColor: cardColor,
          borderColor: borderColor,
          textColor: textColor,
          mapKey: 'commissariat_1',
        ),
        const SizedBox(height: 16),
        _buildCommissariatCard(
          title: 'Commissariat du 13ième arrondissement',
          address: 'Djélibougou, Bamako',
          coordinates: BAMAKO_COORDS_2,
          cardColor: cardColor,
          borderColor: borderColor,
          textColor: textColor,
          mapKey: 'commissariat_13',
        ),
      ],
    );
  }

  // Carte avec seulement les informations (pour grand écran)
  Widget _buildCommissariatInfoCard({
    required String title,
    required String address,
    required Point coordinates,
    required Color cardColor,
    required Color borderColor,
    required Color textColor,
    required String mapKey,
  }) {
    final isCalculating = _isCalculatingRoute[mapKey] ?? false;
    final showRoute = _showRoute[mapKey] ?? false;
    final routeInfo = _routeInfo[mapKey];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 20, height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: textColor.withOpacity(0.5)),
                ),
                child: const Icon(Icons.check, size: 14, color: Color(0xFF14B53A)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor))),
            ],
          ),
          const SizedBox(height: 12),
          Row(children: [
            Icon(Icons.location_on, color: textColor.withOpacity(0.7), size: 16),
            const SizedBox(width: 8),
            Text(address, style: TextStyle(color: textColor.withOpacity(0.8))),
          ]),

          if (_currentPosition != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: isCalculating
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.map, size: 16),
                    label: isCalculating ? const Text('Calcul...') : const Text('Voir itinéraire'),
                    onPressed: isCalculating ? null : () => _calculateRoute(mapKey, coordinates, title),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  ),
                ),

              ],
            ),

            if (showRoute && routeInfo != null)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildRouteInfoItem(Icons.av_timer, '${routeInfo['duration']} min', textColor),
                    _buildRouteInfoItem(Icons.directions_car, '${routeInfo['distance']} km', textColor),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  // Carte avec seulement la carte (pour grand écran)
  Widget _buildMapCard(
      String title,
      String mapKey,
      Point coordinates,
      Color cardColor,
      Color borderColor,
      Color textColor,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 12),
          SizedBox(
            height: 300, // Plus grande hauteur pour les grands écrans
            child: MapWidget(
              key: ValueKey(mapKey),
              cameraOptions: CameraOptions(center: coordinates, zoom: 13.0),
              styleUri: "mapbox://styles/mapbox/streets-v12",
              onMapCreated: (mapboxMap) => _onMapCreated(mapKey, mapboxMap),
            ),
          ),
        ],
      ),
    );
  }

  // Carte complète pour petits écrans
  Widget _buildCommissariatCard({
    required String title,
    required String address,
    required Point coordinates,
    required Color cardColor,
    required Color borderColor,
    required Color textColor,
    required String mapKey,
  }) {
    final isCalculating = _isCalculatingRoute[mapKey] ?? false;
    final showRoute = _showRoute[mapKey] ?? false;
    final routeInfo = _routeInfo[mapKey];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 20, height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: textColor.withOpacity(0.5)),
                ),
                child: const Icon(Icons.check, size: 14, color: Color(0xFF14B53A)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor))),
            ],
          ),
          const SizedBox(height: 12),
          Row(children: [
            Icon(Icons.location_on, color: textColor.withOpacity(0.7), size: 16),
            const SizedBox(width: 8),
            Text(address, style: TextStyle(color: textColor.withOpacity(0.8))),
          ]),
          const SizedBox(height: 12),

          if (_currentPosition != null) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: isCalculating
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.map, size: 16),
                    label: isCalculating ? const Text('Calcul...') : const Text('Voir itinéraire'),
                    onPressed: isCalculating ? null : () => _calculateRoute(mapKey, coordinates, title),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  ),
                ),

              ],
            ),

            if (showRoute && routeInfo != null)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildRouteInfoItem(Icons.av_timer, '${routeInfo['duration']} min', textColor),
                    _buildRouteInfoItem(Icons.directions_car, '${routeInfo['distance']} km', textColor),
                  ],
                ),
              ),
          ],

          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: MapWidget(
              key: ValueKey(mapKey),
              cameraOptions: CameraOptions(center: coordinates, zoom: 13.0),
              styleUri: "mapbox://styles/mapbox/streets-v12",
              onMapCreated: (mapboxMap) => _onMapCreated(mapKey, mapboxMap),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStatusWidget(Color textColor) {
    if (_isLoadingLocation) {
      return _buildStatusContainer(
        Colors.blue.withOpacity(0.1),
        Colors.blue.withOpacity(0.3),
        Row(
          children: [
            const CircularProgressIndicator(strokeWidth: 2),
            const SizedBox(width: 12),
            Text('Localisation en cours...', style: TextStyle(color: textColor)),
          ],
        ),
      );
    }

    if (_locationError.isNotEmpty) {
      return _buildStatusContainer(
        Colors.orange.withOpacity(0.1),
        Colors.orange.withOpacity(0.3),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_off, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text('Géolocalisation indisponible',
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(_locationError, style: TextStyle(color: textColor.withOpacity(0.8))),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _checkAndRequestLocationPermission,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (_currentPosition != null) {
      return _buildStatusContainer(
        Colors.green.withOpacity(0.1),
        Colors.green.withOpacity(0.3),
        Row(
          children: [
            const Icon(Icons.my_location, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Localisation active',
                      style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                  Text('Lat: ${_currentPosition!.latitude.toStringAsFixed(4)}, '
                      'Lng: ${_currentPosition!.longitude.toStringAsFixed(4)}',
                      style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container();
  }

  Widget _buildStatusContainer(Color bgColor, Color borderColor, Widget child) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }

  Widget _buildRouteInfoItem(IconData icon, String text, Color textColor) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blue),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// Widget de carte plein écran pour l'itinéraire
class FullScreenMapRoute extends StatefulWidget {
  final String title;
  final geolocator.Position startPosition;
  final Point destination;
  final List<dynamic> geometry;
  final String distance;
  final String duration;

  const FullScreenMapRoute({
    super.key,
    required this.title,
    required this.startPosition,
    required this.destination,
    required this.geometry,
    required this.distance,
    required this.duration,
  });

  @override
  State<FullScreenMapRoute> createState() => _FullScreenMapRouteState();
}

class _FullScreenMapRouteState extends State<FullScreenMapRoute>
    with TickerProviderStateMixin {
  MapboxMap? _mapboxMap;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  PolylineAnnotationManager? _polylineManager;
  
  // Pour l'animation de traçage de l'itinéraire
  late AnimationController _routeAnimationController;
  late Animation<double> _routeAnimation;
  List<Position> _allCoordinates = [];
  int _currentSegmentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Animation de pulsation pour la position actuelle
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.4).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Animation pour le traçage de l'itinéraire
    _routeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _routeAnimation = CurvedAnimation(
      parent: _routeAnimationController,
      curve: Curves.easeInOut,
    )..addListener(_animateRoute);
  }
  
  void _animateRoute() async {
    if (_allCoordinates.isEmpty || _polylineManager == null) return;
    
    final progress = _routeAnimation.value;
    final targetIndex = (_allCoordinates.length * progress).floor();
    
    if (targetIndex > _currentSegmentIndex && targetIndex <= _allCoordinates.length) {
      _currentSegmentIndex = targetIndex;
      await _updateRouteLine();
    }
  }
  
  Future<void> _updateRouteLine() async {
    if (_polylineManager == null || _currentSegmentIndex < 2) return;
    
    try {
      await _polylineManager!.deleteAll();
      
      final animatedCoordinates = _allCoordinates.sublist(0, _currentSegmentIndex);
      final lineString = LineString(coordinates: animatedCoordinates);
      
      // Ligne de fond (ombre)
      await _polylineManager!.create(
        PolylineAnnotationOptions(
          geometry: lineString,
          lineColor: Colors.black.value,
          lineWidth: 10.0,
          lineOpacity: 0.3,
          lineBlur: 2.0,
        ),
      );

      // Ligne principale bleue
      await _polylineManager!.create(
        PolylineAnnotationOptions(
          geometry: lineString,
          lineColor: Colors.blue.value,
          lineWidth: 7.0,
          lineOpacity: 0.9,
        ),
      );

      // Ligne interne claire (effet 3D)
      await _polylineManager!.create(
        PolylineAnnotationOptions(
          geometry: lineString,
          lineColor: Colors.lightBlueAccent.value,
          lineWidth: 4.0,
          lineOpacity: 0.7,
        ),
      );
    } catch (e) {
      print('Erreur lors de la mise à jour de la ligne: $e');
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _routeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.navigation),
            tooltip: 'Ouvrir dans Google Maps',
            onPressed: _openInGoogleMaps,
          ),
        ],
      ),
      body: Stack(
        children: [
          MapWidget(
            cameraOptions: CameraOptions(
              center: widget.destination,
              zoom: 13.0,
            ),
            styleUri: "mapbox://styles/mapbox/streets-v12",
            onMapCreated: _onMapCreated,
          ),
          // Carte d'information en haut
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoItem(Icons.av_timer, '${widget.duration} min', Colors.orange),
                        Container(width: 1, height: 30, color: Colors.grey.shade300),
                        _buildInfoItem(Icons.directions_car, '${widget.distance} km', Colors.blue),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Ma position', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 20),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Arrivée', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Indicateur de progression de traçage
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _routeAnimation,
                builder: (context, child) {
                  if (_routeAnimation.value >= 1.0) return const SizedBox.shrink();
                  
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.route,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Traçage... ${(_routeAnimation.value * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 80,
                          child: LinearProgressIndicator(
                            value: _routeAnimation.value,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;

    // Ajouter les marqueurs
    final pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();

    // Marqueur de départ (position actuelle) - Bleu avec animation
    await pointAnnotationManager.create(PointAnnotationOptions(
      geometry: Point(
        coordinates: Position(
          widget.startPosition.longitude,
          widget.startPosition.latitude,
        ),
      ),
      iconColor: Colors.blue.value,
      iconSize: 2.0,
      iconImage: 'marker',
      textField: "📍 Départ",
      textColor: Colors.blue.value,
      textSize: 14.0,
      textOffset: [0.0, -3.0],
      textHaloColor: Colors.white.value,
      textHaloWidth: 2.0,
    ));

    // Marqueur de destination - Rouge
    await pointAnnotationManager.create(PointAnnotationOptions(
      geometry: widget.destination,
      iconColor: Colors.red.value,
      iconSize: 2.0,
      iconImage: 'marker',
      textField: "🎯 Arrivée",
      textColor: Colors.red.value,
      textSize: 14.0,
      textOffset: [0.0, -3.0],
      textHaloColor: Colors.white.value,
      textHaloWidth: 2.0,
    ));

    // Dessiner l'itinéraire
    _displayRoute();
  }

  void _displayRoute() async {
    if (_mapboxMap == null) return;

    _allCoordinates = widget.geometry.map<Position>((coord) {
      return Position(
        (coord[0] as num).toDouble(),
        (coord[1] as num).toDouble(),
      );
    }).toList();

    // Créer le gestionnaire de polylignes
    _polylineManager = await _mapboxMap!.annotations.createPolylineAnnotationManager();
    
    // Attendre un peu avant de démarrer l'animation
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Démarrer l'animation de traçage progressif
    _routeAnimationController.forward();

    // Adapter la caméra pour afficher tout l'itinéraire avec animation fluide
    _fitCameraToRoute(_allCoordinates);
  }

  void _fitCameraToRoute(List<Position> coordinates) {
    if (_mapboxMap == null || coordinates.isEmpty) return;

    double minLng = coordinates.first.lng.toDouble();
    double maxLng = coordinates.first.lng.toDouble();
    double minLat = coordinates.first.lat.toDouble();
    double maxLat = coordinates.first.lat.toDouble();

    for (final coord in coordinates) {
      final lng = coord.lng.toDouble();
      final lat = coord.lat.toDouble();

      if (lng < minLng) minLng = lng;
      if (lng > maxLng) maxLng = lng;
      if (lat < minLat) minLat = lat;
      if (lat > maxLat) maxLat = lat;
    }

    final centerLng = (minLng + maxLng) / 2;
    final centerLat = (minLat + maxLat) / 2;

    // Animation fluide avec padding généreux
    final cameraOptions = CameraOptions(
      center: Point(coordinates: Position(centerLng, centerLat)),
      zoom: 12.5,
      padding: MbxEdgeInsets(
        top: 150.0,  // Plus d'espace en haut pour la carte d'info
        left: 80.0,
        bottom: 150.0,  // Plus d'espace en bas pour les marqueurs
        right: 80.0,
      ),
      pitch: 0.0,
      bearing: 0.0,
    );

    // Animation très fluide avec courbe personnalisée
    _mapboxMap!.flyTo(
      cameraOptions,
      MapAnimationOptions(
        duration: 2500,
        startDelay: 500,
      ),
    );
  }

  Future<void> _openInGoogleMaps() async {
    final startLat = widget.startPosition.latitude;
    final startLng = widget.startPosition.longitude;
    final endLat = widget.destination.coordinates.lat;
    final endLng = widget.destination.coordinates.lng;

    final url = 'https://www.google.com/maps/dir/?api=1'
        '&origin=$startLat,$startLng'
        '&destination=$endLat,$endLng'
        '&travelmode=driving';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir Google Maps')),
        );
      }
    }
  }
}