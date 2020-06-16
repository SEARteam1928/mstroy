import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:mstroy/mainclasses/constants/RouteNames.dart';
import 'package:mstroy/mainclasses/constants/urls.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/MSColors.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';

class Authorization extends StatefulWidget {
  Authorization({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

var underLineColor = blue;

class _MyHomePageState extends State<Authorization> {
  TextEditingController loginController = TextEditingController(),
      passwordController = TextEditingController();
  var authTextTitle = "Авторизация";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundWhite,
      body: Center(
          child: SafeArea(
              child: Container(
        padding: EdgeInsets.only(left: 25, top: 40, right: 25, bottom: 40),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                  color: greyOpacity0_5,
                  spreadRadius: 6,
                  blurRadius: 15,
                  offset: Offset(0, 5))
            ]),
        height: 369,
        width: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 20),
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                authTextTitle,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 24.0,
                    color: darkBlue),
              ),
            ),
            _textField(loginController, loginIco, false, "Email", 0),
            _textField(passwordController, passwordIco, true, "Пароль", 20),
            _enterButton()
          ],
        ),
      ))),
    );
  }

  Widget _textField(TextEditingController controller, Widget ico, bool obscure,
      String hintText, double containerMargin) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(top: containerMargin, bottom: containerMargin),
      decoration: BoxDecoration(
        color: backgroundWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(1),
            bottomLeft: Radius.circular(1)),
      ),
      child: TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            suffixIcon: Container(
              child: ico,
              padding: EdgeInsets.all(14),
            ),
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: underLineColor),
            ),
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            hintText: hintText,
          )),
    );
  }

  Widget _enterButton() {
    return Container(
        width: 150,
        height: 46,
        margin: EdgeInsets.only(top: 31),
        child: MaterialButton(
            onPressed: () {
              _checkInputOnNull();
            },
            textColor: white,
            color: blue,
            child: Container(
              padding: EdgeInsets.only(top: 4, bottom: 4),
              child: Text(
                "Войти",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
            )));
  }

  Future<void> _checkInputOnNull() async {
    try {
      String login = loginController.text;
      String password = passwordController.text;

      if (login == '' || password == '') {
        Fluttertoast.showToast(
            msg: "Заполните все поля",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Map authData = {
          "email": loginController.text,
          "password": passwordController.text
        };

//TODO: сделать что-то, что будет показывать, что производится вход в систему
        Fluttertoast.showToast(
            msg: "Выполняется вход в систему!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: lightBlue,
            textColor: Colors.white,
            fontSize: 16.0);

        var body = json.encode(authData);
        var authResponse = await http.post(authApiUrl,
            headers: {"Content-type": "application/json;charset=utf-8"},
            body: body);

        print(authResponse.body);
        var authResponseJson = jsonDecode(authResponse.body);

        if (authResponseJson["status"] == "success") {
          Fluttertoast.showToast(
              msg:
                  "Вход выполнен\n\nПользователь: ${authResponseJson["user"]["username"]}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: lightBlue,
              textColor: white,
              fontSize: 17.0);
          var writeJsonData = _write(authResponse.body);
          print(writeJsonData);
          addBoolToSF(true);
          Navigator.of(context).pushReplacementNamed(projectListRoute);
        } else {
          Fluttertoast.showToast(
              msg: "Ошибка входа, проверьте введёные данные",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: red,
              textColor: white,
              fontSize: 16.0);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Что-то пошло не так, попробуйте снова!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: red,
          textColor: white,
          fontSize: 16.0);
    }
  }
}

addBoolToSF(bool booleanVal) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('authCheck', booleanVal);
}

final String loginAssetname = 'images/authorization_login_ico.svg';
final Widget loginIco = SvgPicture.asset(loginAssetname, semanticsLabel: 'ico');
final String passwordAssetName = 'images/authorization_password_ico.svg';
final Widget passwordIco =
    SvgPicture.asset(passwordAssetName, semanticsLabel: 'ico');

_write(String text) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/my_file.txt');
  await file.writeAsString(text);
}
