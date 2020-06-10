import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mstroy/MSColors.dart';

class NextStage extends StatefulWidget {
  final String projectName;

  NextStage({this.projectName});

  @override
  State<StatefulWidget> createState() =>
      _NextStageState(projectName: projectName);
}

class _NextStageState extends State<NextStage> {
  final String projectName;

  _NextStageState({this.projectName});

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
        body: SafeArea(
            child: Text(projectName)));
  }
}
