import 'package:flutter/material.dart';
import '../../../services/helper/my_date_util.dart';
import '../view_profile_screen.dart';

class UserContentPart extends StatelessWidget {
  const UserContentPart({
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
      top: 325,
      child: Container(
        height: height * .6,
        width: width * .999,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 31, 30, 30),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.user.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      MyDateUtil.getLastActiveTime(
                          context: context,
                          lastActive: widget.user.lastActive),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      widget.user.email,
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 1.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      'Email id',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1,
                        color: Colors.white70,
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 0.3,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.user.about,
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 1.2,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      'About',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1,
                        color: Colors.white70,
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 0.3,
                    ),
                    SizedBox(
                      height: 210,
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Text(
                'Joined On : ${MyDateUtil.getLastMassageTime(context: context, time: widget.user.createdAt, showYear: true)}',
                style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}