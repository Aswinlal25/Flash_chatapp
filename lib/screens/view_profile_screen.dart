import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chat_user.dart';
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
        elevation: 3,
        // title: Text(
        //   'Profile',
        //   style: TextStyle(
        //       color: Colors.white70, fontSize: 19, fontWeight: FontWeight.w500,letterSpacing: 4),
        // ),
      ),
      // floatingActionButton:
      //     Padding(
      //       padding: const EdgeInsets.only(left: 120,bottom: 7),
      //       child: Row(
      //         children: [
      //             Text(
      //       'Joined On : ',
      //       style: TextStyle(
      //           color: Colors.white70,
      //           fontWeight: FontWeight.w700,
      //           letterSpacing: 1.5),
      //             ),
      //             Text(
      //       MyDateUtil.getLastMassageTime(
      //           context: context, time: widget.user.createdAt,
      //            showYear: true),
      //       style: TextStyle(color: Colors.white70,letterSpacing: 1),
      //             ),
      //           ]),
      //     ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              children: [
                SizedBox(height: 28),
                // Circular Avatar
                ClipOval(
                  child: CachedNetworkImage(
                    width: 270,
                    height: 270,
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
                SizedBox(height: 15),

                Text(
                  '${widget.user.about}',
                  style: TextStyle(
                    fontSize: 17,
                    letterSpacing: 1,
                    color: Colors.white,
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
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text(
                'Joined On : ',
                style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5),
                      ),
                      Text(
                MyDateUtil.getLastMassageTime(
                    context: context, time: widget.user.createdAt,
                     showYear: true),
                style: TextStyle(color: Colors.white70,letterSpacing: 1),
                      ),
                    ]),

                SizedBox(height: 86),
                Image.asset('asset/profilepagelogo.png',
                width: 90,
                height: 90,
                ),
                SizedBox(height: 5,),
                Text(
              'FLASH',
              style: TextStyle(
                  color: Colors.white38, letterSpacing: 5 , fontSize: 13),
            ),

                // SizedBox(
                //   height:,
                // ),
                Text(
                  'Version 1.0',
                  style: TextStyle(color: Colors.white24,fontSize: 8),
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
