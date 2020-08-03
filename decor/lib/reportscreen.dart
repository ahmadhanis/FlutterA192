import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import 'pipe.dart';
import 'pipedetails.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List pipedata;
  String titlecenter = "Loading Report";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  final f2 = new DateFormat('hh:mm a');
  final List<int> _mindiff = <int>[];

  @override
  void initState() {
    super.initState();
    _loadPipeData();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
      ),
      body: Container(
          child: Column(children: <Widget>[
        SizedBox(height: 10),
        Text("UUM PIPE Management Report",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        Text(f.format((DateTime.now())),
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        Divider(
          color: Colors.blueGrey,
          height: 5,
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 1),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1, // 10%
                  child: Text("ID", style: TextStyle(color: Colors.white)),
                ),
                Expanded(
                  flex: 2, // 20%
                  child:
                      Text("Location", style: TextStyle(color: Colors.white)),
                ),
                Expanded(
                  flex: 1, // 60%
                  child: Text("Psi", style: TextStyle(color: Colors.white)),
                ),
                Expanded(
                  flex: 3, // 20%
                  child:
                      Text("Date/Time", style: TextStyle(color: Colors.white)),
                ),
                Expanded(
                  flex: 1, // 20%
                  child: Text("Sensor", style: TextStyle(color: Colors.white)),
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
                      _loadPipeData();
                    },
                    child: ListView.builder(
                      itemCount: pipedata == null ? 0 : pipedata.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () => onPipeDetailDialog(index),
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Text(pipedata[index]['pipeid'],
                                            style: TextStyle(
                                                color: Colors.white))),
                                    Expanded(
                                        flex: 2,
                                        child: Text(pipedata[index]['location'],
                                            style: TextStyle(
                                                color: Colors.white))),
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                            (double.parse(
                                                    pipedata[index]['latest']))
                                                .toStringAsFixed(2),
                                            style: TextStyle(
                                              color: (double.parse(
                                                          pipedata[index]
                                                              ['latest']) <
                                                      5)
                                                  ? Colors.red
                                                  : Colors.white,
                                            ))),
                                    Expanded(
                                        flex: 3,
                                        child: Text(
                                            f.format(DateTime.parse(
                                                pipedata[index]['date'])),
                                            style: TextStyle(
                                                color: Colors.white))),
                                    Expanded(
                                      flex: 1,
                                      child: (_mindiff[index] <
                                              int.parse(pipedata[index]
                                                      ['delay']) /
                                                  60)
                                          ? Text("OK",
                                              style: TextStyle(
                                                  color: Colors.white))
                                          : Text("TO",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                    ),
                                  ],
                                )));
                      },
                    )))
      ])),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: Icon(MdiIcons.refreshCircle),
              label: "Refresh Data",
              labelBackgroundColor: Colors.white,
              onTap: _loadPipeData),
          SpeedDialChild(
              child: Icon(MdiIcons.filePdf),
              label: "PDF View",
              labelBackgroundColor: Colors.white,
              onTap: ceatePdf),
        ],
      ),
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
      if (pr.isShowing()) {
        pr.hide();
      }

      if (res.body == "nodata") {
        setState(() {
          pipedata = null;
        });
      } else {
        setState(() {
          _mindiff.clear();
          var extractdata = json.decode(res.body);
          pipedata = extractdata["pipes"];
          print("Pipedata:");
          print(pipedata);
          final date2 = DateTime.now();
          for (int i = 0; i < pipedata.length; i++) {
            final date1 = DateTime.parse(pipedata[i]["date"]);
            final difference = date2.difference(date1).inMinutes;
            _mindiff.insert(i, difference);
          }
          Toast.show("Success.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> ceatePdf() async {
    const tableHeaders = [
      'ID#',
      'Location',
      'Psi',
      'Date/Time',
      'Sensor',
      'Description',
    ];
    final pipelist = <Pipe>[];

    for (int i = 0; i < pipedata.length; i++) {
      String status;
      if (_mindiff[i] < int.parse(pipedata[i]['delay'])) {
        status = "OK";
      } else {
        status = "TO";
      }
      pipelist.add(new Pipe(
          pipedata[i]['pipeid'],
          pipedata[i]['location'],
          pipedata[i]['latest'],
          (f.format(DateTime.parse(pipedata[i]['date'])).toString()),
          status,
          pipedata[i]['desc'],
          "",
          ""));
    }
    print("TEST:" + pipelist[0].description);

    //print("PDF");
    final doc = pw.Document();

    doc.addPage(pw.MultiPage(build: (pw.Context context) {
      return <pw.Widget>[
        pw.Header(
            level: 0,
            child: pw.Text("UUM Pipe Management Report",
                style: pw.TextStyle(fontSize: 16.0))),
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
            3: pw.Alignment.centerLeft,
            4: pw.Alignment.centerLeft,
            5: pw.Alignment.centerLeft,
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
            pipelist.length,
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
                        location: pipedata[index]['location'],
                        details: pipedata[index]['desc'],
                        latitude: pipedata[index]['latitude'],
                        longitude: pipedata[index]['longitude'],
                      ),
                    ));
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
}
