

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_shop/models/cart/cart_item.dart';
import 'package:simple_shop/views/status_page.dart';

import '../constants/colors.dart';
import '../models/user.dart';

//both box will only get values after opening the app again. Hive already have values.
//we used state to display the cart items in realtime and user.fromJson in service not to make user null before closing app
//after opening the app, box will get override values and that will be displayed


final box = Provider<User?>((ref) => null);   //this box will be null first time. simple provider to watch only. this is watched in authprovider
final boxA = Provider<List<CartItem>>((ref) => []);


void main () async{

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Color(0xff4252B5)));


  await Hive.initFlutter();

  Hive.registerAdapter(CartItemAdapter());  //we use adapter to save list
  await Hive.openBox<String?>('user');   //opening box with key name 'user'. can only accept string, int.. data type
  final user = Hive.box<String?>('user');  //taking box reference with key name 'user'
  final userData  = user.get('userInfo');   //getting box values, saved from authService

  final cartBox = await Hive.openBox<CartItem>('carts');


  runApp(
      ProviderScope(
          overrides: [

            ///putting userData into box. since box take UserModel. so converting into model. here userData is in string. need to convert into map(jsonDecode)
            box.overrideWithValue(userData == null ? null : User.fromJson(jsonDecode(userData))),
            boxA.overrideWithValue(cartBox.values.toList())

          ],
          child: Home()
      ));

}




class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
            fontFamily: 'Raleway',
            scaffoldBackgroundColor: AppColor.lightWhite,
            inputDecorationTheme:  InputDecorationTheme(
                floatingLabelStyle: TextStyle(color: AppColor.blue,
                )
            ),
            appBarTheme:  AppBarTheme(
              color:  AppColor.blue,
            )
        ),
        debugShowCheckedModeBanner: false,
        home: StatusPage()
    );
  }
}