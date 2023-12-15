import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../home_screen/widgets/profile_picture_view.dart';
import '../view_profile_screen.dart';

class UserImagePart extends StatelessWidget {
  const UserImagePart({
    super.key,
    required this.widget,
    required this.height,
    required this.netImage,
  });

  final ViewProfileScreen widget;
  final double height;
  final String? netImage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProfilePictureView(user: widget.user)));
      },
      child: Container(
        height: height * .48,
        child: CachedNetworkImage(
          width: 390.0,
          height: 180.0,
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
    );
  }
}