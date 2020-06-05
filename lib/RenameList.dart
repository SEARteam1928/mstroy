import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RenameList extends StatefulWidget {
  RenameList({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<RenameList> {
  TextEditingController loginController = TextEditingController(),
      passwordController = TextEditingController();
  List<Card> cards = List();

  void appendingCards() {
    for (int i = 1; i < 5; i++) {
      cards.add(card("Card $i", "$i"));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
          child: Column(
        children: <Widget>[
          Container(
              height: screenHeight - 100,
              child: CustomScrollView(
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return card("Card ${index + 1}", "${index + 1}");
                    }, childCount: 20),
                  )
                ],
              )),
          Container(
              margin: EdgeInsets.only(top: 16),
              child: MaterialButton(
                  onPressed: () {
                    _checkInputOnNull();
                  },
                  textColor: Colors.white,
                  color: const Color(0xFF4774e8),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 45, top: 4, right: 45, bottom: 4),
                    child: Text(
                      "Назад",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  )))
        ],
      )),
    ));
  }

  void _checkInputOnNull() {
    Navigator.of(context).pushNamed('/Authorization');
  }

  Widget card(String text, String trailingText) => Container(
      height: 150,
      child: Card(
        child: ListTile(
          onTap: () {
            Fluttertoast.showToast(
                msg: "Вы нажали на $trailingText элемент",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: const Color(0xff00A1e7),
                textColor: Colors.white,
                fontSize: 16.0);
          },
          title: Text(
            text,
            style: TextStyle(fontSize: 20),
          ),
          trailing: Container(
            width: 50,
                  height: 50,
            decoration: BoxDecoration(
              color: const Color(0xffe40069),
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
              child: Center(
                  child: Text(
            trailingText,
            style: TextStyle(fontSize: 20,color: Colors.white),
              ))),
        ),
      ));
}
