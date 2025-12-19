import 'package:flutter/material.dart';
import 'package:paryatan_mantralaya_f/screens/loginsignup.dart';
import 'screens/main_shell.dart';
import 'store/trip_store.dart';
import 'store/favourite_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TripStore().loadTrips(); // 👈 LOAD SAVED TRIPS
  await FavouriteStore().loadFavourites();

  // If an auth token already exists, skip the login screen
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  runApp(MyApp(initialAuthToken: token));
}

class MyApp extends StatelessWidget {
  final String? initialAuthToken;

  const MyApp({super.key, this.initialAuthToken});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // start at Login if no token, otherwise go straight to MainShell
      home: initialAuthToken != null ? MainShell() : const Loginsignup(),
    );
  }
}
