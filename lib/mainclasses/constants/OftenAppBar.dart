import 'package:flutter/material.dart';
import 'package:mstroy/mainclasses/constants/MSColors.dart';

class OftenAppBar {
  AppBar create(title) {
    return AppBar(
      elevation: 0.0,
      iconTheme: IconThemeData(color: newDarkBlue),
      title: Text(
        title,
        style: TextStyle(color: newDarkBlue),
      ),
      backgroundColor: newBackgroundWhite,
    );
  }
}
