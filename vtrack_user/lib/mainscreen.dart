import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:vtrack_user/routescreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  ProgressDialog pr;
  List routelist;
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    return Scaffold(
        appBar: AppBar(
          title: Text('ROUTE SELECTION'),
        ),
        body: RefreshIndicator(
          key: refreshKey,
          color: Color.fromRGBO(101, 255, 218, 50),
          onRefresh: () async {
            _loadData();
          },
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: <Widget>[
                Text("Please select your route",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                routelist == null
                    ? Flexible(
                        child: Container(
                            child: Center(
                                child: Text(
                        "No Route Loaded",
                        style: TextStyle(
                            color: Color.fromRGBO(101, 255, 218, 50),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ))))
                    : Flexible(
                        child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio:
                                (screenWidth / screenHeight) / 0.5,
                            children: List.generate(routelist.length, (index) {
                              index -= 0;
                              return Padding(
                                  padding: EdgeInsets.all(1),
                                  child: Card(
                                      elevation: 5,
                                      child: Column(children: <Widget>[
                                        InkWell(
                                          onTap: () => {loadRouteScreen(index)},
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              children: <Widget>[
                                                Center(),
                                                CircleAvatar(
                                                  maxRadius: screenWidth / 16,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                                  .platform ==
                                                              TargetPlatform
                                                                  .android
                                                          ? Colors.blue
                                                          : Colors.blue,
                                                  child: Text(
                                                    routelist[index]['routeid'],
                                                    style: TextStyle(
                                                        fontSize: 20.0,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  routelist[index]
                                                      ["description"],
                                                  overflow: TextOverflow.clip,
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  "Bus available: " +
                                                      routelist[index]["busnum"]
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ])));
                            })))
              ],
            ),
          ),
        ));
  }

  void _loadData() async {
    DateTime now = DateTime.now();
    String curday = now.day.toString();
    String curmonth = now.month.toString();
    String curyear = now.year.toString();
    pr.style(
      message: "Loading",
      backgroundColor: Colors.white,
    );
    pr.show();
    String urlLoadRoute = "https://slumberjer.com/buslora/load_route.php";
    http.post(urlLoadRoute, body: {
      "curday": curday,
      "curmonth": curmonth,
      "curyear": curyear,
    }).then((res) {
      if (res.body == "failed") {
        Toast.show("Server returned error", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.hide();
      } else {
        var extractdata = json.decode(res.body);
        setState(() {
          routelist = extractdata["routes"];
        });

        print(routelist);
        pr.hide();
      }
      pr.hide();
    });
  }

  loadRouteScreen(int index) async {
    String routeid = routelist[index]["routeid"].toString();
    var numbus = routelist[index]["busnum"];
    if (numbus > 0) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  RouteScreen(routeid: routeid)));
      _loadData();
    } else {
      Toast.show(
          "No bus service available for this route at the moment", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
}
