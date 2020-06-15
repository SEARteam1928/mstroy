import 'package:flutter/material.dart';
import 'package:mstroy/construction_control/incidents/AllIncidents.dart';
import 'package:mstroy/construction_control/incidents/AllIncidentsEditPage.dart';
import 'package:mstroy/construction_control/inspections/CreateInspection.dart';
import 'package:mstroy/construction_control/incidents/FixIncident.dart';
import 'package:mstroy/construction_control/incidents/IncidentsOnTheCheck.dart';
import 'package:mstroy/construction_control/inspections/InspectionsEditPage.dart';
import 'package:mstroy/construction_control/inspections/RegisterOfInspections.dart';
import 'package:mstroy/construction_control/inspections/RegisterOfRequests.dart';
import 'package:mstroy/construction_control/ProjectList.dart';
import 'package:mstroy/construction_control/PageOfProject.dart';
import 'package:mstroy/construction_control/inspections/RequestsEditPage.dart';
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
    allIncidentsRoute: (BuildContext context) => AllIncidents(),
    allIncidentsPageStateRoute: (BuildContext context) => AllIncidentsEditPage(),
    incidentsOnTheCheckRoute: (BuildContext context) => IncidentOnTheCheck(),
    createInspectionRoute: (BuildContext context) => CreateInspection(),
    registerOfRequestsRoute: (BuildContext context) => RegisterOfInspections(),
    registerOfInspectionRoute: (BuildContext context) => RegisterOfRequests(),
    inspectionEditPageRoute: (BuildContext context) => InspectionsEditPage(),
    requestsEditPageRoute: (BuildContext context) => RequestsEditPage(),
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
