# 📄 Flutter Document Scanner & OCR App

A Flutter application that allows users to scan documents into PDF files using the device camera and extract text from images using Google ML Kit OCR.

This project combines:

* 📷 Document scanning (multi‑page PDF)
* 💾 Saving PDFs to device storage
* 🔍 Optical Character Recognition (OCR)



## ✨ Features

* Scan documents using the camera
* Generate PDF files (up to 4 pages)
* Save PDFs using native file picker (Android / iOS)
* Extract text from images using Google ML Kit
* Clean and simple UI
* GetX ready (can be extended for state management)


## 📦 Dependencies

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8
  image_picker: ^1.2.0
  get: ^4.7.2
  google_mlkit_text_recognition: ^0.15.0
  flutter_doc_scanner: ^0.0.17
  path_provider: ^2.1.2
  path: ^1.9.0
  file_saver: ^0.2.14


## 📸 Document Scanner Screen

UniversalDocScanner allows users to:

* Launch the document scanner
* Scan up to 4 pages
* Convert scanned pages into a PDF
* Save the PDF to the device

### Key Method


FlutterDocScanner().getScannedDocumentAsPdf(page: 4);


The scanned PDF is temporarily generated and then saved using `file_saver`.


## 🔍 OCR Text Recognition Screen

Recognize_Screen uses Google ML Kit to extract text from an image.

### OCR Flow

1. Pick or capture an image
2. Convert it to `InputImage`
3. Process image with ML Kit
4. Display recognized text

### Core Code

final inputImage = InputImage.fromFile(widget.Image_File);
final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);


## 🔐 Platform Configuration

### Android Permissions (`AndroidManifest.xml`)

<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />


> For Android 13+, storage permissions are handled automatically by `file_saver`.

## 🚀 How to Run
flutter pub get
flutter run
Ensure camera permissions are granted.

## ⚠️ Notes

* Works best on real devices (camera required)
* PDF files are usually saved in Downloads
* OCR accuracy depends on image quality


## 🛠️ Possible Improvements

* Crop & rotate scanned pages
* Search inside scanned PDFs
* Export OCR text to TXT / DOCX
* Cloud storage integration


## 📄 License
This project is open‑source and free to use for learning and development purposes.
