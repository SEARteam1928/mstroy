import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mstroy/mainclasses/constants/MSColors.dart';

class CreateInspection extends StatefulWidget {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;

  CreateInspection({this.projectName, this.buttonName, this.graphQLtoken});

  @override
  State<StatefulWidget> createState() =>
      _CreateInspectionState(projectName: projectName, buttonName: buttonName);
}

class _CreateInspectionState extends State<CreateInspection> {
  final String projectName;
  final String buttonName;
  final String graphQLtoken;

  _CreateInspectionState(
      {this.projectName, this.buttonName, this.graphQLtoken});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Создать заявку"), backgroundColor: mstroyLightBlue,),
        body:
        SingleChildScrollView(
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
                                  return  SingleChildScrollView(
                                      child: Column (children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.blueAccent)),
                                          child: Column(
                                            children: <Widget>[
                                              Text(" № $index"),
                                              Text("Заявка на инспекцию"),
                                              Text("Дата"),
                                              Text("Проект"),
                                              Text(projectName),
                                              Text("Тип инспекции"),
                                              Text("Конструктив"),
                                              Text("Конструктив (описание)"),
                                              Text("Вид работ"),
                                              Text("Ответственный"),
                                              Text("ФИО (роль)"),
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
                                              Text("Лист оценки"),
                                              Text("-Заполнить лист оценки-"),
                                              Text("количество несоответствий"),
                                              Text("-добавить фото-"),
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
                                              Text("Нарушения"),
                                              Text("Зафиксировать нарушение"),
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
                                              Text("-не принята- -принята-"),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.blueAccent)),
                                          child: Column(
                                            children: <Widget>[
                                              Text("-Отменить- -Сохранить-"),
                                            ],
                                          ),
                                        ),
                                      ]));
                                }, childCount: 1),
                          )
                        ],
                      ))              ],
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
