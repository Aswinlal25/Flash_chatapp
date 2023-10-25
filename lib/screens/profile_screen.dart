import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/hive_db/user_db.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/profile_picture_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../apis/api.dart';
import '../widgets/dialogs/logout_dialog.dart';
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

  late double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: null,
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
                        height: 345,
                        fit: BoxFit.cover,
                      ),
                    )
                  :

                  // server image
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    ProfilePictureView(user: widget.user)));
                      },
                      child: Container(
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
                        height: height * 0.02,
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
          top: height*0.38, //l
          left: width*0.83,
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
                    CupertinoIcons.photo_camera_solid,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
            top:height*0.54,
          left: width*0.83,
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
                CupertinoIcons.arrow_left,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        Positioned(
            top: 282,
            right: 0,
            left: 20,
            child: Text(
              widget.user.name,
              style: TextStyle(
                fontSize: 23,
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
         top: height*0.04,
          left: width*0.89,
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
                                'Edit Name',
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
                            showDialog(
                                context: context,
                                builder: (_) => LogoutDialog());

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
      backgroundColor: Color.fromARGB(255, 31, 30, 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: 33),
            Center(
              child: Text(
                'Change Profile Picture',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15.7,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);

                if (image != null) {
                  print(
                      'Image Path: ${image.path} -- MimeType: ${image.mimeType}');
                  setState(() {
                    _image =
                        image.path; // Update _image with selected image path
                  });
                  APIs.updateProfilePicture(File(_image!));
                  Navigator.pop(context);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      // color: Colors.blue[400],
                      color: Color.fromARGB(255, 107, 107, 107),
                    ),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.photo_fill,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Choose from Gallery',
                    style: TextStyle(color: Colors.white, letterSpacing: 0.8),
                  ),
                  SizedBox(),
                ],
              ),
            ),
            SizedBox(height: 11),
            InkWell(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.camera);

                if (image != null) {
                  print('Image Path: ${image.path}');
                  setState(() {
                    _image =
                        image.path; // Update _image with selected image path
                  });

                  APIs.updateProfilePicture(File(_image!));
                  Navigator.pop(context);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      // color: Colors.blue[400],
                      color: Color.fromARGB(255, 107, 107, 107),
                    ),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.photo_camera_solid,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Take Photos',
                    style: TextStyle(color: Colors.white, letterSpacing: 0.8),
                  ),
                  SizedBox()
                ],
              ),
            ),
            SizedBox(height: 28),
          ],
        );
      },
    );
  }
}
