import 'package:flutter/material.dart';
import 'file:///C:/Users/User/Desktop/mstroy/lib/construction_control/incidents/AllIncidents.dart';
import 'file:///C:/Users/User/Desktop/mstroy/lib/construction_control/inspections/CreateInspection.dart';
import 'file:///C:/Users/User/Desktop/mstroy/lib/construction_control/incidents/FixIncident.dart';
import 'file:///C:/Users/User/Desktop/mstroy/lib/construction_control/incidents/IncidentsOnTheCheck.dart';
import 'file:///C:/Users/User/Desktop/mstroy/lib/construction_control/inspections/RegisterOfInspections.dart';
import 'file:///C:/Users/User/Desktop/mstroy/lib/construction_control/inspections/RegisterOfRequests.dart';
import 'file:///C:/Users/User/Desktop/mstroy/lib/construction_control/ProjectList.dart';
import 'file:///C:/Users/User/Desktop/mstroy/lib/construction_control/PageOfProject.dart';
import 'file:///C:/Users/User/Desktop/mstroy/lib/mainclasses/constants/RouteNames.dart';
import 'file:///C:/Users/User/Desktop/mstroy/lib/mainclasses/SplashScreen.dart';
import 'file:///C:/Users/User/Desktop/mstroy/lib/mainclasses/Authorization.dart';
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
