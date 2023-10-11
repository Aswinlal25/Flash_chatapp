import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/hive_db/user_db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/auth/Methods.dart';
import 'package:hive_flutter/adapters.dart';
import '../apis/api.dart';
import '../hive_model/user.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
// import '../models/chat_user.dart';

class CustomDrawer extends StatefulWidget {
  // final ChatUser user;
  const CustomDrawer({
    super.key,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late Box<UserModel> user;

  @override
  void initState() {
    super.initState();
    user = Hive.box('user_db');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ValueListenableBuilder(
        valueListenable: thisUSer,
        builder: (context, user, child) {
          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(user: APIs.me)))
                    ..then((result) {
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
                  height: 220,
                  width: 50,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: CachedNetworkImageProvider(user.image ?? "image"),
                    fit: BoxFit.cover,
                  )),
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Colors.transparent),
                    accountName: Text(
                      user.name ?? "name",
                      style: TextStyle(letterSpacing: 1, fontSize: 18),
                    ),
                    accountEmail: Text(user.about ?? "about"),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
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
                leading:
                    Icon(Icons.document_scanner_sharp, color: Colors.white),
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
                  // _logoutAndShowDialog(context);
                  _LogoutDialog();
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
          );
        },
      ),
      backgroundColor: Color.fromARGB(255, 30, 30, 30),
    );
  }

  void _logoutAndShowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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

  void _LogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          backgroundColor: Color.fromARGB(255, 30, 30, 30),
          content: Stack(children: [
            SizedBox(
              height: 250,
              
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                      child: Image.asset(
                    'asset/logoutEmoji.jpg',
                    width: 97,
                    height: 100,
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Do you want to logout ?',
                    style: TextStyle(color: Colors.white, letterSpacing: 1),
                  ),
                  SizedBox(
                    height: 38,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        // shape: BoxShape.circle,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    width: 200,
                    height: 50,
                    child: Center(
                        child: InkWell(
                            onTap: () {
                              logOut(context);

                              _showSnackBar(context, 'Logout Successfully.',
                                  Colors.black); //  logout method
                            },
                            child: Text(
                              'Logout',
                              style: TextStyle(color: Colors.white),
                            ))),
                  )
                ],
              ),
            ),
            Positioned(
                left: 200,
                bottom: 219,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    size: 24,
                    color: Colors.white,
                  ),
                ))
          ]),
        );
      },
    );
  }
}
