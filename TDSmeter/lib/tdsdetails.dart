import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
//import 'package:charts_flutter/flutter.dart' as charts;
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import 'maputils.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'tds.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';

class TDSDetailsScreen extends StatefulWidget {
  final String tdsid;

  const TDSDetailsScreen({Key key, this.tdsid}) : super(key: key);

  @override
  _TDSDetailsScreenState createState() => _TDSDetailsScreenState();
}

class _TDSDetailsScreenState extends State<TDSDetailsScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List tdsdata;
  String titlecenter = "Loading Meter Details...";
  double screenHeight, screenWidth;
  //List<charts.Series> myData;
  bool animate = false;

  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  final f2 = new DateFormat('h:mm a');

  @override
  void initState() {
    super.initState();
    _loadTDSDetails();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Meter Details (24 Hours)'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
            onPressed: () {
              _onImageDisplay();
            },
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: Icon(MdiIcons.filePdf),
              label: "PDF View",
              labelBackgroundColor: Colors.white,
              onTap: null),
        ],
      ),
      body: Container(
        child: Column(children: <Widget>[
          Container(
            height: screenHeight / 2.5,
            width: screenWidth / 1,
            child: Card(
                elevation: 10,
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: tdsdata == null
                        ? Center(
                            child: Text(
                            "Loading chart..",
                            style: TextStyle(color: Colors.white),
                          ))
                        : createLineChart())),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(20, 1, 20, 1),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1, // 20%
                    child: Text("Bil", style: TextStyle(color: Colors.white)),
                  ),
                  Expanded(
                    flex: 2, // 20%
                    child:
                        Text("Temp(°C)", style: TextStyle(color: Colors.white)),
                  ),
                  Expanded(
                    flex: 3, // 60%
                    child: Text("PPM", style: TextStyle(color: Colors.white)),
                  ),
                  Expanded(
                    flex: 4, // 20%
                    child: Text("Date/Time",
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              )),
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
                  child: RefreshIndicator(
                      key: refreshKey,
                      color: Color.fromRGBO(101, 255, 218, 50),
                      onRefresh: () async {
                        _loadTDSDetails();
                      },
                      child: ListView.builder(
                        itemCount: tdsdata == null ? 0 : tdsdata.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.fromLTRB(20, 1, 20, 1),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                      flex: 1,
                                      child: Text((index + 1).toString(),
                                          style:
                                              TextStyle(color: Colors.white))),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                          tdsdata[index]['temp'].toString(),
                                          style:
                                              TextStyle(color: Colors.white))),
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                          (double.parse(tdsdata[index]['tds']))
                                              .toStringAsFixed(2),
                                          style: TextStyle(
                                            color: (double.parse(
                                                        tdsdata[index]['tds']) <
                                                    5)
                                                ? Colors.red
                                                : Colors.white,
                                          ))),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                          f.format(DateTime.parse(
                                              tdsdata[index]['date'])),
                                          style:
                                              TextStyle(color: Colors.white))),
                                ],
                              ));
                        },
                      )))
        ]),
      ),
    );
  }

  Future<void> _loadTDSDetails() async {
    String urlLoadJobs = "https://slumberjer.com/tdsmeter/load_tds_details.php";
    await http.post(urlLoadJobs, body: {
      "tdsid": widget.tdsid,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          tdsdata = null;
          titlecenter = "TDS data not found";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          tdsdata = extractdata["tdsdetails"];
          Toast.show("Success.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Widget createLineChart() {
    List<double> data1 = new List();
    double high = 0;
    double low = 0;
    String datestart = "";
    String dateend = "";
    if (tdsdata.length > 0) {
      low = double.parse(tdsdata[0]['tds']);
      for (int i = 0; i < tdsdata.length; i++) {
        var data = double.parse(tdsdata[i]['tds']);
        data1.add(data);
        if (data > high) {
          high = data;
        }
        if (data < low) {
          low = data;
        }
        if (i == 0) {
          datestart =
              (f2.format(DateTime.parse(tdsdata[i]['date']))).toString();
        }
        if (i < tdsdata.length) {
          dateend = (f2.format(DateTime.parse(tdsdata[i]['date']))).toString();
        }
      }
    }
    return Stack(children: <Widget>[
      Text(high.toString() + " ppm", style: TextStyle(color: Colors.white)),
      Padding(
          padding: EdgeInsets.all(20.0),
          child: new Sparkline(
            data: data1,
            fillMode: FillMode.below,
            fillGradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.red[800], Colors.red[200]],
            ),
          )),
      Positioned(
        bottom: 20,
        left: 5,
        child: Text(low.toString() + " ppm",
            style: TextStyle(color: Colors.white)),
      ),
      Positioned(
        bottom: 5,
        left: 5,
        child: Text(datestart, style: TextStyle(color: Colors.white)),
      ),
      Positioned(
        bottom: 5,
        right: 20,
        child: Text(dateend, style: TextStyle(color: Colors.white)),
      )
    ]);
  }

  _onImageDisplay() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Center(child: Text("TDS ID:" + widget.tdsid)),
            content: new Container(
              color: Colors.white,
              //height: screenHeight / 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: screenWidth / 1.5,
                      width: screenWidth / 1.5,
                      child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: "http://slumberjer.com" +
                              "/tdsmeter/tdsimages/${widget.tdsid}.jpg")),
                  Divider(
                    color: Colors.grey,
                    thickness: 2,
                  ),
                ],
              ),
            ));
      },
    );
  }
}

class ThisTDS {
  final String time;
  final double tdsval;
  ThisTDS(this.time, this.tdsval);
}
