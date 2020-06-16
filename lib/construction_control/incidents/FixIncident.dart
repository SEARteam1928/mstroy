import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mstroy/WorkWithCamera.dart';
import 'package:mstroy/mainclasses/constants/MSColors.dart';
import 'package:mstroy/mainclasses/constants/RouteNames.dart';

class FixIncident extends StatefulWidget {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;

  FixIncident({this.projectName, this.buttonName, this.graphQLtoken});

  @override
  State<StatefulWidget> createState() => _FixIncidentState(
      projectName: projectName,
      buttonName: buttonName,
      graphQLtoken: graphQLtoken);
}

class _FixIncidentState extends State<FixIncident> {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;
  TabController _tabController;

  _FixIncidentState({this.projectName, this.buttonName, this.graphQLtoken});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                                  Text("-удалить-  -отменить- -сохранить-"),
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
  }

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
