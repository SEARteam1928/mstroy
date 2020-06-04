import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MStroy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'MStroy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController loginController = TextEditingController(), passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: Center(
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
        height: 410,
        width: 340,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 20),
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "Авторизация",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24.0),
              ),
            ),
            Container(
              width: 270,
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(4),topRight: Radius.circular(4), bottomRight: Radius.circular(1),bottomLeft: Radius.circular(1)),
              ),
              child: TextField(
                controller: loginController,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    border: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: "Email",
              )),
            ),
            Container(
              width: 270,
              margin: EdgeInsets.only(top: 20,bottom: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(4),topRight: Radius.circular(4), bottomRight: Radius.circular(1),bottomLeft: Radius.circular(1)),
              ),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                  decoration: InputDecoration(
                border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: "Пароль",
              )),
            ),
            Container(
              margin: EdgeInsets.only(top:16),
                child: MaterialButton(
                    onPressed: () {
                      _checkInputOnNull();
                    },
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 45, top: 4, right: 45, bottom: 4),
                      child: Text(
                        "Войти",
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                    )))
          ],
        ),
      )),
    );
  }

  void _checkInputOnNull(){
    String login = loginController.text;
    String password = passwordController.text;
    if(login == '' || password == ''){
      Fluttertoast.showToast(
          msg: "Заполните все поля",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

  }
}
