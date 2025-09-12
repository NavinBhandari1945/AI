Weather Prediction App

1. Overview
This project is a machine learning-based weather prediction application available as both a web application (using tflite_web) and a mobile application (using tflite_flutter). Users can input 15 weather-related features (e.g., temperature, humidity, wind speed, etc.) through a user-friendly interface, and the app predicts one of four weather conditions: Cloudy, Rainy, Snowy, or Sunny. The prediction is powered by an XGBoost classifier converted to TensorFlow Lite (TFLite) for efficient on-device inference, optimized for both web and mobile platforms.

2. Features .

User Input: Enter 15 weather parameters, including temperature (°C), humidity (%), wind speed (km/h), precipitation (mm), atmospheric pressure (hPa), UV index, visibility (km), cloud cover types (cloudy, overcast, partly cloudy), seasons (spring, summer, winter), and location types (inland, mountain).

Machine Learning Model: Utilizes an XGBoost model trained on weather data, converted to TFLite for lightweight predictions.

Platform Support:
Web: Runs in browsers using tflite_web with WebAssembly for fast inference.
Mobile: Runs on Android and iOS devices using tflite_flutter for native performance.

Prediction Output: Displays the predicted weather condition based on user inputs.

Error Handling: Provides feedback for invalid inputs or model loading issues.

3. How It Works

The app loads a pre-trained TFLite model (xgb_model_web.tflite for web, xgb_model_mobile.tflite for mobile) generated from an XGBoost classifier.
Users input weather-related features via text fields in the app's interface (web or mobile).
The TFLite model processes the inputs and predicts the weather condition, displayed on the screen.
The app handles edge cases (e.g., invalid inputs) and ensures compatibility with the respective platform.

4. Model Details

Training: The XGBoost model was trained on a dataset with 15 features and 4 weather classes.
Conversion: The model was converted to TFLite using Python scripts in Jupyter Lab, ensuring compatibility with tflite_web (web) and tflite_flutter (mobile).
Web: Uses a simplified model with only TFLITE_BUILTINS ops for WebAssembly compatibility.
Mobile: Supports SELECT_TF_OPS for enhanced performance on Android/iOS.
Accuracy: The TFLite models achieve high accuracy (tested to match the original XGBoost model) on the test dataset.

5. Setup

Prerequisites

Flutter SDK: For both web and mobile implementations.
Python Environment: For model conversion (Python 3.10.9, TensorFlow 2.15.0, XGBoost, NumPy).
Dependencies:
Web: tflite_web package.
Mobile: tflite_flutter: ^0.10.4 package.



Installation

Clone the Repository:git clone https://github.com/NavinBhandari1945/AI.git

Add TFLite Models:
Place xgb_model_web.tflite and xgb_model_mobile.tflite in the assets/model/ directory.
Update pubspec.yaml:flutter:
  assets:
    - assets/model/xgb_model_web.tflite
    - assets/model/xgb_model_mobile.tflite




Generate TFLite Models:
Run the provided Jupyter Lab scripts (xgb_to_tflite_web.py for web, xgb_to_tflite_flutter.py for mobile) to generate the TFLite models.
Copy the generated .tflite files to assets/model/.


Build and Run:

Web:flutter run -d chrome
Mobile:flutter run

6. Usage

Launch the app:
Web: Open in a browser (e.g., Chrome) using flutter run -d chrome.
Mobile: Run on an Android/iOS emulator or physical device using flutter run.


Enter values for the 15 weather features in the text fields (e.g., temperature, humidity).
Press the "Predict Weather" button to view the predicted weather condition.
Check for error messages if inputs are invalid or the model fails to load.

7. Project Structure

lib/main.dart: Entry point for the Flutter app.
lib/weather_input_page.dart: UI and prediction logic for both web and mobile.
assets/model/: Contains xgb_model_web.tflite (web) and xgb_model_mobile.tflite (mobile).
xgb_to_tflite_web.py: Python script for generating the web-compatible TFLite model.
xgb_to_tflite_flutter.py: Python script for generating the mobile-compatible TFLite model.

8. Testing

Model Conversion:
Run the Python scripts to generate TFLite models.
Verify high accuracy (~100%) using the test suite in the scripts (Tests 1–3).
Ensure no unsupported ops (CUSTOM) for compatibility (Test 5).

App Testing:
Test predictions with sample inputs from the training dataset (X_test).
Validate model loading and error handling in the app.

9. Troubleshooting

Model Loading Error:
Ensure .tflite files are in assets/model/ and listed in pubspec.yaml.
Run flutter clean && flutter pub get to refresh assets.

Low Accuracy:
Verify the XGBoost model’s accuracy using the Python script’s Test 9.
Check class distribution (Test 10) for imbalance and adjust class weights if needed.

Performance Issues:
Use isolates for mobile inference (IsolateInterpreter in tflite_flutter).
Simplify the XGBoost model (e.g., reduce n_estimators or max_depth).


