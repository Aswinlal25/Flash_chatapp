import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/chat_user.dart';
import '../../screens/chat_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/profile_picture_screen.dart';
import '../../screens/view_profile_screen.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: SizedBox(
        height: 310,
        child: Column(
          children: [
            Stack(children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfilePictureView(user: user)))
                      .then((result) => Navigator.pop(context));
                },
                child: Container(
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
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w400),
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
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomeScreen(),
                            ),
                          );
                        });
                      },
                      icon: const Icon(CupertinoIcons.chat_bubble_text_fill,
                          color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewProfileScreen(user: user)))
                            .then((result) {
                          // Now, navigate to the HomeScreen
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomeScreen(),
                            ),
                          );
                        });
                      },
                      icon: const Icon(CupertinoIcons.info_circle_fill,
                          color: Colors.white),
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
