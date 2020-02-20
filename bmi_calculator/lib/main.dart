import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _heightctrl = new TextEditingController();
  TextEditingController _weightctrl = new TextEditingController();
  String bmi = "";
  AudioCache audioCache = new AudioCache();
  AudioPlayer audioPlayer = new AudioPlayer();
  String img = "assets/images/bmilalai.jpg";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('BMI Calculator'),
        ),
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  img,
                  scale: 5,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                  child: TextField(
                    controller: _heightctrl,
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
                        hintText: "Height (cm)",
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
                    controller: _weightctrl,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        filled: true,
                        hintStyle: new TextStyle(color: Colors.grey[800]),
                        hintText: "Weight (kg)",
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
                    color: Colors.greenAccent,
                    child: new Text('CALCULATE BMI',
                        style:
                            new TextStyle(fontSize: 16.0, color: Colors.black)),
                    onPressed: _bmiOperation,
                  ),
                ),
                new Text(
                  "Result:$bmi",
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

  void _bmiOperation() {
    setState(() {
      double h = double.parse(_heightctrl.text);
      double w = double.parse(_weightctrl.text);
      double result = (w * w) / h;
      print(result);
      bmi = format(result);
      if (result > 25) {
        img = "assets/images/bmilebih.jpg";
        loadFail();
      } else if ((result <= 24.9) && (result >= 18.5)) {
        img = "assets/images/bmibiasa.jpg";
        loadOk();
      } else if (result < 18.5) {
        img = "assets/images/bmikurang.jpg";
        loadFail();
      }
    });
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  Future loadOk() async {
    audioPlayer = await AudioCache().play("audio/ok.wav");
  }

  Future loadFail() async {
    audioPlayer = await AudioCache().play("audio/fail.wav");
  }

  @override
  void dispose() {
    audioPlayer = null;
    super.dispose();
  }
}
