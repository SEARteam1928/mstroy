import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mstroy/mainclasses/constants/OftenAppBar.dart';
import 'package:mstroy/mainclasses/constants/GraphQLQueries.dart';
import 'package:mstroy/mainclasses/constants/NormalDate.dart';
import 'package:mstroy/construction_control/ProjectList.dart';
import 'package:mstroy/construction_control/incidents/AllIncidentsEditPage.dart';
import 'package:mstroy/mainclasses/constants/MSColors.dart';
import 'package:mstroy/mainclasses/constants/urls.dart';

class CardFilterEntry {
  const CardFilterEntry(this.name);

  final String name;
}

final HttpLink httpLink = HttpLink(
  uri: graphQLUrl,
);
double devicePR = 0.0;

final AuthLink authLink = AuthLink(
  getToken: () async => graphQLtoken.toString(),
);
final Link link = authLink.concat(httpLink);
ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    cache: InMemoryCache(),
    link: link,
  ),
);

class CastIncidentFilter extends StatefulWidget {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;
  final String rowIdOfProject;
  final String idOfProject;
  final int selectFilter;

  CastIncidentFilter(
      {this.projectName,
      this.buttonName,
      this.graphQLtoken,
      this.rowIdOfProject,
      this.idOfProject,
      this.selectFilter});

  @override
  State createState() => CastIncidentFilterState(
      projectName: projectName,
      buttonName: buttonName,
      graphQLtoken: graphQLtoken,
      rowIdOfProject: rowIdOfProject,
      idOfProject: idOfProject,
      selectFilter: selectFilter);
}

class CastIncidentFilterState extends State<CastIncidentFilter> {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;
  final String rowIdOfProject;
  final String idOfProject;
  final int selectFilter;

  CastIncidentFilterState({
    this.projectName,
    this.buttonName,
    this.graphQLtoken,
    this.rowIdOfProject,
    this.idOfProject,
    this.selectFilter,
  });

  final List<CardFilterEntry> _cast = <CardFilterEntry>[
    const CardFilterEntry('Все'),
    const CardFilterEntry('Устранённые'),
    const CardFilterEntry('Неустранённые'),
    const CardFilterEntry('В работе'),
    const CardFilterEntry('На проверке'),
    const CardFilterEntry('Просроченные'),
    const CardFilterEntry('Замечания'),
    const CardFilterEntry('Предписания'),
    const CardFilterEntry('Предписания о приостановке работ'),
  ];

  List<String> _filters = <String>[];
  String queryString = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      _filters.add(_cast[selectFilter].name);
      if (_cast[selectFilter].name == "Все") {
        queryString =
            GraphQLQueries().incidentListFromProjectId(rowIdOfProject);
      }
    });
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

  Iterable<Widget> get actorWidgets sync* {
    for (final CardFilterEntry actor in _cast) {
      yield Padding(
        padding: const EdgeInsets.all(2.0),
        child: FilterChip(
          selectedColor: filterIncidentSelectedColor,
          disabledColor: filterIncidentUnSelectedColor,
          showCheckmark: false,
          backgroundColor: filterIncidentUnSelectedColor,
          label: Text(
            actor.name,
            style: TextStyle(color: white),
          ),
          selected: _filters.contains(actor.name),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                if (actor.name == "Все") {
                  queryString = "";

                  queryString = GraphQLQueries()
                      .incidentListFromProjectId(rowIdOfProject);
                  _filters.clear();
                  _filters.add(actor.name);
                }
                if (actor.name != "Все") {
                  queryString = "";

                  _filters.removeWhere((String name) {
                    return name == "Все";
                  });
                  _filters.add(actor.name);
                }
              } else {
                _filters.removeWhere((String name) {
                  return name == actor.name;
                });
              }
            });
          },
        ),
      );
    }
  }

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
    var buttonHeight = 35.toDouble() * devicePR / 2 ;
    var trailingWidth = 36.toDouble() * devicePR / 2;
    var trailingHeight = 23.toDouble() * devicePR / 2;
    var leadingHeight = buttonHeight;

    return GraphQLProvider(
        client: client,
        child: Scaffold(
            appBar: OftenAppBar().incidentAppBar("Нарушения"),
            body: Container(
                color: backgroundWhite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        color: newLeadingRed,
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          children: actorWidgets.toList(),
                        )),
                    SingleChildScrollView(
                      child: SafeArea(
                          child: Column(
                        children: <Widget>[loadInspectionsRequests()],
                      )),
                    ),
                  ],
                ))));
  }

  Widget loadInspectionsRequests() {
    double screenHeight =
        (MediaQuery.of(context).size.height - 136 - 7) * devicePR - 1325;
    try {
      return Query(
        options: QueryOptions(
          documentNode: gql(queryString),
          pollInterval: 10000,
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (queryString == "") {
            return Text("Запрос еще не настроен");
          }
          if (result.hasException) {
            print(result.exception);
            return Text("Что-то пошло не так");
          }

          if (result.loading) {
            return Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: true,
                child: Container(
                    margin: EdgeInsets.only(top: 50, bottom: 30),
                    child: CircularProgressIndicator()));
          }

          List incidents = result.data['allIncidents'];

          try {
            print(incidents.length);
            return Container(
                height: screenHeight,
                margin: EdgeInsets.only(top: 2.5 * devicePR / 2, bottom: 2.5 * devicePR / 2),
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        var incidentName = "s";

                        try {
                          var normalDate = NormalDate()
                              .reDate("${incidents[index]["resolveUntil"]}");
                          try {
                            incidentName = "${incidents[index]["name"]}";
                          } catch (e) {
                            incidentName = "";
                          }

                          return Center(
                              child: card(
                                  "${incidents[index]["comment"]}",
                                  "$index",
                                  "${incidents[index]["rowId"]}",
                                  normalDate,
                                  "Type",
                                  incidentName,
                                  "${incidents[index]["recommendation"]}"));
                        } catch (e) {
                          var normalDate = "--.--.----";
                          try {
                            incidentName = "${incidents[index]["name"]}";
                          } catch (e) {
                            incidentName = "";
                          }

                          return Center(
                              child: card(
                                  "${incidents[index]["comment"]}",
                                  "$index",
                                  "${incidents[index]["rowId"]}",
                                  normalDate,
                                  "Type",
                                  incidentName,
                                  "${incidents[index]["recommendation"]}"));
                        }
                      }, childCount: incidents.length),
                    )
                  ],
                ));
          } catch (e) {
            print(e);
            return Text("Что-то пошло не так");
          }
        },
      );
    } catch (e) {
      print(e);
      return Text("Что-то пошло не так");
    }
  }

  Widget card(String comment, String index, String rowId, String datetime,
          String incidentType, incidentName, recommendation) =>
      Container(
          margin: EdgeInsets.only(top: 2.5 * devicePR / 2, bottom: 2.5 * devicePR / 2),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.all(Radius.circular(10 * devicePR / 2)),
          ),
          width: 339 / devicePR * 3,
          height: 55 * devicePR / 2,
          alignment: Alignment.centerLeft,
          child: MaterialButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                _startEditPage(AllIncidentsEditPage(
                  graphQLtoken: graphQLtoken,
                  index: "$index",
                  projectName: projectName,
                  incidentType: incidentType,
                  incidentName: incidentName,
                  comment: comment,
                  recommendation: recommendation,
                ));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10 * devicePR / 2),
                          bottomLeft: Radius.circular(10 * devicePR / 2)),
                      color: newLeadingRed,
                    ),
                    alignment: Alignment.centerLeft,
                    width: 13 * devicePR / 3,
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          left: 11 * devicePR / 2,
                          top: 7 * devicePR / 2,
                          right: 14 * devicePR / 2),
                      child: Text(
                        "777",
                        style: TextStyle(
                            color: newDarkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14 * devicePR / 2),
                      )),
                  Container(
                    width: 265 * devicePR / 2.5,
                    margin: EdgeInsets.only(top: 7 * devicePR / 2),
                    child: Text(
                      incidentName,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: newDarkBlue,
                          fontSize: 14 * devicePR / 2),
                      maxLines: 5,
                    ),
                  )
                ],
              )));

  void _startEditPage(StatefulWidget statefulWidget) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => statefulWidget));
  }
}
