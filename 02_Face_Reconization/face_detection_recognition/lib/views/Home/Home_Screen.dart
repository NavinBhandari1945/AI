import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Getx/Pick_Image.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  final Image_Picked=Get.put(Pick_Image());
  @override
  Widget build(BuildContext context) {
    var Width_Value=MediaQuery.of(context).size.width;
    var Height_Value=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body:
      Container (
        width: Width_Value,
        height: Height_Value,
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
            [

              Obx(
              ()=>
                  Container(
                    width:Width_Value*0.5,
                    height: Height_Value*0.3,
                    color: Colors.red,
                    child: Image_Picked.Image_Path.value.isEmpty?
                        Icon(Icons.image_outlined):
                    Image.file(
                        File(Image_Picked.Image_Path.value),
                      fit: BoxFit.cover,
                    ),
                  ),
              ),

              SizedBox(
                height: Height_Value*0.01,
              ),

              ElevatedButton(onPressed: ()async{
                int Pick_Image_Result=await Image_Picked.pick_image();
                print(Pick_Image_Result);
              }, child:Text("Capture/Choose"))

            ],
          ),
        ),

      ),

    );
  }
}
