import 'package:flutter/material.dart';
import 'package:mstroy/AllIncidents.dart';
import 'package:mstroy/CreateInspection.dart';
import 'package:mstroy/FixIncident.dart';
import 'package:mstroy/IncidentsOnTheCheck.dart';
import 'package:mstroy/PageOfProject.dart';
import 'package:mstroy/ProjectList.dart';
import 'package:mstroy/RegisterOfInspections.dart';
import 'package:mstroy/RegisterOfRequests.dart';
import 'package:mstroy/RouteNames.dart';
import 'package:mstroy/SplashScreen.dart';
import 'package:mstroy/Authorization.dart';
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
    incidentsOnTheCheckRoute: (BuildContext context) => IncidentOnTheCheck(),
    createInspectionRoute: (BuildContext context) => CreateInspection(),
    registerOfRequestsRoute: (BuildContext context) => RegisterOfInspections(),
    registerOfInspectionRoute: (BuildContext context) => RegisterOfRequests(),
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
