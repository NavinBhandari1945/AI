import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../../common_method/pick_image.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});
  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  // Model,image selection and Prediction Variables
  Interpreter? interpreter;
  List<String> labels = [];
  String predictionResult = "No Prediction Yet";
  File? selectedImage;
  final Pick_Image picker = Pick_Image();

  @override
  void initState() {
    //initialize the model and labels when the screen is loaded
    super.initState();
    Load_Model();
    Load_Labels();
  }

  Future<void> Load_Model() async {
    interpreter = await Interpreter.fromAsset(
        "assets/classification_model/animal_classifier.tflite"
    );
    print('Model loaded sucess');
  }

  Future<void> Load_Labels() async {
    final labelData = await rootBundle.loadString(
        "assets/classification_model/labels.json"
    );
    final List decoded = json.decode(labelData);
    labels = decoded.map((e) => e.toString()).toList();
    print('Class from model loaded sucess');
    print(labels);
  }


  Future<List<List<List<List<double>>>>> Pre_Process_Image(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    img.Image? originalImage = img.decodeImage(bytes);
    img.Image resized = img.copyResize(
      originalImage!,
      width: 150,
      height: 150,
    );
    List<List<List<List<double>>>> input = List.generate(
      1,
          (_) => List.generate(
        150,
            (y) => List.generate(
          150,
              (x) {

            final pixel = resized.getPixel(x, y);

            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
        ),
      ),
    );

    return input;
  }

  Future<void> Run_Model(File imageFile) async {

    if (interpreter == null) return;

    var input = await Pre_Process_Image(imageFile);

    var output = List.generate(
      1,
          (_) => List.filled(labels.length, 0.0),
    );

    interpreter!.run(input, output);

    int maxIndex = 0;
    double maxScore = 0;

    for (int i = 0; i < labels.length; i++) {
      if (output[0][i] > maxScore) {
        maxScore = output[0][i];
        maxIndex = i;
      }
    }

    setState(() {
      predictionResult = labels[maxIndex];
    });
  }


  Future<void> Pick_And_Predict() async {

    String? path = await picker.Image_Pick();

    if (path == null) return;

    File imageFile = File(path);

    setState(() {
      selectedImage = imageFile;
    });

    await Run_Model(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Animal Image Classification")),


      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              selectedImage != null
                  ? Image.file(
                selectedImage!,
                height: 250,
              )
                  : const Text("No Image Selected"),

              const SizedBox(height: 20),

              Text(
                predictionResult,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: Pick_And_Predict,
                child: const Text("Pick Image From Camera"),
              )
            ],
          ),
        ),
      ),

    );
  }
}
