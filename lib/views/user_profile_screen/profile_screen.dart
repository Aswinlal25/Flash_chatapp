import 'dart:io';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/views/user_profile_screen/widgets/bottomsheet.dart';
import 'package:chat_app/views/user_profile_screen/widgets/components.dart';
import 'package:chat_app/views/user_profile_screen/widgets/content_widget.dart';
import 'package:chat_app/views/user_profile_screen/widgets/image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../services/apis/api.dart';
import '../../utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //final _formkey = GlobalKey<FormState>();
  String? _image;
  String? netImage;

  @override
  void initState() {
    super.initState();
    netImage = widget.user.image;
  }

  late double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: null,
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ImagePart(image: _image, widget: widget, netImage: netImage),
                ContentPart(height: height, widget: widget),
              ],
            ),
          ),
          cameraButton(),
          Components.editButton(context),
          Components.backArrowButton(context),
          Components.Username(widget.user.name),
          Components.onlineTxt(),
          Components.popMenuButton((String imagePath) {
            setState(() {
              _image = imagePath; // Update the state in the parent widget
            });
          })
        ]),
        backgroundColor: primarycolor);
  }

  Positioned cameraButton() {
    return Positioned(
          top: height * 0.38, //l
          left: width * 0.83,
          child: GestureDetector(
            onTap: () {
              _showBottomSheet();
            },
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  color: Color.fromARGB(255, 107, 107, 107),
                ),
                child: Center(
                  child: Icon(
                    CupertinoIcons.photo_camera_solid,
                    color: white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        );
  }
  _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color.fromARGB(255, 16, 16, 16),
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: ProfilePictureBottomSheet(
            onUpdateProfilePicture: (File image) {
              setState(() {
                _image = image.path;
              });
              APIs.updateProfilePicture(image);
            },
            image: _image,
          ),
        );
      },
    );
  }
}
