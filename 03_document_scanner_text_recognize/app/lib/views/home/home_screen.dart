import 'package:app/views/home/getx/image_picker_camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../recognize/reconize_home.dart';
import '../scan/scan_home.dart';
import 'getx/image_picker_gallery.dart';


//home screen to select option for scan recognize
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final gallery_image_pick=Get.put(pick_single_photo_getx_int_gallery());
  final camera_image_pick=Get.put(pick_single_photo_getx_int_camera());

  @override
  Widget build(BuildContext context) {

    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;
    var shortestval=MediaQuery.of(context).size.shortestSide;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Container(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
          [

            Card(
              child: Container(
                height: heightval*0.10,
                color:Colors.green,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:
                    [
                      //scan ,crop and save as pdf
                      InkWell(
                        child: Column(
                          children: [
                            Icon(
                              Icons.scanner,
                              color: Colors.red,
                              size: shortestval*0.15,
                            ),
                            Text("Scan",style: TextStyle(fontSize: shortestval*0.05),)
                          ],
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return UniversalDocScanner();
                          },));
                        },
                      ),


                      //extract contents of resources
                      InkWell(
                        child: Column(
                          children: [
                            Icon(
                              Icons.document_scanner,
                              color: Colors.red,
                              size: shortestval*0.15,
                            ),
                            Text("Recognize",style: TextStyle(fontSize: shortestval*0.05),)
                          ],
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return Reconize_Home();
                          },));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //loading image from assets
            Expanded(
              child: Card(
                color: Colors.black,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/image2.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),

      ),
    );
  }
}
