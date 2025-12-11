# Object Detection 

This project demonstrates real-time object detection using a TFLite MobileNet model integrated with Flutter and the device camera. The app captures live camera frames, preprocesses them, runs inference on a TensorFlow Lite model, and displays prediction results on the screen.



## "Project Overview"

* This Flutter application performs on-device object detection.
* It uses a "TensorFlow Lite" model (`mobilenet.tflite`) and corresponding label file.
* The camera feed is processed in real-time for inference.
* Predictions are displayed with confidence scores.



## "Features"

* Real-time camera streaming
* Image preprocessing (YUV420 to RGB conversion)
* Input resizing to 224x224 for MobileNet
* Normalization to range [-1, 1]
* TensorFlow Lite inference using "tflite_flutter"
* Displays the predicted label with confidence


## "Project Structure"

* Loads TFLite model from assets
* Initializes the device camera
* Converts raw camera image (YUV) to RGB format
* Resizes and normalizes the image
* Runs inference using TensorFlow Lite
* Outputs the prediction on-screen



## "Dependencies"


camera: ^0.11.2  
tflite_flutter: ^0.11.0  
image: ^4.5.4  
cupertino_icons: ^1.0.8


## "Steps Performed in the App"

* Load MobileNet model from assets folder
* Load all label names from the label text file
* Initialize device camera using CameraController
* Start a camera image stream
* Convert YUV420 camera frame to an RGB image
* Resize image to 224x224 for MobileNet
* Normalize pixel values
* Run inference through Interpreter
* Identify highest probability label
* Display result in UI



## "Model and Label Files"

Your assets folder must contain:

* `"assets/models/mobilenet.tflite"`
* `"assets/models/mobilenet.txt"`

Be sure to include them in your pubspec.yaml:


assets:
  - assets/models/mobilenet.tflite
  - assets/models/mobilenet.txt


## "How to Run the Project"

* Install Flutter SDK
* Add required model files in the assets folder
* Run `flutter pub get`
* Connect a real device (camera plugin does not work on most emulators)
* Run the project using

flutter run


## "Known Limitations"

* Works best on physical devices
* Requires proper lighting for accurate detection
* MobileNet model predicts general object categories



## "Future Improvements"

* Add bounding box detection
* Use SSD MobileNet for real object detection
* Display multiple predictions
* Improve UI for more interactive experience

