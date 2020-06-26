import 'package:flutter/material.dart';
import 'package:mstroy/mainclasses/constants/MSColors.dart';

class OftenAppBar {
  AppBar mainAppBar(title) {
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

  AppBar incidentAppBar(title) {
    return AppBar(
      elevation: 0.0,
      title: Text(
        title,
        style: TextStyle(color: white),
      ),
      backgroundColor: newLeadingRed,
    );
  }
}
