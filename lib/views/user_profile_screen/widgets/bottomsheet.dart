// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePictureBottomSheet extends StatelessWidget {
   String? image;
  final Function(File) onUpdateProfilePicture;

  ProfilePictureBottomSheet({
    required this.onUpdateProfilePicture,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 31, 30, 30),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
      ),
     // color: Color.fromARGB(255, 31, 30, 30),
      child: ListView(
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
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildGalleryOption(context),
          SizedBox(height: 11),
          _buildCameraOption(context),
          SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _buildGalleryOption(BuildContext context) {
    return InkWell(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);

        if (image != null) {
          print('Image Path: ${image.path} -- MimeType: ${image.mimeType}');
          onUpdateProfilePicture(File(image.path));
          Navigator.pop(context);
        }
      },
      child: _buildOptionRow(
        icon: CupertinoIcons.photo_fill,
        label: 'Choose from Gallery',
      ),
    );
  }

  Widget _buildCameraOption(BuildContext context) {
    return InkWell(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.camera);

        if (image != null) {
          print('Image Path: ${image.path}');
          onUpdateProfilePicture(File(image.path));
          Navigator.pop(context);
        }
      },
      child: _buildOptionRow(
        icon: CupertinoIcons.photo_camera_solid,
        label: 'Take Photos',
      ),
    );
  }

  Widget _buildOptionRow({required IconData icon, required String label}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 20),
        Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Color.fromARGB(255, 107, 107, 107),
          ),
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
        SizedBox(width: 15),
        Text(
          label,
          style: TextStyle(color: Colors.white, letterSpacing: 0.8),
        ),
        SizedBox(),
      ],
    );
  }
}
