import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:simple_shop/services/auth_services.dart';
import 'package:simple_shop/views/main.dart';

import '../models/common_state/common_state.dart';




final authProvider = StateNotifierProvider<AuthProvider, CommonState>((ref) => AuthProvider(CommonState(
    errText: '', isLoad: false, isSuccess: false, isError: false, user: ref.watch(box))));


class AuthProvider extends StateNotifier<CommonState>{
  AuthProvider(super.state);


  Future<void> userLogin({
    required String email,
    required String password
  }) async {
    state = state.copyWith(errText: '', isError: false, isLoad: true, isSuccess: false);
    final response = await AuthService.userLogin(email: email, password: password);
    response.fold(
            (l) {
          state=  state.copyWith(errText: l, isError: true, isLoad: false,isSuccess: false);
        },
            (r) {
          state = state.copyWith(errText: '', isError: false, isLoad: false,isSuccess: true,user: r);
        }
    );

  }

  void userLogOut(){
    Hive.box<String?>('user').clear();
    state = state.copyWith(user: null);
  }

}