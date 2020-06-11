import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mstroy/MSColors.dart';

class RegisterOfRequests extends StatefulWidget {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;

  RegisterOfRequests({this.projectName, this.buttonName, this.graphQLtoken});

  @override
  State<StatefulWidget> createState() => _RegisterOfRequestsState(
      projectName: projectName, buttonName: buttonName);
}

class _RegisterOfRequestsState extends State<RegisterOfRequests> {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;
  var s = 12;

  _RegisterOfRequestsState(
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
            title: new Text("Реестр заявок"),
            bottom: new TabBar(
              indicatorColor: white,
              tabs: <Tab>[
                new Tab(
                  text: "НЕ ЗАКРЫТЫЕ",
                ),
                new Tab(
                  text: "ЗАКРЫТЫЕ",
                ),
                new Tab(
                  text: "ВСЕ",
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
                                  return card("$index Не закрытые", "$index");
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
                                  return card("$index Закрытые", "$index");
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
