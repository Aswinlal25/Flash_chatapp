import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../apis/api.dart';
import '../helper/my_date_util.dart';
import '../widgets/dialogs/chat_delete_dialog.dart';
import 'profile_picture_screen.dart';

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
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfilePictureView(user: widget.user)));
            },
            child: Container(
              height: height * .48,
              child: CachedNetworkImage(
                width: 390.0,
                height: 180.0,
                fit: BoxFit.cover,
                imageUrl: netImage!,
                errorWidget: (context, url, error) {
                  print('Error loading image: $error');
                  return const Icon(
                    CupertinoIcons.person,
                    size: 140,
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 900,
          ),
          Positioned(
            top: 325,
            child: Container(
              height: height * .6,
              width: width * .999,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 31, 30, 30),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    widget.user.name,
                    style: TextStyle(
                        color: Colors.white, fontSize: 25, letterSpacing: 1.5),
                  ),
                  SizedBox(height: 15),
                  Text(
                    widget.user.email,
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.7,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    MyDateUtil.getLastActiveTime(
                        context: context, lastActive: widget.user.lastActive),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatScreen(
                                      user: widget.user,
                                    ),
                                  )).then((result) {
                                // Now, navigate to the HomeScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => HomeScreen(),
                                  ),
                                );
                              });
                            },
                            icon: const Icon(
                              Icons.chat,
                              color: Colors.white,
                              size: 27,
                            ),
                          ),
                          SizedBox(
                            width: 34,
                          ),
                          IconButton(
                            onPressed: () {
                              //_DeleteAllMsgDialog();
                              showDialog(
                        context: context,
                        builder: (_) =>   ChatDeleteDialog(user : widget.user
                            
                            ));
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 27,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '  Message',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            letterSpacing: .5,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        ' Delete chat',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            letterSpacing: .5,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(.20),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.9),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 40, 40, 40),
                        borderRadius: BorderRadius.all(
                            Radius.circular(20)), // Adjust the radius as needed
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 5, left: 30),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'About : ',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        // fontWeight: FontWeight.w700,
                                        letterSpacing: 1.5,
                                        fontSize: 15),
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.user.about,
                                      style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1,
                                          fontSize: 17),
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 13, left: 30),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Joined On : ',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.5,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    MyDateUtil.getLastMassageTime(
                                        context: context,
                                        time: widget.user.createdAt,
                                        showYear: true),
                                    style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 1,
                                        fontSize: 12),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(height: 100),
                  Text(
                    'FLASH',
                    style: TextStyle(
                        color: Colors.white38, letterSpacing: 5, fontSize: 13),
                  ),
                  Text(
                    'Version 1.0',
                    style: TextStyle(color: Colors.white24, fontSize: 8),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 5,
            top: 15,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                CupertinoIcons.arrow_left,
                color: Colors.white,
                size: 27,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 31, 30, 30),
    );
  }

 

  void _showSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white, letterSpacing: 1),
      ),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(8)), // Rounded rectangle border
      ),
      behavior: SnackBarBehavior.fixed,
    ));
  }
}
