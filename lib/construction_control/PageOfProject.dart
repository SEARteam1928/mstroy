import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mstroy/construction_control/incidents/CastIncidentFilter.dart';
import 'package:mstroy/construction_control/inspections/CastInspectionFilter.dart';
import 'package:mstroy/construction_control/inspections/inspections/CreateInspection.dart';
import 'package:mstroy/construction_control/incidents/FixIncident.dart';
import 'package:mstroy/mainclasses/constants/MSColors.dart';

class PageOfProject extends StatefulWidget {
  final String projectName;
  final String graphQLtoken;
  final String rowIdOfProject;
  final String idOfProject;

  PageOfProject(
      {this.projectName,
      this.graphQLtoken,
      this.rowIdOfProject,
      this.idOfProject});

//TODO: Сделать определённый State для определённой роли
  @override
  State<StatefulWidget> createState() {
    if (this.projectName == "Сделать state по роли") {
      return _PageOfProjectState2(
          projectName: "SECOND STATE", graphQLtoken: graphQLtoken);
    } else {
      return _PageOfProjectState(
          projectName: projectName,
          graphQLtoken: graphQLtoken,
          rowIdOfProject: rowIdOfProject,
          idOfProject: idOfProject);
    }
  }
}

class _PageOfProjectState extends State<PageOfProject> {
  final String projectName;
  final String graphQLtoken;
  int _allIncidentsCount = 0;
  int _incidentsOnTheCheckCount = 0;
  int _registerOfRequestsCount = 0;
  int _registerOfInspectionsCount = 0;
  final String rowIdOfProject;
  final String idOfProject;

  _PageOfProjectState(
      {this.projectName,
      this.graphQLtoken,
      this.rowIdOfProject,
      this.idOfProject});

  @override
  void initState() {
    super.initState();
  }

  var redOpacity = const Color(0x59d40069);

  @override
  Widget build(BuildContext context) {
/*
    print("${MediaQuery.of(context).size.height - 40}");
*/

    var buttonWidth = MediaQuery.of(context).size.width / 3 - 10;

    var buttonHeight = (MediaQuery.of(context).size.height / 2 - 68) / 3;

    var buttonFontSize = 40.toDouble();
    var buttonInfoFontSize = 14.toDouble();
    var buttonFontWeight = FontWeight.w200;
    var buttonFontWeight2 = FontWeight.w300;

    var buttonPadding = EdgeInsets.only(top: 4, bottom: 4);
    var buttonMargin = EdgeInsets.only(top: 10, bottom: 10);
    var fixButtonMargin =
        EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10);

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
                      Center(
                          child: Column(
                        children: <Widget>[
                          Row(children: <Widget>[
//Просрочено
                            Container(
                                height: buttonHeight,
                                margin: buttonMargin,
                                width: buttonWidth,
                                child: Column(children: <Widget>[
                                  MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                      ),
                                      onPressed: () {
                                        _onButtonPressed("Просрочено");
                                      },
                                      textColor: darkBlue,
                                      child: Container(
                                        padding: buttonPadding,
                                        child: Text(
                                          "$_allIncidentsCount",
                                          style: TextStyle(
                                              fontWeight: buttonFontWeight,
                                              fontSize: buttonFontSize),
                                        ),
                                      )),
                                  Text(
                                    "Просрочено",
                                    style:
                                        TextStyle(fontSize: buttonInfoFontSize),
                                  )
                                ])),
//Неустранённые
                            Container(
                                height: buttonHeight,
                                margin: buttonMargin,
                                width: buttonWidth,
                                child: Column(
                                  children: <Widget>[
                                    MaterialButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                        onPressed: () {
                                          _onButtonPressed("Неустранённые");
                                        },
                                        textColor: darkBlue,
                                        child: Container(
                                          padding: buttonPadding,
                                          child: Text(
                                            "$_incidentsOnTheCheckCount",
                                            style: TextStyle(
                                                fontWeight: buttonFontWeight,
                                                fontSize: buttonFontSize),
                                          ),
                                        )),
                                    Text("Неустранённые",
                                        style: TextStyle(
                                            fontSize: buttonInfoFontSize))
                                  ],
                                )),
//На проверке
                            Container(
                                height: buttonHeight,
                                margin: buttonMargin,
                                width: buttonWidth,
                                child: Column(
                                  children: <Widget>[
                                    MaterialButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                        onPressed: () {
                                          _onButtonPressed(
                                              "На проверке incident");
                                        },
                                        textColor: darkBlue,
                                        child: Container(
                                          padding: buttonPadding,
                                          child: Text(
                                            "$_incidentsOnTheCheckCount",
                                            style: TextStyle(
                                                fontWeight: buttonFontWeight,
                                                fontSize: buttonFontSize),
                                          ),
                                        )),
                                    Text("На проверке",
                                        style: TextStyle(
                                            fontSize: buttonInfoFontSize))
                                  ],
                                )),
                          ]),
//Зафиксировать нарушение
                          Container(
                              height: (MediaQuery.of(context).size.height / 2 -
                                          68) /
                                      3 -
                                  47,
                              margin: fixButtonMargin,
                              width: MediaQuery.of(context).size.width,
                              child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      side: BorderSide(color: red)),
                                  highlightColor: redOpacity,
                                  disabledTextColor: red,
                                  hoverColor: red,
                                  focusColor: red,
                                  onPressed: () {
                                    _onButtonPressed("Зафиксировать нарушение");
                                  },
                                  textColor: red,
                                  color: white,
                                  child: Container(
                                    padding: buttonPadding,
                                    child: Text(
                                      "Зафиксировать нарушение",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18),
                                    ),
                                  ))),
                        ],
                      ))
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
                      Center(
                          child: Column(
                        children: <Widget>[
                          Row(children: <Widget>[
//Просрочено
                            Container(
                                height: buttonHeight,
                                margin: buttonMargin,
                                width: buttonWidth,
                                child: Column(children: <Widget>[
                                  MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                      ),
                                      onPressed: () {
                                        _onButtonPressed("Заявки");
                                      },
                                      textColor: white,
                                      child: Container(
                                        padding: buttonPadding,
                                        child: Text(
                                          "$_registerOfRequestsCount",
                                          style: TextStyle(
                                              fontWeight: buttonFontWeight2,
                                              fontSize: buttonFontSize),
                                        ),
                                      )),
                                  Text(
                                    "Заявки",
                                    style: TextStyle(
                                        fontSize: buttonInfoFontSize,
                                        color: white),
                                  )
                                ])),
//Неустранённые
                            Container(
                                height: buttonHeight,
                                margin: buttonMargin,
                                width: buttonWidth,
                                child: Column(
                                  children: <Widget>[
                                    MaterialButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                        onPressed: () {
                                          _onButtonPressed("Непринятые");
                                        },
                                        textColor: white,
                                        child: Container(
                                          padding: buttonPadding,
                                          child: Text(
                                            "$_incidentsOnTheCheckCount",
                                            style: TextStyle(
                                                fontWeight: buttonFontWeight2,
                                                fontSize: buttonFontSize),
                                          ),
                                        )),
                                    Text("Непринятые",
                                        style: TextStyle(
                                            fontSize: buttonInfoFontSize,
                                            color: white))
                                  ],
                                )),
//На проверке
                            Container(
                                height: buttonHeight,
                                margin: buttonMargin,
                                width: buttonWidth,
                                child: Column(
                                  children: <Widget>[
                                    MaterialButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                        onPressed: () {
                                          _onButtonPressed(
                                              "На проверке inspection");
                                        },
                                        textColor: white,
                                        child: Container(
                                          padding: buttonPadding,
                                          child: Text(
                                            "$_incidentsOnTheCheckCount",
                                            style: TextStyle(
                                                fontWeight: buttonFontWeight2,
                                                fontSize: buttonFontSize),
                                          ),
                                        )),
                                    Text("На проверке",
                                        style: TextStyle(
                                            fontSize: buttonInfoFontSize,
                                            color: white))
                                  ],
                                )),
                          ]),
//Зафиксировать нарушение
                          Container(
                              height: (MediaQuery.of(context).size.height / 2 -
                                          68) /
                                      3 -
                                  47,
                              margin: fixButtonMargin,
                              width: MediaQuery.of(context).size.width,
                              child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      side: BorderSide(color: darkBlue)),
                                  highlightColor: redOpacity,
                                  disabledTextColor: red,
                                  hoverColor: red,
                                  focusColor: red,
                                  onPressed: () {
                                    _onButtonPressed("Создать инспекцию");
                                  },
                                  textColor: darkBlue,
                                  color: white,
                                  child: Container(
                                    padding: buttonPadding,
                                    child: Text(
                                      "Создать инспекцию",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18),
                                    ),
                                  ))),
                        ],
                      ))
                    ]))),
          ],
        ))));
  }

  void _onButtonPressed(String buttonName) {
    switch (buttonName) {
      case "Зафиксировать нарушение":
        _pushToRegister(FixIncident(
          projectName: projectName,
          buttonName: buttonName,
          graphQLtoken: graphQLtoken,
        ));
        break;
      case "Просрочено":
        _pushToRegister(CastIncidentFilter(
          projectName: projectName,
          rowIdOfProject: rowIdOfProject,
          idOfProject: idOfProject,
          graphQLtoken: graphQLtoken,
          buttonName: buttonName,
          selectFilter: 0,
        ));
        break;
      case "Неустранённые":
        _pushToRegister(CastIncidentFilter(
          projectName: projectName,
          rowIdOfProject: rowIdOfProject,
          idOfProject: idOfProject,
          graphQLtoken: graphQLtoken,
          buttonName: buttonName,
          selectFilter: 1,
        ));
        break;
      case "На проверке incident":
        _pushToRegister(CastIncidentFilter(
          projectName: projectName,
          rowIdOfProject: rowIdOfProject,
          idOfProject: idOfProject,
          graphQLtoken: graphQLtoken,
          buttonName: "На проверке",
          selectFilter: 2,
        ));
        break;
      case "Создать инспекцию":
        _pushToRegister(CreateInspection(
            projectName: projectName,
            buttonName: buttonName,
            graphQLtoken: graphQLtoken));
        break;
      case "Заявки":
        _pushToRegister(CastInspectionFilter(
          projectName: projectName,
          buttonName: buttonName,
          graphQLtoken: graphQLtoken,
          selectFilter: 0,
          idOfProject: idOfProject,
          rowIdOfProject: rowIdOfProject,
        ));
        break;
      case "Непринятые":
        _pushToRegister(CastInspectionFilter(
          projectName: projectName,
          buttonName: buttonName,
          graphQLtoken: graphQLtoken,
          selectFilter: 1,
          idOfProject: idOfProject,
          rowIdOfProject: rowIdOfProject,
        ));
        break;
      case "На проверке inspection":
        _pushToRegister(CastInspectionFilter(
          projectName: projectName,
          buttonName: "На проверке",
          graphQLtoken: graphQLtoken,
          selectFilter: 2,
          idOfProject: idOfProject,
          rowIdOfProject: rowIdOfProject,
        ));
        break;

      default:
        Fluttertoast.showToast(
            msg: "Что-то пошло не так...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: red,
            textColor: Colors.white,
            fontSize: 16.0);
        break;
    }
  }

  void _pushToRegister(StatefulWidget statefulWidget) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => statefulWidget));
  }
}

class _PageOfProjectState2 extends State<PageOfProject> {
  final String projectName;
  final String graphQLtoken;
  int _allIncidentsCount = 0;
  int _incidentsOnTheCheckCount = 0;
  int _registerOfRequestsCount = 0;
  int _registerOfInspectionsCount = 0;
  final String rowIdOfProject;
  final String idOfProject;

  _PageOfProjectState2(
      {this.projectName,
      this.graphQLtoken,
      this.rowIdOfProject,
      this.idOfProject});

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
            Text("text")
          ],
        ))));
  }
}
