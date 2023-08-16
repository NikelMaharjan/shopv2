import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';


import '../models/common_state/common_state.dart';
import '../services/product_service.dart';




final crudProvider = StateNotifierProvider<ProductProvider, CommonState>((ref) => ProductProvider(CommonState(
    errText: '', isLoad: false, isSuccess: false, isError: false, user: null)));


class ProductProvider extends StateNotifier<CommonState>{
  ProductProvider(super.state);



  Future<void>  addProduct ({
    required String product_name,
    required String product_detail,
    required int   product_price,
    required XFile product_image,
    required String brand,
    required String category,
    required int countInStock,
    required String token
  })async {
    state = state.copyWith(errText: '', isError: false, isLoad: true,isSuccess: false);
    final response = await ProductService.addProduct(
        product_name: product_name,
        product_detail: product_detail,
        product_price: product_price,
        product_image: product_image,
        brand: brand,
        category: category,
        countInStock: countInStock,
        token: token,

    );

    response.fold(
            (l) {
          state=  state.copyWith(errText: l, isError: true, isLoad: false,isSuccess: false);
        },
            (r) {
          state = state.copyWith(errText: '', isError: false, isLoad: false,isSuccess: r,);
        }
    );

  }



  Future<void>  updateProduct ({
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
    state = state.copyWith(errText: '', isError: false, isLoad: true,isSuccess: false);
    final response = await ProductService.updateProduct(
        product_name: product_name,
        product_detail: product_detail,
        product_price: product_price,
        brand: brand,
        category: category,
        countInStock: countInStock,
        token: token,
        productId: productId,
        oldImage: oldImage,
        product_image: product_image

    );
    response.fold(
            (l) {
          state=  state.copyWith(errText: l, isError: true, isLoad: false,isSuccess: false);
        },
            (r) {
          state = state.copyWith(errText: '', isError: false, isLoad: false,isSuccess: r,);
        }
    );
  }


  Future<void>  removeProduct ({
    required String token,
    required String productId,
    required String oldImage,
  })async {
    state = state.copyWith(errText: '', isError: false, isLoad: true,isSuccess: false);
    final response = await ProductService.removeProduct(
        token: token,
        productId: productId,
        oldImage: oldImage
    );
    response.fold(
            (l) {
          state=  state.copyWith(errText: l, isError: true, isLoad: false,isSuccess: false);
        },
            (r) {
          state = state.copyWith(errText: '', isError: false, isLoad: false,isSuccess: r,);
        }
    );
  }



}