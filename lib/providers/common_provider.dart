import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';



final loadingProvider = StateNotifierProvider<LoadingProvider, bool>((ref) => LoadingProvider(false));


class LoadingProvider extends StateNotifier<bool>{
  LoadingProvider(super.state);

  void toggle(){
    state = !state;
  }

}


final indexProvider = StateNotifierProvider<IndexProvider, int>((ref) => IndexProvider(0));


class IndexProvider extends StateNotifier<int>{
  IndexProvider(super.state);

  void change(int index){
    state = index;
  }

}


final imageProvider = StateNotifierProvider.autoDispose<ImageProvider, XFile?>(
        (ref) => ImageProvider(null));


class ImageProvider extends StateNotifier<XFile?>{
  ImageProvider(super.state);

  void pickAnImage(bool isCamera) async{
    final ImagePicker _picker = ImagePicker();
    if(isCamera){
      state = await _picker.pickImage(source: ImageSource.camera);
    }else{
      state = await _picker.pickImage(source: ImageSource.gallery);
    }
  }

}