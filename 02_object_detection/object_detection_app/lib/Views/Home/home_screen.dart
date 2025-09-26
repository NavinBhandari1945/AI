import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import '../../main.dart';

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
  Interpreter? _interpreter;
  List<String>? _labels;
  String _prediction = "";

  @override
  void initState() {
    super.initState();
    _loadModelAndLabels();
  }
  
  Future<void> _loadModelAndLabels() async {
    try {
      // Load the model
      _interpreter = await Interpreter.fromAsset(
        'assets/models/mobilenet.tflite',
      );
      debugPrint("Model loaded successfully");

      // Load the labels
      String labelsData = await DefaultAssetBundle.of(
        context,
      ).loadString('assets/models/mobilenet.txt');
      _labels = labelsData
          .split('\n')
          .where((label) => label.trim().isNotEmpty)
          .toList();
      debugPrint("Labels loaded: ${_labels!.length} labels");
      if (_labels!.length != 1001) {
        debugPrint(
          "Warning: Expected 1001 labels, but loaded ${_labels!.length}",
        );
        setState(() {
          result =
              "Label count mismatch: Expected 1001, got ${_labels!.length}";
        });
      }
    } catch (e) {
      setState(() {
        result = "Error loading model or labels: $e";
      });
      debugPrint("Error loading model or labels: $e");
    }
  }

  Future<void> _initializeCamera() async {
    try {

      // if already initialized, skip
      if (camCont != null && camCont!.value.isInitialized) return;

      camCont = CameraController(
        Camera[0], // from main.dart
        ResolutionPreset.medium,
      );

      await camCont!.initialize();

      if (!mounted) return;

      // start the image stream
      camCont!.startImageStream((imageFromStream) {
        if (!isWorking && _interpreter != null && _labels != null) {
          isWorking = true;
          setState(() {
            imageCamera = imageFromStream;
            debugPrint(
              "Image received: ${imageCamera!.width}x${imageCamera!.height}",
            );
          });
          _runInference(imageFromStream); // Run prediction
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

  Future<void> _runInference(CameraImage image) async {
    try {
      // Preprocess the image
      final inputImage = _preprocessImage(image);
      if (inputImage == null)
      {
        setState(() {
          result = "Error preprocessing image";
        });
        return;
      }

      // Prepare input and output tensors
      var input = inputImage.reshape([1, 224, 224, 3]);
      var output = List.filled(
        1 * 1001,
        0.0,
      ).reshape([1, 1001]); // Fixed to 1001 classes

      // Run inference
      _interpreter!.run(input, output);

      // Get the top prediction
      List<double> outputList = output[0].cast<double>();
      int maxIndex = outputList
          .asMap()
          .entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
      double maxScore = outputList[maxIndex];

      setState(() {
        _prediction =
            "${_labels![maxIndex]} (Confidence: ${(maxScore * 100).toStringAsFixed(2)}%)";
        result = ""; // Clear error if prediction succeeds
      });
    } catch (e) {
      setState(() {
        result = "Error running inference: $e";
      });
      debugPrint("Error running inference: $e");
    }
  }

  Float32List? _preprocessImage(CameraImage image) {
    try {
      // Convert CameraImage (YUV420) to RGB
      img.Image? rgbImage = _convertYUV420ToImage(image);
      if (rgbImage == null) return null;

      // Resize to 224x224 (MobileNet input size)
      img.Image resizedImage = img.copyResize(
        rgbImage,
        width: 224,
        height: 224,
      );

      // Convert to Float32List and normalize to [-1, 1]
      final input = Float32List(1 * 224 * 224 * 3);
      int pixelIndex = 0;
      for (int y = 0; y < 224; y++) {
        for (int x = 0; x < 224; x++) {
          final pixel = resizedImage.getPixel(x, y);
          input[pixelIndex++] = (pixel.r / 127.5) - 1.0; // R
          input[pixelIndex++] = (pixel.g / 127.5) - 1.0; // G
          input[pixelIndex++] = (pixel.b / 127.5) - 1.0; // B
        }
      }
      return input;
    } catch (e) {
      debugPrint("Error preprocessing image: $e");
      return null;
    }
  }

  img.Image? _convertYUV420ToImage(CameraImage image) {
    try {
      final int width = image.width;
      final int height = image.height;
      final int uvRowStride = image.planes[1].bytesPerRow;
      final int uvPixelStride = image.planes[1].bytesPerPixel!;

      final img.Image rgbImage = img.Image(width: width, height: height);

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final int uvIndex = uvPixelStride * (x ~/ 2) + uvRowStride * (y ~/ 2);
          final int index = y * width + x;

          final yp = image.planes[0].bytes[index];
          final up = image.planes[1].bytes[uvIndex];
          final vp = image.planes[2].bytes[uvIndex];

          // Convert YUV to RGB
          int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
          int g = (yp - up * 46549 / 131072 - vp * 81309 / 131072 + 135)
              .round()
              .clamp(0, 255);
          int b = (yp + up * 1814 / 1024 - 226).round().clamp(0, 255);

          // Set pixel with alpha = 255 (fully opaque)
          rgbImage.setPixelRgba(x, y, r, g, b, 255);
        }
      }
      return rgbImage;
    } catch (e) {
      debugPrint("Error converting YUV to RGB: $e");
      return null;
    }
  }

  @override
  void dispose() {
    camCont?.dispose();
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Object Detection")),
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
                child:
                    imageCamera != null &&
                        camCont != null &&
                        camCont!.value.isInitialized
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              result.isNotEmpty
                  ? result
                  : _prediction.isNotEmpty
                  ? _prediction
                  : "No image detected",
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
