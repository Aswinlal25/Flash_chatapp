import 'package:flutter/material.dart';
import '../../chat_screen/chat_screen.dart';
import '../../home_screen/home_screen.dart';
import '../view_profile_screen.dart';

class NavigationButton extends StatelessWidget {
  const NavigationButton({
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
      top: height * 0.43,
      left: width * 0.82,
      child: InkWell(
        onTap: () {
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
        child: Container(
          width: 45.0,
          height: 45.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Color.fromARGB(255, 107, 107, 107),
          ),
          child: Center(
            child: Icon(
              Icons.chat,
              color: Colors.white,
              size: 21,
            ),
          ),
        ),
      ),
    );
  }
}