import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mstroy/mainclasses/WorkWithCamera.dart';
import 'package:mstroy/mainclasses/constants/GraphQLQueries.dart';
import 'package:mstroy/mainclasses/constants/MSColors.dart';
import 'package:mstroy/mainclasses/constants/urls.dart';

class CreateIncident extends StatefulWidget {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;

  CreateIncident({this.projectName, this.buttonName, this.graphQLtoken});

  @override
  State<StatefulWidget> createState() => _CreateIncidentState(
      projectName: projectName,
      buttonName: buttonName,
      graphQLtoken: graphQLtoken);
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
class _CreateIncidentState extends State<CreateIncident> {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;
  TabController _tabController;

  _CreateIncidentState({this.projectName, this.buttonName, this.graphQLtoken});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: client,
        child: Mutation(
      options: MutationOptions(
        documentNode: gql(GraphQLQueries().createIncidentMutation(
          "InAppTestName",
          "InAppTestRecomendation",
          "InAppTestComment",
          "74994",
          "51",
          "1",
          "74990",
          "false",
          "2020-06-30T01:36:36+00:00"
        )), // this is the mutation string you just created
        // you can update the cache based on results
        update: (Cache cache, QueryResult result) {
          return cache;
        },
        // or do something with the result.data on completion
        onCompleted: (dynamic resultData) {
          Fluttertoast.showToast(
              msg: "Нарушение сохранено",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: mstroyLightBlue,
              textColor: white,
              fontSize: 16.0);
          print(resultData);
        },
      ),
      builder: (
          RunMutation runMutation,
          QueryResult result,
          ) {
        return Scaffold(
            appBar: AppBar(
              title: Text("Нарушение"),
              backgroundColor: mstroyLightBlue,
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Container(
                          height: MediaQuery.of(context).size.height - 100,
                          child: CustomScrollView(
                            shrinkWrap: true,
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      return SingleChildScrollView(
                                          child: Column(children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.blueAccent)),
                                              child: Column(
                                                children: <Widget>[
                                                  Text(" № $index"),
                                                  Text("Категория"),
                                                  Text("-Замечание"),
                                                  Text("-Предписание"),
                                                  Text("-Предписание о приостановке работ"),
                                                  Text("Проект"),
                                                  Text(projectName),
                                                  Text("Нарушение"),
                                                  Text("-Кратко назовите замечание-"),
                                                  Text("Описание"),
                                                  Text("-подробно опишите замечание-"),
                                                  Text("Конструктив"),
                                                  Text("Конструктив (описание)"),
                                                  Text("Вид работ"),
                                                  Text("Дата"),
                                                  Text("dd.mm.yyyy"),
                                                  Text("Нарушение зафиксировал"),
                                                  Text("ФИО (роль)"),
                                                  Container(
                                                      margin: EdgeInsets.all(10),
                                                      child: WorkWithCamera()),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.blueAccent)),
                                              child: Column(
                                                children: <Widget>[
                                                  Text("Решение"),
                                                  Text("Срок устранения"),
                                                  Text("Рекомендации"),
                                                  Text("Подписать"),
                                                  Text("Подписано СК"),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              height: 1000,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.blueAccent)),
                                              child: Column(
                                                children: <Widget>[
                                                  Text("Статус нарушения"),
                                                  Text("Принято в работу"),
                                                  Text("Готово к проверке"),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.blueAccent)),
                                              child: Column(
                                                children: <Widget>[
                                                  MaterialButton(
                                                      onPressed: () {},
                                                      textColor: white,
                                                      color: red,
                                                      child: Container(
                                                          padding: EdgeInsets.only(
                                                              left: 45,
                                                              top: 4,
                                                              right: 45,
                                                              bottom: 4),
                                                          child: Text(
                                                            "Удалить",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w400),
                                                          ))),
                                                  MaterialButton(
                                                      onPressed: () {},
                                                      textColor: white,
                                                      color: Colors.grey,
                                                      child: Container(
                                                          padding: EdgeInsets.only(
                                                              left: 45,
                                                              top: 4,
                                                              right: 45,
                                                              bottom: 4),
                                                          child: Text(
                                                            "отменить",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w400),
                                                          ))),
                                                  MaterialButton(
                                                      onPressed: () {
                                                        runMutation({});
                                                        Fluttertoast.showToast(
                                                            msg: "Выполняется сохранение нарушения",
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            gravity: ToastGravity.TOP,
                                                            timeInSecForIosWeb: 1,
                                                            backgroundColor: mstroyLightBlue,
                                                            textColor: white,
                                                            fontSize: 16.0);
                                                        },
                                                      textColor: white,
                                                      color: Colors.lightGreenAccent,
                                                      child: Container(
                                                          padding: EdgeInsets.only(
                                                              left: 45,
                                                              top: 4,
                                                              right: 45,
                                                              bottom: 4),
                                                          child: Text(
                                                            "сохранить",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w400),
                                                          ))),
                                                ],
                                              ),
                                            ),
                                          ]));
                                    }, childCount: 1),
                              )
                            ],
                          ))
                    ],
                  )),
            ));
      },
    ));
  }


/*  Scaffold(
  appBar: AppBar(
  title: Text("Нарушение"),
  backgroundColor: mstroyLightBlue,
  ),
  body: SingleChildScrollView(
  child: SafeArea(
  child: Column(
  children: <Widget>[
  Container(
  height: MediaQuery.of(context).size.height - 100,
  child: CustomScrollView(
  shrinkWrap: true,
  slivers: <Widget>[
  SliverList(
  delegate: SliverChildBuilderDelegate(
  (BuildContext context, int index) {
  return SingleChildScrollView(
  child: Column(children: <Widget>[
  Container(
  margin: EdgeInsets.all(10),
  decoration: BoxDecoration(
  border: Border.all(color: Colors.blueAccent)),
  child: Column(
  children: <Widget>[
  Text(" № $index"),
  Text("Категория"),
  Text("-Замечание"),
  Text("-Предписание"),
  Text("-Предписание о приостановке работ"),
  Text("Проект"),
  Text(projectName),
  Text("Нарушение"),
  Text("-Кратко назовите замечание-"),
  Text("Описание"),
  Text("-подробно опишите замечание-"),
  Text("Конструктив"),
  Text("Конструктив (описание)"),
  Text("Вид работ"),
  Text("Дата"),
  Text("dd.mm.yyyy"),
  Text("Нарушение зафиксировал"),
  Text("ФИО (роль)"),
  Container(
  margin: EdgeInsets.all(10),
  child: WorkWithCamera()),
  ],
  ),
  ),
  Container(
  margin: EdgeInsets.all(10),
  decoration: BoxDecoration(
  border: Border.all(color: Colors.blueAccent)),
  child: Column(
  children: <Widget>[
  Text("Решение"),
  Text("Срок устранения"),
  Text("Рекомендации"),
  Text("Подписать"),
  Text("Подписано СК"),
  ],
  ),
  ),
  Container(
  margin: EdgeInsets.all(10),
  height: 1000,
  decoration: BoxDecoration(
  border: Border.all(color: Colors.blueAccent)),
  child: Column(
  children: <Widget>[
  Text("Статус нарушения"),
  Text("Принято в работу"),
  Text("Готово к проверке"),
  ],
  ),
  ),
  Container(
  margin: EdgeInsets.all(10),
  decoration: BoxDecoration(
  border: Border.all(color: Colors.blueAccent)),
  child: Column(
  children: <Widget>[
  MaterialButton(
  onPressed: () {},
  textColor: white,
  color: red,
  child: Container(
  padding: EdgeInsets.only(
  left: 45,
  top: 4,
  right: 45,
  bottom: 4),
  child: Text(
  "Удалить",
  style: TextStyle(
  fontWeight: FontWeight.w400),
  ))),
  MaterialButton(
  onPressed: () {},
  textColor: white,
  color: Colors.grey,
  child: Container(
  padding: EdgeInsets.only(
  left: 45,
  top: 4,
  right: 45,
  bottom: 4),
  child: Text(
  "отменить",
  style: TextStyle(
  fontWeight: FontWeight.w400),
  ))),
  MaterialButton(
  onPressed: () {},
  textColor: white,
  color: Colors.lightGreenAccent,
  child: Container(
  padding: EdgeInsets.only(
  left: 45,
  top: 4,
  right: 45,
  bottom: 4),
  child: Text(
  "сохранить",
  style: TextStyle(
  fontWeight: FontWeight.w400),
  ))),
  ],
  ),
  ),
  ]));
  }, childCount: 1),
  )
  ],
  ))
  ],
  )),
  ));*/

  Widget card(String text, String trailingText) => Container(
      height: 100,
      child: Card(
          child: MaterialButton(
              onPressed: () {},
              child: ListTile(
                title: Text(
                  text,
                  style: TextStyle(fontSize: 16),
                ),
              ))));
}


/*class StarrableRepository extends StatelessWidget {
  const StarrableRepository({
    Key key,
    @required this.repository,
  }) : super(key: key);

  final Map<String, Object> repository;

  Map<String, Object> extractRepositoryData(Object data) {
    final action =
    (data as Map<String, Object>)['action'] as Map<String, Object>;
    if (action == null) {
      return null;
    }
    return action['starrable'] as Map<String, Object>;
  }

  bool get starred => repository['viewerHasStarred'] as bool;
  bool get optimistic => (repository as LazyCacheMap).isOptimistic;

  Map<String, dynamic> get expectedResult => <String, dynamic>{
    'action': <String, dynamic>{
      'starrable': <String, dynamic>{'viewerHasStarred': !starred}
    }
  };

  @override
  Widget build(BuildContext context) {
    return
  }*/
