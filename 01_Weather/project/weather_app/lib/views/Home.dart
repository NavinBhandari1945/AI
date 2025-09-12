// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:tflite_web/tflite_web.dart';
//
// class WeatherInputPage extends StatefulWidget {
//   const WeatherInputPage({super.key});
//
//   @override
//   State<WeatherInputPage> createState() => _WeatherInputPageState();
// }
//
// class _WeatherInputPageState extends State<WeatherInputPage> {
//   // Controllers for all 15 features
//   final tempController = TextEditingController();
//   final humidityController = TextEditingController();
//   final windController = TextEditingController();
//   final precipitationController = TextEditingController();
//   final pressureController = TextEditingController();
//   final uvController = TextEditingController();
//   final visibilityController = TextEditingController();
//   final cloudCloudyController = TextEditingController();
//   final cloudOvercastController = TextEditingController();
//   final cloudPartlyCloudyController = TextEditingController();
//   final seasonSpringController = TextEditingController();
//   final seasonSummerController = TextEditingController();
//   final seasonWinterController = TextEditingController();
//   final locationInlandController = TextEditingController();
//   final locationMountainController = TextEditingController();
//
//   TFLiteModel? _model;
//   String? _prediction;
//   String? _errorMessage;
//
//   // Class labels for output (replace with actual labels from lbe.classes_)
//   final List<String> _weatherClasses = ['Cloudy', 'Rainy', 'Snow','Sunny'];
//
//   @override
//   void initState() {
//     super.initState();
//     _initTFLite();
//   }
//
//   Future<void> _initTFLite() async {
//     try {
//       print('Initializing TFLiteWeb...');
//       await TFLiteWeb.initializeUsingCDN();
//       print('Loading model from assets...');
//       final byteData = await rootBundle.load('assets/model/xgb_model_web.tflite');
//       final bytes = byteData.buffer.asUint8List();
//       print('Model bytes loaded, size: ${bytes.length} bytes');
//       _model = await TFLiteModel.fromMemory(bytes);
//       print('Model loaded successfully');
//       setState(() {});
//     } catch (e) {
//       print('Error initializing TFLite or loading model: $e');
//       setState(() {
//         _errorMessage = 'Failed to load model: $e';
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     tempController.dispose();
//     humidityController.dispose();
//     windController.dispose();
//     precipitationController.dispose();
//     pressureController.dispose();
//     uvController.dispose();
//     visibilityController.dispose();
//     cloudCloudyController.dispose();
//     cloudOvercastController.dispose();
//     cloudPartlyCloudyController.dispose();
//     seasonSpringController.dispose();
//     seasonSummerController.dispose();
//     seasonWinterController.dispose();
//     locationInlandController.dispose();
//     locationMountainController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Weather Prediction")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildTextField(tempController, "Temperature (°C)"),
//             _buildTextField(humidityController, "Humidity (%)"),
//             _buildTextField(windController, "Wind Speed (km/h)"),
//             _buildTextField(precipitationController, "Precipitation (mm)"),
//             _buildTextField(pressureController, "Atmospheric Pressure (hPa)"),
//             _buildTextField(uvController, "UV Index"),
//             _buildTextField(visibilityController, "Visibility (km)"),
//             _buildTextField(
//               cloudCloudyController,
//               "Cloud Cover_cloudy (0 or 1)",
//             ),
//             _buildTextField(
//               cloudOvercastController,
//               "Cloud Cover_overcast (0 or 1)",
//             ),
//             _buildTextField(
//               cloudPartlyCloudyController,
//               "Cloud Cover_partly cloudy (0 or 1)",
//             ),
//             _buildTextField(seasonSpringController, "Season_Spring (0 or 1)"),
//             _buildTextField(seasonSummerController, "Season_Summer (0 or 1)"),
//             _buildTextField(seasonWinterController, "Season_Winter (0 or 1)"),
//             _buildTextField(
//               locationInlandController,
//               "Location_inland (0 or 1)",
//             ),
//             _buildTextField(
//               locationMountainController,
//               "Location_mountain (0 or 1)",
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _model == null ? null : _predictWeather,
//               child: const Text("Predict Weather"),
//             ),
//             const SizedBox(height: 20),
//             if (_prediction != null) Text("Predicted Weather: $_prediction"),
//             if (_errorMessage != null)
//               Text(
//                 "Error: $_errorMessage",
//                 style: const TextStyle(color: Colors.red),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, String label) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         keyboardType: TextInputType.numberWithOptions(decimal: true),
//       ),
//     );
//   }
//
//   void _predictWeather() async {
//     try {
//       // Collect all inputs
//       final List<String> inputStrings = [
//         tempController.text,
//         humidityController.text,
//         windController.text,
//         precipitationController.text,
//         pressureController.text,
//         uvController.text,
//         visibilityController.text,
//         cloudCloudyController.text,
//         cloudOvercastController.text,
//         cloudPartlyCloudyController.text,
//         seasonSpringController.text,
//         seasonSummerController.text,
//         seasonWinterController.text,
//         locationInlandController.text,
//         locationMountainController.text,
//       ];
//
//       // Validate inputs
//       for (var input in inputStrings) {
//         if (input.isEmpty) {
//           throw Exception('All fields must be filled');
//         }
//         if (double.tryParse(input) == null) {
//           throw Exception('Invalid numeric input: $input');
//         }
//       }
//
//       // Parse inputs to doubles
//       final List<double> inputValues = [
//         double.parse(tempController.text),
//         double.parse(humidityController.text),
//         double.parse(windController.text),
//         double.parse(precipitationController.text),
//         double.parse(pressureController.text),
//         double.parse(uvController.text),
//         double.parse(visibilityController.text),
//         double.parse(cloudCloudyController.text),
//         double.parse(cloudOvercastController.text),
//         double.parse(cloudPartlyCloudyController.text),
//         double.parse(seasonSpringController.text),
//         double.parse(seasonSummerController.text),
//         double.parse(seasonWinterController.text),
//         double.parse(locationInlandController.text),
//         double.parse(locationMountainController.text),
//       ];
//
//       // Validate one-hot encoded inputs (0 or 1)
//       for (var i = 7; i < inputValues.length; i++) {
//         if (inputValues[i] != 0.0 && inputValues[i] != 1.0) {
//           throw Exception(
//             'One-hot encoded fields must be 0 or 1: ${inputValues[i]}',
//           );
//         }
//       }
//
//       // Validate one-hot encoding constraints
//       final cloudSum = inputValues[7] + inputValues[8] + inputValues[9];
//       final seasonSum = inputValues[10] + inputValues[11] + inputValues[12];
//       final locationSum = inputValues[13] + inputValues[14];
//       if (cloudSum > 1.0) {
//         throw Exception(
//           'Cloud Cover: Only one of cloudy, overcast, partly cloudy, or none (clear) can be 1',
//         );
//       }
//       if (seasonSum > 1.0) {
//         throw Exception(
//           'Season: Only one of Spring, Summer, Winter, or none (Autumn) can be 1',
//         );
//       }
//       if (locationSum > 1.0) {
//         throw Exception(
//           'Location: Only one of inland, mountain, or none (coastal) can be 1',
//         );
//       }
//
//       // Validate input values (no NaN or Infinity)
//       for (var value in inputValues) {
//         if (value.isNaN || value.isInfinite) {
//           throw Exception('Invalid input value: $value (NaN or Infinite)');
//         }
//       }
//
//       print('Input Values: $inputValues');
//
//       // Create input tensor (shape [1, 15], float32)
//       // Note: Float32List stores values as IEEE 754 32-bit floats (some tiny precision loss possible compared to Dart double which is 64-bit).
//       final Float32List data = Float32List.fromList(inputValues);
//       // passing 1 row and  15 column
//       final Tensor inputTensor = Tensor(
//         data,
//         shape: [1, 15],
//         type: TFLiteDataType.float32,
//       );
//
//       // Run prediction
//       print('Running prediction...');
//       final Tensor outputTensor = await _model!.predict<Tensor>(inputTensor);
//       print('Prediction completed');
//
//       // Extract class index
//       final List<int> outputData = outputTensor.dataSync<List<int>>();
//
//       final int predictedClass = outputData[0];
//
//       // Map to weather label
//       final String predictedLabel = _weatherClasses[predictedClass];
//
//       // Update UI and print to console
//       setState(() {
//         _prediction = predictedLabel;
//         _errorMessage = null;
//       });
//       print(
//         "Predicted Weather: $predictedLabel (Class Index: $predictedClass)",
//       );
//     } catch (e) {
//       print('Error during prediction: $e');
//       setState(() {
//         _errorMessage = 'Prediction failed: $e';
//       });
//     }
//   }
// }
