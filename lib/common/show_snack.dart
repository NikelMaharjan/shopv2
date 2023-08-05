
import 'package:flutter/material.dart';



class CommonSnack{

  static successSnack (BuildContext context , String msg){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: Duration(seconds: 1),backgroundColor: Colors.blueGrey,content: Text(msg, style: TextStyle(color: Colors.white),)));
  }


  static errrorSnack (BuildContext context , String msg){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: Duration(seconds: 1),backgroundColor: Colors.pinkAccent,content: Text(msg, style: TextStyle(color: Colors.white),)));
  }


}