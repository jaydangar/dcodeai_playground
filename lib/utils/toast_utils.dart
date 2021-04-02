import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static showToastMessage(
      {@required String text,
      double fontSize,
      Color bgColor,
      Color textColor}) {
    Fluttertoast.showToast(
      msg: text,
      fontSize: fontSize ?? 16,
      backgroundColor: bgColor ?? Colors.white,
      textColor: textColor ?? Colors.black,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
