import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mstroy/construction_control/inspections/inspections/InspectionsEditPage.dart';
import 'package:mstroy/mainclasses/constants/OftenAppBar.dart';
import 'package:mstroy/construction_control/inspections/requests_of_inspections/RequestsEditPage.dart';
import 'package:mstroy/mainclasses/constants/GraphQLQueries.dart';
import 'package:mstroy/mainclasses/constants/NormalDate.dart';
import 'package:mstroy/construction_control/ProjectList.dart';
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

class CastInspectionFilter extends StatefulWidget {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;
  final String rowIdOfProject;
  final String idOfProject;
  final int selectFilter;

  CastInspectionFilter(
      {this.projectName,
      this.buttonName,
      this.graphQLtoken,
      this.rowIdOfProject,
      this.idOfProject,
      this.selectFilter});

  @override
  State createState() => CastInspectionFilterState(
      projectName: projectName,
      buttonName: buttonName,
      graphQLtoken: graphQLtoken,
      rowIdOfProject: rowIdOfProject,
      idOfProject: idOfProject,
      selectFilter: selectFilter);
}

class CastInspectionFilterState extends State<CastInspectionFilter> {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;
  final String rowIdOfProject;
  final String idOfProject;
  final int selectFilter;

  CastInspectionFilterState({
    this.projectName,
    this.buttonName,
    this.graphQLtoken,
    this.rowIdOfProject,
    this.idOfProject,
    this.selectFilter,
  });

  final List<CardFilterEntry> _cast = <CardFilterEntry>[
    const CardFilterEntry('Все'),
    const CardFilterEntry('Принятые'),
    const CardFilterEntry('Непринятые'),
    const CardFilterEntry('В работе'),
    const CardFilterEntry('На проверке'),
  ];

  List<String> _filters = <String>[];
  String queryString = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      _filters.add(_cast[selectFilter].name);
      if (_cast[selectFilter].name == "Все") {
        queryString = "";

        queryString =
            GraphQLQueries().inspectionRequestsFromProjectId(rowIdOfProject);
      }
    });
  }

  Iterable<Widget> get actorWidgets sync* {
    for (final CardFilterEntry actor in _cast) {
      yield Padding(
        padding: const EdgeInsets.all(2.0),
        child: FilterChip(
          label: Text(
            actor.name,
            style: TextStyle(color: white),
          ),
          selectedColor: filterInspectionSelectedColor,
          backgroundColor: filterInspectionUnSelectedColor,
          showCheckmark: false,
          selected: _filters.contains(actor.name),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                if (actor.name == "Все") {
                  queryString = "";

                  queryString = GraphQLQueries()
                      .inspectionRequestsFromProjectId(rowIdOfProject);
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
            appBar: OftenAppBar().inspectionAppBar("Инспекции"),
            body: Container(
                color: backgroundWhite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        color: newButtonMstroyBlue,
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
            return loadingIndicator();
          }

          if (result.loading) {
            return loadingIndicator();
          }

          List inspections = result.data['allInspectionRequests'];

          try {
            print(inspections.length);
            return Container(
                height: screenHeight,
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        try {
                          var normalDate = NormalDate()
                              .reDate("${inspections[index]["planDate"]}");
                          return Center(
                              child: card(
                            "${inspections[index]["name"]}",
                            "$index",
                            "${inspections[index]["rowId"]}",
                            normalDate,
                            "",
                            "",
                            "",
                          ));
                        } catch (e) {
                          var normalDate = "--.--.----";
                          return Center(
                              child: card(
                            "${inspections[index]["name"]}",
                            "$index",
                            "${inspections[index]["rowId"]}",
                            normalDate,
                            "",
                            "",
                            "",
                          ));
                        }
                      }, childCount: inspections.length),
                    )
                  ],
                ));
          } catch (e) {
            return loadingIndicator();
          }
        },
      );
    } catch (e) {
      print(e);
      return loadingIndicator();
    }
  }

  Widget loadingIndicator() {
    return Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: true,
        child: Container(
            margin: EdgeInsets.only(top: 50, bottom: 30),
            child: CircularProgressIndicator()));
  }

/*
  Widget card(String text, String index, String id, String datetime) =>
      Container(
          constraints: BoxConstraints(minHeight: 100),
          child: Card(
              child: MaterialButton(
                  onPressed: () {
                    _startEditPage(RequestsEditPage(
                      graphQLtoken: graphQLtoken,
                      index: "$index",
                      projectName: projectName,
                      rowId: id,
                      comment: text,
                    ));
                  },
                  child: Column(children: <Widget>[
                    ListTile(
                      leading: Text(id),
                      title: Text(
                        text,
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: Text(datetime, style: TextStyle(fontSize: 12)),
                    )
                  ]))));
*/

  Widget card(String comment, String index, String rowId, String datetime,
          String incidentType, incidentName, recommendation) =>
      Container(
          margin: EdgeInsets.only(
              top: 2.5 * devicePR / 2, bottom: 2.5 * devicePR / 2),
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
                _startEditPage(InspectionsEditPage(
                  graphQLtoken: graphQLtoken,
                  index: "$index",
                  projectName: projectName,
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
