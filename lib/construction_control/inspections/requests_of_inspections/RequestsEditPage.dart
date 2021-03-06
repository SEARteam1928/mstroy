import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mstroy/mainclasses/constants/OftenAppBar.dart';
import 'package:mstroy/mainclasses/WorkWithCamera.dart';

class RequestsEditPage extends StatefulWidget {
  final String projectName;
  final String index;
  final String rowId;
  final String graphQLtoken;
  final String comment;

  RequestsEditPage(
      {this.projectName,
      this.index,
      this.graphQLtoken,
      this.rowId,
      this.comment});

  @override
  State<StatefulWidget> createState() => _RequestsEditPageState(
      projectName: projectName,
      incidentIndex: index,
      graphQLtoken: graphQLtoken,
      rowId: rowId,
      comment: comment);
}

class _RequestsEditPageState extends State<RequestsEditPage> {
  final String projectName;
  final String incidentIndex;
  final String rowId;
  final String graphQLtoken;
  final String comment;

  _RequestsEditPageState(
      {this.projectName,
      this.incidentIndex,
      this.graphQLtoken,
      this.rowId,
      this.comment});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: OftenAppBar().inspectionAppBar("Инспекция"),
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
                                  Text("№ $rowId"),
                                  Text("Проект"),
                                  Text(projectName),
                                  Text("Плановая дата"),
                                  Text("Конструктив"),
                                  Text("Вид работ"),
                                  Text("Номер чертежа"),
                                  Text("Руководящие документы"),
                                  Text("Инициатор"),
                                  Text("Комментарий"),
                                  Text("$comment")
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent)),
                              child: Column(
                                children: <Widget>[
                                  Text("Фотографии"),
                                  Container(
                                      margin: EdgeInsets.all(10),
                                      child: WorkWithCamera()),
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
                                  Text("Подписи"),
                                  Text("Заявка создана"),
                                  Text("Виза ОКС"),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent)),
                              child: Column(
                                children: <Widget>[
                                  Text("Создать инспекцию"),
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
