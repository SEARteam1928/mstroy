import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mstroy/construction_control/PageOfProject.dart';
import 'package:mstroy/mainclasses/constants/GraphQLQueries.dart';
import 'package:mstroy/mainclasses/constants/urls.dart';
import 'package:mstroy/mainclasses/constants/MSColors.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mstroy/mainclasses/constants/RouteNames.dart';

class ProjectList extends StatefulWidget {
  ProjectList({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final HttpLink httpLink = HttpLink(
  uri: graphQLUrl,
);
var graphQLtoken;
var userName = "";
var userEmail = "";
final AuthLink authLink = AuthLink(
  getToken: () async => graphQLtoken.toString(),
);

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    cache: InMemoryCache(),
    link: link,
  ),
);

final Link link = authLink.concat(httpLink);
var color = Colors.grey.shade300;

addBoolToSF(bool booleanVal) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('authCheck', booleanVal);
}

class _MyHomePageState extends State<ProjectList> {
  int _selectedIndex = 0;
  TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> startScreen() async {
    // ignore: unrelated_type_equality_checks
    if (checkAuthorizationIsNull == false) {
      Navigator.of(context).pushReplacementNamed(authorizationRoute);
    } else {
      String text;
      try {
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file = File('${directory.path}/my_file.txt');
        text = await file.readAsString();
        var jsonText = jsonDecode(text);

        graphQLtoken = jsonText["Authorization"].toString();
        setState(() {
          userName = jsonText["user"]["username"];
          userEmail = jsonText["user"]["email"];
        });
      } catch (e) {
        print("Couldn't read file");
      }
    }
  }

  Widget loadUserInfo() {
    double screenHeight = MediaQuery.of(context).size.height - 290;
    try {
      return Query(
        options: QueryOptions(
          documentNode: gql(GraphQLQueries().userInfo(userEmail)),
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            return loadIndicate();
          }

          if (result.loading) {
            return loadIndicate();
          }

          List allUsersInfo = result.data['allUsers'][0]['roles'];

          try {} catch (e) {}
          try {
            return Container(
                height: screenHeight,
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return Center(
                            child: Text(
                                "${allUsersInfo[index]["name"]}:  ${allUsersInfo[index]["description"]}"));
                      }, childCount: allUsersInfo.length),
                    )
                  ],
                ));
          } catch (e) {
            return loadIndicate();
          }
        },
      );
    } catch (e) {
      return loadIndicate();
    }
  }

/*
*
* */
  @override
  Widget build(BuildContext context) {
    startScreen();

    _widgetOptions = <Widget>[
      projectListWidget(),
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: newBackgroundWhite,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          margin: EdgeInsets.only(top: 16),
          child: Column(children: <Widget>[
            SingleChildScrollView(
              child: SafeArea(
                  child: Column(
                children: <Widget>[
                  MaterialButton(
                      onPressed: () {
                        _backScreen();
                      },
                      textColor: white,
                      color: mstroyBlue,
                      child: Container(
                          padding: EdgeInsets.only(
                              left: 45, top: 4, right: 45, bottom: 4),
                          child: Text(
                            "Выйти из аккаунта",
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ))),
                  Text("Имя пользователя: "),
                  Text(userName),
                  Text("Email"),
                  Text(userEmail),
                  Text("Роль:"),
                  loadUserInfo(),
                ],
              )),
            ),
          ])),
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: newBackgroundWhite),
          child: Text("Hello World"))
    ];

    return GraphQLProvider(
        client: client,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: newBackgroundWhite,
            title: Text(
              "MStroy",
              style: TextStyle(
                  color: newDarkBlue,
                  fontSize: 10 * MediaQuery.of(context).devicePixelRatio),
            ),
            iconTheme: IconThemeData(color: newDarkBlue),
            centerTitle: true,
          ),
          body: Center(
            child: Container(
                decoration: BoxDecoration(color: newBackgroundWhite),
                child: _widgetOptions.elementAt(_selectedIndex)),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.format_list_numbered_rtl),
                title: Text('Проекты'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Главная'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.help),
                title: Text('Справка'),
              ),
            ],
            currentIndex: _selectedIndex,
            backgroundColor: newBackgroundWhite,
            elevation: 0.0,
            selectedItemColor: darkBlue,
            onTap: _onItemTapped,
          ),
        ));
  }

  Widget projectListWidget() {
    return SingleChildScrollView(
      child: SafeArea(
          child: Column(
        children: <Widget>[
          loadProjects(),
        ],
      )),
    );
  }

  Widget loadProjects() {
    double screenHeight = MediaQuery.of(context).size.height;
    try {
      return Query(
        options: QueryOptions(
          documentNode: gql(GraphQLQueries().allProjectQuery()),
          pollInterval: 20000,
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            return loadIndicate();
          }

          if (result.loading) {
            return loadIndicate();
          }

          List allProjectsJson = result.data['allProjects'];

          try {
            return Container(
                height: screenHeight - 100,
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
/*
                        print("${allProjectsJson[index]["shortName"]}");
*/

                        if ("${allProjectsJson[index]["shortName"]}" == null ||
                            "${allProjectsJson[index]["shortName"]}" == "" ||
                            "${allProjectsJson[index]["shortName"]}" ==
                                "null") {
                          return card(
                              "${allProjectsJson[index]["name"]}",
                              "${allProjectsJson[index]["name"]}",
                              "$index",
                              "${allProjectsJson[index]["rowId"]}",
                              "${allProjectsJson[index]["id"]}");
                        } else {
                          return card(
                              "${allProjectsJson[index]["name"]}",
                              "${allProjectsJson[index]["shortName"]}",
                              "$index",
                              "${allProjectsJson[index]["rowId"]}",
                              "${allProjectsJson[index]["id"]}");
                        }
                      }, childCount: allProjectsJson.length),
                    )
                  ],
                ));
          } catch (e) {
            return loadIndicate();
          }
        },
      );
    } catch (e) {
      return loadIndicate();
    }
  }

  Widget loadIndicate() {
    return Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: true,
        child: Container(
            margin: EdgeInsets.only(top: 50, bottom: 30),
            child: CircularProgressIndicator()));
  }

  Widget notifyNum(String rowIdOfProject) {
    try {
      return Query(
        options: QueryOptions(
          documentNode:
              gql(GraphQLQueries().allNotifyFromIdOfProject(rowIdOfProject)),
          pollInterval: 1000,
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            return Text(
              "0",
              style: TextStyle(fontSize: 20, color: white),
              maxLines: 1,
            );
          }

          if (result.loading) {
            return loadIndicator();
          }

          List allInspectionRequestsJson = result.data['allInspectionRequests'];
          List allInspectionsJson = result.data['allInspections'];
          List allIncidentsJson = result.data['allIncidents'];

          try {
            var notifyLength = allInspectionRequestsJson.length +
                allInspectionsJson.length +
                allIncidentsJson.length;
            return Text(
              "$notifyLength",
              style: TextStyle(fontSize: 20, color: white),
              maxLines: 1,
            );
          } catch (e) {
            return Text(
              "0",
              style: TextStyle(fontSize: 20, color: white),
              maxLines: 1,
            );
          }
        },
      );
    } catch (e) {
      return Text(
        "0",
        style: TextStyle(fontSize: 20, color: white),
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

  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.txt');
    await file.writeAsString(text);
  }

  void _backScreen() {
    var exitAuth = _write("");
    print("$exitAuth");
    addBoolToSF(true);
    Navigator.of(context).pushReplacementNamed(authorizationRoute);
  }

  Widget card(String text, String shortName, String trailingText,
          String rowIdOfProject, String idOfProject) =>
      Container(
        height: 100,
        child: Card(
          child: MaterialButton(
            onPressed: () {
              print(rowIdOfProject);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PageOfProject(
                        projectName: "$text",
                        shortName: shortName,
                        graphQLtoken: graphQLtoken.toString(),
                        rowIdOfProject: rowIdOfProject,
                        idOfProject: idOfProject,
                      )));
            },
            child: Center(
              child: ListTile(
                title: Text(
                  text,
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: red,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child:
                      Center(child: Center(child: notifyNum(rowIdOfProject))),
                ),
              ),
            ),
          ),
        ),
      );
}

bool checkAuthorizationIsNull() {
  var text = _read();
  try {
    // ignore: unrelated_type_equality_checks
    if (text != '' || text != null) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}

dynamic _read() async {
  String text;
  try {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.txt');
    text = await file.readAsString();
    var jsonText = jsonDecode(text);

    graphQLtoken = jsonText["Authorization"].toString();
  } catch (e) {
    print("Couldn't read file");
  }

  return text;
}

final String projectsIcoName = 'images/projects_ico.svg';
final Widget projectsIco =
    SvgPicture.asset(projectsIcoName, semanticsLabel: 'ico');
