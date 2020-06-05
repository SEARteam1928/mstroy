import 'package:flutter/material.dart';
import 'package:mstroy/RenameList.dart';
import 'package:mstroy/SplashScreen.dart';
import 'package:mstroy/Authorization.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    '/Authorization': (BuildContext context) => Authorization(title: 'MStroy'),
    '/RenameList': (BuildContext context) => RenameList(title: 'MStroy')
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
