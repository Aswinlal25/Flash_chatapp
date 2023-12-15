import 'package:flutter/material.dart';
import '../../../common_widgets/snackbar.dart';
import '../../../services/apis/api.dart';
import '../../../utils/constants.dart';

class EditAppbar extends StatelessWidget implements PreferredSizeWidget {
  const EditAppbar({
    Key? key,
    required GlobalKey<FormState> formkey,
  }) : _formkey = formkey, super(key: key);

  final GlobalKey<FormState> _formkey;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        'Edit profile',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 19,
          fontWeight: FontWeight.w400,
          letterSpacing: 3,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              _formkey.currentState!.save();
              APIs.updateUserInfo();
              CustomSnackBar.show(context, 'Update successfully', black );
            }
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.check,
            color: white,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

