import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../profile_screen.dart';

class ContentPart extends StatelessWidget {
  const ContentPart({
    super.key,
    required this.height,
    required this.widget,
  });

  final double height;
  final ProfileScreen widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.10),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 1,
                    color: Colors.white70,
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Text(
              widget.user.email,
              style: dataStyle
            ),
            height7,
            Text(
              'Email id',
              style: contenttitlestyle
            ),
            Divider(
              color: Colors.black,
              thickness: 0.3,
            ),
           height10,
            Text(
              widget.user.about,
              style: dataStyle
            ),                    
            height7,
            Text(
              'About',
              style: contenttitlestyle
            ),
            Divider(
              color: black,
              thickness: 0.3,
            ),
          ],
        ),
      ),
    );
  }
}

