import 'package:chat_app/views/users_profile_screen/view_profile_screen.dart';
import 'package:flutter/material.dart';
import '../../chat_screen/widgets/chat_delete_dialog.dart';

class PopMenu extends StatelessWidget {
  const PopMenu({
    super.key,
    required this.height,
    required this.width,
    required this.widget,
  });

  final double height;
  final double width;
  final ViewProfileScreen widget;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: height * 0.04,
        left: width * 0.89,
        child: PopupMenuButton(
            color: Color.fromARGB(255, 41, 40, 40),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(8.0), // Adjust the radius as needed
            ),
            itemBuilder: (context) => [
                  PopupMenuItem(
                    child: InkWell(
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (_) =>
                                ChatDeleteDialog(user: widget.user));
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 7,
                          ),
                          Icon(
                            Icons.delete,
                            color: Colors.white70, // Icon color
                            size: 22.0, // Icon size
                          ),
                          SizedBox(width: 15.0),
                          Text(
                            'Delete chat',
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 16.0, // Text size
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
            offset: Offset(0, 5),
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.more_vert, color: Colors.white),
            )));
  }
}
