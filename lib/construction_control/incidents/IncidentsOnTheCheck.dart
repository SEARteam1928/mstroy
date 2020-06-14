import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mstroy/mainclasses/constants/MSColors.dart';

class IncidentOnTheCheck extends StatefulWidget {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;

  IncidentOnTheCheck({this.projectName, this.buttonName, this.graphQLtoken});

  @override
  State<StatefulWidget> createState() => _IncidentOnTheCheckState(
      projectName: projectName, buttonName: buttonName);
}

class _IncidentOnTheCheckState extends State<IncidentOnTheCheck> {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;
  var s = 12;

  _IncidentOnTheCheckState(
      {this.projectName, this.buttonName, this.graphQLtoken});

  @override
  void initState() {
    super.initState();
  }

  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: new AppBar(
              backgroundColor: mstroyLightBlue,
              title: new Text("Нарушения на проверке"),
              bottom: new TabBar(
                indicatorColor: white,
                tabs: <Tab>[
                  new Tab(
                    text: "НА ПРОВЕРКУ",
                  ),
                  new Tab(
                    text: "ВСЕ",
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
                                  return card("$index на проверку", "$index");
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
                                  return card("$index Все", "$index");
                                }, childCount: s),
                              )
                            ],
                          ))),
                ],
                controller: _tabController,
              ),
            )));
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
