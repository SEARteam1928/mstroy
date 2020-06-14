import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'file:///C:/Users/User/Desktop/mstroy/lib/mainclasses/constants/MSColors.dart';

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
          body:Container(
    color: backgroundWhite,
    child:  new TabBarView(
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
                                  return card("$index Не принятые", "$index");
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
                                  return card("$index Принятые", "$index");
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
          ),)
        ));
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
