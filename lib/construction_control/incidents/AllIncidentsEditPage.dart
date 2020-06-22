import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mstroy/mainclasses/constants/MSColors.dart';

class AllIncidentsEditPage extends StatefulWidget {
  final String projectName;
  final String index;
  final String graphQLtoken;
  final String incidentType;
  final String incidentName;
  final String comment;
  final String recommendation;

  AllIncidentsEditPage(
      {this.projectName,
      this.index,
      this.graphQLtoken,
      this.incidentType,
      this.incidentName,
      this.comment,
      this.recommendation});

  @override
  State<StatefulWidget> createState() => _AllIncidentsEditPageState(
      projectName: projectName,
      incidentIndex: index,
      graphQLtoken: graphQLtoken,
      incidentType: incidentType,
      incidentName: incidentName,
      comment: comment,
      recommendation: recommendation);
}

class _AllIncidentsEditPageState extends State<AllIncidentsEditPage> {
  final String projectName;
  final String incidentIndex;
  final String graphQLtoken;
  final String incidentType;
  final String incidentName;
  final String comment;
  final String recommendation;

  _AllIncidentsEditPageState(
      {this.projectName,
      this.incidentIndex,
      this.graphQLtoken,
      this.incidentType,
      this.incidentName,
      this.comment,
      this.recommendation});

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
                                  Text("$incidentType № $incidentIndex"),
                                  Text("Проект : $projectName"),
                                  Text("Нарушение : $incidentName"),
                                  Text("Описание : $comment"),
                                  Text("Конструктив"),
                                  Text("Конструктив (описание)"),
                                  Text("Вид работ"),
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
                                  Text("Рекомендации: $recommendation"),
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
                                  Text("Устранение нарушения"),
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
                                  Text("Подтверждение нарушения"),
                                  Text(
                                    "Подтвердить нарушение",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  Text("Готово к проверке"),
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
      constraints: BoxConstraints(minHeight: 100),
      child: Card(
          child: MaterialButton(
              onPressed: () {},
              child: Column(children: <Widget>[
                ListTile(
                  title: Text(
                    text,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ]))));
}
