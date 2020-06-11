import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mstroy/MSColors.dart';

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
                                      return card("$index В работе", "$index");
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
                  SingleChildScrollView(
                      child: Container(
                          height: MediaQuery.of(context).size.height - 135,
                          child: CustomScrollView(
                            shrinkWrap: true,
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      return card("$index Черновики", "$index");
                                    }, childCount: s),
                              )
                            ],
                          ))),
                ],
                controller: _tabController,
              ))),
    );
  }

  Widget card(String text, String trailingText) => Container(
      height: 100,
      child: Card(
        child: MaterialButton(
          onPressed: (){},
            child: ListTile(
          title:
          Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
          )
      )));
}
