import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/services/apis/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/chat_user.dart';


class ProfilePictureView extends StatefulWidget {

  ProfilePictureView({super.key, required this.user,});

  final ChatUser user;
   
  @override
  State<ProfilePictureView> createState() => _ProfilePictureViewState();
}

class _ProfilePictureViewState extends State<ProfilePictureView> {
  late double height, width;
  
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed:() {
            Navigator.pop(context);
          },
          icon: Icon( CupertinoIcons.arrow_left,)),
        title: 
        widget.user == APIs.me?
        Text( 
        'Profile Picture',
          style: TextStyle(color: Colors.white70),
        ):
        Text( 
        widget.user.name,
          style: TextStyle(color: Colors.white),
        ),
        
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 140,
          ),
          Container(
            child: CachedNetworkImage(
              width: double.infinity,
              height: 400.0,
              fit: BoxFit.cover,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error) {
                print('Error loading image: $error');
                return const Icon(
                  CupertinoIcons.person,
                  size: 140,
                );
              },
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
