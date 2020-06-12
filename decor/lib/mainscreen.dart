import 'dart:convert';
import 'package:decor/mapscreen.dart';
import 'package:decor/reportscreen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gauge/flutter_gauge.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'newpipescreen.dart';
import 'pipedetails.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List pipedata;
  String titlecenter = "Loading Pipes...";
  double screenHeight, screenWidth;
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  bool status;
  @override
  void initState() {
    super.initState();
    _loadPipeData();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            title: Text('List of Pipes'),
          ),
          body: RefreshIndicator(
              key: refreshKey,
              color: Color.fromRGBO(101, 255, 218, 50),
              onRefresh: () async {
                _loadPipeData();
              },
              child: Container(
                child: Column(
                  children: <Widget>[
                    pipedata == null
                        ? Flexible(
                            child: Container(
                                child: Center(
                                    child: Text(
                            titlecenter,
                            style: TextStyle(
                                color: Color.fromRGBO(101, 255, 218, 50),
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ))))
                        : Expanded(
                            child: GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio:
                                    (screenHeight / screenWidth) * 0.6,
                                children:
                                    List.generate(pipedata.length, (index) {
                                  return Container(
                                      child: InkWell(
                                    onTap: () => onPipeDetailDialog(index),
                                    onLongPress: () async {
                                      await onPipeDeleteDialog(index);
                                      _loadPipeData();
                                    },
                                    child: Card(
                                        color: (int.parse(
                                                    pipedata[index]['latest']) <
                                                300)
                                            ? Colors.red
                                            : Colors.blueGrey,
                                        elevation: 10,
                                        child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                      pipedata[index]
                                                              ['pipeid'] +
                                                          "/" +
                                                          pipedata[index]
                                                              ['location'],
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white)),
                                                  Container(
                                                      height: 105,
                                                      //color: Colors.black38,
                                                      child: FlutterGauge(
                                                        inactiveColor:
                                                            Colors.white38,
                                                        activeColor:
                                                            Colors.green,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        handSize: 20,
                                                        index: (double.parse(
                                                                pipedata[index][
                                                                    'latest']) *
                                                            0.06),
                                                        fontFamily: "Iran",
                                                        end: 120,
                                                        number:
                                                            Number.endAndStart,
                                                        textStyle: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        secondsMarker:
                                                            SecondsMarker
                                                                .minutes,
                                                        isCircle: false,
                                                        hand: Hand.none,
                                                        counterAlign:
                                                            CounterAlign.center,
                                                        counterStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                        isDecimal: false,
                                                      )),
                                                  SizedBox(height: 5),
                                                  Text(
                                                      f.format(DateTime.parse(
                                                          pipedata[index]
                                                              ['date'])),
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ]))),
                                  ));
                                })))
                  ],
                ),
              )),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                  child: Icon(Icons.open_in_new),
                  label: "New Pipe",
                  labelBackgroundColor: Colors.white,
                  onTap: newPipeDialog),
              SpeedDialChild(
                  child: Icon(Icons.map),
                  label: "Map View",
                  labelBackgroundColor: Colors.white,
                  onTap: loadPipeMap),
              SpeedDialChild(
                  child: Icon(Icons.pageview),
                  label: "Report View",
                  labelBackgroundColor: Colors.white,
                  onTap: loadReport),
            ],
          ),
        ));
  }

  void onPipeDetailDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Show Pipe " + pipedata[index]['pipeid'] + " details?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PipeDetailsScreen(
                              pipeid: pipedata[index]['pipeid'],
                              date: pipedata[index]['date'],
                            )));
                _loadPipeData();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _loadPipeData() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Loading pipes...");
    pr.show();
    String urlLoadJobs = "https://slumberjer.com/decor/load_pipes.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      print(res.body);
      pr.hide();
      if (res.body == "nodata") {
        setState(() {
          pipedata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          pipedata = extractdata["pipes"];
          print(pipedata);
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void newPipeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Register new Pipe?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => NewPipeScreen()));
                _loadPipeData();
              },
            ),
            new FlatButton(
              child: new Text(
                "Tidak",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Do you want to exit Decor?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: new Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
            ],
          ),
        ) ??
        false;
  }

  onPipeDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Delete Pipe " + pipedata[index]['pipeid'],
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _deletePipe(index);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePipe(int index) async {
    String urlLoadJobs = "https://slumberjer.com/decor/delete_pipe.php";
    await http.post(urlLoadJobs,
        body: {"pipeid": pipedata[index]['pipeid']}).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Success.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Failed.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> loadPipeMap() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => MapScreen()));
    _loadPipeData();
  }

  Future<void> loadReport() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => ReportScreen()));
    _loadPipeData();
  }
}
