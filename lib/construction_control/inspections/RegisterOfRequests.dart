import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mstroy/construction_control/ProjectList.dart';
import 'package:mstroy/construction_control/inspections/RequestsEditPage.dart';
import 'package:mstroy/mainclasses/constants/MSColors.dart';
import 'package:mstroy/mainclasses/constants/urls.dart';

class RegisterOfRequests extends StatefulWidget {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;
  final String rowIdOfProject;
  final String idOfProject;

  RegisterOfRequests(
      {this.projectName,
      this.buttonName,
      this.graphQLtoken,
      this.rowIdOfProject,
      this.idOfProject});

  @override
  State<StatefulWidget> createState() => _RegisterOfRequestsState(
      projectName: projectName,
      buttonName: buttonName,
      graphQLtoken: graphQLtoken,
      rowIdOfProject: rowIdOfProject,
      idOfProject: idOfProject);
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

class _RegisterOfRequestsState extends State<RegisterOfRequests> {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;
  final String rowIdOfProject;
  final String idOfProject;
  var s = 12;

  _RegisterOfRequestsState(
      {this.projectName,
      this.buttonName,
      this.graphQLtoken,
      this.rowIdOfProject,
      this.idOfProject});

  @override
  void initState() {
    super.initState();
    print(rowIdOfProject);
  }

  TabController _tabController;

  Widget loadInspectionsRequests() {
    double screenHeight = MediaQuery.of(context).size.height - 136;
    String allInspectionRequestId = """
query findAllInspectionRequests {
  allInspectionRequests(filters:{projectIdEq:$rowIdOfProject}){
    id
    comment
    constructive
    work
    managerId
    projectId
    constructiveId
    mainSignListId
    workId
    planDate
    isRepeated
    drawingNumber
    manager{
      name
    }
    project{
      id
      name
    }
    governingDocuments
    inspectionId
    rowId
  }
}
""";
    try {
      return Query(
        options: QueryOptions(
          documentNode: gql(allInspectionRequestId),
          pollInterval: 20,
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

          List allInspectionRequests = result.data['allInspectionRequests'];

          try {
/*            print(allProjectsJson);
            print(allProjectsJson[0]["name"]);*/
          } catch (e) {}
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
                        return Center(
                            child: card(
                                "${allInspectionRequests[index]["comment"]}",
                                "$index",
                                "${allInspectionRequests[index]["rowId"]}"));
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
        child: DefaultTabController(
            length: 3,
            child: Scaffold(
                appBar: new AppBar(
                  backgroundColor: mstroyLightBlue,
                  title: new Text("Реестр заявок"),
                  bottom: new TabBar(
                    indicatorColor: white,
                    tabs: <Tab>[
                      new Tab(
                        text: "НЕ ЗАКРЫТЫЕ",
                      ),
                      new Tab(
                        text: "ЗАКРЫТЫЕ",
                      ),
                      new Tab(
                        text: "ВСЕ",
                      ),
                    ],
                    controller: _tabController,
                  ),
                ),
                body: Container(
                  color: backgroundWhite,
                  child: new TabBarView(
                    children: <Widget>[
                      SingleChildScrollView(
                          child: Container(
                              height: MediaQuery.of(context).size.height - 135,
                              child: CustomScrollView(
                                shrinkWrap: true,
                                slivers: <Widget>[
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      return card("Не закрытые", "$index", "s");
                                    }, childCount: s),
                                  )
                                ],
                              ))),
                      SingleChildScrollView(
                          child: Container(
                              height: MediaQuery.of(context).size.height - 135,
                              child: CustomScrollView(
                                shrinkWrap: true,
                                slivers: <Widget>[
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      return card("Закрытые", "$index", "s");
                                    }, childCount: s),
                                  )
                                ],
                              ))),
                      SingleChildScrollView(
                        child: SafeArea(
                            child: Column(
                          children: <Widget>[loadInspectionsRequests()],
                        )),
                      ),
                    ],
                    controller: _tabController,
                  ),
                ))));
  }

  Widget card(String text, String index, String id) => Container(
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
                  trailing: Text("dd.mm.yyyy", style: TextStyle(fontSize: 12)),
                )
              ]))));

  void _startEditPage(StatefulWidget statefulWidget) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => statefulWidget));
  }
}
