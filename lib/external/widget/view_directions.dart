import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stores_app/external/model/store_model.dart';
import 'package:http/http.dart' as http;
import 'package:stores_app/external/theme/app_colors.dart';

class ViewDirections extends StatefulWidget {
  final StoreModel store;

  const ViewDirections({super.key, required this.store});

  @override
  State<ViewDirections> createState() => _ViewDirectionsState();
}

class _ViewDirectionsState extends State<ViewDirections> {
  LatLng? _userLocation;
  double? _distance;
  List<LatLng> _routePoints = [];
  late final MapController _mapController;
  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      final userLatLng = LatLng(position.latitude, position.longitude);
      final storeLatLng = LatLng(
        widget.store.store_location_latitude,
        widget.store.store_location_longitude,
      );

      final distanceInMeters = Geolocator.distanceBetween(
        userLatLng.latitude,
        userLatLng.longitude,
        storeLatLng.latitude,
        storeLatLng.longitude,
      );
      setState(() {
        _userLocation = userLatLng;
        _distance = distanceInMeters / 1000;
      });

      _getRoute(userLatLng, storeLatLng);
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> _getRoute(LatLng origin, LatLng destination) async {
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/foot/'
      '${origin.longitude},${origin.latitude};'
      '${destination.longitude},${destination.latitude}'
      '?overview=full&geometries=geojson',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) {
      debugPrint('route error: ${response.statusCode}');
      return;
    }

    final data = json.decode(response.body);
    final coords =
        (data['routes'][0]['geometry']['coordinates'] as List)
            .cast<List<dynamic>>();

    if (coords.isEmpty) {
      debugPrint('No route found');
      return;
    }

    setState(() {
      _routePoints =
          coords.map((pt) => LatLng(pt[1] as double, pt[0] as double)).toList();
    });

    debugPrint('Got ${_routePoints.length} points from router');

    if (_routePoints.isEmpty) {
      debugPrint('No route found');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeLatLng = LatLng(
      widget.store.store_location_latitude,
      widget.store.store_location_longitude,
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        backgroundColor: AppColors.mainColor,
        title: Text(
          'Directions to ${widget.store.name}',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            return Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset('assets/images/logo.png', height: 50),
          ),
        ],
      ),
      body:
          _userLocation == null
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                options: MapOptions(
                  initialCenter: _userLocation!,
                  initialZoom: 14,
                  interactionOptions: const InteractionOptions(),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _userLocation!,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.person_pin_circle,
                          color: Colors.blue,
                          size: 32,
                        ),
                      ),
                      Marker(
                        point: storeLatLng,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 32,
                        ),
                      ),
                    ],
                  ),

                  if (_routePoints.isNotEmpty)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _routePoints,
                          color: Colors.blueAccent,
                          strokeWidth: 4,
                        ),
                      ],
                    ),
                  if (_distance != null)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Card(
                        margin: const EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'Distance: ${_distance!.toStringAsFixed(2)} km',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
    );
  }
}
