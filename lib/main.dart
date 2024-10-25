import 'package:firebase_core/firebase_core.dart';
import 'package:recipe_app/Pages/recipe_details.dart';
import 'package:recipe_app/firebase_options.dart';
import 'package:flutter/material.dart';

import 'Pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures all bindings are initialized before app runs
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  ); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
