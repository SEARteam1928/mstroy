import 'package:flutter/material.dart';
import 'package:mstroy/ProjectList.dart';
import 'package:mstroy/SplashScreen.dart';
import 'package:mstroy/Authorization.dart';
import 'package:mstroy/MSColors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    '/Authorization': (BuildContext context) => Authorization(),
    '/RenameList': (BuildContext context) => RenameList()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MStroy',
      home: SplashScreen(nextRoute: '/Authorization'),
      routes: routes,
    );
  }
}
