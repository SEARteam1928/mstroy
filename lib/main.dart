import 'package:flutter/material.dart';
import 'package:mstroy/mainclasses/WorkWithCamera.dart';
import 'package:mstroy/construction_control/incidents/AllIncidentsEditPage.dart';
import 'package:mstroy/construction_control/inspections/inspections/CreateInspection.dart';
import 'package:mstroy/construction_control/incidents/FixIncident.dart';
import 'package:mstroy/construction_control/inspections/inspections/InspectionsEditPage.dart';
import 'package:mstroy/construction_control/ProjectList.dart';
import 'package:mstroy/construction_control/PageOfProject.dart';
import 'package:mstroy/construction_control/inspections/requests_of_inspections/RequestsEditPage.dart';
import 'package:mstroy/mainclasses/constants/RouteNames.dart';
import 'package:mstroy/mainclasses/SplashScreen.dart';
import 'package:mstroy/mainclasses/Authorization.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    authorizationRoute: (BuildContext context) => Authorization(),
    projectListRoute: (BuildContext context) => ProjectList(),
    pageOfProjectRoute: (BuildContext context) => PageOfProject(),
    fixIncidentRoute: (BuildContext context) => FixIncident(),
    allIncidentsPageStateRoute: (BuildContext context) =>
        AllIncidentsEditPage(),
    createInspectionRoute: (BuildContext context) => CreateInspection(),
    inspectionEditPageRoute: (BuildContext context) => InspectionsEditPage(),
    requestsEditPageRoute: (BuildContext context) => RequestsEditPage(),
    workWithCameraRoute: (BuildContext context) => WorkWithCamera(),
  };

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MStroy',
      home: SplashScreen(nextRoute: authorizationRoute),
      routes: routes,
    );
  }
}
