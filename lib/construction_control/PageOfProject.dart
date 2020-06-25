import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mstroy/construction_control/incidents/CastIncidentFilter.dart';
import 'package:mstroy/construction_control/inspections/CastInspectionFilter.dart';
import 'package:mstroy/construction_control/inspections/inspections/CreateInspection.dart';
import 'package:mstroy/construction_control/incidents/CreateIncident.dart';
import 'package:mstroy/mainclasses/constants/GraphQLQueries.dart';
import 'package:mstroy/mainclasses/constants/MSColors.dart';
import 'package:mstroy/mainclasses/constants/urls.dart';

class PageOfProject extends StatefulWidget {
  final String projectName;
  final String shortName;
  final String graphQLtoken;
  final String rowIdOfProject;
  final String idOfProject;

  PageOfProject(
      {this.projectName,
      this.shortName,
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
          shortName: shortName,
          graphQLtoken: graphQLtoken,
          rowIdOfProject: rowIdOfProject,
          idOfProject: idOfProject);
    }
  }
}

final AuthLink authLink = AuthLink(
  getToken: () async => graphQLtoken.toString(),
);

final HttpLink httpLink = HttpLink(
  uri: graphQLUrl,
);
ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    cache: InMemoryCache(),
    link: link,
  ),
);
final Link link = authLink.concat(httpLink);
double devicePR = 0.0;

class _PageOfProjectState extends State<PageOfProject> {
  final String projectName;
  final String shortName;
  final String graphQLtoken;
  int _allIncidentsCount = 0;
  int _incidentsOnTheCheckCount = 0;
  int _registerOfRequestsCount = 0;
  int _registerOfInspectionsCount = 0;
  final String rowIdOfProject;
  final String idOfProject;

  _PageOfProjectState(
      {this.projectName,
      this.shortName,
      this.graphQLtoken,
      this.rowIdOfProject,
      this.idOfProject});

  @override
  void initState() {
    super.initState();
  }

  var redOpacity = const Color(0x591890FF);

  var textColor = newDarkBlue;
  var trailingBackColor = trailingBackgroundColor;
  var createButtonColor = newMstroyBlue;
  var listTileColor = newBackgroundWhite2;
  var trailingBorderRadius = BorderRadius.all(Radius.circular(50));
  var leadingBorderRadius = BorderRadius.only(
      bottomLeft: Radius.circular(4), topLeft: Radius.circular(4));
  var buttonBodrerRadius = BorderRadius.only(
      bottomRight: Radius.circular(4), topRight: Radius.circular(4));

  var buttonFontWeight = FontWeight.w200;
  var buttonFontWeight2 = FontWeight.w300;

  @override
  Widget build(BuildContext context) {
    devicePR = MediaQuery.of(context).devicePixelRatio;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var textSize = 14.toDouble() * devicePR / 2;
    var leadingWidth = 6.toDouble() * devicePR / 2;
    var buttonFontSize = 40.toDouble() * devicePR / 2;
    var contentPadding =
        EdgeInsets.only(top: 0, left: 15, right: 10, bottom: 4 * devicePR / 2);
    var fixButtonMargin = EdgeInsets.only(
        left: 10, right: 10, top: 18, bottom: 12 * devicePR / 2);
    var fixButtonSize = 14.toDouble() * devicePR / 2.1;
    var trailingTextSize = 14.toDouble() * devicePR;
    trailingTextSize = 14.toDouble() * devicePR / 2;

    setState(() {
      devicePR = MediaQuery.of(context).devicePixelRatio;
      trailingTextSize = 14.toDouble() * devicePR / 2;
    });

    var leadingMargin = EdgeInsets.only(left: 12, bottom: 4 * devicePR / 2);

    var buttonMargin = EdgeInsets.only(top: 0, bottom: 4 * devicePR / 2);

/*
    var buttonPadding = EdgeInsets.only(top: 6 * devicePR / 2, bottom: 6 * devicePR / 2);
*/
    var buttonPadding = EdgeInsets.only(top: 0, bottom: 4 * devicePR / 2);

/*
    Fluttertoast.showToast(
        msg:
            "$devicePR \n ${devicePR * width} \n ${devicePR * height} \n $width \n $height \n ${devicePR * 17} \n ${276 * devicePR / 2}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: lightBlue,
        textColor: Colors.white,
        fontSize: 16.0);
*/

    var buttonWidth = 318.toDouble() / devicePR * 3;
    var buttonHeight = 35.toDouble() * devicePR / 2 + 2;
    var trailingWidth = 36.toDouble() * devicePR / 2;
    var trailingHeight = 23.toDouble() * devicePR / 2;
    var leadingHeight = buttonHeight;

    return GraphQLProvider(
        client: client,
        child: Scaffold(
            backgroundColor: newBackgroundWhite,
            //AppBar
            appBar: AppBar(
              elevation: 0.0,
              iconTheme: IconThemeData(color: newDarkBlue),
              title: Text(
                shortName,
                style:
                    TextStyle(color: newDarkBlue, fontSize: 14 * devicePR / 2),
              ),
              backgroundColor: newBackgroundWhite,
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
                    height: 276 * devicePR / 2,
                    width: 339 * devicePR,
                    margin: EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Container(
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Column(children: <Widget>[
                          Container(
                              height: 26 * devicePR / 2,
                              margin: EdgeInsets.only(
                                  top: 17 * devicePR / 3,
                                  bottom: 15.1 * devicePR / 3),
                              child: Text("Нарушения",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                    fontSize: 18 * devicePR / 2,
                                  ))),
                          Center(
                              child: Column(
                            children: <Widget>[
//Неустранённые

                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: leadingMargin,
                                    height: leadingHeight,
                                    width: leadingWidth,
                                    decoration: BoxDecoration(
                                        color: listTileColor,
                                        borderRadius: leadingBorderRadius),
                                  ),
                                  Container(
                                    height: buttonHeight,
                                    margin: buttonMargin,
                                    width: buttonWidth,
                                    decoration: BoxDecoration(
                                        borderRadius: buttonBodrerRadius,
                                        color: listTileColor),
                                    child: ListTile(
                                      enabled: true,
                                      onLongPress: () {},
                                      contentPadding: contentPadding,
                                      onTap: () {
                                        _onButtonPressed("Все incident");
                                      },
                                      title: Text(
                                        "Общее количество",
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: textSize,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Container(
                                        width: trailingWidth,
                                        height: trailingHeight,
                                        decoration: BoxDecoration(
                                          color: trailingBackColor,
                                          borderRadius: trailingBorderRadius,
                                        ),
                                        child: Center(
                                            child: Center(
                                                child: allNotifyNumIncidents(
                                                    "$rowIdOfProject",
                                                    trailingTextSize))),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: leadingMargin,
                                    height: leadingHeight,
                                    width: leadingWidth,
                                    decoration: BoxDecoration(
                                        color: leadingRed,
                                        borderRadius: leadingBorderRadius),
                                  ),
                                  Container(
                                    height: buttonHeight,
                                    margin: buttonMargin,
                                    width: buttonWidth,
                                    decoration: BoxDecoration(
                                        borderRadius: buttonBodrerRadius,
                                        color: listTileColor),
                                    child: ListTile(
                                      contentPadding: contentPadding,
                                      enabled: true,
                                      onLongPress: () {},
                                      onTap: () {
                                        _onButtonPressed("Просрочено");
                                      },
                                      title: Text(
                                        "Просрочено",
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: textSize,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      trailing: Container(
                                        width: trailingWidth,
                                        height: trailingHeight,
                                        decoration: BoxDecoration(
                                          color: trailingBackColor,
                                          borderRadius: trailingBorderRadius,
                                        ),
                                        child: Center(
                                            child: Center(
                                                child: Text(
                                          "0",
                                          style: TextStyle(
                                              color: white,
                                              fontSize: trailingTextSize),
                                        ))),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: leadingMargin,
                                    height: leadingHeight,
                                    width: leadingWidth,
                                    decoration: BoxDecoration(
                                        color: leadingYellow,
                                        borderRadius: leadingBorderRadius),
                                  ),
                                  Container(
                                    height: buttonHeight,
                                    margin: buttonMargin,
                                    decoration: BoxDecoration(
                                        borderRadius: buttonBodrerRadius,
                                        color: listTileColor),
                                    width: buttonWidth,
                                    child: ListTile(
                                      onLongPress: () {},
                                      contentPadding: contentPadding,
                                      onTap: () {
                                        _onButtonPressed("Неустранённые");
                                      },
                                      title: Text(
                                        "Неустранённые",
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: textSize,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      trailing: Container(
                                        width: trailingWidth,
                                        height: trailingHeight,
                                        decoration: BoxDecoration(
                                          color: trailingBackColor,
                                          borderRadius: trailingBorderRadius,
                                        ),
                                        child: Center(
                                            child: Center(
                                                child: Text(
                                          "0",
                                          style: TextStyle(
                                              color: white,
                                              fontSize: trailingTextSize),
                                        ))),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: leadingMargin,
                                    width: leadingWidth,
                                    height: leadingHeight,
                                    decoration: BoxDecoration(
                                        color: leadingBlue,
                                        borderRadius: leadingBorderRadius),
                                  ),
                                  Container(
                                    height: buttonHeight,
                                    margin: buttonMargin,
                                    width: buttonWidth,
                                    decoration: BoxDecoration(
                                        borderRadius: buttonBodrerRadius,
                                        color: listTileColor),
                                    child: ListTile(
                                      onLongPress: () {},
                                      contentPadding: contentPadding,
                                      onTap: () {
                                        _onButtonPressed(
                                            "На проверке incident");
                                      },
                                      title: Text(
                                        "На проверке",
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: textSize,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      trailing: Container(
                                        width: trailingWidth,
                                        height: trailingHeight,
                                        decoration: BoxDecoration(
                                          color: trailingBackColor,
                                          borderRadius: trailingBorderRadius,
                                        ),
                                        child: Center(
                                            child: Center(
                                                child: Text(
                                          "0",
                                          style: TextStyle(
                                              color: white,
                                              fontSize: trailingTextSize),
                                        ))),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

//На проверке

//Просрочено

//Зафиксировать нарушение
                              Container(
                                  height: buttonHeight,
                                  margin: fixButtonMargin,
                                  width: MediaQuery.of(context).size.width,
                                  child: MaterialButton(
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7)),
                                      ),
                                      onPressed: () {
                                        _onButtonPressed(
                                            "Зафиксировать нарушение");
                                      },
                                      textColor: white,
                                      color: newMstroyBlue,
                                      child: Container(
                                        padding: buttonPadding,
                                        child: Text(
                                          "Зафиксировать нарушение",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: fixButtonSize),
                                        ),
                                      ))),
                            ],
                          ))
                        ]))),

                Container(
                    height: 276 * devicePR / 2,
                    width: 339 * devicePR,
                    margin: EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Container(
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Column(children: <Widget>[
                          Container(
                              height: 26 * devicePR / 2,
                              margin: EdgeInsets.only(
                                  top: 17 * devicePR / 3,
                                  bottom: 15.1 * devicePR / 3),
                              child: Text("Инспекции",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                    fontSize: 18 * devicePR / 2,
                                  ))),
                          Center(
                              child: Column(
                            children: <Widget>[
                              //Все

                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: leadingMargin,
                                    width: leadingWidth,
                                    height: leadingHeight,
                                    decoration: BoxDecoration(
                                        color: listTileColor,
                                        borderRadius: leadingBorderRadius),
                                  ),
                                  Container(
                                    height: buttonHeight,
                                    margin: buttonMargin,
                                    width: buttonWidth,
                                    decoration: BoxDecoration(
                                        borderRadius: buttonBodrerRadius,
                                        color: listTileColor),
                                    child: ListTile(
                                      onLongPress: () {},
                                      contentPadding: contentPadding,
                                      onTap: () {
                                        _onButtonPressed("Все inspection");
                                      },
                                      title: Text(
                                        "Общее количество",
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: textSize,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Container(
                                        width: trailingWidth,
                                        height: trailingHeight,
                                        decoration: BoxDecoration(
                                          color: trailingBackColor,
                                          borderRadius: trailingBorderRadius,
                                        ),
                                        child: Center(
                                            child: Center(
                                          child: allNotifyNumInspections(
                                              rowIdOfProject, trailingTextSize),
                                        )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
//Непринятые

                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: leadingMargin,
                                    width: leadingWidth,
                                    height: leadingHeight,
                                    decoration: BoxDecoration(
                                        color: leadingYellow,
                                        borderRadius: leadingBorderRadius),
                                  ),
                                  Container(
                                    height: buttonHeight,
                                    margin: buttonMargin,
                                    width: buttonWidth,
                                    decoration: BoxDecoration(
                                        borderRadius: buttonBodrerRadius,
                                        color: listTileColor),
                                    child: ListTile(
                                      onLongPress: () {},
                                      contentPadding: contentPadding,
                                      onTap: () {
                                        _onButtonPressed("Заявки");
                                      },
                                      title: Text(
                                        "Новые заявки",
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: textSize,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      trailing: Container(
                                        width: trailingWidth,
                                        height: trailingHeight,
                                        decoration: BoxDecoration(
                                          color: trailingBackColor,
                                          borderRadius: trailingBorderRadius,
                                        ),
                                        child: Center(
                                            child: Center(
                                                child: Text(
                                          "0",
                                          style: TextStyle(
                                              color: white,
                                              fontSize: trailingTextSize),
                                        ))),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: leadingMargin,
                                    width: leadingWidth,
                                    height: leadingHeight,
                                    decoration: BoxDecoration(
                                        color: leadingRed,
                                        borderRadius: leadingBorderRadius),
                                  ),
                                  Container(
                                    height: buttonHeight,
                                    margin: buttonMargin,
                                    width: buttonWidth,
                                    decoration: BoxDecoration(
                                        borderRadius: buttonBodrerRadius,
                                        color: listTileColor),
                                    child: ListTile(
                                      onLongPress: () {},
                                      contentPadding: contentPadding,
                                      onTap: () {
                                        _onButtonPressed("Непринятые");
                                      },
                                      title: Text(
                                        "Непринятые",
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: textSize,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      trailing: Container(
                                        width: trailingWidth,
                                        height: trailingHeight,
                                        decoration: BoxDecoration(
                                          color: trailingBackColor,
                                          borderRadius: trailingBorderRadius,
                                        ),
                                        child: Center(
                                            child: Center(
                                                child: Text(
                                          "0",
                                          style: TextStyle(
                                              color: white,
                                              fontSize: trailingTextSize),
                                        ))),
                                      ),
                                    ),
                                  ), //Неустранённые
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: leadingMargin,
                                    width: leadingWidth,
                                    height: leadingHeight,
                                    decoration: BoxDecoration(
                                        color: leadingBlue,
                                        borderRadius: leadingBorderRadius),
                                  ),
                                  Container(
                                    height: buttonHeight,
                                    margin: buttonMargin,
                                    width: buttonWidth,
                                    decoration: BoxDecoration(
                                        borderRadius: buttonBodrerRadius,
                                        color: listTileColor),
                                    child: ListTile(
                                      onLongPress: () {},
                                      contentPadding: contentPadding,
                                      onTap: () {
                                        _onButtonPressed(
                                            "На проверке inspection");
                                      },
                                      title: Text(
                                        "На проверке",
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: textSize,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      trailing: Container(
                                        width: trailingWidth,
                                        height: trailingHeight,
                                        decoration: BoxDecoration(
                                          color: trailingBackColor,
                                          borderRadius: trailingBorderRadius,
                                        ),
                                        child: Center(
                                            child: Center(
                                                child: Text(
                                          "0",
                                          style: TextStyle(
                                              color: white,
                                              fontSize: trailingTextSize),
                                        ))),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

//На проверке
//Заявки

//Создать инспекцию
                              Container(
                                  height: buttonHeight,
                                  margin: fixButtonMargin,
                                  width: MediaQuery.of(context).size.width,
                                  child: MaterialButton(
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7)),
                                      ),
                                      onPressed: () {
                                        _onButtonPressed("Создать инспекцию");
                                      },
                                      textColor: white,
                                      color: newMstroyBlue,
                                      child: Container(
                                        padding: buttonPadding,
                                        child: Text(
                                          "Создать заявку на инспекцию",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: fixButtonSize),
                                        ),
                                      ))),
                            ],
                          ))
                        ]))),
              ],
            )))));
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

  Widget allNotifyNumIncidents(String rowIdOfProject, double trailingTextSize) {
    try {
      return Query(
        options: QueryOptions(
          documentNode: gql(
              GraphQLQueries().incidentNotifyFromIdOfProject(rowIdOfProject)),
          pollInterval: 1000,
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            print(result.exception);
            return Text(
              "?1",
              style: TextStyle(color: white, fontSize: trailingTextSize),
              maxLines: 1,
            );
          }

          if (result.loading) {
            return loadIndicator();
          }
          List allIncidentsJson = result.data['allIncidents'];

          try {
            var notifyLength = allIncidentsJson.length;
            return Text(
              "$notifyLength",
              style: TextStyle(color: white, fontSize: trailingTextSize),
              maxLines: 1,
            );
          } catch (e) {
            print(e.toString());
            return Text(
              "?2",
              style: TextStyle(color: white, fontSize: trailingTextSize),
              maxLines: 1,
            );
          }
        },
      );
    } catch (e) {
      print(e.toString());
      return Text(
        "?3",
        style: TextStyle(color: white, fontSize: trailingTextSize),
        maxLines: 1,
      );
    }
  }

  Widget allNotifyNumInspections(
      String rowIdOfProject, double trailingTextSize) {
    try {
      return Query(
        options: QueryOptions(
          documentNode: gql(
              GraphQLQueries().inspectionNotifyFromIdOfProject(rowIdOfProject)),
          pollInterval: 1000,
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            print(result.exception);
            return Text(
              "0",
              style: TextStyle(color: white, fontSize: trailingTextSize),
              maxLines: 1,
            );
          }

          if (result.loading) {
            return loadIndicator();
          }
          List allInspectionsJson = result.data['allInspections'];
          List allInspectionRequestJson = result.data['allInspectionRequests'];

          try {
            var notifyLength =
                allInspectionsJson.length + allInspectionRequestJson.length;
            return Text(
              "$notifyLength",
              style: TextStyle(color: white, fontSize: trailingTextSize),
              maxLines: 1,
            );
          } catch (e) {
            print(e.toString());
            return Text(
              "0",
              style: TextStyle(color: white, fontSize: trailingTextSize),
              maxLines: 1,
            );
          }
        },
      );
    } catch (e) {
      print(e.toString());
      return Text(
        "0",
        style: TextStyle(color: white, fontSize: trailingTextSize),
        maxLines: 1,
      );
    }
  }

  Widget loadIndicator() {
    return Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: true,
        child: Container(
            width: 20,
            height: 20,
            margin: EdgeInsets.only(top: 5, bottom: 5),
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(white),
            )));
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
