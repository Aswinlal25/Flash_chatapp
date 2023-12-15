

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common_widgets/dialogs/logout_dialog.dart';
import '../../../services/apis/api.dart';
import '../../../services/hive_database/hive_db/user_db.dart';
import '../../../utils/constants.dart';
import '../../edit_profile_screen/edit_profile_screen.dart';

class Components {
 static Positioned editButton(BuildContext context) {
      late double height, width;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Positioned(
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
          ));
  }

  static Positioned backArrowButton(BuildContext context) {
    return Positioned(
          top: 20,
          left: 0,
          child: IconButton(
            icon: Icon(
              CupertinoIcons.arrow_left,
              color: white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ));
  }

 static Positioned Username(String name) {
    return Positioned(
          top: 282,
          right: 0,
          left: 20,
          child: Text(
            name,
            style: TextStyle(
              fontSize: 23,
              letterSpacing: 1,
              color: white,
              fontWeight: FontWeight.w500,
            ),
          ));
  }

  static Positioned onlineTxt() {
    return Positioned(
          top: 312,
          right: 0,
          left: 21,
          child: Text(
            'Online',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1,
              color: white,
              fontWeight: FontWeight.w500,
            ),
          ));
  }

   static Positioned popMenuButton(Function(String) onProfilePictureSelected) {
    //  late double height, width;
    // height = MediaQuery.of(context).size.height;
    // width = MediaQuery.of(context).size.width;
  return Positioned(
    // top: height * 0.04,
    // left: width * 0.89,
    top: 28,
    right: 10,
    child: PopupMenuButton(
      color: primarycolor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: InkWell(
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);

              if (image != null) {
                print(
                    'Image Path: ${image.path} -- MimeType: ${image.mimeType}');
                // Use the callback to update the state in the parent widget
                onProfilePictureSelected(image.path);
                APIs.updateProfilePicture(File(image.path));
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
                  color: Colors.white70,
                  size: 22.0,
                ),
                SizedBox(width: 15.0),
                Text(
                  'Set Profile Picture',
                  style: TextStyle(
                    color: white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
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
                            color: Colors.white70,
                            size: 22.0,
                          ),
                          SizedBox(width: 15.0),
                          Text(
                            'Edit Name',
                            style: TextStyle(
                                color: white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context, builder: (_) => LogoutDialog());
                        deleteDB();
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 7,
                          ),
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.white70,
                            size: 22.0,
                          ),
                          SizedBox(width: 15.0),
                          Text(
                            'Logout',
                            style: TextStyle(
                                color: white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
            offset: Offset(0, 5),
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.more_vert, color: white),
            )));
      
    
  
}

}