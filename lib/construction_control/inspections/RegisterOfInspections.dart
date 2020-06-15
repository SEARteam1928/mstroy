import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mstroy/construction_control/inspections/InspectionsEditPage.dart';
import 'package:mstroy/mainclasses/constants/MSColors.dart';

class RegisterOfInspections extends StatefulWidget {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;

  RegisterOfInspections({this.projectName, this.buttonName, this.graphQLtoken});

  @override
  State<StatefulWidget> createState() =>
      _RegisterOfInspections(projectName: projectName, buttonName: buttonName);
}

class _RegisterOfInspections extends State<RegisterOfInspections> {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;

  var s = 12;

  _RegisterOfInspections(
      {this.projectName, this.buttonName, this.graphQLtoken});

  @override
  void initState() {
    super.initState();
  }

  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: new AppBar(
              backgroundColor: mstroyLightBlue,
              title: new Text("Реестр инспекций"),
              bottom: new TabBar(
                indicatorColor: white,
                tabs: <Tab>[
                  new Tab(
                    text: "НЕ ПРИНЯТЫЕ",
                  ),
                  new Tab(
                    text: "ПРИНЯТЫЕ",
                  ),
                  new Tab(
                    text: "ЧЕРНОВИКИ",
                  ),
                ],
                controller: _tabController,
              ),
            ),
            body: Container(
              color: backgroundWhite,
              child: new TabBarView(
                children: <Widget>[
                  SingleChildScrollView(
                      child: Container(
                          height: MediaQuery.of(context).size.height - 135,
                          child: CustomScrollView(
                            shrinkWrap: true,
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  return card("Не принятые", "$index");
                                }, childCount: s),
                              )
                            ],
                          ))),
                  SingleChildScrollView(
                      child: Container(
                          height: MediaQuery.of(context).size.height - 135,
                          child: CustomScrollView(
                            shrinkWrap: true,
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  return card("Принятые", "$index");
                                }, childCount: s),
                              )
                            ],
                          ))),
                  SingleChildScrollView(
                      child: Container(
                          height: MediaQuery.of(context).size.height - 135,
                          child: CustomScrollView(
                            shrinkWrap: true,
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  return card("Черновики", "$index");
                                }, childCount: s),
                              )
                            ],
                          ))),
                ],
                controller: _tabController,
              ),
            )));
  }

  Widget card(String text, String index) => Container(
      constraints: BoxConstraints(minHeight: 100),
      child: Card(
          child: MaterialButton(
              onPressed: () {
                _startEditPage(InspectionsEditPage(
                    graphQLtoken: graphQLtoken,
                    index: "$index",
                    projectName: projectName));
              },
              child: Column(children: <Widget>[
                ListTile(
                  leading: Text(index),
                  title: Text(
                    text,
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: Text("dd.mm.yyyy", style: TextStyle(fontSize: 12)),
                )
              ]))));

  void _startEditPage(StatefulWidget statefulWidget) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => statefulWidget));
  }
}
