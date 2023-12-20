import 'package:flutter/material.dart';
 

class Dialogs{


static void showSnackbar(BuildContext context, String msg) {
  final snackBar = SnackBar(
    content: Text(msg),
    backgroundColor: Colors.black,
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 1), // Set the duration as needed
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

  static void showProgressBar(BuildContext context){
    showDialog(context: context, builder: (_)=> const Center(child: CircularProgressIndicator(),));
  }
}