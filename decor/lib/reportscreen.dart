import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List pipedata;
  String titlecenter = "Loading Report";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  final f2 = new DateFormat('hh:mm a');

  @override
  void initState() {
    super.initState();
    _loadPipeData();
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
            padding: EdgeInsets.fromLTRB(20, 10, 20, 1),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1, // 10%
                  child: Text("ID", style: TextStyle(color: Colors.white)),
                ),
                Expanded(
                  flex: 4, // 20%
                  child:
                      Text("Location", style: TextStyle(color: Colors.white)),
                ),
                Expanded(
                  flex: 3, // 60%
                  child: Text("Pressure(psi)",
                      style: TextStyle(color: Colors.white)),
                ),
                Expanded(
                  flex: 2, // 20%
                  child:
                      Text("Date/Time", style: TextStyle(color: Colors.white)),
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
                              flex: 1,
                              child: Text(pipedata[index]['pipeid'],
                                  style: TextStyle(color: Colors.white))),
                          Expanded(
                              flex: 4,
                              child: Text(pipedata[index]['location'],
                                  style: TextStyle(color: Colors.white))),
                          Expanded(
                              flex: 3,
                              child: Text(
                                  (double.parse(pipedata[index]['latest']) *
                                          0.06)
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                    color:
                                        (int.parse(pipedata[index]['latest']) <
                                                300)
                                            ? Colors.red
                                            : Colors.white,
                                  ))),
                          Expanded(
                              flex: 2,
                              child: Text(
                                  f2.format(
                                      DateTime.parse(pipedata[index]['date'])),
                                  style: TextStyle(color: Colors.white))),
                        ],
                      ));
                },
              ))
      ])),
      floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                  child: Icon(Icons.email),
                  label: "Email Report",
                  labelBackgroundColor: Colors.white,
                  onTap: null),
              SpeedDialChild(
                  child: Icon(MdiIcons.whatsapp),
                  label: "Whatsup",
                  labelBackgroundColor: Colors.white,
                  onTap: null),
              SpeedDialChild(
                  child: Icon(MdiIcons.fileExcel),
                  label: "Excell View",
                  labelBackgroundColor: Colors.white,
                  onTap: null),
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
}
