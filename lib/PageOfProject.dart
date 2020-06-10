import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mstroy/MSColors.dart';
import 'package:mstroy/NextStage.dart';

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

  var redOpacity = const Color(0x59d40069);

  @override
  Widget build(BuildContext context) {
    print("${MediaQuery.of(context).size.height - 40}");
    return Scaffold(
        backgroundColor: backgroundWhite,
        //AppBar
        appBar: AppBar(
          centerTitle: true,
          title: Text(projectName),
          backgroundColor: mstroyLightBlue,
        ),
        //Body
        body: SafeArea(
            child: Container(
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            //IncidentContainer
            Container(
                height: MediaQuery.of(context).size.height / 2 - 68,
                margin:
                    EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: greyOpacity0_5,
                      spreadRadius: 6,
                      blurRadius: 15,
                      offset: Offset(0, 5))
                ], borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Container(
                    decoration: BoxDecoration(
                        color: backgroundWhite,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Column(children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(bottom: 10, top: 20),
                          child: Text("Нарушения",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: red,
                                fontSize: 30,
                              ))),
                      ListTile(
                          title: Center(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                            Container(
                                height:
                                    (MediaQuery.of(context).size.height / 2 -
                                                68) /
                                            3 -
                                        47,
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                child: MaterialButton(
                                  onLongPress: (){},
                                    highlightColor: redOpacity,
                                    disabledTextColor: red,
                                    hoverColor: red,
                                    focusColor: red,
                                    onPressed: () {_onButtonPressed("Зафиксировать нарушение");},
                                    textColor: red,
                                    color: white,
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(top: 4, bottom: 4),
                                      child: Text(
                                        "Зафиксировать нарушение",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20),
                                      ),
                                    ))),
                            Container(
                                height:
                                    (MediaQuery.of(context).size.height / 2 -
                                                68) /
                                            3 -
                                        47,
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                child: MaterialButton(
                                    disabledTextColor: red,
                                    hoverColor: red,
                                    focusColor: red,
                                    onPressed: () {_onButtonPressed("Все нарушения");},
                                    textColor: darkBlue,
                                    color: white,
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(top: 4, bottom: 4),
                                      child: Text(
                                        "Все нарушения (неустранённых: -)",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20),
                                      ),
                                    ))),
                            Container(
                                height:
                                    (MediaQuery.of(context).size.height / 2 -
                                                68) /
                                            3 -
                                        47,
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                child: MaterialButton(
                                    disabledTextColor: red,
                                    hoverColor: red,
                                    focusColor: red,
                                    onPressed: () {_onButtonPressed("Нарушений на проверке");},
                                    textColor: darkBlue,
                                    color: white,
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(top: 4, bottom: 4),
                                      child: Text(
                                        "Нарушений на проверке(-)",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20),
                                      ),
                                    )))
                          ])))
                    ]))),
            Container(
                height: MediaQuery.of(context).size.height / 2 - 68,
                margin:
                    EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: greyOpacity0_5,
                      spreadRadius: 6,
                      blurRadius: 15,
                      offset: Offset(0, 5))
                ], borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Container(
                    decoration: BoxDecoration(
                        color: mstroyBlue,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Column(children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(bottom: 10, top: 20),
                          child: Text("Инспекции",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: white,
                                fontSize: 30,
                              ))),
                      ListTile(
                          title: Center(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                            Container(
                                height:
                                    (MediaQuery.of(context).size.height / 2 -
                                                67) /
                                            3 -
                                        47,
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                child: MaterialButton(
                                    onPressed: () {_onButtonPressed("Создать инспекцию");},
                                    textColor: darkBlue,
                                    color: white,
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(top: 4, bottom: 4),
                                      child: Text(
                                        "Создать инспекцию",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20),
                                      ),
                                    ))),
                            Container(
                                height:
                                    (MediaQuery.of(context).size.height / 2 -
                                                67) /
                                            3 -
                                        47,
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                child: MaterialButton(
                                    onPressed: () {_onButtonPressed("Реестр Заявок");},
                                    textColor: darkBlue,
                                    color: white,
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(top: 4, bottom: 4),
                                      child: Text(
                                        "Реестр Заявок (новых: -)",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20),
                                      ),
                                    ))),
                            Container(
                                height:
                                    (MediaQuery.of(context).size.height / 2 -
                                                67) /
                                            3 -
                                        47,
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                child: MaterialButton(
                                    onPressed: () {
                                      _onButtonPressed("Реестр инспекций");
                                    },
                                    textColor: darkBlue,
                                    color: white,
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(top: 4, bottom: 4),
                                      child: Text(
                                        "Реестр инспекций (непринятых: -)",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20),
                                      ),
                                    )))
                          ])))
                    ])))
          ],
        ))));
  }

  void _onButtonPressed(String buttonName){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NextStage(
          projectName: "$buttonName",
        )));
  }
}
