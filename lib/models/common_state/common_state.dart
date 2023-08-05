

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_shop/models/user.dart';

part 'common_state.freezed.dart';

@freezed
class CommonState with _$CommonState{

  const factory CommonState({
    required String errText,
    required bool isLoad,
    required bool isSuccess,
    required bool isError,
    required User? user
  }) =_CommonState;



  //if need to make initialstate
  // factory CommonState.empty(){
  //   return CommonState(errText: '', isLoad: false, isSuccess: false, isError: false, user: null);
  // }



}