import 'package:chat_app/views/edit_profile_screen/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import '../../../services/apis/api.dart';
import '../../../utils/constants.dart';

enum InputFieldType { username, about }

class InputField extends StatelessWidget {
  final EditProfile widget;
  final InputFieldType fieldType;

  InputField({
    required this.widget,
    required this.fieldType,
  });

  @override
  Widget build(BuildContext context) {
    String hintText = '';
    String? initialValue;
    Function(String?) onSaved;

    switch (fieldType) {
      case InputFieldType.username:
        hintText = 'Username';
        initialValue = widget.user.name;
        onSaved = (val) => APIs.me.name = val ?? '';
        break;
      case InputFieldType.about:
        hintText = 'About';
        initialValue = widget.user.about;
        onSaved = (val) => APIs.me.about = val ?? '';
        break;
    }

    return TextFormField(
      initialValue: initialValue,
      onSaved: onSaved,
      validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field',
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.white24, // Border color in normal state
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: white, // Border color in focused state
            width: 2.0,
          ),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: white,
          letterSpacing: 2,
          fontSize: 15,
        ),
        prefixIcon: fieldType == InputFieldType.username
            ? Icon(
                Icons.person_2_outlined,
                color: white,
                size: 20,
              )
            : Icon(
                Icons.info_outline,
                color: white,
                size: 20,
              ),
      ),
      style: TextStyle(color: white),
    );
  }
}