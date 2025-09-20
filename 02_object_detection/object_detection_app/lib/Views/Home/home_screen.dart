import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../main.dart'; // make sure 'cameras' is initialized in main.dart

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  CameraImage? imageCamera;
  CameraController? camCont;
  bool isWorking = false;
  String result = "";

  Future<void> _initializeCamera() async {
    try {
      // if already initialized, skip
      if (camCont != null && camCont!.value.isInitialized) return;

      camCont = CameraController(
        Camera[0], // <-- from main.dart
        ResolutionPreset.medium,
      );

      await camCont!.initialize();

      if (!mounted) return;

      // start the image stream
      camCont!.startImageStream((imageFromStream) {
        if (!isWorking) {
          isWorking = true;
          setState(() {
            imageCamera = imageFromStream;
          });
          isWorking = false;
        }
      });

      setState(() {}); // refresh UI after initialization
    } catch (e) {
      setState(() {
        result = "Error initializing camera: $e";
      });
    }
  }

  @override
  void dispose() {
    camCont?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await _initializeCamera();
              },
              child: SizedBox(
                height: 300,
                width: 300,
                child: imageCamera != null && camCont != null && camCont!.value.isInitialized
                    ? AspectRatio(
                  aspectRatio: camCont!.value.aspectRatio,
                  child: CameraPreview(camCont!),
                )
                    : const Icon(
                  Icons.camera_front_outlined,
                  size: 40,
                  color: Colors.green,
                ),
              ),
            ),
          ),
          result.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(result, style: const TextStyle(color: Colors.red)),
          )
              : const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "No image detected",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}



