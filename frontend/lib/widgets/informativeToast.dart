import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InformativeToast {
  InformativeToast(String s);

  static void show(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white.withOpacity(0.4),
      textColor: const Color.fromARGB(255, 79, 74, 74),
      fontSize: 13.0,
    );
  }
}


