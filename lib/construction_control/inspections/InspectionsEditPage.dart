import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mstroy/mainclasses/constants/MSColors.dart';

class InspectionsEditPage extends StatefulWidget {
  final String projectName;
  final String index;
  final String graphQLtoken;

  InspectionsEditPage({this.projectName, this.index, this.graphQLtoken});

  @override
  State<StatefulWidget> createState() => _InspectionsEditPageState(
      projectName: projectName,
      incidentIndex: index,
      graphQLtoken: graphQLtoken);
}

class _InspectionsEditPageState extends State<InspectionsEditPage> {
  final String projectName;
  final String incidentIndex;
  final String graphQLtoken;

  _InspectionsEditPageState(
      {this.projectName, this.incidentIndex, this.graphQLtoken});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Инспекции"),
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
                                  Text("№ $incidentIndex"),
                                  Text("Заявка на инспекцию"),
                                  Text("Проект"),
                                  Text(projectName),
                                  Text("Тип инспекции"),
                                  Text("Конструктив"),
                                  Text("Вид работ"),
                                  Text("Ответственный"),
                                  Text("Температура"),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent)),
                              child: Column(
                                children: <Widget>[
                                  Text("Заключение"),
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
                                  Text(
                                      "Результаты оценки -выполнено- -корректно-"),
                                  Text(
                                      "Количество несоответствий -выполнено- -корректно-"),
                                  Text("Чек-листы -выполнено- -корректно-"),
                                  Text(
                                      "Паспорта, сертификаты соответствия, таможенные декларации -выполнено- -корректно-"),
                                  Text(
                                      "Исполнительные схемы -выполнено- -корректно-"),
                                  Text(
                                      "Требования ПД и РД -выполнено- -корректно-"),
                                  Text(
                                      "Требования нормативной документации -выполнено- -корректно-"),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent)),
                              child: Column(
                                children: <Widget>[
                                  Text("Инспекция принята/не принята"),
                                  Text("Виза ОКС"),
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
