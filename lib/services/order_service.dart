import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:simple_shop/api.dart';
import 'package:simple_shop/exceptions/api_exceptions.dart';
import 'package:simple_shop/models/cart/cart_item.dart';
import 'package:simple_shop/models/order.dart';







class OrderService {
  static final dio = Dio();

  static Future<List<Orders>>  getOrderById() async {
    try {
      final response = await dio.get(Api.baseUrl, options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }
      ));
      return (response.data as List).map((e) => Orders.fromJson(e)).toList();
    } on DioException catch (err) {
      print(err);
      throw DioExceptions.getDioError(err);
    }
  }

  static Future<Either<String, bool>>  addOrder ({
    required List<CartItem> cartItems,
    required int totalPrice,
    required String token
  })async {
    try {

      final response = await dio.post(Api.addProduct, data: {
        'orderItems': cartItems.map((e) => e.toJson()).toList(),
        'totalPrice': totalPrice
      }, options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            HttpHeaders.authorizationHeader: token,
          }
      ));
      return Right(true);
    } on DioException catch (err) {
      return Left(DioExceptions.getDioError(err));
    }
  }






}