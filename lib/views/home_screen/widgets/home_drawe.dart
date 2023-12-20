import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/services/hive_database/hive_db/user_db.dart';
import 'package:chat_app/services/hive_database/hive_model/user.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:share_plus/share_plus.dart';
import '../../../services/apis/api.dart';
import '../home_screen.dart';
import '../../user_profile_screen/profile_screen.dart';
import '../../../common_widgets/dialogs/logout_dialog.dart';
import '../../../common_widgets/dialogs/policy_dialog.dart';

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
                  showDialog(
                      context: context,
                      builder: (context) {
                        return PolicyDialog(mdFileName: 'privacy_policy.md');
                      });
                },
              ),
              ListTile(
                leading: Icon(Icons.book, color: Colors.white),
                title: Text('About Us', style: TextStyle(color: Colors.white)),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return PolicyDialog(mdFileName: 'about_us.md');
                      });
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.document_scanner_sharp, color: Colors.white),
                title: Text('Terms and Conditions',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return PolicyDialog(mdFileName: 'terms_conditions.md');
                      });
                },
              ),
              ListTile(
                leading: Icon(Icons.share, color: Colors.white),
                title: Text('Share', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Share.share("com.aswin.chat_app");
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.white),
                title: Text('Logout', style: TextStyle(color: Colors.white)),
                onTap: () {
                 
                  showDialog(
                        context: context,
                        builder: (_) => LogoutDialog(
                            
                            ));
                },
              ),
              SizedBox(
                height: 230,
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

  // ignore: unused_element
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
