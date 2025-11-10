import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../services/mapbox_nearby_service.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:url_launcher/url_launcher.dart';

/// Widget de carte affichant le centre le plus proche
class NearbyCenterMap extends StatefulWidget {
  final String centerType; // Ex: "Mairie", "Commissariat", etc.
  
  const NearbyCenterMap({
    super.key,
    required this.centerType,
  });

  @override
  State<NearbyCenterMap> createState() => _NearbyCenterMapState();
}

class _NearbyCenterMapState extends State<NearbyCenterMap> {
  MapboxMap? _mapboxMap;
  geo.Position? _userPosition;
  NearbyPlace? _nearestPlace;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Initialiser MapBox
    if (MapBoxNearbyService.MAPBOX_ACCESS_TOKEN.isNotEmpty) {
      MapboxOptions.setAccessToken(MapBoxNearbyService.MAPBOX_ACCESS_TOKEN);
    }
    _searchNearestPlace();
  }

  /// Rechercher le lieu le plus proche
  Future<void> _searchNearestPlace() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Obtenir la position de l'utilisateur
      final position = await MapBoxNearbyService.getUserLocation();
      
      if (!mounted) return;
      
      if (position == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Impossible d\'obtenir votre position.\nVeuillez autoriser la géolocalisation dans les paramètres.';
        });
        return;
      }

      setState(() {
        _userPosition = position;
      });

      // 2. Rechercher les lieux à proximité
      final places = await MapBoxNearbyService.searchNearby(
        centerType: widget.centerType,
        latitude: position.latitude,
        longitude: position.longitude,
        limit: 5,
      );

      if (!mounted) return;

      if (places.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Aucun ${widget.centerType} trouvé près de vous.\nEssayez d\'élargir la zone de recherche.';
        });
        return;
      }

      // 3. Prendre le plus proche
      setState(() {
        _nearestPlace = places.first;
        _isLoading = false;
      });

      // 4. Centrer la carte sur le lieu trouvé
      _centerMapOnPlace();
      
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erreur: $e';
      });
    }
  }

  /// Centrer la carte sur le lieu trouvé
  void _centerMapOnPlace() {
    if (_mapboxMap == null || _nearestPlace == null) return;

    final cameraOptions = CameraOptions(
      center: Point(
        coordinates: Position(
          _nearestPlace!.longitude,
          _nearestPlace!.latitude,
        ),
      ),
      zoom: 14.0,
    );

    _mapboxMap!.flyTo(cameraOptions, MapAnimationOptions(duration: 1500));
  }

  /// Ouvrir Google Maps pour l'itinéraire
  void _openGoogleMaps() async {
    if (_userPosition == null || _nearestPlace == null) return;

    final url = 
      'https://www.google.com/maps/dir/?api=1'
      '&origin=${_userPosition!.latitude},${_userPosition!.longitude}'
      '&destination=${_nearestPlace!.latitude},${_nearestPlace!.longitude}'
      '&travelmode=driving';

    try {
    final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('❌ Erreur ouverture Google Maps : $e');
      // L'utilisateur verra l'erreur si Google Maps n'est pas installé
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête avec type de centre
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.green, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Centre le plus proche : ${widget.centerType}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              if (!_isLoading)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _searchNearestPlace,
                  tooltip: 'Rechercher à nouveau',
                ),
            ],
          ),
        ),

        // Carte MapBox
        Container(
          height: 300,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          clipBehavior: Clip.hardEdge,
          child: _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: Colors.green),
                      const SizedBox(height: 16),
                      Text(
                        'Recherche du ${widget.centerType} le plus proche...',
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                )
              : _errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: textColor),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _searchNearestPlace,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Réessayer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : MapWidget(
                      onMapCreated: (MapboxMap mapboxMap) {
                        _mapboxMap = mapboxMap;
                        _centerMapOnPlace();
                      },
                    ),
        ),

        const SizedBox(height: 16),

        // Informations sur le lieu trouvé
        if (_nearestPlace != null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.business, color: Colors.green, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _nearestPlace!.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Distance
                _buildInfoRow(
                  Icons.straighten,
                  'Distance',
                  _nearestPlace!.distanceText,
                  textColor,
                ),
                
                // Adresse
                if (_nearestPlace!.address.isNotEmpty)
                  _buildInfoRow(
                    Icons.place,
                    'Adresse',
                    _nearestPlace!.address,
                    textColor,
                  ),
                
                // Téléphone
                if (_nearestPlace!.phone != null)
                  _buildInfoRow(
                    Icons.phone,
                    'Téléphone',
                    _nearestPlace!.phone!,
                    textColor,
                  ),
                
                const SizedBox(height: 16),
                
                // Bouton itinéraire
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _openGoogleMaps,
                    icon: const Icon(Icons.directions),
                    label: const Text('Voir l\'itinéraire'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

