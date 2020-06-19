import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mstroy/construction_control/ProjectList.dart';
import 'package:mstroy/construction_control/incidents/IncidentsQueries.dart';
import 'package:mstroy/construction_control/inspections/requests_of_inspections/RequestsEditPage.dart';
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

class CastFilter extends StatefulWidget {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;
  final String rowIdOfProject;
  final String idOfProject;

  CastFilter(
      {this.projectName,
      this.buttonName,
      this.graphQLtoken,
      this.rowIdOfProject,
      this.idOfProject});

  @override
  State createState() => CastFilterState(
      projectName: projectName,
      buttonName: buttonName,
      graphQLtoken: graphQLtoken,
      rowIdOfProject: rowIdOfProject,
      idOfProject: idOfProject);
}

class CastFilterState extends State<CastFilter> {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;
  final String rowIdOfProject;
  final String idOfProject;

  CastFilterState(
      {this.projectName,
      this.buttonName,
      this.graphQLtoken,
      this.rowIdOfProject,
      this.idOfProject});

  final List<CardFilterEntry> _cast = <CardFilterEntry>[
    const CardFilterEntry('Просрочено'),
    const CardFilterEntry('Неустранённые'),
    const CardFilterEntry('Все'),
    const CardFilterEntry('На проверке'),
  ];

  List<String> _filters = <String>[];

  Iterable<Widget> get actorWidgets sync* {
    for (final CardFilterEntry actor in _cast) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          label: Text(actor.name),
          selected: _filters.contains(actor.name),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _filters.add(actor.name);
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


  Widget loadInspectionsRequests() {
    double screenHeight = MediaQuery.of(context).size.height - 136-79;
    try {
      return Query(
        options: QueryOptions(
          documentNode: gql(allInspectionRequestId(rowIdOfProject)),
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

          if(result.loading){
            return Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: true,
                child: Container(
                    margin: EdgeInsets.only(top: 50, bottom: 30),
                    child: CircularProgressIndicator()));
          }

          List allInspectionRequests = result.data['allInspectionRequests'];

          try {
            print(allInspectionRequests.length);
            return Container(
                height: screenHeight,
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            try {
                              var datetimeSplitStr =
                              "${allInspectionRequests[index]["planDate"]}"
                                  .split("T")[0];
                              var dateSplit = datetimeSplitStr.split("-");
                              var yearStr = dateSplit[0];
                              var mounthStr = dateSplit[1];
                              var dayStr = dateSplit[2];
                              var normalDate = "$dayStr.$mounthStr.$yearStr";
                              return Center(
                                  child: card(
                                      "${allInspectionRequests[index]["comment"]}",
                                      "$index",
                                      "${allInspectionRequests[index]["rowId"]}",
                                      normalDate));
                            } catch (e) {
                              var normalDate = "--.--.----";
                              return Center(
                                  child: card(
                                      "${allInspectionRequests[index]["comment"]}",
                                      "$index",
                                      "${allInspectionRequests[index]["rowId"]}",
                                      normalDate));
                            }
                          }, childCount: allInspectionRequests.length),
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

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: client,
        child: Scaffold(
        appBar: new AppBar(
        backgroundColor: mstroyLightBlue,
        title: new Text("Нарушения"), ),
        body: Container(
              color: backgroundWhite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Wrap(
                  alignment: WrapAlignment.start,
                  children: actorWidgets.toList(),
                ),
                Text('Вы выбрали: ${_filters.join(', ')}'),
                SingleChildScrollView(
                  child: SafeArea(
                      child: Column(
                        children: <Widget>[loadInspectionsRequests()],
                      )),
                ),
              ],)


            )));
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
