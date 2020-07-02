import 'dart:async';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mstroy/mainclasses/constants/OftenAppBar.dart';
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
      bottomLeft: Radius.circular(4 * devicePR / 2),
      topLeft: Radius.circular(4 * devicePR / 2));
  var buttonBodrerRadius = BorderRadius.only(
      bottomRight: Radius.circular(4 * devicePR / 2),
      topRight: Radius.circular(4 * devicePR / 2));

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
    var buttonPadding =
        EdgeInsets.only(top: 4 * devicePR / 2, bottom: 4 * devicePR / 2);

    var buttonWidth = 318.toDouble() / devicePR * 3;
    var buttonHeight = 35.toDouble() * devicePR / 2 + 2;
    var trailingWidth = 36.toDouble() * devicePR / 2;
    var trailingHeight = 23.toDouble() * devicePR / 2;
    var leadingHeight = buttonHeight;

    Widget buttonRow(leadingColor, buttonPressedText, buttonText, fontWeight,
        notifyWidget, trailingBackgroundColor) {
      return Row(
        children: <Widget>[
          Container(
            margin: leadingMargin,
            height: leadingHeight,
            width: leadingWidth,
            decoration: BoxDecoration(
                color: leadingColor, borderRadius: leadingBorderRadius),
          ),
          Container(
              height: buttonHeight,
              margin: buttonMargin,
              width: buttonWidth,
              decoration: BoxDecoration(
                  borderRadius: buttonBodrerRadius, color: listTileColor),
              child: Container(
                  child: Row(children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 5),
                  width: (172 + 60) * devicePR / 2,
                  child: MaterialButton(
                    onLongPress: () {},
                    onPressed: () {
                      _onButtonPressed(buttonPressedText);
                    },
                    child: Align(
                      child: Text(
                        buttonText,
                        style: TextStyle(
                            color: textColor,
                            fontSize: textSize,
                            fontWeight: fontWeight),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                Container(
                    width: trailingWidth,
                    height: trailingHeight,
                    decoration: BoxDecoration(
                      color: trailingBackgroundColor,
                      borderRadius: trailingBorderRadius,
                    ),
                    child: Center(
                      child: notifyWidget,
                    )),
              ]))),
        ],
      );
    }

    Widget buttonRowAll(leadingColor, buttonPressedText, buttonText, fontWeight,
        notifyWidget, trailingBackgroundColor) {
      return Row(
        children: <Widget>[
          Container(
            margin: leadingMargin,
            height: leadingHeight,
            width: leadingWidth,
            decoration: BoxDecoration(
                color: leadingColor, borderRadius: leadingBorderRadius),
          ),
          Container(
              height: buttonHeight,
              margin: buttonMargin,
              width: buttonWidth,
              decoration: BoxDecoration(
                  borderRadius: buttonBodrerRadius, color: listTileColor),
              child: Container(
                  child: Row(children: <Widget>[
                Container(
                  width: (172 + 60) * devicePR / 2,
                  child: MaterialButton(
                    onLongPress: () {},
                    onPressed: () {
                      _onButtonPressed(buttonPressedText);
                    },
                    child: Align(
                      child: Text(
                        buttonText,
                        style: TextStyle(
                            color: textColor,
                            fontSize: textSize,
                            fontWeight: fontWeight),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                Container(
                    width: trailingWidth,
                    height: trailingHeight,
                    decoration: BoxDecoration(
                      color: trailingBackgroundColor,
                      borderRadius: trailingBorderRadius,
                    ),
                    child: Center(
                      child: notifyWidget,
                    )),
              ]))),
        ],
      );
    }

    return GraphQLProvider(
        client: client,
        child: Scaffold(
            backgroundColor: newBackgroundWhite,
            //AppBar
            appBar: OftenAppBar().mainAppBar(shortName),

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
                        borderRadius: BorderRadius.all(
                            Radius.circular(10 * devicePR / 2))),
                    child: Container(
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.all(
                                Radius.circular(10 * devicePR / 2))),
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

                              buttonRow(
                                  listTileColor,
                                  "Просрочено",
                                  "Просрочено",
                                  FontWeight.w600,
                                  Text(
                                    "0",
                                    style: TextStyle(
                                        color: white,
                                        fontSize: trailingTextSize),
                                  ),
                                  redTrailing),

                              buttonRow(
                                  listTileColor,
                                  "Неустранённые",
                                  "Неустранённые",
                                  FontWeight.w600,
                                  Text(
                                    "0",
                                    style: TextStyle(
                                        color: white,
                                        fontSize: trailingTextSize),
                                  ),
                                  trailingBackColor),

                              buttonRow(
                                  listTileColor,
                                  "На проверке incident",
                                  "На проверке",
                                  FontWeight.w600,
                                  Text(
                                    "0",
                                    style: TextStyle(
                                        color: white,
                                        fontSize: trailingTextSize),
                                  ),
                                  trailingBackColor),
                              buttonRowAll(
                                  listTileColor,
                                  "Все incident",
                                  "Общее количество",
                                  FontWeight.bold,
                                  allNotifyNumIncidents(
                                      "$rowIdOfProject", trailingTextSize),
                                  trailingBackColor),

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
                                      color: newButtonMstroyBlue,
                                      child: Container(
                                        padding: buttonPadding,
                                        child: Text(
                                          "Зафиксировать нарушение",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
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
                        borderRadius: BorderRadius.all(
                            Radius.circular(10 * devicePR / 2))),
                    child: Container(
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.all(
                                Radius.circular(10 * devicePR / 2))),
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

                              buttonRow(
                                  listTileColor,
                                  "Непринятые",
                                  "Непринятые",
                                  FontWeight.w600,
                                  Center(
                                      child: Text(
                                    "0",
                                    style: TextStyle(
                                        color: white,
                                        fontSize: trailingTextSize),
                                  )),
                                  redTrailing),

                              buttonRow(
                                  listTileColor,
                                  "Заявки",
                                  "Новые заявки",
                                  FontWeight.w600,
                                  Center(
                                      child: Text(
                                    "0",
                                    style: TextStyle(
                                        color: white,
                                        fontSize: trailingTextSize),
                                  )),
                                  trailingBackColor),

                              buttonRow(
                                  listTileColor,
                                  "На проверке inspection",
                                  "На проверке",
                                  FontWeight.w600,
                                  Center(
                                      child: Text(
                                    "0",
                                    style: TextStyle(
                                        color: white,
                                        fontSize: trailingTextSize),
                                  )),
                                  trailingBackColor),
                              buttonRowAll(
                                  listTileColor,
                                  "Все inspection",
                                  "Общее количество",
                                  FontWeight.bold,
                                  Center(
                                    child: allNotifyNumInspections(
                                        rowIdOfProject, trailingTextSize),
                                  ),
                                  trailingBackColor),

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
                                      color: newButtonMstroyBlue,
                                      child: Container(
                                        padding: buttonPadding,
                                        child: Text(
                                          "Создать заявку на инспекцию",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
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
          selectFilter: 5,
        ));
        break;
      case "Неустранённые":
        _pushToRegister(CastIncidentFilter(
          projectName: projectName,
          rowIdOfProject: rowIdOfProject,
          idOfProject: idOfProject,
          graphQLtoken: graphQLtoken,
          buttonName: buttonName,
          selectFilter: 2,
        ));
        break;
      case "На проверке incident":
        _pushToRegister(CastIncidentFilter(
          projectName: projectName,
          rowIdOfProject: rowIdOfProject,
          idOfProject: idOfProject,
          graphQLtoken: graphQLtoken,
          buttonName: "На проверке",
          selectFilter: 4,
        ));
        break;
      case "Все incident":
        _pushToRegister(CastIncidentFilter(
          projectName: projectName,
          rowIdOfProject: rowIdOfProject,
          idOfProject: idOfProject,
          graphQLtoken: graphQLtoken,
          buttonName: "Все",
          selectFilter: 0,
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
          selectFilter: 2,
          idOfProject: idOfProject,
          rowIdOfProject: rowIdOfProject,
        ));
        break;
      case "На проверке inspection":
        _pushToRegister(CastInspectionFilter(
          projectName: projectName,
          buttonName: "На проверке",
          graphQLtoken: graphQLtoken,
          selectFilter: 4,
          idOfProject: idOfProject,
          rowIdOfProject: rowIdOfProject,
        ));
        break;
      case "Все inspection":
        _pushToRegister(CastInspectionFilter(
          projectName: projectName,
          buttonName: "Все",
          graphQLtoken: graphQLtoken,
          selectFilter: 0,
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
            print("$notifyLength");
            return Text(
              "$notifyLength",
              style: TextStyle(color: white, fontSize: trailingTextSize),
              maxLines: 1,
            );
          } catch (e) {
            print(e.toString());
            Timer(Duration(seconds: 5), () async {});
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
