import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stores_app/external/theme/app_colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stores_app/external/model/store_model.dart';
import 'package:stores_app/external/widget/custom_loading.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';

class SingleStoreView extends StatelessWidget {
  final StoreModel storeModel;

  /// Function to calculate the distance between two geographical points
  double calculateDistance(
    double storeLat,
    double storeLng,
    double userLat,
    double userLng,
  ) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double toRadians(double degree) => degree * pi / 180;

    final double dLat = toRadians(userLat - storeLat);
    final double dLng = toRadians(userLng - storeLng);

    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(toRadians(storeLat)) *
            cos(toRadians(userLat)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c; // Distance in kilometers
  }

  /// Function to get the user's current location
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    // Get the current position
    return await Geolocator.getCurrentPosition();
  }

  SingleStoreView({required this.storeModel});
  bool is_the_button_valid = true;
  @override
  Widget build(BuildContext context) {
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
        centerTitle: true,
        title: Text(
          storeModel.name,
          style: TextStyle(fontSize: 18, color: Colors.white),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 250,
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: Colors.black)],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          storeModel.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              margin: EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black)],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Store Title
                      Text(
                        storeModel.name,

                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: const Icon(Icons.location_on),
                        tooltip: 'View Location',
                        onPressed: () async {
                          try {
                            // Get the user's current location
                            Position userPosition = await _getCurrentLocation();

                            // Calculate the distance
                            double distance = calculateDistance(
                              storeModel.store_location_latitude,
                              storeModel.store_location_longitude,
                              userPosition.latitude /*30.030813*/,
                              userPosition.longitude /*31.209620*/,
                            );

                            // Show the distance in a dialog
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('Distance to Store'),
                                    content: Text(
                                      'The store is ${distance.toStringAsFixed(2)} km away.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                            );
                          } catch (e) {
                            // Handle errors (e.g., location permissions denied)
                            showTopSnackBar(
                              Overlay.of(context),
                              CustomSnackBar.error(message: e.toString()),
                            );
                          }
                        },
                        color: AppColors.mainColor,
                        iconSize: 30,
                      ),
                      
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RatingBarIndicator(
                      rating: storeModel.review,
                      itemBuilder:
                          (context, index) =>
                              const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 25.0,
                      direction: Axis.horizontal,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black)],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              margin: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Descrption',
                    style: TextStyle(
                      fontSize: 19,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    storeModel.store_description,
                    style: TextStyle(fontSize: 13, height: 1.2),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
