import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/chat_user.dart';
import '../../screens/chat_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/view_profile_screen.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        height: 310,
        child: Column(
          children: [
            Stack(children: [
              Container(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: user.image,
                  errorWidget: (context, url, error) => CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
                width: 260,
                height: 260,
              ),
            ]),
            Stack(children: [
              Container(
                height: 40,
                color: Color.fromARGB(255, 31, 30, 30),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      user.name,
                      style: TextStyle(color: Colors.white, letterSpacing: 1),
                    ),
                    SizedBox(width: 40),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                user: user,
                              ),
                            )).then((result) {
                          // Now, navigate to the HomeScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  HomeScreen(), // Replace HomeScreen with the actual home screen widget
                            ),
                          );
                        });
                      },
                      icon: const Icon(Icons.chat, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                   ViewProfileScreen(user: user))).then((result) {
                          // Now, navigate to the HomeScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  HomeScreen(), // Replace HomeScreen with the actual home screen widget
                            ),
                          );
                        });
                      },
                      icon: const Icon(Icons.person, color: Colors.white),
                    )
                  ],
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}
