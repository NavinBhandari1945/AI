import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class Recognize_Screen extends StatefulWidget {
  final Image_File;
  const Recognize_Screen({super.key,required this.Image_File});

  @override
  State<Recognize_Screen> createState() => _Recognize_ScreenState();
}

class _Recognize_ScreenState extends State<Recognize_Screen> {
  late TextRecognizer textRecognizer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    Do_Text_Recognizition();
  }

  String Result="";

  Do_Text_Recognizition()async{
    final inputImage = InputImage.fromFile(widget.Image_File);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    Result = recognizedText.text;
    print(Result);
    setState(() {
      Result;
    });
    for (TextBlock block in recognizedText.blocks) {
      final Rect rect = block.boundingBox;
      final List<Point<int>> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;
    var shortestval=MediaQuery.of(context).size.shortestSide;
    return Scaffold(
        appBar: AppBar(
        title: Text("Recognize Screen"),
    ),
    body: Container(
      width: widthval,
      height: heightval,
      color: Colors.white,
      child:
      Align(
        alignment: Alignment.center,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                    child: Image.file(widget.Image_File)),

                SizedBox(
                  height: heightval*0.04,
                ),

                Card(
                  child: Container(
                      child:
                      Column(
                        children: [
                          Container(
                            child:  Text("Result",style:TextStyle(color: Colors.black,fontSize: shortestval*0.05),),
                          ),
                          Text(Result,style:TextStyle(color: Colors.black,fontSize: shortestval*0.05),),
                        ],
                      )),
                ),
              ],
            ),
          )),
    )
    );
  }
}
