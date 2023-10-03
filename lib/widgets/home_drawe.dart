import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/auth/Methods.dart';
import '../models/chat_user.dart';

class CustomDrawer extends StatelessWidget {
  final ChatUser user;
  const CustomDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 270,
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.transparent),
              accountName: Text(
                user.name,
                style: TextStyle(letterSpacing: 1, fontSize: 18),
              ),
              accountEmail: Text(user.about),
              currentAccountPicture: CircleAvatar(
                radius: 70,
                backgroundColor:
                    Colors.transparent, // Ensure the background is transparent
                child: ClipOval(
                  child: CachedNetworkImage(
                    width:
                        140, // Double the radius to cover the entire CircleAvatar
                    height:
                        140, // Double the radius to cover the entire CircleAvatar
                    fit: BoxFit.cover,
                    imageUrl: user.image,
                    errorWidget: (context, url, error) {
                      print('Error loading image: $error');
                      return const Icon(CupertinoIcons.person,
                          size: 140); // Use an icon as the error widget
                    },
                  ),
                ),
              ),
              currentAccountPictureSize: Size(140, 165),
            ),
          ),
          ListTile(
            leading: Icon(Icons.lock, color: Colors.white),
            title: Text(
              'Privacy and Policy',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.book, color: Colors.white),
            title: Text('About Us', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.document_scanner_sharp, color: Colors.white),
            title: Text('Terms and Conditions',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.share, color: Colors.white),
            title: Text('Share', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.white),
            title: Text('Logout', style: TextStyle(color: Colors.white)),
            onTap: () {
              _logoutAndShowDialog(context);
              // logOut(context);
            },
          ),
          SizedBox(
            height: 110,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              'FLASH',
              style: TextStyle(
                  color: Colors.white38, letterSpacing: 5, fontSize: 15),
            ),
            Text(
              'Version 1.0',
              style: TextStyle(color: Colors.white24, fontSize: 9.5),
            )
          ])
        ],
      ),
      backgroundColor: Color.fromARGB(255, 31, 30, 30),
    );
  }

  void _logoutAndShowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          
          shape: RoundedRectangleBorder(
            
    borderRadius: BorderRadius.circular(15.0)),
          backgroundColor: Color.fromARGB(255, 31, 30, 30),
          title: Text('Logout',
              style: TextStyle(color: Colors.white, letterSpacing: 0.9)),
          content: Text(
            'Are you sure you want to log out ?',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () {
                logOut(context);
                _showSnackBar(context, 'Logout Successfully.',
                    Colors.black); //  logout method
                //Navigator.
              },
              child: Text('Logout', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
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
