
import 'package:app/views/Home_Web.dart';
import 'package:app/views/Home_Mobile.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      // for web
      home: const WeatherInputPageWeb(),

      // for mobile
      // home: const WeatherInputPageMobile(),

    );
  }
}
