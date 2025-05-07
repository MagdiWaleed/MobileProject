import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stores_app/splash/splash.dart';
import 'package:geolocator/geolocator.dart';

Future<void> requestLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions are permanently denied.');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestLocationPermission();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: '/Login',
      // routes: {
      //   '/Login': (context) =>  LoginPage(),
      //   '/Home': (context) => const HomePage(),
      //   '/profile': (context) => const ProfilePage(),
      //   '/signup/Step 1': (context) => const SignupPage(step: 1),
      //   '/signup/Step 2': (context) => const SignupPage(step: 2),
      //   '/signup/Step 3': (context) => const SignupPage(step: 3),
      // },
      home: Splash(),
    );
  }
}
