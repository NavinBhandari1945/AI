import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class WeatherInputPage extends StatefulWidget {
  const WeatherInputPage({super.key});

  @override
  State<WeatherInputPage> createState() => _WeatherInputPageState();
}

class _WeatherInputPageState extends State<WeatherInputPage> {
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

  final List<String> _weatherClasses = ['Cloudy', 'Rainy', 'Snow','Sunny'];

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('model/xgb_model_mobile.tflite');
      debugPrint("Model loaded successfully!");
    } catch (e) {
      debugPrint("Failed to load model: $e");
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
        double.parse(tempController.text),
        double.parse(humidityController.text),
        double.parse(windController.text),
        double.parse(precipitationController.text),
        double.parse(pressureController.text),
        double.parse(uvController.text),
        double.parse(visibilityController.text),
        double.parse(cloudCloudyController.text),
        double.parse(cloudOvercastController.text),
        double.parse(cloudPartlyCloudyController.text),
        double.parse(seasonSpringController.text),
        double.parse(seasonSummerController.text),
        double.parse(seasonWinterController.text),
        double.parse(locationInlandController.text),
        double.parse(locationMountainController.text),
      ];

      // Prepare input & output tensor
      var input = [inputValues]; // shape [1,15]
      var output = List.filled(1 * _weatherClasses.length, 0).reshape([1, _weatherClasses.length]);

      // Run inference
      _interpreter!.run(input, output);

      // Get predicted class index
      int predictedClass = output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));

      setState(() {
        _prediction = _weatherClasses[predictedClass];
        _errorMessage = null;
      });

      debugPrint("Prediction: $_prediction (Class Index: $predictedClass)");
    } catch (e) {
      debugPrint("❌ Prediction failed: $e");
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
            if (_prediction != null) Text("Predicted Weather: $_prediction"),
            if (_errorMessage != null)
              Text("Error: $_errorMessage", style: const TextStyle(color: Colors.red)),
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

