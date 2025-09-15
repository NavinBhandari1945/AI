import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Pick_Image{
  RxString Image_Path=" ".obs;
  Future<int> pick_image()async{
    try {
      final select_image = ImagePicker();
      final selected_iamge = await select_image.pickImage(
          source: ImageSource.gallery);
      if (selected_iamge != null) {
        Image_Path.value=selected_iamge.path;
        print("Image select success");
        return 2;
      }
      else {
        print("No image selected");
        return 1;
      }
    }catch(obj){
      print("Exception caught while picking image.");
      print(obj.toString());
      return 0;
    }

    return 0;
  }


}