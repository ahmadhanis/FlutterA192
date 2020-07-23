import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
//import 'package:charts_flutter/flutter.dart' as charts;
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'maputils.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'pipe.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';

class PipeDetailsScreen extends StatefulWidget {
  final String pipeid, date, location, details, longitude, latitude;

  const PipeDetailsScreen(
      {Key key,
      this.pipeid,
      this.date,
      this.location,
      this.details,
      this.longitude,
      this.latitude})
      : super(key: key);

  @override
  _PipeDetailsScreenState createState() => _PipeDetailsScreenState();
}

class _PipeDetailsScreenState extends State<PipeDetailsScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List pipedata;
  String titlecenter = "Loading Pipe Data...";
  double screenHeight, screenWidth;
  //List<charts.Series> myData;
  bool animate = false;

  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  final f2 = new DateFormat('h:mm a');

  @override
  void initState() {
    super.initState();
    _loadPipeDetails();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pipe Details (24 Hours)'),
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
              onTap: ceatePdf),
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
                    child: pipedata == null
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
                    flex: 2, // 20%
                    child: Text("Bil", style: TextStyle(color: Colors.white)),
                  ),
                  Expanded(
                    flex: 4, // 60%
                    child: Text("Pressure (psi)",
                        style: TextStyle(color: Colors.white)),
                  ),
                  Expanded(
                    flex: 4, // 20%
                    child: Text("Date/Time",
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              )),
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
                  child: RefreshIndicator(
                      key: refreshKey,
                      color: Color.fromRGBO(101, 255, 218, 50),
                      onRefresh: () async {
                        _loadPipeDetails();
                      },
                      child: ListView.builder(
                        itemCount: pipedata == null ? 0 : pipedata.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.fromLTRB(20, 1, 20, 1),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                      flex: 2,
                                      child: Text((index + 1).toString(),
                                          style:
                                              TextStyle(color: Colors.white))),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                          (double.parse(
                                                  pipedata[index]['pressure']))
                                              .toStringAsFixed(2),
                                          style: TextStyle(
                                            color: (double.parse(pipedata[index]
                                                        ['pressure']) <
                                                    5)
                                                ? Colors.red
                                                : Colors.white,
                                          ))),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                          f.format(DateTime.parse(
                                              pipedata[index]['date'])),
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

  Future<void> _loadPipeDetails() async {
    String urlLoadJobs = "https://slumberjer.com/decor/load_pipe_details.php";
    await http.post(urlLoadJobs, body: {
      "pipeid": widget.pipeid,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          pipedata = null;
          titlecenter = "Pipe data not found";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          pipedata = extractdata["pipes"];
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
    String datestart = "";
    String dateend = "";
    for (int i = 0; i < pipedata.length; i++) {
      var data = double.parse(pipedata[i]['pressure']);
      data1.add(data);
      if (data > high) {
        high = data;
      }
      if (i == 0) {
        datestart = (f2.format(DateTime.parse(pipedata[i]['date']))).toString();
      }
      if (i < pipedata.length) {
        dateend = (f2.format(DateTime.parse(pipedata[i]['date']))).toString();
      }
    }
    return Stack(children: <Widget>[
      Text(high.toString() + " Psi", style: TextStyle(color: Colors.white)),
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
        child: Text("0 Psi", style: TextStyle(color: Colors.white)),
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

  // Widget createChart() {
  //   List<charts.Series<ThisPipe, String>> seriesList = [];
  //   int len;
  //   if (pipedata.length > 15) {
  //     len = 10;
  //   } else {
  //     len = 2;
  //   }
  //   for (int i = 0; i < pipedata.length; i += len) {
  //     String id =
  //         f2.format(DateTime.parse(pipedata[i]['date'])); //'WZG${i + 1}';
  //     seriesList.add(createSeries(id, i));
  //   }

  //   return Stack(children: <Widget>[
  //     AnimatedPositioned(
  //       // use top,bottom,left and right property to set the location and Transform.rotate to rotate the widget if needed
  //       top: 0,
  //       child: Text(
  //         "Pressure (Psi)",
  //         style: TextStyle(color: Colors.white),
  //       ),
  //       duration: Duration(seconds: 3),
  //     ),
  //     AnimatedPositioned(
  //       // use top,bottom,left and right property to set the location and Transform.rotate to rotate the widget if needed
  //       bottom: 10,
  //       right: 10,
  //       child: Text(
  //         "Time",
  //         style: TextStyle(color: Colors.white),
  //       ),
  //       duration: Duration(seconds: 3),
  //     ),
  //     AnimatedPositioned(
  //       // use top,bottom,left and right property to set the location and Transform.rotate to rotate the widget if needed
  //       bottom: 10,
  //       left: 10,
  //       child: Text(
  //         widget.pipeid + "/" + widget.location,
  //         style: TextStyle(color: Colors.white),
  //       ),
  //       duration: Duration(seconds: 3),
  //     ),
  //     new charts.BarChart(
  //       seriesList,
  //       barGroupingType: charts.BarGroupingType.stacked,
  //       animationDuration: Duration(seconds: 1),
  //       behaviors: [
  //         new charts.SlidingViewport(),
  //         new charts.PanAndZoomBehavior(),
  //         new charts.ChartTitle(
  //           'Time',
  //           behaviorPosition: charts.BehaviorPosition.bottom,
  //         ),
  //         new charts.ChartTitle('Pressure',
  //             behaviorPosition: charts.BehaviorPosition.start,
  //             titleOutsideJustification:
  //                 charts.OutsideJustification.middleDrawArea)
  //       ],
  //       primaryMeasureAxis: new charts.NumericAxisSpec(
  //           renderSpec: new charts.GridlineRendererSpec(

  //               // Tick and Label styling here.
  //               labelStyle: new charts.TextStyleSpec(
  //                   fontSize: 12, // size in Pts.
  //                   color: charts.MaterialPalette.white),

  //               // Change the line colors to match text color.
  //               lineStyle: new charts.LineStyleSpec(
  //                   color: charts.MaterialPalette.white))),
  //       domainAxis: new charts.OrdinalAxisSpec(
  //           renderSpec: new charts.SmallTickRendererSpec(
  //               // Tick and Label styling here.
  //               labelStyle: new charts.TextStyleSpec(
  //                   fontSize: 8, // size in Pts.
  //                   color: charts.MaterialPalette.white),

  //               // Change the line colors to match text color.
  //               lineStyle: new charts.LineStyleSpec(
  //                   color: charts.MaterialPalette.black))),
  //     )
  //   ]);
  // }

  // charts.Series<ThisPipe, String> createSeries(String id, int i) {
  //   return charts.Series<ThisPipe, String>(
  //     id: "Pressure",
  //     domainFn: (ThisPipe time, _) => time.time,
  //     measureFn: (ThisPipe pressure, _) => pressure.pressure,
  //     colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
  //     data: [
  //       ThisPipe(f2.format(DateTime.parse(pipedata[i]['date'])).toString(),
  //           double.parse(pipedata[i]['pressure'])),
  //     ],
  //   );
  // }

  _onImageDisplay() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Center(child: Text("Pipe ID:" + widget.pipeid)),
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
                          imageUrl: "http://slumberjer.com/decor" +
                              "/pipeimages/${widget.pipeid}.jpg")),
                  Divider(
                    color: Colors.grey,
                    thickness: 2,
                  ),
                  GestureDetector(
                      onTap: () => MapUtils.openMap(
                          double.parse(widget.latitude),
                          double.parse(widget.longitude)),
                      child: Text("Location (click):" + widget.location)),
                  Text("Details:" + widget.details)
                ],
              ),
            ));
      },
    );
  }

  Future<void> ceatePdf() async {
    const tableHeaders = ['Bil#', 'Psi', 'Date/Time'];
    final pipelist = <Pipe>[];

    for (int i = 0; i < pipedata.length; i++) {
      pipelist.add(new Pipe(
          (i + 1).toString(),
          pipedata[i]['pressure'],
          (f.format(DateTime.parse(pipedata[i]['date'])).toString()),
          "",
          "",
          "",
          "",
          ""));
    }
    print("PDF");
    final doc = pw.Document();

    doc.addPage(pw.MultiPage(build: (pw.Context context) {
      return <pw.Widget>[
        pw.Header(
            level: 0,
            child: pw.Text("UUM Pipe Management Report (24 Hours)",
                style: pw.TextStyle(fontSize: 16))),
        pw.Text("Pipe ID:" + widget.pipeid),
        pw.Text("Location:" + widget.location),
        pw.Table.fromTextArray(
          border: null,
          cellAlignment: pw.Alignment.centerLeft,
          headerDecoration: pw.BoxDecoration(
            borderRadius: 2,
          ),
          headerHeight: 25,
          cellHeight: 30,
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            //3: pw.Alignment.centerLeft,
            // 4: pw.Alignment.centerLeft,
          },
          headerStyle: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
          ),
          cellStyle: const pw.TextStyle(
            fontSize: 10,
          ),
          rowDecoration: pw.BoxDecoration(
            border: pw.BoxBorder(
              bottom: true,
              width: .5,
            ),
          ),
          headers: List<String>.generate(
            tableHeaders.length,
            (col) => tableHeaders[col],
          ),
          data: List<List<String>>.generate(
            pipedata.length,
            (row) => List<String>.generate(
              tableHeaders.length,
              (col) => pipelist[row].getIndex(col),
            ),
          ),
        )
      ];
    }));
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/pipe_report.pdf');
    file.writeAsBytesSync(doc.save());
    print(file.toString());
    OpenFile.open('${directory.path}/pipe_report.pdf');
  }
}

class ThisPipe {
  final String time;
  final double pressure;

  ThisPipe(this.time, this.pressure);
}
