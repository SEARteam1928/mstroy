import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'file:///C:/Users/User/Desktop/mstroy/lib/mainclasses/constants/MSColors.dart';

class CreateInspection extends StatefulWidget {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;

  CreateInspection({this.projectName, this.buttonName, this.graphQLtoken});

  @override
  State<StatefulWidget> createState() =>
      _CreateInspectionState(projectName: projectName, buttonName: buttonName);
}

class _CreateInspectionState extends State<CreateInspection> {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;

  _CreateInspectionState(
      {this.projectName, this.buttonName, this.graphQLtoken});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(projectName),
          backgroundColor: mstroyLightBlue,
        ),
        body: SafeArea(child: Text(buttonName)));
  }
}
