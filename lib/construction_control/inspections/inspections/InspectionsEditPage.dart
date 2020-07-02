import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mstroy/mainclasses/constants/MSColors.dart';
import 'package:mstroy/mainclasses/constants/OftenAppBar.dart';

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

  double devicePR = 0.0;

  _InspectionsEditPageState(
      {this.projectName, this.incidentIndex, this.graphQLtoken});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      devicePR = MediaQuery.of(context).devicePixelRatio;
    });
    var trailingTextSize = 14.toDouble() * devicePR;
    trailingTextSize = 14.toDouble() * devicePR / 2;
    var fixButtonMargin = EdgeInsets.only(bottom: 10 * devicePR / 2);
    var buttonHeight = 35.toDouble() * devicePR / 2 + 2;
    var buttonPadding =
        EdgeInsets.only(top: 4 * devicePR / 2, bottom: 4 * devicePR / 2);
    var fixButtonSize = 14.toDouble() * devicePR / 2.1;

    return Scaffold(
        appBar: OftenAppBar().inspectionAppBar("Инспекции"),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Column(
            children: <Widget>[
              Container(
                  color: inspectionEditPageBackground,
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
                                  Text("Проект"),
                                  Text(projectName),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(10 * devicePR / 2),
                              padding: EdgeInsets.all(11 * devicePR / 2),
                              decoration: BoxDecoration(
                                  color: inspectionEditPageRequestsGreen,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10 * devicePR / 2))),
                              child: Column(
                                children: <Widget>[Text("Заявка")],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(10 * devicePR / 2),
                              padding: EdgeInsets.all(11 * devicePR / 2),
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10 * devicePR / 2))),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        "РЕЗУЛЬТАТЫ ИНСПЕКЦИИ",
                                        style: TextStyle(
                                          color: newDarkBlue,
                                          fontSize: fixButtonSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      )),
                                  Container(
                                    margin: EdgeInsets.only(top: 11* devicePR / 2),
                                      child: Row(
                                    children: <Widget>[
                                      Text("Выполнено"),
                                      Text("Корректно"),
                                    ],
                                  )),
                                  Row(
                                    children: <Widget>[
                                      _switchesNamesColumn(),
                                      _firstSwitches(),
                                      _secondSwitches()
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(10 * devicePR / 2),
                              padding: EdgeInsets.all(11 * devicePR / 2),
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10 * devicePR / 2))),
                              child: Column(
                                children: <Widget>[Text("Photo")],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(10 * devicePR / 2),
                              padding: EdgeInsets.all(11 * devicePR / 2),
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10 * devicePR / 2))),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      height: buttonHeight,
                                      margin: fixButtonMargin,
                                      width: MediaQuery.of(context).size.width,
                                      child: MaterialButton(
                                          elevation: 0.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    5 * devicePR / 2)),
                                          ),
                                          onPressed: () {},
                                          textColor: white,
                                          color: inspectionEditPageButtonYellow,
                                          child: Container(
                                            padding: buttonPadding,
                                            child: Text(
                                              "Принять в работу",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: fixButtonSize),
                                            ),
                                          ))),
                                  Container(
                                      height: buttonHeight,
                                      margin: fixButtonMargin,
                                      width: MediaQuery.of(context).size.width,
                                      child: MaterialButton(
                                          elevation: 0.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7)),
                                          ),
                                          onPressed: () {},
                                          textColor: white,
                                          color: newButtonMstroyBlue,
                                          child: Container(
                                            padding: buttonPadding,
                                            child: Text(
                                              "Готово к проверке",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: fixButtonSize),
                                            ),
                                          ))),
                                  Container(
                                      height: buttonHeight,
                                      margin: fixButtonMargin,
                                      width: MediaQuery.of(context).size.width,
                                      child: MaterialButton(
                                          elevation: 0.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7)),
                                          ),
                                          onPressed: () {},
                                          textColor: white,
                                          color: inspectionEditPageButtonGreen,
                                          child: Container(
                                            padding: buttonPadding,
                                            child: Text(
                                              "Подтвердить устранение",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: fixButtonSize),
                                            ),
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
  }

  Widget _switchesNamesColumn() => Container(
      padding: EdgeInsets.only(top: 15),
      constraints: BoxConstraints(maxWidth: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 15),
            child: Text("Результаты оценки"),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 15),
            child: Text("Количество несоответствий"),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 15),
            child: Text("Чек-листы"),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 15),
            child: Text(
                "Паспорта, сертификаты соответствия, таможенные декларации"),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 15),
            child: Text("Исполнительные схемы"),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 15),
            child: Text("Требования ПД и РД"),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 15),
            child: Text("Требования нормативной документации"),
          ),
        ],
      ));

  Widget _firstSwitches() => Column(
        children: <Widget>[
          Switch(
            onChanged: (val) => setState(() => _resultEstimationFirst = val),
            value: _resultEstimationFirst,
          ),
          Switch(
            onChanged: (val) => setState(() => _discrepanciesCountFirst = val),
            value: _discrepanciesCountFirst,
          ),
          Switch(
            onChanged: (val) => setState(() => _checklistsFirst = val),
            value: _checklistsFirst,
          ),
          Switch(
            onChanged: (val) => setState(() => _passportsFirst = val),
            value: _passportsFirst,
          ),
          Switch(
            onChanged: (val) => setState(() => _executiveSchemeFirst = val),
            value: _executiveSchemeFirst,
          ),
          Switch(
            onChanged: (val) =>
                setState(() => _requirementsForPDandRDFirst = val),
            value: _requirementsForPDandRDFirst,
          ),
          Switch(
            onChanged: (val) =>
                setState(() => _regulatoryDocumentationFirst = val),
            value: _regulatoryDocumentationFirst,
          ),
        ],
      );

  Widget _secondSwitches() => Column(
        children: <Widget>[
          Switch(
            value: _resultEstimationSecond,
            onChanged: (bool newValue) {
              setState(() {
                _resultEstimationSecond = newValue;
              });
            },
          ),
          Switch(
            value: _discrepanciesCountSecond,
            onChanged: (bool newValue) {
              setState(() {
                _discrepanciesCountSecond = newValue;
              });
            },
          ),
          Switch(
            value: _checklistsSecond,
            onChanged: (bool newValue) {
              setState(() {
                _checklistsSecond = newValue;
              });
            },
          ),
          Switch(
            value: _passportsSecond,
            onChanged: (bool newValue) {
              setState(() {
                _passportsSecond = newValue;
              });
            },
          ),
          Switch(
            value: _executiveSchemeSecond,
            onChanged: (bool newValue) {
              setState(() {
                _executiveSchemeSecond = newValue;
              });
            },
          ),
          Switch(
            value: _requirementsForPDandRDSecond,
            onChanged: (bool newValue) {
              setState(() {
                _requirementsForPDandRDSecond = newValue;
              });
            },
          ),
          Switch(
            value: _regulatoryDocumentationSecond,
            onChanged: (bool newValue) {
              setState(() {
                _regulatoryDocumentationSecond = newValue;
              });
            },
          ),
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
