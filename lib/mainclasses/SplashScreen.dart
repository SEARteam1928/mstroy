import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
    Timer(Duration(seconds: 1), () async {
      Future<String> text;
      String graphQLtoken;
      final Future<Directory> directory = getApplicationDocumentsDirectory();
      try {
        final Future<File> file = directory
            .then((value) => File('${value.path}/my_file.txt'))
            .catchError((onError) =>
                Navigator.of(context).pushReplacementNamed(widget.nextRoute));

        text = file.then((value) => value.readAsString());
        var jsonText = text.then((value) => jsonDecode(value.toString()));

        var s = await jsonText.then((value) => value);
        print(s);

        jsonText.then((value) => {
              if (value["Authorization"].toString() == "" ||
                  value["Authorization"] == "" ||
                  value["Authorization"].toString() == null ||
                  graphQLtoken == null ||
                  graphQLtoken.toString() == "Instance of 'Future<String>'")
                {Navigator.of(context).pushReplacementNamed('/RenameList')}
              else
                {Navigator.of(context).pushReplacementNamed(widget.nextRoute)}
            });
      } catch (e) {
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

bool checkAuthBool;

final String logoAssetName = 'images/mstroy_vertical.svg';
final Widget logoIco = SvgPicture.asset(logoAssetName, semanticsLabel: 'ico');
