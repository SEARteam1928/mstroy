import 'package:flutter/material.dart';
import 'package:mstroy/PageOfProject.dart';
import 'package:mstroy/ProjectList.dart';
import 'package:mstroy/RouteNames.dart';
import 'package:mstroy/SplashScreen.dart';
import 'package:mstroy/Authorization.dart';
import 'package:mstroy/MSColors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    authorizationRoute: (BuildContext context) => Authorization(),
    projectListRoute: (BuildContext context) => ProjectList(),
    pageOfProjectRoute: (BuildContext context) => PageOfProject()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MStroy',
      home: SplashScreen(nextRoute: authorizationRoute),
      routes: routes,
    );
  }
}
