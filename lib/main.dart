import 'package:flutter/material.dart';
import 'package:mstroy/NextStage.dart';
import 'package:mstroy/PageOfProject.dart';
import 'package:mstroy/ProjectList.dart';
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
    nextStageRoute: (BuildContext context) => NextStage()
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
