import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stores_app/external/theme/app_colors.dart';
import 'package:stores_app/main/provider/search_provider.dart';
import 'package:stores_app/store_details/single_shop_view.dart';
import 'package:stores_app/external/widget/custom_loading.dart';
import 'package:stores_app/external/model/store_model.dart';

class ViewMap extends ConsumerStatefulWidget {
  const ViewMap({Key? key}) : super(key: key);

  @override
  ConsumerState<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends ConsumerState<ViewMap> {
  LatLng _userLocation = LatLng(30, 31);
  bool _locationReady = false;
  final MapController _mapController = MapController();
  String _selectedDistance = '';
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _locationReady = true;
      });
      _mapController.move(_userLocation, 14);
    } catch (e) {
      debugPrint('Location error: $e');
      setState(() {
        _locationReady = true;
      });
    }
  }

  void _initMarkers(List<StoreModel> stores) {
    if (_markers.isNotEmpty) return;

    for (var store in stores) {
      final storeLatLng = LatLng(
        store.store_location_latitude,
        store.store_location_longitude,
      );
      _markers.add(
        Marker(
          width: 40,
          height: 40,
          point: storeLatLng,
          child: IconButton(
            icon: const Icon(Icons.location_on, color: Colors.red, size: 32),
            onPressed: () async {
              final dist =
                  Geolocator.distanceBetween(
                    _userLocation.latitude,
                    _userLocation.longitude,
                    store.store_location_latitude,
                    store.store_location_longitude,
                  ) /
                  1000;
              setState(() {
                _selectedDistance = '${store.name}: $dist km';
              });
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final storesAsync = ref.watch(searchProvider);
    return storesAsync.when(
      loading: () => const Scaffold(body: Center(child: CustomLoading())),
      error:
          (err, _) =>
              Scaffold(body: Center(child: Text('Error loading stores: $err'))),
      data: (data) {
        final stores = data.cast<StoreModel>();
        _initMarkers(stores);

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
              'Stores Map',
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
              !_locationReady
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _userLocation,
                          initialZoom: 14,
                          interactionOptions: const InteractionOptions(),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          MarkerLayer(markers: _markers),
                        ],
                      ),
                      if (_selectedDistance.isNotEmpty)
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Expanded(child: Text(_selectedDistance)),
                                  ElevatedButton(
                                    onPressed: () {
                                      final name =
                                          _selectedDistance
                                              .split(':')
                                              .first
                                              .trim();
                                      final store = stores.firstWhere(
                                        (s) => s.name == name,
                                        orElse: () => stores.first,
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  SingleShopView(shop: store),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.mainColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'View Store',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
        );
      },
    );
  }
}
