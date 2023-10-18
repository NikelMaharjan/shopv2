import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_shop/exceptions/api_exceptions.dart';
import 'package:simple_shop/models/product.dart';

import '../api.dart';




final productProvider = FutureProvider((ref) => ProductService.getAllProducts);



class ProductService {
  static final dio = Dio();

  static Future<List<Product>> get getAllProducts async {
    try {
      final response = await dio.get(Api.baseUrl, options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }
      ));
      return (response.data as List).map((e) => Product.fromJson(e)).toList();
    } on DioException catch (err) {
      print(err);
      throw DioExceptions.getDioError(err);
    }
  }


  static Future<Either<String, bool>>  addProduct ({
    required String product_name,
    required String product_detail,
    required int   product_price,
    required XFile product_image,
    required String brand,
    required String category,
    required int countInStock,
    required String token
  })async {
    try {
      final formData = FormData.fromMap({
        'product_name': product_name,
        'product_detail': product_detail,
        'product_price': product_price,
        'brand': brand,
        'category' : category,
        'countInStock': countInStock,
        'product_image':  await MultipartFile.fromFile(product_image.path, filename: product_image.name),
      });
      final response = await dio.post(Api.addProduct, data: formData, options: Options(
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



  static Future<Either<String, bool>>  updateProduct ({
    required String product_name,
    required String product_detail,
    required int   product_price,
    required String brand,
    required String category,
    required int countInStock,
    required String token,
    required String productId,
    XFile? product_image,
    String? oldImage,
  })async {
    try {
      if(product_image == null){

        final response = await dio.patch('${Api.productUpdate}/$productId', data: {
          'product_name': product_name,
          'product_detail': product_detail,
          'product_price': product_price,
          'brand': brand,
          'category' : category,
          'countInStock': countInStock,
        },
            options: Options(
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  HttpHeaders.authorizationHeader: token,
                }
            ));
        return Right(true);
      }
      else{
        final formData = FormData.fromMap({
          'product_name': product_name,
          'product_detail': product_detail,
          'product_price': product_price,
          'brand': brand,
          'category' : category,
          'countInStock': countInStock,
          'product_image':  await MultipartFile.fromFile(product_image.path, filename: product_image.name),

        });
        final response = await dio.patch('${Api.productUpdate}/$productId',
            data: formData,
            queryParameters: {
              'oldImage': oldImage
            },
            options: Options(
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  HttpHeaders.authorizationHeader: token,
                }
            ));
        return Right(true);
      }


    } on DioException catch (err) {
      return Left(DioExceptions.getDioError(err));
    }
  }





  static Future<Either<String, bool>>  removeProduct ({
    required String token,
    required String productId,
    required String oldImage,
  })async {
    try {

      final response = await dio.delete('${Api.productRemove}/$productId',
          queryParameters: {
            'oldImage': oldImage
          },
          options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                HttpHeaders.authorizationHeader: token,
              }
          ));
      print("response is $response");
      return Right(true);


    } on DioException catch (err) {
      print(err.response);
      return Left(DioExceptions.getDioError(err));
    }
  }







}