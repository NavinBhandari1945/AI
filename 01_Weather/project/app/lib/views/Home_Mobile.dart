//for mobile app using tflite flutter

import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';

class WeatherInputPageMobile extends StatefulWidget {
  const WeatherInputPageMobile({super.key});

  @override
  State<WeatherInputPageMobile> createState() => _WeatherInputPageMobileState();
}

class _WeatherInputPageMobileState extends State<WeatherInputPageMobile> {
  // Controllers for 15 input fields
  final tempController = TextEditingController();
  final humidityController = TextEditingController();
  final windController = TextEditingController();
  final precipitationController = TextEditingController();
  final pressureController = TextEditingController();
  final uvController = TextEditingController();
  final visibilityController = TextEditingController();
  final cloudCloudyController = TextEditingController();
  final cloudOvercastController = TextEditingController();
  final cloudPartlyCloudyController = TextEditingController();
  final seasonSpringController = TextEditingController();
  final seasonSummerController = TextEditingController();
  final seasonWinterController = TextEditingController();
  final locationInlandController = TextEditingController();
  final locationMountainController = TextEditingController();

  Interpreter? _interpreter;
  String? _prediction;
  String? _errorMessage;

  final List<String> _weatherClasses = ['Cloudy', 'Rainy', 'Snowy', 'Sunny'];

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model/xgb_model_mobile.tflite');
      debugPrint("Model loaded successfully!");
    } catch (e, stackTrace) {
      debugPrint("Failed to load model: $e\nStackTrace: $stackTrace");
      setState(() => _errorMessage = "Failed to load model: $e");
    }
  }

  @override
  void dispose() {
    tempController.dispose();
    humidityController.dispose();
    windController.dispose();
    precipitationController.dispose();
    pressureController.dispose();
    uvController.dispose();
    visibilityController.dispose();
    cloudCloudyController.dispose();
    cloudOvercastController.dispose();
    cloudPartlyCloudyController.dispose();
    seasonSpringController.dispose();
    seasonSummerController.dispose();
    seasonWinterController.dispose();
    locationInlandController.dispose();
    locationMountainController.dispose();
    _interpreter?.close();
    super.dispose();
  }

  void _predictWeather() {
    try {
      if (_interpreter == null) {
        throw Exception("Model not loaded");
      }

      // Parse inputs
      final inputValues = [
        double.parse(tempController.text.isEmpty ? '0' : tempController.text),
        double.parse(humidityController.text.isEmpty ? '0' : humidityController.text),
        double.parse(windController.text.isEmpty ? '0' : windController.text),
        double.parse(precipitationController.text.isEmpty ? '0' : precipitationController.text),
        double.parse(pressureController.text.isEmpty ? '0' : pressureController.text),
        double.parse(uvController.text.isEmpty ? '0' : uvController.text),
        double.parse(visibilityController.text.isEmpty ? '0' : visibilityController.text),
        double.parse(cloudCloudyController.text.isEmpty ? '0' : cloudCloudyController.text),
        double.parse(cloudOvercastController.text.isEmpty ? '0' : cloudOvercastController.text),
        double.parse(cloudPartlyCloudyController.text.isEmpty ? '0' : cloudPartlyCloudyController.text),
        double.parse(seasonSpringController.text.isEmpty ? '0' : seasonSpringController.text),
        double.parse(seasonSummerController.text.isEmpty ? '0' : seasonSummerController.text),
        double.parse(seasonWinterController.text.isEmpty ? '0' : seasonWinterController.text),
        double.parse(locationInlandController.text.isEmpty ? '0' : locationInlandController.text),
        double.parse(locationMountainController.text.isEmpty ? '0' : locationMountainController.text),
      ];

      // Prepare input & output tensor
      var input = Float32List.fromList(inputValues).reshape([1, 15]);

      var output = Int32List(1).reshape([1]); // Model outputs [1] int32 (class index)

      // Run inference
      _interpreter!.run(input, output);

      // Get predicted class index
      int predictedClass = output[0];

      setState(() {
        _prediction = _weatherClasses[predictedClass];
        _errorMessage = null;
      });

      debugPrint("Prediction: $_prediction (Class Index: $predictedClass)");
    } catch (e, stackTrace) {
      debugPrint("Prediction failed: $e\nStackTrace: $stackTrace");
      setState(() => _errorMessage = "Prediction failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather Prediction")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(tempController, "Temperature (°C)"),
            _buildTextField(humidityController, "Humidity (%)"),
            _buildTextField(windController, "Wind Speed (km/h)"),
            _buildTextField(precipitationController, "Precipitation (mm)"),
            _buildTextField(pressureController, "Atmospheric Pressure (hPa)"),
            _buildTextField(uvController, "UV Index"),
            _buildTextField(visibilityController, "Visibility (km)"),
            _buildTextField(cloudCloudyController, "Cloud Cover_cloudy (0/1)"),
            _buildTextField(cloudOvercastController, "Cloud Cover_overcast (0/1)"),
            _buildTextField(cloudPartlyCloudyController, "Cloud Cover_partly cloudy (0/1)"),
            _buildTextField(seasonSpringController, "Season_Spring (0/1)"),
            _buildTextField(seasonSummerController, "Season_Summer (0/1)"),
            _buildTextField(seasonWinterController, "Season_Winter (0/1)"),
            _buildTextField(locationInlandController, "Location_inland (0/1)"),
            _buildTextField(locationMountainController, "Location_mountain (0/1)"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _interpreter == null ? null : _predictWeather,
              child: const Text("Predict Weather"),
            ),
            const SizedBox(height: 20),
            if (_prediction != null) Text("Predicted Weather: $_prediction", style: const TextStyle(fontSize: 18)),
            if (_errorMessage != null)
              Text("Error: $_errorMessage", style: const TextStyle(color: Colors.red, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }
}