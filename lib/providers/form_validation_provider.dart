






import 'package:flutter_riverpod/flutter_riverpod.dart';

final validateProvider = StateNotifierProvider<ValidateProvider, bool>((ref) => ValidateProvider(true));


class ValidateProvider extends StateNotifier<bool>{

  ValidateProvider(super.state);


  void visible(){

    if(state){
      state = false;
    }
    else{
      state = true;
    }


  }





}