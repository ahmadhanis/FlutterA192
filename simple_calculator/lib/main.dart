import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _num1ctrl = new TextEditingController();
  TextEditingController _num2ctrl = new TextEditingController();
  int result = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Simple Calculator'),
        ),
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/mycalculator.jpg",
                  scale: 5,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                  child: TextField(
                    controller: _num1ctrl,
                    keyboardType: TextInputType.numberWithOptions(),
                    style: new TextStyle(
                        fontSize: 22.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"),
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        filled: true,
                        hintStyle: new TextStyle(color: Colors.grey[800]),
                        hintText: "Enter First Number",
                        fillColor: Colors.white70),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(),
                    style: new TextStyle(
                        fontSize: 22.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"),
                    controller: _num2ctrl,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        filled: true,
                        hintStyle: new TextStyle(color: Colors.grey[800]),
                        hintText: "Type in your text",
                        fillColor: Colors.white70),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                  child: new MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    elevation: 5.0,
                    minWidth: 200.0,
                    height: 50,
                    color: Colors.blueAccent,
                    child: new Text('ADD',
                        style:
                            new TextStyle(fontSize: 16.0, color: Colors.white)),
                    onPressed: _addOperation,
                  ),
                ),
                new Text(
                  "Result:$result",
                  style: new TextStyle(
                      fontSize: 36.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w200,
                      fontFamily: "Merriweather"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addOperation() {
    setState(() {
      int a = int.parse(_num1ctrl.text);
      int b = int.parse(_num2ctrl.text);
      result = a + b;
    });
  }
}
