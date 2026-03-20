import 'package:image_picker/image_picker.dart';

class Pick_Image{

  Future<String?> Image_Pick() async {
    try {
      String? Image_Path = '';
      final ImagePicker Image_Pick_Obj = ImagePicker();
      final Picked_Media = await Image_Pick_Obj.pickImage(
          source: ImageSource.gallery
      );

      if (Picked_Media == null) {
        print("Image picked failed");
        return null;
      }
      else {
        Image_Path = Picked_Media.path.toString();
        print("Image picked success");
        return Image_Path;
      }
    }catch(Obj){
      print("Exceptioon caugh while picking image.");
      return null;
    }
  }
}