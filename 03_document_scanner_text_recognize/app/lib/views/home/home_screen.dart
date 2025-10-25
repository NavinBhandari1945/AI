import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          children:
          [

            Card(
              child: Container(
                height: heightval*0.10,
                color:Colors.green,
                child: Row(
                  children:
                  [

                    InkWell(
                      child: Icon(
                          Icons.camera,
                        color: Colors.red,
                        size: shortestval*0.15,
                      ),
                      onTap: (){

                      },
                    ),

                  ],
                ),
              ),
            )

          ],
        ),

      ),
    );
  }
}
