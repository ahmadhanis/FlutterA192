import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_gauge/flutter_gauge.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'newtdsscreen.dart';
import 'tdsdetails.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List tdsdata;
  String titlecenter = "Loading TDS Meters...";
  double screenHeight, screenWidth;
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  bool status;
  final List<int> _mindiff = <int>[];

  @override
  void initState() {
    super.initState();
    _loadTDSData();
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
            title: Text('List of TDS Meters'),
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Logout'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(
                        choice,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          body: RefreshIndicator(
              key: refreshKey,
              color: Color.fromRGBO(101, 255, 218, 50),
              onRefresh: () async {
                _loadTDSData();
              },
              child: Container(
                child: Column(
                  children: <Widget>[
                    tdsdata == null
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
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 1.3),
                                children:
                                    List.generate(tdsdata.length, (index) {
                                  return Container(
                                      child: InkWell(
                                    onTap: () => onTDSDetailDialog(index),
                                    onLongPress: () => _onDelete(index),
                                    child: Card(
                                        color: (double.parse(
                                                    tdsdata[index]['latest']) <
                                                5)
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
                                                    tdsdata[index]['tdsid'] +
                                                        "/" +
                                                        tdsdata[index]['desc'],
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
                                                      activeColor: Colors.green,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      handSize: 20,
                                                      index: double.parse(
                                                          tdsdata[index]
                                                              ['latest']),
                                                      //fontFamily: "Iran",
                                                      end: 3500,
                                                      number:
                                                          Number.endAndStart,
                                                      textStyle: TextStyle(
                                                          color: Colors.white),

                                                      isCircle: false,
                                                      hand: Hand.short,
                                                      counterAlign:
                                                          CounterAlign.center,
                                                      counterStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                      isDecimal: false,
                                                    )),
                                                SizedBox(height: 25),
                                                Text(
                                                    f.format(DateTime.parse(
                                                        tdsdata[index]
                                                            ['date'])),
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                Text(
                                                    tdsdata[index]
                                                            ['templatest'] +
                                                        " °C",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                (_mindiff[index] <
                                                        int.parse(tdsdata[index]
                                                                ['delay']) /
                                                            60)
                                                    ? Text("Sensor:Ok",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .greenAccent))
                                                    : Text("Sensor:Timeout",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.yellow)),
                                              ],
                                            ))),
                                  ));
                                })),
                          ),
                  ],
                ),
              )),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                  child: Icon(Icons.open_in_new),
                  label: "New TDS Meter",
                  labelBackgroundColor: Colors.white,
                  onTap: newTDSDialog),
            ],
          ),
        ));
  }

  void onTDSDetailDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Show Meter " + tdsdata[index]['tdsid'] + " details?",
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
                      builder: (BuildContext context) => TDSDetailsScreen(
                        tdsid: tdsdata[index]['tdsid'],
                      ),
                    ));
                _loadTDSData();
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

  void _loadTDSData() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Loading TDSMeters...");
    pr.show();
    String urlLoadJobs = "https://slumberjer.com/tdsmeter/load_tds.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      print(res.body);
      if (pr.isShowing()) {
        pr.hide();
      }
      //pr.hide();
      if (res.body == "nodata") {
        setState(() {
          tdsdata = null;
        });
      } else {
        _mindiff.clear();
        setState(() {
          var extractdata = json.decode(res.body);
          tdsdata = extractdata["tdsmeters"];
          final date2 = DateTime.now();
          for (int i = 0; i < tdsdata.length; i++) {
            final date1 = DateTime.parse(tdsdata[i]["date"]);
            final difference = date2.difference(date1).inMinutes;
            _mindiff.insert(i, difference);
          }
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void newTDSDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Register new TDS Meter?",
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
                        builder: (BuildContext context) => NewTDSScreen()));
                _loadTDSData();
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

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Do you want to exit TDS Meter?',
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

  onTdsDeleteDialog(int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Delete TDS Meter " + tdsdata[index]['tdsid'],
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
                _deleteTDSmeter(index);
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

  Future<void> _deleteTDSmeter(int index) async {
    String urlLoadJobs = "https://slumberjer.com/tdsmeter/delete_tds.php";
    await http.post(urlLoadJobs, body: {"tdsid": tdsdata[index]['tdsid']}).then(
        (res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Success.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadTDSData();
      } else {
        Toast.show("Failed.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> _onDelete(int index) async {
    await onTdsDeleteDialog(index);
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        _onBackPressed();
        break;
    }
  }
}
