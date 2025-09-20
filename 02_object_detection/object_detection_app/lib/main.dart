import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'Views/Home/home_screen.dart';

late List<CameraDescription> Camera;

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  Camera=await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Home_Screen(),
    );
  }
}
