import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final String nextRoute;

  SplashScreen({this.nextRoute});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}
getBoolValuesSF()  {
  SharedPreferences prefs = SharedPreferences.getInstance() as SharedPreferences;
  //Return bool
  bool boolValue = prefs.getBool('authCheck');
  return boolValue;
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {

      // ignore: unrelated_type_equality_checks
      try{
      if(getBoolValuesSF().toString() == "true" ||getBoolValuesSF() == "true" || getBoolValuesSF().toString() == true ||getBoolValuesSF() == true || getBoolValuesSF().toString() == "Instance of 'Future<bool>'"){
        Navigator.of(context).pushReplacementNamed('/RenameList');
      }
      else{
        Navigator.of(context).pushReplacementNamed(widget.nextRoute);
      }}
      catch(e) {
        Navigator.of(context).pushReplacementNamed(widget.nextRoute);

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 400,
              width: 400,
              child: logoIco,
              padding: EdgeInsets.all(0),
            ),
          ],
        ),
      ),
    );
  }
}

bool checkAuthorizationIsNull()  {
  String text;
  var graphQLtoken;
  try {
    final Directory directory =  getApplicationDocumentsDirectory() as Directory;
    final File file = File('${directory.path}/my_file.txt');
    text =  file.readAsString() as String;
    print(text);
    var jsonText = jsonDecode(text);

    graphQLtoken = jsonText["Authorization"].toString();
    print(graphQLtoken+"ff");

  } catch (e) {
    return false;
  }
  try {
    // ignore: unrelated_type_equality_checks
    if (graphQLtoken.toString() == "" ||graphQLtoken == "" || graphQLtoken.toString() == null ||graphQLtoken == null || graphQLtoken.toString() == "Instance of 'Future<String>'") {
      return false;
    } else {
      return true;
    }
  } catch (e) {
    print(e+"dddd");
    return false;
  }
}

final String logoAssetName = 'images/mstroy_vertical.svg';
final Widget logoIco = SvgPicture.asset(logoAssetName, semanticsLabel: 'ico');

