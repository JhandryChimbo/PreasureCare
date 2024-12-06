import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ErrorToast {
  ErrorToast(String s);

  static void show(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red.withOpacity(0.8),
      textColor: Colors.white,
      fontSize: 13.0,
    );
  }
}
