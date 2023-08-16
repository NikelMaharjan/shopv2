import 'package:flutter/material.dart';
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

final modeProvider = StateNotifierProvider.autoDispose<ModeProvider, AutovalidateMode>((ref) => ModeProvider(AutovalidateMode.disabled));


class ModeProvider extends StateNotifier<AutovalidateMode>{
  ModeProvider(super.state);

  void changeMode(){
    state = AutovalidateMode.onUserInteraction;
  }


}



final imageProvider = StateNotifierProvider.autoDispose<ImageProvider, XFile?>((ref) => ImageProvider(null));


class ImageProvider extends StateNotifier<XFile?> {
  ImageProvider(super.state);


  Future<void> pickAnImage(isCamera) async {
    final ImagePicker picker = ImagePicker();

    if(isCamera){
      state = await picker.pickImage(source: ImageSource.camera);
    }

    else {
     state  = await picker.pickImage(source: ImageSource.gallery);


    }


  }

}


