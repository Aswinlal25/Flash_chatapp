import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../helper/my_date_util.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ViewProfileScreen> {
  String? netImage; // Initialize with an empty string

  @override
  void initState() {
    super.initState();
    // Initialize _image with the user's current profile picture URL
    netImage = widget.user.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              children: [
                // Circular Avatar
                ClipOval(
                  child: CachedNetworkImage(
                    width: 250,
                    height: 250,
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
                SizedBox(height: 15),
                Text(
                  widget.user.name,
                  style: TextStyle(
                      color: Colors.white, fontSize: 25, letterSpacing: 1.5),
                ),
                SizedBox(height: 5),
                Text(
                  MyDateUtil.getLastActiveTime(
                      context: context, lastActive: widget.user.lastActive),
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),

                SizedBox(height: 5),
                Text(
                  widget.user.email,
                  style: TextStyle(
                    fontSize: 15,
                    letterSpacing: 1.7,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
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
                    Text(
                      'Message',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          letterSpacing: .5),
                    ),
                  ],
                ),
                Divider(
                  color: Color.fromARGB(255, 35, 35, 35),
                  height: 20,
                  thickness: 10,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'About : ',
                    style: TextStyle(
                        color: Colors.white70,
                        // fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        fontSize: 14),
                  ),
                  Text(
                    widget.user.about,
                    style: TextStyle(
                        color: Colors.white, letterSpacing: 1, fontSize: 17),
                  ),
                ]),

                SizedBox(
                  height: 5,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                        color: Colors.white, letterSpacing: 1, fontSize: 12),
                  ),
                ]),

                Divider(
                  color: Color.fromARGB(255, 35, 35, 35),
                  height: 30,
                  thickness: 10,
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
      ),
      backgroundColor: Color.fromARGB(255, 31, 30, 30),
    );
  }
}
