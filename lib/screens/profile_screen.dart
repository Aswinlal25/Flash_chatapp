import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/auth/Methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../apis/api.dart';



class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formkey = GlobalKey<FormState>();
  String? _image;
  String? netImage; // Initialize with an empty string

  @override
  void initState() {
    super.initState();
    print('dddddddddddddddddddd${widget.user.image}');
    // Initialize _image with the user's current profile picture URL
    netImage = widget.user.image;
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 3,
        title: Text(
          'Profile',
          style: TextStyle(
              color: Colors.white70, fontSize: 19, fontWeight: FontWeight.w500,letterSpacing: 4),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(height: 28),
              // Circular Avatar
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _image != null
                        ?

                        //local image
                         CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.transparent,
                            child: 
                            ClipOval(
                           
                                child: Image.file(
                                  File(_image!),
                              width: 140,
                              height: 140,
                              fit: BoxFit.cover,
                              
                             )
                            ),
                          )
                        :
                        
                        // server image
                        CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                             child:   CachedNetworkImage(
                              width: 140,
                              height: 140,
                              fit: BoxFit.cover,
                              imageUrl: netImage!,
                              errorWidget: (context, url, error) {
                                print('Error loading image: $error');
                                return const Icon(
                                  CupertinoIcons.person,
                                  size: 140,
                                );
                              },
                            )
                            ),
                          ),
                         Positioned(
                            bottom: 0,
                            right: 0,
                            left: 110,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: RawMaterialButton(
                                onPressed: () {
                                  // Handle edit button tap
                                  // You can open an image picker or any other action here
                                  _showBottomSheet();
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                shape: CircleBorder(),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Text(
                widget.user.email,
                style: TextStyle(
                  fontSize: 13,
                  letterSpacing: 1,
                  color: Colors.white70,
                ),
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(height: 70),
                    // Circular Text Fields
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                        width: 330,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          initialValue: widget.user.name,
                          onSaved: (val) => APIs.me.name = val ?? '',
                          validator: (val) => val != null && val.isNotEmpty
                              ? null
                              : 'Required Field',
                          decoration: InputDecoration(
                            hintText: 'Username',
                            hintStyle: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 15,
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                        width: 330,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          initialValue: widget.user.about,
                          onSaved: (val) => APIs.me.about = val ?? '',
                          validator: (val) => val != null && val.isNotEmpty
                              ? null
                              : 'Required Field',
                          decoration: InputDecoration(
                            hintText: 'About',
                            hintStyle: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 15,
                            ),
                            prefixIcon: Icon(
                              Icons.info,
                              color: Colors.black,
                              size: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white54,
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 55),
              Padding(
                padding: const EdgeInsets.only(left: 37),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                          APIs.updateUserInfo();
                          
                          _showSnackBar(
                              context, 'Update successfully.', Colors.black);
                        }
                      },
                      icon: Icon(Icons.upload),
                      label: Text(
                        'Update',
                        style: TextStyle(fontSize: 15, letterSpacing: 0.5),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onPrimary: Colors.white,
                        minimumSize: Size(135, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    Container(
                      width: 20,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _logoutAndShowDialog(context);
                      },
                      icon: Icon(
                        Icons.logout,
                      ),
                      label: Text(
                        'Logout',
                        style: TextStyle(fontSize: 15, letterSpacing: 0.5),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onPrimary: Colors.white,
                        minimumSize: Size(135, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 110,
              ),
              // Text(
              //   'Version 1.0',
              //   style: TextStyle(color: Colors.white60),
              // )
              // Image.asset('asset/profilepagelogo.png',
              //   width: 90,
              //   height: 90,
              //   ),
              //   SizedBox(height: 5,),
                Text(
              'FLASH',
              style: TextStyle(
                  color: Colors.white38, letterSpacing: 5 , fontSize: 15),
            ),
             Text(
                  'Version 1.0',
                  style: TextStyle(color: Colors.white24,fontSize: 9.5),
                )
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 31, 30, 30),
    );
  }

  void _logoutAndShowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
         // backgroundColor: Color.fromARGB(255, 43, 42, 42),
         backgroundColor:  Color.fromARGB(255, 31, 30, 30),
          title: Text(
            'Logout',
            style: TextStyle(color: Colors.white, letterSpacing: 0.9),
          ),
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
                _showSnackBar(context, 'Logout Successfully.', Colors.black);
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
                style: TextStyle(color: Colors.white70, fontSize: 15,letterSpacing: 2),
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
                    onPressed: ()  async{

                       final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);

                      if (image != null) {
                        print(
                            'Image Path: ${image.path}');
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
}



