import 'dart:core';
import 'package:flutter/material.dart';
import 'package:mstroy/MSColors.dart';

class PageOfProject extends StatefulWidget {
  final String projectName;
  final String graphQLtoken;

  PageOfProject({this.projectName, this.graphQLtoken});

  @override
  State<StatefulWidget> createState() =>
      _PageOfProjectState(projectName: projectName, graphQLtoken: graphQLtoken);
}

class _PageOfProjectState extends State<PageOfProject> {
  final String projectName;
  final String graphQLtoken;

  _PageOfProjectState({this.projectName, this.graphQLtoken});

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
            child: Container(
                child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 10),
          decoration: BoxDecoration(
          ),
          child: Text(graphQLtoken
            ,style: TextStyle(
              fontSize: 15,
            ),))
      ],
    ))));
  }
}
