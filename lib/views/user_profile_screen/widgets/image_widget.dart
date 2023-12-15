

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/views/user_profile_screen/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../home_screen/widgets/profile_picture_view.dart';

class ImagePart extends StatelessWidget {
  const ImagePart({
    super.key,
    required String? image,
    required this.widget,
    required this.netImage,
  }) : _image = image;

  final String? _image;
  final ProfileScreen widget;
  final String? netImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _image != null ?
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
      ],
    );
  }
}


