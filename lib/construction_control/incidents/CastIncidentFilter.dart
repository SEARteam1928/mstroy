import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
    const CardFilterEntry('Просрочено'),
    const CardFilterEntry('Неустранённые'),
    const CardFilterEntry('На проверке'),
    const CardFilterEntry('Все'),
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

  Iterable<Widget> get actorWidgets sync* {
    for (final CardFilterEntry actor in _cast) {
      yield Padding(
        padding: const EdgeInsets.all(2.0),
        child: FilterChip(
          label: Text(actor.name),
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
    return GraphQLProvider(
        client: client,
        child: Scaffold(
            appBar: new AppBar(
              backgroundColor: mstroyLightBlue,
              title: new Text("Нарушения"),
            ),
            body: Container(
                color: backgroundWhite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      alignment: WrapAlignment.start,
                      children: actorWidgets.toList(),
                    ),
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
    double screenHeight = MediaQuery.of(context).size.height - 136 - 79;
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
          constraints: BoxConstraints(minHeight: 100),
          child: Card(
              child: MaterialButton(
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
                  child: Column(children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(incidentType),
                    ),
                    ListTile(
                      leading: Text(index),
                      title: Text(
                        incidentName,
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: Text(datetime, style: TextStyle(fontSize: 12)),
                    )
                  ]))));

  void _startEditPage(StatefulWidget statefulWidget) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => statefulWidget));
  }
}
