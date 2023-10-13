import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/hive_db/user_db.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/auth/Methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../apis/api.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //final _formkey = GlobalKey<FormState>();
  String? _image;
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
      appBar: null,
      // appBar: AppBar(
      //     backgroundColor: Colors.transparent,
      //     centerTitle: true,
      //     title: Text(
      //       'Profile',
      //       style: TextStyle(
      //           color: Colors.white70,
      //           fontSize: 19,
      //           fontWeight: FontWeight.w500,
      //           letterSpacing: 4),
      //     ),
      //     actions: [
      // PopupMenuButton(

      //     color: Color.fromARGB(255, 41, 40, 40),
      //     shape: RoundedRectangleBorder(
      //       borderRadius:
      //           BorderRadius.circular(8.0), // Adjust the radius as needed
      //     ),
      //     itemBuilder: (context) => [
      //           PopupMenuItem(
      //             child: InkWell(
      //               onTap: () async {
      //                 final ImagePicker picker = ImagePicker();
      //                 final XFile? image = await picker.pickImage(
      //                     source: ImageSource.gallery);

      //                 if (image != null) {
      //                   print(
      //                       'Image Path: ${image.path} -- MimeType: ${image.mimeType}');
      //                   setState(() {
      //                     _image = image
      //                         .path; // Update _image with selected image path
      //                   });
      //                   APIs.updateProfilePicture(File(_image!));
      //                   Navigator.pop(context);
      //                 }
      //               },
      //               child: Row(
      //                 children: [
      //                   SizedBox(
      //                     width: 7,
      //                   ),
      //                   Icon(
      //                     Icons.add_a_photo,
      //                     color: Colors.white70, // Icon color
      //                     size: 22.0, // Icon size
      //                   ),
      //                   SizedBox(width: 15.0),
      //                   Text(
      //                     'Set Profile Picture',
      //                     style: TextStyle(
      //                       color: Colors.white70, // Text color
      //                       fontSize: 16.0, // Text size
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //           PopupMenuItem(
      //             child: InkWell(
      //               onTap: () {
      //                  Navigator.pop(context);
      //                 Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (context) => EditProfile(
      //                               user: APIs.me,
      //                             )));

      //               },
      //               child: Row(
      //                 children: [
      //                   SizedBox(
      //                     width: 7,
      //                   ),

      //                   Icon(
      //                     Icons.edit,
      //                     color: Colors.white70, // Icon color
      //                     size: 22.0, // Icon size
      //                   ),
      //                   SizedBox(
      //                       width:
      //                           15.0), // Add spacing between icon and text
      //                   Text(
      //                     'Edit Profile',
      //                     style: TextStyle(
      //                       color: Colors.white70, // Text color
      //                       fontSize: 16.0, // Text size
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //           PopupMenuItem(
      //             child: InkWell(
      //               onTap: () {
      //                 // _logoutAndShowDialog(context);
      //                  _LogoutDialog();
      //                 deleteDB();
      //               },
      //               child: Row(
      //                 children: [
      //                   SizedBox(
      //                     width: 7,
      //                   ),
      //                   Icon(
      //                     Icons.exit_to_app,
      //                     color: Colors.white70, // Icon color
      //                     size: 22.0, // Icon size
      //                   ),
      //                   SizedBox(
      //                       width:
      //                           15.0), // Add spacing between icon and text
      //                   Text(
      //                     'Logout',
      //                     style: TextStyle(
      //                       color: Colors.white70, // Text color
      //                       fontSize: 16.0, // Text size
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ],
      //     offset: Offset(0, 60),
      //     child: Padding(
      //       padding: const EdgeInsets.only(right: 10),
      //       child: Icon(Icons.more_vert, color: Colors.white),
      //     ))
      // ]),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              _image != null
                  ?

                  //local image
                  Container(
                      width: 500,
                      child: Image.file(
                        File(_image!),
                        width: 155,
                        height: 290,
                        fit: BoxFit.cover,
                      ),
                    )
                  :

                  // server image
                  Container(
                      width: 500,
                      child: CachedNetworkImage(
                        width: 155,
                        height: 345,
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
              Padding(
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
                        height: 20,
                      ),
                      Text(
                        widget.user.email,
                        style: TextStyle(
                          fontSize: 15,
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
                          fontSize: 12,
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
                            fontSize: 16,
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
                          fontSize: 12,
                          letterSpacing: 1,
                          color: Colors.white70,
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 0.3,
                      ),
                      SizedBox(
                        height: 120,
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'FLASH',
                              style: TextStyle(
                                  color: Colors.white24,
                                  letterSpacing: 5,
                                  fontSize: 15),
                            ),
                            Text(
                              'Version 1.0',
                              style: TextStyle(
                                  color: Colors.white12, fontSize: 9.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 321, //l
          left: 327,
          child: GestureDetector(
            onTap: () {
              _showBottomSheet();
            },
            child: Material(
              color: Colors.transparent,
              // shape: CircleBorder(),
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  // color: Colors.blue[400],
                  color: Color.fromARGB(255, 107, 107, 107),
                ),
                child: Center(
                  child: Icon(
                    Icons.add_a_photo,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
            top: 457,
            left: 328,
            child: IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white54,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfile(
                              user: APIs.me,
                            )));
              },
            )),
            Positioned(
            top: 20,
            left: 0,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        Positioned(
            top: 285,
            right: 0,
            left: 20,
            child: Text(
              widget.user.name,
              style: TextStyle(
                fontSize: 20,
                letterSpacing: 1,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            )),
        Positioned(
            top: 312,
            right: 0,
            left: 21,
            child: Text(
              'Online',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            )),
        Positioned(
            top: 30,
            left: 350,
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
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);

                            if (image != null) {
                              print(
                                  'Image Path: ${image.path} -- MimeType: ${image.mimeType}');
                              setState(() {
                                _image = image
                                    .path; // Update _image with selected image path
                              });
                              APIs.updateProfilePicture(File(_image!));
                              Navigator.pop(context);
                            }
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 7,
                              ),
                              Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.white70, // Icon color
                                size: 22.0, // Icon size
                              ),
                              SizedBox(width: 15.0),
                              Text(
                                'Set Profile Picture',
                                style: TextStyle(
                                  color: Colors.white, // Text color
                                  fontSize: 16.0, // Text size
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile(
                                          user: APIs.me,
                                        )));
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 7,
                              ),

                              Icon(
                                Icons.mode_edit_outline,
                                color: Colors.white70, // Icon color
                                size: 22.0, // Icon size
                              ),
                              SizedBox(
                                  width:
                                      15.0), // Add spacing between icon and text
                              Text(
                                'Edit Profile',
                                style: TextStyle(
                                  color: Colors.white, // Text color
                                  fontSize: 16.0, // Text size
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        child: InkWell(
                          onTap: () {
                            // _logoutAndShowDialog(context);
                            _LogoutDialog();
                            deleteDB();
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 7,
                              ),
                              Icon(
                                Icons.exit_to_app,
                                color: Colors.white70, // Icon color
                                size: 22.0, // Icon size
                              ),
                              SizedBox(
                                  width:
                                      15.0), // Add spacing between icon and text
                              Text(
                                'Logout',
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
                )))
      ]),
      backgroundColor: Color.fromARGB(255, 31, 30, 30),
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
                // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen(),), (route) => false);
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
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
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      behavior: SnackBarBehavior.fixed,
    ));
  }

  void _showBottomSheet() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'Pick Profile Picture',
                style: TextStyle(
                    color: Colors.white70, fontSize: 15, letterSpacing: 2),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  child: ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);

                      if (image != null) {
                        print(
                            'Image Path: ${image.path} -- MimeType: ${image.mimeType}');
                        setState(() {
                          _image = image
                              .path; // Update _image with selected image path
                        });
                        APIs.updateProfilePicture(File(_image!));
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Image.asset(
                      'asset/img.jpg',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: 120,
                  height: 120,
                  child: ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);

                      if (image != null) {
                        print('Image Path: ${image.path}');
                        setState(() {
                          _image = image
                              .path; // Update _image with selected image path
                        });

                        APIs.updateProfilePicture(File(_image!));
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Image.asset(
                      'asset/cam3.jpg',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
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
                    'asset/logoutWarnig.png',
                    width: 100,
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
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      logOut(context);

                      _showSnackBar(context, 'Logout Successfully.',
                          Colors.black); //  logout method
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          // shape: BoxShape.circle,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      width: 200,
                      height: 50,
                      child: Center(
                          child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
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
