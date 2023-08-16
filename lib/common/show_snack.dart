
import 'package:flutter/material.dart';
import 'package:simple_shop/constants/colors.dart';
import 'package:get/get.dart';
import 'package:simple_shop/views/cart_page.dart';



class CommonSnack{

  static successSnack ({required BuildContext context ,required String msg, bool? isCart}){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            action: isCart == true ? SnackBarAction(
                label: 'Go to Cart', onPressed: (){
                  Get.to(CartPage(), transition: Transition.leftToRight);
            }) : null,
            duration: Duration(seconds: 1),backgroundColor: AppColor.blue,content: Text(msg, style: TextStyle(color: Colors.white),)));
  }


  static errrorSnack ({required BuildContext context ,required String msg, bool? isCart}){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            action: isCart == true ? SnackBarAction(
                label: 'Go to Cart', onPressed: (){
              Get.to(CartPage(), transition: Transition.leftToRight);
            }) : null,
            duration: Duration(seconds: 1),backgroundColor: AppColor.red,content: Text(msg, style: TextStyle(color: Colors.white),)));
  }


}