import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mstroy/mainclasses/constants/MSColors.dart';

class FixIncident extends StatefulWidget {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;

  FixIncident({this.projectName, this.buttonName, this.graphQLtoken});

  @override
  State<StatefulWidget> createState() => _FixIncidentState(
      projectName: projectName,
      buttonName: buttonName,
      graphQLtoken: graphQLtoken);
}

class _FixIncidentState extends State<FixIncident> {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;
  TabController _tabController;

  _FixIncidentState({this.projectName, this.buttonName, this.graphQLtoken});

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

  Widget card(String text, String trailingText) => Container(
      height: 100,
      child: Card(
          child: MaterialButton(
              onPressed: () {},
              child: ListTile(
                title: Text(
                  text,
                  style: TextStyle(fontSize: 16),
                ),
              ))));
}
