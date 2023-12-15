import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/views/users_profile_screen/widgets/back_button.dart';
import 'package:chat_app/views/users_profile_screen/widgets/content.dart';
import 'package:chat_app/views/users_profile_screen/widgets/image_part.dart';
import 'package:chat_app/views/users_profile_screen/widgets/navigation_button.dart';
import 'package:chat_app/views/users_profile_screen/widgets/popupmenu_button.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ViewProfileScreen> {
  late double height, width;
  String? netImage; // Initialize with an empty string

  @override
  void initState() {
    super.initState();
    // Initialize _image with the user's current profile picture URL
    netImage = widget.user.image;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          UserImagePart(widget: widget, height: height, netImage: netImage),
          height900,
          UserContentPart(height: height, width: width, widget: widget),
          NavigationButton(height: height, width: width, widget: widget),
          PopMenu(height: height, width: width, widget: widget),
          BackArrow(),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 31, 30, 30),
    );
  }
}

