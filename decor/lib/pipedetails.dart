import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PipeDetailsScreen extends StatefulWidget {
  final String pipeid, date;

  const PipeDetailsScreen({Key key, this.pipeid, this.date}) : super(key: key);

  @override
  _PipeDetailsScreenState createState() => _PipeDetailsScreenState();
}

class _PipeDetailsScreenState extends State<PipeDetailsScreen> {
  List pipedata;
  String titlecenter = "Loading Pipe Data...";
  double screenHeight, screenWidth;
  //List<charts.Series> myData;
  bool animate = false;

  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  final f2 = new DateFormat('hh:mm');

  @override
  void initState() {
    super.initState();
    _loadPipeDetails();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pipe Details (24 Hours)'),
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
                        : createChart())),
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
                  child: ListView.builder(
                  itemCount: pipedata == null ? 0 : pipedata.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.fromLTRB(20, 1, 20, 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                                flex: 2,
                                child: Text((index + 1).toString(),
                                    style: TextStyle(color: Colors.white))),
                            Expanded(
                                flex: 4,
                                child: Text(
                                    (double.parse(pipedata[index]['pressure']) *
                                            0.06)
                                        .toStringAsFixed(2),
                                    style: TextStyle(
                                      color: (int.parse(
                                                  pipedata[index]['pressure']) <
                                              300)
                                          ? Colors.red
                                          : Colors.white,
                                    ))),
                            Expanded(
                                flex: 4,
                                child: Text(
                                    f.format(DateTime.parse(
                                        pipedata[index]['date'])),
                                    style: TextStyle(color: Colors.white))),
                          ],
                        ));
                  },
                ))
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
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Widget createChart() {
    List<charts.Series<Pipe, String>> seriesList = [];

    for (int i = 0; i < pipedata.length; i += 10) {
      String id =
          f2.format(DateTime.parse(pipedata[i]['date'])); //'WZG${i + 1}';
      seriesList.add(createSeries(id, i));
    }

    return Stack(children: <Widget>[
      AnimatedPositioned(
        // use top,bottom,left and right property to set the location and Transform.rotate to rotate the widget if needed
        top: 0,
        child: Text(
          "Pressure (Psi)",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      ),
      AnimatedPositioned(
        // use top,bottom,left and right property to set the location and Transform.rotate to rotate the widget if needed
        bottom: 10,
        right: 10,
        child: Text(
          "Time",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      ),
      new charts.BarChart(
        seriesList,
        barGroupingType: charts.BarGroupingType.stacked,
        animationDuration: Duration(seconds: 1),
        behaviors: [
          new charts.SlidingViewport(),
          new charts.PanAndZoomBehavior(),
          new charts.ChartTitle(
            'Time',
            behaviorPosition: charts.BehaviorPosition.bottom,
          ),
          new charts.ChartTitle('Pressure',
              behaviorPosition: charts.BehaviorPosition.start,
              titleOutsideJustification:
                  charts.OutsideJustification.middleDrawArea)
        ],
        primaryMeasureAxis: new charts.NumericAxisSpec(
            renderSpec: new charts.GridlineRendererSpec(

                // Tick and Label styling here.
                labelStyle: new charts.TextStyleSpec(
                    fontSize: 12, // size in Pts.
                    color: charts.MaterialPalette.white),

                // Change the line colors to match text color.
                lineStyle: new charts.LineStyleSpec(
                    color: charts.MaterialPalette.white))),
        domainAxis: new charts.OrdinalAxisSpec(
            renderSpec: new charts.SmallTickRendererSpec(
                // Tick and Label styling here.
                labelStyle: new charts.TextStyleSpec(
                    fontSize: 8, // size in Pts.
                    color: charts.MaterialPalette.white),

                // Change the line colors to match text color.
                lineStyle: new charts.LineStyleSpec(
                    color: charts.MaterialPalette.black))),
      )
    ]);
  }

  charts.Series<Pipe, String> createSeries(String id, int i) {
    return charts.Series<Pipe, String>(
      id: "Pressure",
      domainFn: (Pipe time, _) => time.time,
      measureFn: (Pipe pressure, _) => pressure.pressure,
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      data: [
        Pipe(f2.format(DateTime.parse(pipedata[i]['date'])).toString(),
            double.parse(pipedata[i]['pressure']) * 0.06),
      ],
    );
  }
}

class Pipe {
  final String time;
  final double pressure;

  Pipe(this.time, this.pressure);
}
