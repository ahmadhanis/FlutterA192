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
      body: 
      RefreshIndicator(
            key: refreshKey,
            color: Color.fromRGBO(101, 255, 218, 50),
            onRefresh: () async {
              _loadData();
            }, child:
      Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            Text("Please select your route",
                style: TextStyle(fontSize: 20.0, color: Colors.white,fontWeight: FontWeight.bold)),
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
                    child: ListView.builder(
                        itemCount: routelist == null ? 1 : routelist.length,
                        itemBuilder: (context, index) {
                          index -= 0;
                          return Column(children: <Widget>[
                            InkWell(
                              onTap: () => {loadRouteScreen(index)},
                              child: Card(
                                  elevation: 10,
                                  child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Row(children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor:
                                              Theme.of(context).platform ==
                                                      TargetPlatform.android
                                                  ? Colors.blue
                                                  : Colors.blue,
                                          child: Text(
                                            routelist[index]['routeid'],
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white),
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
                                                routelist[index]["description"],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                "Bus available: " +
                                                    routelist[index]["busnum"]
                                                        .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                      ]))),
                            )
                          ]);
                        }))
          ],
        ),
      ),
    ));
  }

  void _loadData() async {
    pr.style(
      message: "Loading",
      backgroundColor: Colors.white,
    );
    pr.show();
    String urlLoadRoute = "https://slumberjer.com/buslora/load_route.php";
    http.get(urlLoadRoute).then((res) {
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

  loadRouteScreen(int index) {
    String routeid = routelist[index]["routeid"].toString();
    var numbus =  routelist[index]["busnum"];
    if (numbus>0){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => RouteScreen(routeid: routeid)));  
    }else{
      Toast.show("No bus service available for this route at the moment", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
    
  }
}
