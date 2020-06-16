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

  bool _resultEstimationFirst = false;
  bool _resultEstimationSecond = false;

  bool _discrepanciesCountFirst = false;
  bool _discrepanciesCountSecond = false;

  bool _checklistsFirst = false;
  bool _checklistsSecond = false;

  bool _passportsFirst = false;
  bool _passportsSecond = false;

  bool _executiveSchemeFirst = false;
  bool _executiveSchemeSecond = false;

  bool _requirementsForPDandRDFirst = false;
  bool _requirementsForPDandRDSecond = false;

  bool _regulatoryDocumentationFirst = false;
  bool _regulatoryDocumentationSecond = false;

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
                                  Row(
                                    children: <Widget>[
                                      Text("Выполнено"),
                                      Text("Корректно"),
                                    ],
                                  ),
                                  _resultEstimation("Результаты оценки"),
                                  _discrepanciesCount("Количество несоответствий"),
                                  _checklists("Чек-листы"),
                                  _passports("Паспорта, сертификаты соответствия, таможенные декларации"),
                                  _executiveScheme("Исполнительные схемы"),
                                  _requirementsForPDandRD("Требования ПД и РД"),
                                  _regulatoryDocumentation("Требования нормативной документации"),
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

  Widget _resultEstimation(String text) => Row(
        children: <Widget>[
          Text(text),
          Switch(
            onChanged: (val) => setState(() => _resultEstimationFirst = val),
            value: _resultEstimationFirst,
          ),
          Switch(
            value: _resultEstimationSecond,
            onChanged: (bool newValue) {
              setState(() {
                _resultEstimationSecond = newValue;
              });
            },
          )
        ],
      );

  Widget _discrepanciesCount(String text) => Row(
        children: <Widget>[
          Text(text),
          Switch(
            onChanged: (val) => setState(() => _discrepanciesCountFirst = val),
            value: _discrepanciesCountFirst,
          ),
          Switch(
            value: _discrepanciesCountSecond,
            onChanged: (bool newValue) {
              setState(() {
                _discrepanciesCountSecond = newValue;
              });
            },
          )
        ],
      );

  Widget _checklists(String text) => Row(
        children: <Widget>[
          Text(text),
          Switch(
            onChanged: (val) => setState(() => _checklistsFirst = val),
            value: _checklistsFirst,
          ),
          Switch(
            value: _checklistsSecond,
            onChanged: (bool newValue) {
              setState(() {
                _checklistsSecond = newValue;
              });
            },
          )
        ],
      );

  Widget _passports(String text) => Row(
        children: <Widget>[
          Text(text),
          Switch(
            onChanged: (val) => setState(() => _passportsFirst = val),
            value: _passportsFirst,
          ),
          Switch(
            value: _passportsSecond,
            onChanged: (bool newValue) {
              setState(() {
                _passportsSecond = newValue;
              });
            },
          )
        ],
      );

  Widget _executiveScheme(String text) => Row(
        children: <Widget>[
          Text(text),
          Switch(
            onChanged: (val) => setState(() => _executiveSchemeFirst = val),
            value: _executiveSchemeFirst,
          ),
          Switch(
            value: _executiveSchemeSecond,
            onChanged: (bool newValue) {
              setState(() {
                _executiveSchemeSecond = newValue;
              });
            },
          )
        ],
      );

  Widget _requirementsForPDandRD(String text) => Row(
        children: <Widget>[
          Text(text),
          Switch(
            onChanged: (val) => setState(() => _requirementsForPDandRDFirst = val),
            value: _requirementsForPDandRDFirst,
          ),
          Switch(
            value: _requirementsForPDandRDSecond,
            onChanged: (bool newValue) {
              setState(() {
                _requirementsForPDandRDSecond = newValue;
              });
            },
          )
        ],
      );

  Widget _regulatoryDocumentation(String text) => Row(
        children: <Widget>[
          Text(text),
          Switch(
            onChanged: (val) => setState(() => _regulatoryDocumentationFirst = val),
            value: _regulatoryDocumentationFirst,
          ),
          Switch(
            value: _regulatoryDocumentationSecond,
            onChanged: (bool newValue) {
              setState(() {
                _regulatoryDocumentationSecond = newValue;
              });
            },
          )
        ],
      );

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
