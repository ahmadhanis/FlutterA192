import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:wfh_attendance/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:geocoder/geocoder.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() => runApp(MainScreen());

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Position _currentPosition;
  List userattlist;
  String curaddress;
  final f = new DateFormat('dd-MM-yyyy hh:mm');
  @override
  void initState() {
    super.initState();
    _loadRecord();
  }

  @override
  Widget build(BuildContext context) {
    if (userattlist == null) {

      return Scaffold(
          appBar: AppBar(
            title: Text('Record Your Attendance'),
          ),
          body: Center(
              child: Text("Record your attendance",
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              // Add your onPressed code here!
              _getCurrentLocation();
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
            tooltip: "Record your attendance",
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Record Your Attendance'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              _getCurrentLocation();
              // Add your onPressed code here!
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
            tooltip: "Record your attendance",
          ),
          body: ListView.builder(
              itemCount: userattlist == null ? 1 : userattlist.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.all(2),
                    child: Card(
                      elevation: 5,
                      child: InkWell(
                        onLongPress: () => _deleteDetail(index),
                        child: Padding(
                            padding: EdgeInsets.all(3),
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: Theme.of(context).platform ==
                                          TargetPlatform.android
                                      ? Colors.blue
                                      : Colors.blue,
                                  child: Text(
                                    userattlist[index]['id'].toString(),
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          "Record ID:" +
                                              userattlist[index]['rid'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(userattlist[index]['name'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text("Lat:" +
                                          userattlist[index]['latitude'] +
                                          "/" +
                                          "Lon:" +
                                          userattlist[index]['longitude']),
                                      Text("Date:" +
                                          f.format(DateTime.parse(
                                              userattlist[index]['date']))),
                                      Text(userattlist[index]['address']),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ));
              }));
    }
  }

  _getCurrentLocation() {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Locating...");
    pr.show();
    try {
      final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
          .timeout(Duration(seconds: 5), onTimeout: () {
        pr.dismiss();
        Toast.show(
            "Getting address timeout please check/enable your location permission",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
      }).then((Position position) {
        setState(() async {
          _currentPosition = position;
          if (_currentPosition != null) {
            final coordinates = new Coordinates(
                _currentPosition.latitude, _currentPosition.longitude);
            var addresses =
                await Geocoder.local.findAddressesFromCoordinates(coordinates);
            var first = addresses.first;
            curaddress = first.addressLine;
            print(curaddress);
            pr.dismiss();
            print("Record data");
            _recordAtt();
          }
        });
      }).catchError((e) {
        pr.dismiss();
        print(e);
      });
    } catch (exception) {
      pr.dismiss();
      print(exception.toString());
    }
  }

  _recordAtt() {
    var now = new DateTime.now();

    if (curaddress == "" || curaddress == null) {
      Toast.show("No address please wait for address and try again", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Record Your Attendance  " + f.format(now)),
            content: Container(child: Text("at " + curaddress)),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  http.post("http://slumberjer.com/wfh/insert_att.php", body: {
                    "id": widget.user.id,
                    "name": widget.user.name,
                    "latitude": _currentPosition.latitude.toString(),
                    "longitude": _currentPosition.longitude.toString(),
                    "address": curaddress,
                  }).then((res) {
                    print(res.body);
                    if (res.body == "success") {
                      curaddress = "";
                      _loadRecord();
                    } else {
                      Toast.show("Failed", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }
                  }).catchError((err) {
                    print(err);
                    Navigator.of(context).pop();
                  });
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _loadRecord() {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    pr.show();
    String urlLoadJobs = "https://slumberjer.com/wfh/load_att.php";
    http.post(urlLoadJobs, body: {
      "id": widget.user.id,
    }).then((res) {
      print(res.body);
      pr.dismiss();
      setState(() {
        var extractdata = json.decode(res.body);
        userattlist = extractdata["records"];
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }

  void _deleteDetail(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Delete Record " + userattlist[index]["rid"] + "?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Yes"),
                onPressed: () async {
                  http.post("https://slumberjer.com/wfh/delete_record.php",
                      body: {
                        "rid": userattlist[index]["rid"],
                      }).then((res) {
                    print(res.body);
                    if (res.body == "success") {
                      Toast.show("Success", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    } else {
                      Toast.show("Failed", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }
                    _loadRecord();
                  }).catchError((err) {
                    print(err);
                  });
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
