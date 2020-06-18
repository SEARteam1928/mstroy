import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mstroy/construction_control/PageOfProject.dart';
import 'package:mstroy/mainclasses/constants/urls.dart';
import 'package:mstroy/mainclasses/constants/MSColors.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mainclasses/constants/RouteNames.dart';

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

String allProjectQuery = """
  query allProjectQuery {
   allProjects{
     id
     rowId
     name
    }
  }
""";

String userInfo(String email) {
  return """
  query q {
allUsers(filters: {EmailEq: "$email"}){
  roles{
    name
    description
  }
}
}
""";
}

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    cache: InMemoryCache(),
    link: link,
  ),
);

var color = Colors.grey.shade300;
final Link link = authLink.concat(httpLink);

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
          documentNode: gql(userInfo(userEmail)),
          variables: {'allUsers': 1},
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

          List allUsersInfo = result.data['allUsers'][0]['roles'];

          try {
/*            print(allProjectsJson);
            print(allProjectsJson[0]["name"]);*/
          } catch (e) {}
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
    startScreen();

    _widgetOptions = <Widget>[
      projectListWidget(),
      Container(
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
      ActionChip(
          avatar: CircleAvatar(
            backgroundColor: mstroyBlue,
            child: Text('НП'),
          ),
          label: Text('На проверке'),
          backgroundColor: color,
          onPressed: () {
            setState(() {
              if (color == Colors.grey.shade300) {
                color = mstroyLightBlue;
              } else {
                color = Colors.grey.shade300;
              }
            });

            /*    Fluttertoast.showToast(
                msg: "Вы нажали на чип",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: mstroyLightBlue,
                textColor: Colors.white,
                fontSize: 16.0);       */
          })
    ];

    return GraphQLProvider(
        client: client,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("MStroy"),
            backgroundColor: mstroyLightBlue,
          ),
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
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
            backgroundColor: mstroyBlue,
            selectedItemColor: white,
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
          documentNode: gql(allProjectQuery),
          variables: {'allProjects': 1},
          pollInterval: 10,
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

          List allProjectsJson = result.data['allProjects'];

          try {
/*            print(allProjectsJson);
            print(allProjectsJson[0]["name"]);*/
          } catch (e) {}
          try {
            return Container(
                height: screenHeight - 100,
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return card(
                            "${allProjectsJson[index]["name"]}",
                            "$index",
                            "${allProjectsJson[index]["rowId"]}",
                            "${allProjectsJson[index]["id"]}");
                      }, childCount: allProjectsJson.length),
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

  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.txt');
    await file.writeAsString(text);
  }

  void _backScreen() {
    var exitAuth = _write("");
    addBoolToSF(true);
    Navigator.of(context).pushReplacementNamed(authorizationRoute);
  }

  Widget card(String text, String trailingText, String rowIdOfProject,
          String idOfProject) =>
      Container(
          height: 100,
          child: Card(
              child: MaterialButton(
                  onPressed: () {
                    print(rowIdOfProject);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PageOfProject(
                              projectName: "$text",
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
                          child: Center(
                              child: Text(
                            trailingText,
                            style: TextStyle(fontSize: 20, color: white),
                            maxLines: 1,
                          ))),
                    ),
                  ))));
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
/*
    print(text);
*/
    var jsonText = jsonDecode(text);

    graphQLtoken = jsonText["Authorization"].toString();
/*
    print(graphQLtoken);
*/
  } catch (e) {
    print("Couldn't read file");
  }

  return text;
}

final String projectsIcoName = 'images/projects_ico.svg';
final Widget projectsIco =
    SvgPicture.asset(projectsIcoName, semanticsLabel: 'ico');
