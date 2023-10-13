import 'package:flutter/material.dart';

import '../apis/api.dart';
import '../models/chat_user.dart';

class EditProfile extends StatefulWidget {
  final ChatUser user;
  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 30, 30),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Edit profile',
            style: TextStyle(
                color: Colors.white70,
                fontSize: 19,
                fontWeight: FontWeight.w400,
                letterSpacing: 3),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    _formkey.currentState!.save();
                    APIs.updateUserInfo();

                    _showSnackBar(
                        context, 'Update successfully.', Colors.black);
                  }
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                )),
          ]),
      body: Column(
        children: [
          Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(19.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  // Circular Text Fields
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 5),
                  //   child: Container(
                  //     width: 330,
                  //     height: 50,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(25),
                  //       // color: Colors.white,
                  //     ),
                  //     child: TextFormField(
                  //       initialValue: widget.user.name,
                  //       onSaved: (val) => APIs.me.name = val ?? '',
                  //       validator: (val) => val != null && val.isNotEmpty
                  //           ? null
                  //           : 'Required Field',
                  //       decoration: InputDecoration(
                  //         hintText: 'Username',
                  //         hintStyle: TextStyle(
                  //           color: Colors.black,
                  //           letterSpacing: 2,
                  //           fontSize: 15,
                  //         ),
                  //         prefixIcon: Icon(
                  //           Icons.person,
                  //           color: Colors.black,
                  //           size: 20,
                  //         ),
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(25),
                  //           borderSide: BorderSide.none,
                  //         ),
                  //         filled: true,
                  //         fillColor: Colors.white,
                  //       ),
                  //       style: TextStyle(color: Colors.black),
                  //     ),
                  //   ),
                  // ),
                  TextFormField(
                     initialValue: widget.user.name,
                        onSaved: (val) => APIs.me.name = val ?? '',
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : 'Required Field',
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Colors.white38, // Border color in normal state
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Colors.white, // Border color in focused state
                            width: 2.0,
                          ),
                        ),
                        hintText: 'Username',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2,
                          fontSize: 15,
                        ),
                        prefixIcon: Icon(
                          Icons.person_2_outlined,
                          color: Colors.white,
                          size: 20,
                        )),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 22),
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Colors.white38, // Border color in normal state
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Colors.white, // Border color in focused state
                            width: 2.0,
                          ),
                        ),
                        hintText: 'About',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2,
                          fontSize: 15,
                        ),
                        prefixIcon: Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: 20,
                        )),
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 220, top: 20),
          //   child: Row(
          //     children: [
          //       ElevatedButton.icon(
          //         onPressed: () {
          //           if (_formkey.currentState!.validate()) {
          //             _formkey.currentState!.save();
          //             APIs.updateUserInfo();

          //             _showSnackBar(
          //                 context, 'Update successfully.', Colors.black);
          //           }
          //         },
          //         icon: Icon(Icons.upload),
          //         label: Text(
          //           'Update',
          //           style: TextStyle(fontSize: 15, letterSpacing: 0.5),
          //         ),
          //         style: ElevatedButton.styleFrom(
          //           primary: Colors.transparent,
          //           onPrimary: Colors.white,
          //           minimumSize: Size(135, 50),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
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
}
