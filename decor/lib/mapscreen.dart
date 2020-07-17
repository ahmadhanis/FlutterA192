import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'pipedetails.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List pipelist;
  double screenHeight, screenWidth, latitude = 6.465176, longitude = 100.503542;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController gmcontroller;
  CameraPosition _cameraPos;
  GlobalKey<RefreshIndicatorState> refreshKey;
  List markerlist;
  // A map of markers
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  //Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _cameraPos =
        CameraPosition(target: LatLng(latitude, longitude), zoom: 14.5);
    _loadPipes();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Pipe Location'),
        ),
        body: Center(
          child: Column(children: <Widget>[
            Text("Decor Pipe Sensors Location",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Container(
              child: pipelist == null
                  ? Flexible(
                      child: Container(
                          child: Center(
                              child: Text(
                      "Loading map...",
                      style: TextStyle(
                          color: Color.fromRGBO(101, 255, 218, 50),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ))))
                  : Flexible(
                      child: Container(
                      //height: screenHeight / 2,
                      //width: screenWidth / 1.05,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _cameraPos,
                        gestureRecognizers:
                            <Factory<OneSequenceGestureRecognizer>>[
                          Factory<OneSequenceGestureRecognizer>(
                              () => ScaleGestureRecognizer())
                        ].toSet(),
                        markers: Set<Marker>.of(markers.values),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    )),
            ),
            Text("Click on marker to get details of the sensor",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ]),
        ));
  }

  _loadPipes() {
    markers.clear();
    String urlLoadRoute = "https://slumberjer.com/decor/load_pipes.php";
    http.post(urlLoadRoute, body: {}).then((res) {
      print(res.body);
      if (res.body != 'failed') {
        var extractdata = json.decode(res.body);
        setState(() {
          pipelist = extractdata["pipes"];
        });
        buildMarkers();
      }
    });
  }

  int generateIds() {
    var rng = new Random();
    var randomInt;
    randomInt = rng.nextInt(100);
    print(rng.nextInt(100));
    return randomInt;
  }

  buildMarkers() {
    markerlist = new List();
    for (var i = 0; i < pipelist.length; i++) {
      var markerIdVal = generateIds();
      markerlist.insert(i, markerIdVal);
      final MarkerId markerId = MarkerId(markerIdVal.toString());
      final Marker marker = Marker(
          markerId: markerId,
          icon: (double.parse(pipelist[i]['latest']) > 0)
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
              : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: LatLng(
            double.parse(pipelist[i]["latitude"]),
            double.parse(pipelist[i]["longitude"]),
          ),
          infoWindow: InfoWindow(
            title: pipelist[i]["pipeid"] + "/" + pipelist[i]["latest"],
            snippet: f.format(DateTime.parse(pipelist[i]["date"])),
          ),
          onTap: () => _onImageDisplay(i));

      // you could do setState here when adding the markers to the Map
      markers[markerId] = marker;
    }
    var markerIdVal = generateIds();
    markerlist.insert(
        markerlist.length, markerIdVal); //user current location marker
    final MarkerId markerId = MarkerId(markerIdVal.toString());
    final Marker marker2 = Marker(
        markerId: markerId,
        //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(
          latitude,
          longitude,
        ),
        infoWindow: InfoWindow(
          title: "UUM",
          snippet: "Pipe Management",
        ));
    print(markerlist);
    //markers[markerId] = marker2;
  }

  handleTap(int i) async {
    Navigator.of(context).pop();
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => PipeDetailsScreen(
            pipeid: pipelist[i]['pipeid'],
            date: pipelist[i]['date'],
            location: pipelist[i]['location'],
            details: pipelist[i]['desc'],
            latitude: pipelist[i]['latitude'],
            longitude: pipelist[i]['longitude'],
          ),
        ));
  }

  _onImageDisplay(int i) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Center(child: Text("Pipe ID:" + pipelist[i]['pipeid'])),
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
                              "/pipeimages/${pipelist[i]['pipeid']}.jpg")),
                  Divider(
                    color: Colors.grey,
                    thickness: 2,
                  ),
                  Text("Pressure: " + pipelist[i]['latest'] + " Psi"),
                  Text(
                      "Date: " + f.format(DateTime.parse(pipelist[i]['date']))),
                  Text("Location: " + pipelist[i]['location']),
                  Text("Details: " + pipelist[i]['desc']),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    minWidth: 150,
                    height: 30,
                    child: Text('Sensor Details'),
                    color: Color.fromRGBO(101, 255, 218, 50),
                    textColor: Colors.black,
                    elevation: 5,
                    onPressed: () => handleTap(i),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
