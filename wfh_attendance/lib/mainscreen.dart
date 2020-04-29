import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:wfh_attendance/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:geocoder/geocoder.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:date_util/date_util.dart';

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
  String curaddress, selectedMonth, selectedYear;
  double screenHeight, screenWidth;
  String curmonth, curyear, titlecenter = "Location Based Attendance";

  final fa = new DateFormat('dd');
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var dateUtility;
  var numdaymonth;

  List<String> monthlist = [
    "January",
    "Febuary",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  List<String> yearlist = [
    "2020",
    "2021",
    "2022",
    "2023",
    "2024",
    "2025",
    "2026",
    "2027",
  ];
  List days = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '24',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31'
  ];

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    dateUtility = new DateUtil();

    curmonth = now.month.toString();
    curyear = now.year.toString();
    numdaymonth = dateUtility.daysInMonth(now.month, now.year);
    print(curmonth);
    print(curyear);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadRecord(curmonth, curyear));
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Your Attendance',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _getCurrentLocation();
          // Add your onPressed code here!
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(101, 255, 218, 50),
        tooltip: "Record your attendance",
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Text("Your Attendance: " + widget.user.name,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Text("Month: " + curmonth,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              Container(
                child: Text("Year: " + curyear,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              userattlist == null
                  ? Text("")
                  : Container(
                      child: Text(
                          userattlist.length.toString() +
                              "/" +
                              numdaymonth.toString(),
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
            ],
          ),
          Card(
            elevation: 5,
            child: Container(
              height: screenHeight / 14,
              margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 40,
                    child: DropdownButton(
                      //sorting dropdownoption
                      hint: Text(
                        'Month',
                        style: TextStyle(
                          color: Color.fromRGBO(101, 255, 218, 50),
                        ),
                      ), // Not necessary for Option 1
                      value: selectedMonth,
                      onChanged: (newValue) {
                        setState(() {
                          selectedMonth = newValue;
                          print(selectedMonth);
                        });
                      },
                      items: monthlist.map((selectedMonth) {
                        return DropdownMenuItem(
                          child: new Text(selectedMonth,
                              style: TextStyle(
                                  color: Color.fromRGBO(101, 255, 218, 50))),
                          value: selectedMonth,
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    height: 40,
                    child: DropdownButton(
                      //sorting dropdownoption
                      hint: Text(
                        'Year',
                        style: TextStyle(
                          color: Color.fromRGBO(101, 255, 218, 50),
                        ),
                      ), // Not necessary for Option 1
                      value: selectedYear,
                      onChanged: (newValue) {
                        setState(() {
                          selectedYear = newValue;
                          print(selectedYear);
                        });
                      },
                      items: yearlist.map((selectedYear) {
                        return DropdownMenuItem(
                          child: new Text(selectedYear,
                              style: TextStyle(
                                  color: Color.fromRGBO(101, 255, 218, 50))),
                          value: selectedYear,
                        );
                      }).toList(),
                    ),
                  ),
                  MaterialButton(
                      color: Color.fromRGBO(101, 255, 218, 50),
                      onPressed: () => {
                            changeAtt(selectedMonth, selectedYear),
                          },
                      elevation: 5,
                      child: Text(
                        "Search",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ),
            ),
          ),
          userattlist == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ))))
              : Flexible(
                  child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (screenWidth / screenHeight) / 0.65,
                  children: List.generate(userattlist.length, (index) {
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
                                      backgroundColor: Theme.of(context)
                                                  .platform ==
                                              TargetPlatform.android
                                          ? Color.fromRGBO(101, 255, 218, 50)
                                          : Color.fromRGBO(101, 255, 218, 50),
                                      child: Text(
                                        fa.format(DateTime.parse(
                                            userattlist[index]['date'])),
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
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          Text(
                                              "Lat:" +
                                                  userattlist[index]
                                                      ['latitude'] +
                                                  "/" +
                                                  "Lon:" +
                                                  userattlist[index]
                                                      ['longitude'],
                                              style: TextStyle(
                                                color: Colors.white,
                                              )),
                                          Text(
                                              "Date:" +
                                                  f.format(
                                                    DateTime.parse(
                                                        userattlist[index]
                                                            ['date']),
                                                  ),
                                              style: TextStyle(
                                                color: Colors.white,
                                              )),
                                          Text(userattlist[index]['address'],
                                              style: TextStyle(
                                                color: Colors.white,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ));
                  }),
                ))
        ],
      ),
    );
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
            title: new Text("Record Your Attendance  " + f.format(now),
                style: TextStyle(
                  color: Colors.white,
                )),
            content: Container(
              child: Text(
                "at " + curaddress,
                style: TextStyle(
                  color: Colors.white,
                ),
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
                      _loadRecord(curmonth, curyear);
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
        });
  }

  void _loadRecord(String month, String year) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Loading...");
    pr.show();
    String urlLoadJobs = "https://slumberjer.com/wfh/load_att.php";
    http.post(urlLoadJobs, body: {
      "id": widget.user.id,
      "month": month,
      "year": year,
    }).then((res) {
      print(res.body);
      pr.dismiss();
      setState(() {
        if (res.body == "nodata") {
          userattlist = null;
          Toast.show("No records", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          titlecenter = "No records found";
        } else {
          var extractdata = json.decode(res.body);
          userattlist = extractdata["records"];
        }
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
            title: new Text(
              "Delete Record " + userattlist[index]["rid"] + "?",
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
                    _loadRecord(curmonth, curyear);
                  }).catchError((err) {
                    print(err);
                  });
                  Navigator.of(context).pop();
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
        });
  }

  changeAtt(String selectedMonth, String selectedYear) {
    if (selectedMonth == null) {
      Toast.show("Please select month", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (selectedMonth == "January") {
      selectedMonth = "1";
    }
    if (selectedMonth == "Febuary") {
      selectedMonth = "2";
    }
    if (selectedMonth == "March") {
      selectedMonth = "3";
    }
    if (selectedMonth == "April") {
      selectedMonth = "4";
    }
    if (selectedMonth == "May") {
      selectedMonth = "5";
    }
    if (selectedMonth == "June") {
      selectedMonth = "6";
    }
    if (selectedMonth == "July") {
      selectedMonth = "7";
    }
    if (selectedMonth == "August") {
      selectedMonth = "8";
    }
    if (selectedMonth == "September") {
      selectedMonth = "9";
    }
    if (selectedMonth == "October") {
      selectedMonth = "10";
    }
    if (selectedMonth == "November") {
      selectedMonth = "11";
    }
    if (selectedMonth == "December") {
      selectedMonth = "12";
    }

    if (selectedYear == null) {
      Toast.show("Please select year", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    setState(() {
      curyear = selectedYear;
      curmonth = selectedMonth;
    });

    _loadRecord(selectedMonth, selectedYear);
  }
}
