import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mstroy/construction_control/inspections/requests_of_inspections/RequestsEditPage.dart';
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
    const CardFilterEntry('Заявки'),
    const CardFilterEntry('Непринятые'),
    const CardFilterEntry('Все'),
    const CardFilterEntry('На проверке'),
  ];

  List<String> _filters = <String>[];
  String queryString = "";


  @override
  void initState() {
    super.initState();
    setState(() {
      _filters.add(_cast[selectFilter].name);
      if(_cast[selectFilter].name == "Все"){
        queryString = "";

        queryString = GraphQLQueries().inspectionRequestsFromProjectId(rowIdOfProject);
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
                if(actor.name == "Все"){
                  queryString = "";

                  queryString = GraphQLQueries().inspectionRequestsFromProjectId(rowIdOfProject);
                  _filters.clear();
                  _filters.add(actor.name);
                }
                if(actor.name != "Все"){
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
    double screenHeight = MediaQuery.of(context).size.height - 136 - 58;
    try {
      return Query(
        options: QueryOptions(
          documentNode: gql(queryString),
          pollInterval: 30,
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            return Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: true,
                child: Container(
                    margin: EdgeInsets.only(top: 50, bottom: 30),
                    child: CircularProgressIndicator()));
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
                                      "${inspections[index]["comment"]}",
                                      "$index",
                                      "${inspections[index]["rowId"]}",
                                      normalDate));
                            } catch (e) {
                              var normalDate = "--.--.----";
                              return Center(
                                  child: card(
                                      "${inspections[index]["comment"]}",
                                      "$index",
                                      "${inspections[index]["rowId"]}",
                                      normalDate));
                            }
                          }, childCount: inspections.length),
                    )
                  ],
                ));
          } catch (e) {
            return Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: true,
                child: Container(
                    margin: EdgeInsets.only(top: 50, bottom: 30),
                    child: CircularProgressIndicator()));
          }
        },
      );
    } catch (e) {
      print(e);
      return Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: true,
          child: Container(
              margin: EdgeInsets.only(top: 50, bottom: 30),
              child: CircularProgressIndicator()));
    }
  }

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

  void _startEditPage(StatefulWidget statefulWidget) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => statefulWidget));
  }
}
