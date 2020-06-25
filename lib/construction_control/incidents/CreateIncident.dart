import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mstroy/mainclasses/constants/OftenAppBar.dart';
import 'package:mstroy/mainclasses/WorkWithCamera.dart';
import 'package:mstroy/mainclasses/constants/GraphQLQueries.dart';
import 'package:mstroy/mainclasses/constants/MSColors.dart';
import 'package:mstroy/mainclasses/constants/NormalDate.dart';
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
const String MIN_DATETIME = '2020-01-01 09:23:10';
const String MAX_DATETIME = '2025-06-03 21:11:00';
const String INIT_DATETIME = '2020-05-16 09:00:00';

class _CreateIncidentState extends State<CreateIncident> {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;

  String _name = "";
  String _recomendation = "InAppTestRecomendation";
  String _comment = "";
  String _work = "74994";
  String _managerid = "51";
  String _projectId = "1";
  String _constructiveId = "74990";
  String _resolved = "false";
  String _resolvedUntil = "2020-06-30T01:36:36+00:00";

  TextEditingController _nameController = TextEditingController();
  TextEditingController _recomendationController = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  TextEditingController _workController = TextEditingController();
  TextEditingController _manageridController = TextEditingController();
  TextEditingController _projectIdController = TextEditingController();
  TextEditingController _constructiveIdController = TextEditingController();
  TextEditingController _resolvedController = TextEditingController();
  TextEditingController _resolvedUntilController = TextEditingController();

  _CreateIncidentState({this.projectName, this.buttonName, this.graphQLtoken});

  bool _showTitle = true;
  String _format = 'dd, MM, yyyy EEE,HH:mm';

/*
  String _format = 'YYYY-MM-DDTHH:mm:ssZ';
*/

/*
  'yy年M月d日    EEE,H时:m分';
*/
  DateTime _dateTime;
  TextEditingController _formatCtrl = TextEditingController();
  DateTimePickerLocale _locale = DateTimePickerLocale.ru;

  @override
  void initState() {
    super.initState();
    _formatCtrl.text = _format;
    _dateTime = DateTime.parse(INIT_DATETIME);
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: client,
        child: Mutation(
          options: MutationOptions(
            documentNode: gql(GraphQLQueries().createIncidentMutation(
              _name,
              _recomendation,
              _comment,
              _work,
              _managerid,
              _projectId,
              _constructiveId,
              _resolved,
              _resolvedUntil,
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
                appBar: OftenAppBar().create("Нарушение"),
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
                                          border: Border.all(
                                              color: Colors.blueAccent)),
                                      child: Column(
                                        children: <Widget>[
                                          Text(" № $index"),
                                          Text("Категория"),
                                          Text("-Замечание"),
                                          Text("-Предписание"),
                                          Text(
                                              "-Предписание о приостановке работ"),
                                          Text("Проект"),
                                          Text(projectName),
                                          Text("Нарушение"),
                                          _nameTextField(_nameController,
                                              "Кратко назовите нарушение", 20),
                                          Text("Описание"),
                                          _commentTextField(_commentController,
                                              "Подробно опишите замечание", 20),
                                          Text("Конструктив"),
                                          Text("Конструктив (описание)"),
                                          Text("Вид работ"),
                                          Text(
                                            "Дата",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          Text(
                                            "${NormalDate().formatDateInCreateView(DateTime.now())}",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          Text("Нарушение зафиксировал"),
                                          Center(
                                              child: new DropdownButton(
                                            items: new List.generate(20,
                                                (int index) {
                                              return new DropdownMenuItem(
                                                  child: new Container(
                                                child: new Text("ФИО#$index"),
                                                width: 200.0, //200.0 to 100.0
                                              ));
                                            }),
                                            onChanged: (value) {},
                                          )),
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
                                          border: Border.all(
                                              color: Colors.blueAccent)),
                                      child: Column(
                                        children: <Widget>[
                                          Text("Решение"),
                                          Text("Срок устранения"),
                                          Text("Рекомендации"),
                                          _recomendationTextField(
                                              _recomendationController,
                                              "Рекомендации",
                                              20),
                                          Text("Подписать"),
                                          Text("Подписано СК"),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      height: 1000,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.blueAccent)),
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
                                          border: Border.all(
                                              color: Colors.blueAccent)),
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
                                                        fontWeight:
                                                            FontWeight.w400),
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
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ))),
                                          MaterialButton(
                                              onPressed: () {
                                                setState(() {
                                                  _name = _nameController.text;
                                                });
                                                print(_name);
                                                runMutation({
                                                  _name: _nameController.text
                                                });
                                                print(_name);
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Выполняется сохранение нарушения",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.TOP,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        mstroyLightBlue,
                                                    textColor: white,
                                                    fontSize: 16.0);
                                              },
                                              textColor: white,
                                              color: Colors.lightGreen,
                                              child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 45,
                                                      top: 4,
                                                      right: 45,
                                                      bottom: 4),
                                                  child: Text(
                                                    "сохранить",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400),
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

  Widget _nameTextField(TextEditingController controller, String hintText,
      double containerMargin) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(top: containerMargin, bottom: containerMargin),
      decoration: BoxDecoration(
        color: backgroundWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(1),
            bottomLeft: Radius.circular(1)),
      ),
      child: TextField(
          onChanged: (value) {
            _name = value;
          },
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: mstroyLightBlue),
            ),
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            hintText: hintText,
          )),
    );
  }

  Widget _recomendationTextField(TextEditingController controller,
      String hintText, double containerMargin) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(top: containerMargin, bottom: containerMargin),
      decoration: BoxDecoration(
        color: backgroundWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(1),
            bottomLeft: Radius.circular(1)),
      ),
      child: TextField(
          onChanged: (value) {
            _recomendation = value;
          },
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: mstroyLightBlue),
            ),
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            hintText: hintText,
          )),
    );
  }

  Widget _commentTextField(TextEditingController controller, String hintText,
      double containerMargin) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(top: containerMargin, bottom: containerMargin),
      decoration: BoxDecoration(
        color: backgroundWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(1),
            bottomLeft: Radius.circular(1)),
      ),
      child: TextField(
          onChanged: (value) {
            _comment = value;
          },
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: mstroyLightBlue),
            ),
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            hintText: hintText,
          )),
    );
  }

  Widget _workTextField(TextEditingController controller, String hintText,
      double containerMargin) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(top: containerMargin, bottom: containerMargin),
      decoration: BoxDecoration(
        color: backgroundWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(1),
            bottomLeft: Radius.circular(1)),
      ),
      child: TextField(
          onChanged: (value) {
            _work = value;
          },
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: mstroyLightBlue),
            ),
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            hintText: hintText,
          )),
    );
  }

  Widget _managerIdTextField(TextEditingController controller, String hintText,
      double containerMargin) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(top: containerMargin, bottom: containerMargin),
      decoration: BoxDecoration(
        color: backgroundWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(1),
            bottomLeft: Radius.circular(1)),
      ),
      child: TextField(
          onChanged: (value) {
            _managerid = value;
          },
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: mstroyLightBlue),
            ),
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            hintText: hintText,
          )),
    );
  }

  Widget _projectIdTextField(TextEditingController controller, String hintText,
      double containerMargin) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(top: containerMargin, bottom: containerMargin),
      decoration: BoxDecoration(
        color: backgroundWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(1),
            bottomLeft: Radius.circular(1)),
      ),
      child: TextField(
          onChanged: (value) {
            _projectId = value;
          },
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: mstroyLightBlue),
            ),
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            hintText: hintText,
          )),
    );
  }

  Widget _constructiveIdTextField(TextEditingController controller,
      String hintText, double containerMargin) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(top: containerMargin, bottom: containerMargin),
      decoration: BoxDecoration(
        color: backgroundWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(1),
            bottomLeft: Radius.circular(1)),
      ),
      child: TextField(
          onChanged: (value) {
            _constructiveId = value;
          },
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: mstroyLightBlue),
            ),
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            hintText: hintText,
          )),
    );
  }

  Widget _resolvedTextField(TextEditingController controller, String hintText,
      double containerMargin) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(top: containerMargin, bottom: containerMargin),
      decoration: BoxDecoration(
        color: backgroundWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(1),
            bottomLeft: Radius.circular(1)),
      ),
      child: TextField(
          onChanged: (value) {
            _resolved = value;
          },
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: mstroyLightBlue),
            ),
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            hintText: hintText,
          )),
    );
  }

  Widget _resolvedUntilTextField(TextEditingController controller,
      String hintText, double containerMargin) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(top: containerMargin, bottom: containerMargin),
      decoration: BoxDecoration(
        color: backgroundWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(1),
            bottomLeft: Radius.circular(1)),
      ),
      child: TextField(
          onChanged: (value) {
            _resolvedUntil = value;
          },
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: mstroyLightBlue),
            ),
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            hintText: hintText,
          )),
    );
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
