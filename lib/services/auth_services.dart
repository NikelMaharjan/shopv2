





import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_shop/api.dart';
import 'package:simple_shop/exceptions/api_exceptions.dart';
import 'package:simple_shop/models/user.dart';

class AuthService{


  static final dio = Dio();

  static Future<Either<String, User>> userLogin({
    required String email,
    required String password
  }) async {
    try {
      final response = await dio.post(Api.userLogin,
          data: {
            'email': email,
            'password': password
          },
          options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
              }
          ));
      final user = Hive.box<String?>('user');      //taking box reference with key name 'user'
      user.put('userInfo', jsonEncode(response.data));  //putting response data in user box in 'userInfo' keyname. box wont take map. so need to convert map into string (jsonEncode)
      return Right(User.fromJson(response.data));
    } on DioException catch (err) {
      print(err.response);
      return Left(DioExceptions.getDioError(err));
    }
  }


}