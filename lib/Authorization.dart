import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Authorization extends StatefulWidget {
  Authorization({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Authorization> {
  TextEditingController loginController = TextEditingController(),
      passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: Center(
          child: SafeArea(
              child: Container(
        padding: EdgeInsets.only(left: 25, top: 40, right: 25, bottom: 40),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 6,
                  blurRadius: 15,
                  offset: Offset(0, 5))
            ]),
        height: 359,
        width: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 20),
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "Авторизация",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 24.0,
                    color: const Color(0xff132B4D)),
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
        color: const Color(0xFFF4F7FA),
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
              borderSide: BorderSide(color: const Color(0xFF4774e8)),
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
        width: 137,
        height: 36,
        margin: EdgeInsets.only(top: 31),
        child: MaterialButton(
            onPressed: () {
              _checkInputOnNull();
            },
            textColor: Colors.white,
            color: const Color(0xFF4774e8),
            child: Container(
              padding: EdgeInsets.only(top: 4, bottom: 4),
              child: Text(
                "Войти",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
            )));
  }

  void _checkInputOnNull() {
    String login = loginController.text;
    String password = passwordController.text;
    if (login == '' || password == '') {
      Fluttertoast.showToast(
          msg: "Заполните все поля",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xffe40069),
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Вход в систему!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xff00A1e7),
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.of(context).pushNamed('/RenameList');
    }
  }
}

final String loginAssetname = 'images/authorization_login_ico.svg';
final Widget loginIco = SvgPicture.asset(loginAssetname, semanticsLabel: 'ico');
final String passwordAssetName = 'images/authorization_password_ico.svg';
final Widget passwordIco =
    SvgPicture.asset(passwordAssetName, semanticsLabel: 'ico');
