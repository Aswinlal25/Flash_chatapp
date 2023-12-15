import 'package:chat_app/views/edit_profile_screen/widgets/Input_feild.dart';
import 'package:chat_app/views/edit_profile_screen/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import '../../models/chat_user.dart';
import '../../utils/constants.dart';


class EditProfile extends StatefulWidget {
  final ChatUser user;
  const EditProfile({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 30, 30),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: EditAppbar(formkey: _formkey),
      ),
      body: Column(
        children: [
          Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(19.0),
              child: Column(
                children: [
                  height20,
                  InputField(widget: widget,fieldType: InputFieldType.username,),
                  height22,
                  InputField(widget: widget,fieldType: InputFieldType.about,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}