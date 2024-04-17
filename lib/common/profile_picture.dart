import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    required this.userImg,
  });

  final String userImg;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      child: ClipOval(
          child: FadeInImage.assetNetwork(
            placeholder:
                'assets/images/img_not_found.jpg',
            image: userImg,
            fit: BoxFit.cover,
            height: 50,
            width: 50,
            imageErrorBuilder:
                (context, error, stackTrace) {
              return const CircleAvatar(
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 50,
                ),
              );
            },
          ),
        ),
    );
  }
}