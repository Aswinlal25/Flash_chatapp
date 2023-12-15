import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show(BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white, letterSpacing: 1),
        ),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}
