import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mstroy/construction_control/incidents/CastIncidentFilter.dart';
import 'package:mstroy/construction_control/inspections/CastInspectionFilter.dart';
import 'package:mstroy/construction_control/inspections/inspections/CreateInspection.dart';
import 'package:mstroy/construction_control/incidents/CreateIncident.dart';
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

  var redOpacity = const Color(0x591890FF);

  @override
  Widget build(BuildContext context) {
    var buttonWidth = MediaQuery.of(context).size.width - 50;
    var buttonHeight = (MediaQuery.of(context).size.height / 2 - 120) / 6;

    var textColor = newDarkBlue;
    var trailingBackColor = trailingBackgroundColor;
    var createButtonColor = newMstroyBlue;
    var listTileColor = newBackgroundWhite2;

    var trailingWidth = 40.toDouble();
    var trailingHeight = 40.toDouble();

    var buttonFontSize = 40.toDouble();
    var buttonInfoFontSize = 14.toDouble();
    var buttonFontWeight = FontWeight.w200;
    var buttonFontWeight2 = FontWeight.w300;

    var buttonBodrerRadius = BorderRadius.all(Radius.circular(3));

    var contentPadding =
        EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 0);

    var buttonPadding = EdgeInsets.only(top: 0, bottom: 0);
    var buttonMargin = EdgeInsets.only(top: 2, bottom: 2);
    var fixButtonMargin =
        EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10);

    return Scaffold(
        backgroundColor: newBackgroundWhite,
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
                        color: white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Column(children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(bottom: 10, top: 20),
                          child: Text("Нарушения",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                fontSize: 20,
                              ))),
                      Center(
                          child: Column(
                        children: <Widget>[
//Неустранённые
                          Container(
                            height: buttonHeight,
                            margin: buttonMargin,
                            decoration: BoxDecoration(
                              borderRadius: buttonBodrerRadius,
                              color: listTileColor
                            ),
                            width: buttonWidth,
                            child: ListTile(
                              onLongPress: () {},
                              contentPadding: contentPadding,
                              onTap: () {
                                _onButtonPressed("Неустранённые");
                              },
                              title: Text(
                                "Неустранённые",
                                style: TextStyle(color: textColor, fontSize: 20),
                              ),
                              trailing: Container(
                                width: trailingWidth,
                                height: trailingHeight,
                                decoration: BoxDecoration(
                                  color: trailingBackColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(
                                    child: Center(
                                        child: Text(
                                  "0",
                                  style: TextStyle(color: white, fontSize: 20),
                                ))),
                              ),
                            ),
                          ),
//На проверке
                          Container(
                            height: buttonHeight,
                            margin: buttonMargin,
                            width: buttonWidth,
                            decoration: BoxDecoration(
                                borderRadius: buttonBodrerRadius,
                                color: listTileColor
                            ),
                            child: ListTile(
                              onLongPress: () {},
                              contentPadding: contentPadding,
                              onTap: () {
                                _onButtonPressed("На проверке incident");
                              },
                              title: Text(
                                "На проверке",
                                style: TextStyle(color: textColor, fontSize: 20),
                              ),
                              trailing: Container(
                                width: trailingWidth,
                                height: trailingHeight,
                                decoration: BoxDecoration(
                                  color: trailingBackColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(
                                    child: Center(
                                        child: Text(
                                  "0",
                                  style: TextStyle(color: white, fontSize: 20),
                                ))),
                              ),
                            ),
                          ),
//Просрочено
                          Container(
                            height: buttonHeight,
                            margin: buttonMargin,
                            width: buttonWidth,
                            decoration: BoxDecoration(
                                borderRadius: buttonBodrerRadius,
                                color: listTileColor
                            ),
                            child: ListTile(
                              contentPadding: contentPadding,
                              enabled: true,
                              onLongPress: () {},
                              onTap: () {
                                _onButtonPressed("Просрочено");
                              },
                              title: Text(
                                "Просрочено",
                                style: TextStyle(color: textColor, fontSize: 20),
                              ),
                              trailing: Container(
                                width: trailingWidth,
                                height: trailingHeight,
                                decoration: BoxDecoration(
                                  color: trailingBackColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(
                                    child: Center(
                                        child: Text(
                                  "0",
                                  style: TextStyle(color: white, fontSize: 20),
                                ))),
                              ),
                            ),
                          ),
//Все
                          Container(
                            height: buttonHeight,
                            margin: buttonMargin,
                            width: buttonWidth,
                            decoration: BoxDecoration(
                                borderRadius: buttonBodrerRadius,
                                color: listTileColor
                            ),
                            child: ListTile(
                              enabled: true,
                              onLongPress: () {},
                              contentPadding: contentPadding,
                              onTap: () {
                                _onButtonPressed("Все incident");
                              },
                              title: Text(
                                "Все",
                                style: TextStyle(color: textColor, fontSize: 20),
                              ),
                              trailing: Container(
                                width: trailingWidth,
                                height: trailingHeight,
                                decoration: BoxDecoration(
                                  color: trailingBackColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(
                                    child: Center(
                                        child: Text(
                                  "0",
                                  style: TextStyle(color: white, fontSize: 20),
                                ))),
                              ),
                            ),
                          ),

//Зафиксировать нарушение
                          Container(
                              height: (MediaQuery.of(context).size.height / 2 -
                                          68) /
                                      3 -
                                  60,
                              margin: fixButtonMargin,
                              width: MediaQuery.of(context).size.width,
                              child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      side: BorderSide(color: createButtonColor)),
                                  highlightColor: redOpacity,
                                  disabledTextColor: createButtonColor,
                                  hoverColor: createButtonColor,
                                  focusColor: createButtonColor,
                                  onPressed: () {
                                    _onButtonPressed("Зафиксировать нарушение");
                                  },
                                  textColor: createButtonColor,
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
                        color: white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Column(children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(bottom: 10, top: 20),
                          child: Text("Инспекции",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                fontSize: 20,
                              ))),
                      Center(
                          child: Column(
                        children: <Widget>[
//Непринятые
                          Container(
                            height: buttonHeight,
                            margin: buttonMargin,
                            width: buttonWidth,
                            decoration: BoxDecoration(
                                borderRadius: buttonBodrerRadius,
                                color: listTileColor
                            ),
                            child: ListTile(
                              onLongPress: () {},
                              contentPadding: contentPadding,
                              onTap: () {
                                _onButtonPressed("Непринятые");
                              },
                              title: Text(
                                "Непринятые",
                                style: TextStyle(color: textColor, fontSize: 20),
                              ),
                              trailing: Container(
                                width: trailingWidth,
                                height: trailingHeight,
                                decoration: BoxDecoration(
                                  color: trailingBackColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(
                                    child: Center(
                                        child: Text(
                                  "0",
                                  style: TextStyle(color: white, fontSize: 20),
                                ))),
                              ),
                            ),
                          ), //Неустранённые
//На проверке
                          Container(
                            height: buttonHeight,
                            margin: buttonMargin,
                            width: buttonWidth,
                            decoration: BoxDecoration(
                                borderRadius: buttonBodrerRadius,
                                color: listTileColor
                            ),
                            child: ListTile(
                              onLongPress: () {},
                              contentPadding: contentPadding,
                              onTap: () {
                                _onButtonPressed("На проверке inspection");
                              },
                              title: Text(
                                "На проверке",
                                style: TextStyle(color: textColor, fontSize: 20),
                              ),
                              trailing: Container(
                                width: trailingWidth,
                                height: trailingHeight,
                                decoration: BoxDecoration(
                                  color: trailingBackColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(
                                    child: Center(
                                        child: Text(
                                  "0",
                                  style: TextStyle(color: white, fontSize: 20),
                                ))),
                              ),
                            ),
                          ),
//Заявки
                          Container(
                            height: buttonHeight,
                            margin: buttonMargin,
                            width: buttonWidth,
                            decoration: BoxDecoration(
                                borderRadius: buttonBodrerRadius,
                                color: listTileColor
                            ),
                            child: ListTile(
                              onLongPress: () {},
                              contentPadding: contentPadding,
                              onTap: () {
                                _onButtonPressed("Заявки");
                              },
                              title: Text(
                                "Заявки",
                                style: TextStyle(color: textColor, fontSize: 20),
                              ),
                              trailing: Container(
                                width: trailingWidth,
                                height: trailingHeight,
                                decoration: BoxDecoration(
                                  color: trailingBackColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(
                                    child: Center(
                                        child: Text(
                                  "0",
                                  style: TextStyle(color: white, fontSize: 20),
                                ))),
                              ),
                            ),
                          ),
//Все
                          Container(
                            height: buttonHeight,
                            margin: buttonMargin,
                            width: buttonWidth,
                            decoration: BoxDecoration(
                                borderRadius: buttonBodrerRadius,
                                color: listTileColor
                            ),
                            child: ListTile(
                              onLongPress: () {},
                              contentPadding: contentPadding,
                              onTap: () {
                                _onButtonPressed("Все inspection");
                              },
                              title: Text(
                                "Все",
                                style: TextStyle(color: textColor, fontSize: 20),
                              ),
                              trailing: Container(
                                width: trailingWidth,
                                height: trailingHeight,
                                decoration: BoxDecoration(
                                  color: trailingBackColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(
                                    child: Center(
                                        child: Text(
                                  "0",
                                  style: TextStyle(color: white, fontSize: 20),
                                ))),
                              ),
                            ),
                          ),
//Создать инспекцию
                          Container(
                              height: (MediaQuery.of(context).size.height / 2 -
                                          68) /
                                      3 -
                                  60,
                              margin: fixButtonMargin,
                              width: MediaQuery.of(context).size.width,
                              child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      side: BorderSide(color: newDarkBlue)),
                                  highlightColor: redOpacity,
                                  disabledTextColor: red,
                                  hoverColor: red,
                                  focusColor: red,
                                  onPressed: () {
                                    _onButtonPressed("Создать инспекцию");
                                  },
                                  textColor: newDarkBlue,
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
        _pushToRegister(CreateIncident(
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
      case "Все incident":
        _pushToRegister(CastIncidentFilter(
          projectName: projectName,
          rowIdOfProject: rowIdOfProject,
          idOfProject: idOfProject,
          graphQLtoken: graphQLtoken,
          buttonName: "Все",
          selectFilter: 3,
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
      case "Все inspection":
        _pushToRegister(CastInspectionFilter(
          projectName: projectName,
          buttonName: "Все",
          graphQLtoken: graphQLtoken,
          selectFilter: 3,
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
