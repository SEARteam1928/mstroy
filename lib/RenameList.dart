import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:convert';

import 'package:mstroy/MSColors.dart';

class RenameList extends StatefulWidget {
  RenameList({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final HttpLink httpLink = HttpLink(
  uri: 'https://graphql.ms11.ru/',
);

final AuthLink authLink = AuthLink(
  getToken: () async =>
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJleHAiOjE1OTE2NjE5MTIzNzAsImlhdCI6MTU5MTU3NTUwNzM3MCwicmxzIjpbMV0sInVzciI6ODh9.6_Salic-P54csFYqVnxUn-US_uIDztIDTQ1GKOV5kPxDszs1uqIO5txtUv3NqhLIsdruq8_LKg_k3Zuq9AOPlA',
  // OR
  // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
);

String allProjectQuery = """
  query allProjectQuery {
   allProjects{
     name
    }
  }
""";

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    cache: InMemoryCache(),
    link: link,
  ),
);

final Link link = authLink.concat(httpLink);

class _MyHomePageState extends State<RenameList> {

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return GraphQLProvider(
        client: client,
        child: Scaffold(
            body: SingleChildScrollView(
          child: SafeArea(
              child: Column(
            children: <Widget>[
              Query(
                options: QueryOptions(
                  documentNode: gql(allProjectQuery),
                  variables: {'allProjects': 2},
                  pollInterval: 50,
                ),
                builder: (QueryResult result,
                    {VoidCallback refetch, FetchMore fetchMore}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }

                  if (result.loading) {
                    return Text('Loading');
                  }
                  List allProjectsJson = result.data['allProjects'];
                  print(allProjectsJson);
                  print(allProjectsJson[0]["name"]);
                  return Container(
                      height: screenHeight - 100,
                      child: CustomScrollView(
                        shrinkWrap: true,
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  return card("${allProjectsJson[index]["name"]}","$index");
                                }, childCount: allProjectsJson.length),
                          )
                        ],
                      )) ;
                },
              ),
              Container(
                  margin: EdgeInsets.only(top: 16),
                  child: MaterialButton(
                      onPressed: () {
                        _backScreen();
                      },
                      textColor: white,
                      color: blue,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 45, top: 4, right: 45, bottom: 4),
                        child: Text(
                          "Назад",
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                      )))
            ],
          )),
        )));
  }

  void _backScreen() {
    Navigator.of(context).pushReplacementNamed('/Authorization');
  }

  Widget card(String text, String trailingText) => Container(
      height: 150,
      child: Card(
        child: ListTile(
          onTap: () {
            Fluttertoast.showToast(
                msg: "Вы выбрали $trailingText-й проект",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: lightBlue,
                textColor: white,
                fontSize: 16.0);
          },
          title: Text(
            text,
            style: TextStyle(fontSize: 20),
          ),
          trailing: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: red,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Center(
                  child: Text(
                trailingText,
                style: TextStyle(fontSize: 20, color: white),
              ))),
        ),
      ));
}
