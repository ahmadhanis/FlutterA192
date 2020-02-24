import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              actions: <Widget>[],
            ),
            body: Container(
              color: Colors.red,
              child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    color: Colors.blue,
                    child: Padding(
                      padding: EdgeInsets.all(50),
                      child: Text("Hello"),
                    ),
                  ),
                  Text("Hello World"),
                ],
              ),
            )));
  }
}
