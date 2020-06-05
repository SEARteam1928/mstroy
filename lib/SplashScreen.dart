import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreen extends StatefulWidget {
  final String nextRoute;

  SplashScreen({this.nextRoute});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed(widget.nextRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
              height: 300,
              width: 300,
              child: logoIco,
              padding: EdgeInsets.all(0),
            ),
            Container(
                margin: EdgeInsets.only(top: 50),
                child:
            Text("Здесь будет проверка авторизованности",))
          ],
        ),
      ),
    );
  }
}
final String logoAssetName = 'images/mstroy_vertical.svg';
final Widget logoIco = SvgPicture.asset(logoAssetName, semanticsLabel: 'ico');