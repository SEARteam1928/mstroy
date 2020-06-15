import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mstroy/construction_control/incidents/AllIncidentsEditPage.dart';
import 'package:mstroy/mainclasses/constants/MSColors.dart';

class AllIncidents extends StatefulWidget {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;

  AllIncidents({this.projectName, this.buttonName, this.graphQLtoken});

  @override
  State<StatefulWidget> createState() =>
      _AllIncidentState(projectName: projectName, buttonName: buttonName);
}

class _AllIncidentState extends State<AllIncidents> {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;
  TabController _tabController;
  var s = 12;

  _AllIncidentState({this.projectName, this.buttonName, this.graphQLtoken});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: new AppBar(
            backgroundColor: mstroyLightBlue,
            title: new Text("Все нарушения"),
            bottom: new TabBar(
              indicatorColor: white,
              tabs: <Tab>[
                new Tab(
                  text: "В РАБОТЕ",
                ),
                new Tab(
                  text: "ВСЕ",
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
                                  return card("В работе", "$index", "Type");
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
                                  return card("Все", "$index", "Type");
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
                                  return card("Черновики", "$index", "Тип");
                                }, childCount: s),
                              )
                            ],
                          ))),
                ],
                controller: _tabController,
              ))),
    );
  }

  Widget card(String text, String index, String incidentType) => Container(
      constraints: BoxConstraints(minHeight: 100),
      child: Card(
          child: MaterialButton(
              onPressed: () {
                _startEditPage(AllIncidentsEditPage(
                    graphQLtoken: graphQLtoken,
                    index: "$index",
                    projectName: projectName,
                    incidentType: incidentType));
              },
              child: Column(children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(incidentType),
                ),
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
