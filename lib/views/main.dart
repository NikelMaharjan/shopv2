

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_shop/views/status_page.dart';

import '../constants/colors.dart';
import '../models/user.dart';

final box = Provider<User?>((ref) => null);   //this box will be null first time. simple provider to watch only. this is watched in authprovider

void main () async{

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Color(0xff4252B5)));


  await Hive.initFlutter();
  await Hive.openBox<String?>('user');   //opening box with key name 'user'. can only accept string, int.. data type
  final user = Hive.box<String?>('user');  //taking box reference with key name 'user'
  final userData  = user.get('userInfo');   //getting box values, saved from authService

  runApp(
      ProviderScope(
          overrides: [

            ///putting userData into box. since box take UserModel. so converting into model. here userData is in string. need to convert into map(jsonDecode)
            box.overrideWithValue(userData == null ? null : User.fromJson(jsonDecode(userData)))

          ],
          child: Home()
      ));

}




class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
            textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
            scaffoldBackgroundColor: lightWhite,
            inputDecorationTheme: const InputDecorationTheme(
                floatingLabelStyle: TextStyle(color: blue,
                )
            ),
            appBarTheme: const AppBarTheme(
              color:  blue,
            )
        ),
        debugShowCheckedModeBanner: false,
        home: StatusPage()
    );
  }
}