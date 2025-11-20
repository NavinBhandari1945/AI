import 'dart:io';

import 'package:app/views/recognize/recognize_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../common widget/toast_message.dart';
import '../home/getx/image_picker_camera.dart';
import '../home/getx/image_picker_gallery.dart';

class Reconize_Home extends StatefulWidget {
  const Reconize_Home({super.key});

  @override
  State<Reconize_Home> createState() => _Reconize_HomeState();
}

class _Reconize_HomeState extends State<Reconize_Home> {
  final gallery_image_pick=Get.put(pick_single_photo_getx_int_gallery());
  final camera_image_pick=Get.put(pick_single_photo_getx_int_camera());
  @override
  Widget build(BuildContext context) {
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;
    var shortestval=MediaQuery.of(context).size.shortestSide;
    return Scaffold(

        appBar: AppBar(
          title: Text("Recognize Home Screen"),
        ),
        body:     Center(
          child: Card (
            child: Container(
              height: heightval,
              color:Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                [

                  InkWell(
                    child: Icon(
                      Icons.camera,
                      color: Colors.red,
                      size: shortestval*0.15,
                    ),
                    onTap: ()async{
                      int result=await camera_image_pick.pickImage();
                      print(result);
                      if(result==1){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return Recognize_Screen(Image_File: File(camera_image_pick.imagePath.value));
                        },));
                      }
                      else{
                        Toastget().Toastmsg("No image select from camera");
                      }
                    },
                  ),

                  InkWell(
                    child: Icon(
                      Icons.image,
                      color: Colors.red,
                      size: shortestval*0.15,
                    ),
                    onTap: () async{
                      int result=await gallery_image_pick.pickImage();
                      print(result);
                      if(result==1){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return Recognize_Screen(Image_File: File(gallery_image_pick.imagePath.value));
                        },));
                      }
                      else{
                        Toastget().Toastmsg("No image select from gallery");
                      }
                    },
                  ),

                ],
              ),
            ),
          ),
        )


    );
  }
}
