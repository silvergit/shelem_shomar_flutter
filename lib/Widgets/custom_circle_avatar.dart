import 'dart:io';

import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String avatar;
  final double radius;
  final double iconSize;
  final Color circleColor;

  CustomCircleAvatar(
    this.avatar, {
    this.radius = 35.0,
    this.iconSize = 50.0,
    this.circleColor = Colors.grey,
  });

  Widget avatarWidget() {
    if (avatar == null) {
      return IconButton(
        icon: Icon(Icons.person),
        onPressed: null,
        iconSize: iconSize,
        color: Colors.white,
      );
    } else {
      return Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          image: new DecorationImage(
            fit: BoxFit.cover,
            alignment: FractionalOffset.topCenter,
            image: FileImage(File(avatar)),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: circleColor, radius: radius, child: avatarWidget());
  }
}
