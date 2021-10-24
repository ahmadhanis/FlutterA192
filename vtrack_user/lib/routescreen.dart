import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class RouteScreen extends StatefulWidget {
  final String routeid;

  const RouteScreen({Key key, this.routeid}) : super(key: key);

  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  List buslist;
  double screenHeight, screenWidth, latitude, longitude;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController gmcontroller;
  CameraPosition _cameraPos;
  GlobalKey<RefreshIndicatorState> refreshKey;
  List markerlist;
  // A map of markers
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  Position _currentPosition;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _loadRoute();
  }

  _getLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    _currentPosition = await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .timeout(Duration(seconds: 15), onTimeout: () {
      Toast.show("Unable to detect your current position", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    });

    setState(() {
      if (_currentPosition != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        _cameraPos =
            CameraPosition(target: LatLng(latitude, longitude), zoom: 14);
        buildMarkers();
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Route ' + widget.routeid),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Map for Bus route " + widget.routeid,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              latitude == null || buslist == null
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
                      height: screenHeight / 2,
                      width: screenWidth / 1.05,
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
              SizedBox(height: 5),
              Divider(
                height: 2,
                color: Color.fromRGBO(101, 255, 218, 50),
              ),
              Text("Active shuttle/s",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              buslist == null
                  ? Flexible(
                      child: Container(
                          child: Center(
                              child: Text(
                      "Loading buses...",
                      style: TextStyle(
                          color: Color.fromRGBO(101, 255, 218, 50),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ))))
                  : Flexible(
                      child: RefreshIndicator(
                          key: refreshKey,
                          color: Color.fromRGBO(101, 255, 218, 50),
                          onRefresh: () async {
                            _loadRoute();
                          },
                          child: ListView.builder(
                              itemCount: buslist == null ? 1 : buslist.length,
                              itemBuilder: (context, index) {
                                index -= 0;
                                return InkWell(
                                    onTap: () => {selectMarker(index)},
                                    child: Card(
                                        elevation: 10,
                                        child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Table(
                                                      defaultColumnWidth:
                                                          FlexColumnWidth(1.0),
                                                      columnWidths: {
                                                        0: FlexColumnWidth(3.5),
                                                        1: FlexColumnWidth(6.5),
                                                      },
                                                      children: [
                                                        TableRow(children: [
                                                          TableCell(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                height: 20,
                                                                child: Text(
                                                                    "Bus ID",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white))),
                                                          ),
                                                          TableCell(
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              height: 20,
                                                              child: Text(
                                                                  buslist[index]
                                                                      ["busid"],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                          ),
                                                        ]),
                                                        TableRow(children: [
                                                          TableCell(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                height: 20,
                                                                child: Text(
                                                                    "Range from you",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white))),
                                                          ),
                                                          TableCell(
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              height: 20,
                                                              child: Text(
                                                                  calculateDistance(
                                                                        latitude,
                                                                        longitude,
                                                                        double.parse(buslist[index]
                                                                            [
                                                                            "latitude"]),
                                                                        double.parse(buslist[index]
                                                                            [
                                                                            "longitude"]),
                                                                      ).toStringAsFixed(
                                                                          2) +
                                                                      " km",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                          ),
                                                        ]),
                                                        TableRow(children: [
                                                          TableCell(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                height: 20,
                                                                child: Text(
                                                                    "Last update",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white))),
                                                          ),
                                                          TableCell(
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              height: 20,
                                                              child: Text(
                                                                  f.format(DateTime
                                                                      .parse(buslist[
                                                                              index]
                                                                          [
                                                                          "bdate"])),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                          ),
                                                        ]),
                                                      ]),
                                                ]))));
                              })),
                    )
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
                child: Icon(Icons.refresh),
                label: "Refresh Location",
                labelBackgroundColor: Colors.white,
                onTap: () => _loadRoute()),
            SpeedDialChild(
                child: Icon(Icons.my_location),
                label: "Show My Location",
                labelBackgroundColor: Colors.white, //_changeLocality()
                onTap: () => selectMyMarker()),
          ],
        ));
  }

  int generateIds() {
    var rng = new Random();
    var randomInt;
    randomInt = rng.nextInt(100);
    print(rng.nextInt(100));
    return randomInt;
  }

  //call this function in initstate
  // I'm getting a json Object with locations from an
  // external api
  buildMarkers() {
    markerlist = new List();
    for (var i = 0; i < buslist.length; i++) {
      var markerIdVal = generateIds();
      markerlist.insert(i, markerIdVal);
      final MarkerId markerId = MarkerId(markerIdVal.toString());
      final Marker marker = Marker(
          markerId: markerId,
          position: LatLng(
            double.parse(buslist[i]["latitude"]),
            double.parse(buslist[i]["longitude"]),
          ),
          infoWindow: InfoWindow(
            title: buslist[i]["busid"],
            snippet: f.format(DateTime.parse(buslist[i]["bdate"])),
          ));

      // you could do setState here when adding the markers to the Map
      markers[markerId] = marker;
    }
    var markerIdVal = generateIds();
    markerlist.insert(
        markerlist.length, markerIdVal); //user current location marker
    final MarkerId markerId = MarkerId(markerIdVal.toString());
    final Marker marker2 = Marker(
        markerId: markerId,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(
          latitude,
          longitude,
        ),
        infoWindow: InfoWindow(
          title: "Your Location",
          snippet: "Current location",
        ));
    print(markerlist);
    markers[markerId] = marker2;
  }

  _loadRoute() {
    DateTime now = DateTime.now();
    String curday = now.day.toString();
    String curmonth = now.month.toString();
    String curyear = now.year.toString();
    markers.clear();
    String urlLoadRoute = "https://slumberjer.com/buslora/load_route_id.php";
    http.post(urlLoadRoute, body: {
      "routeid": widget.routeid,
      "curday": curday,
      "curmonth": curmonth,
      "curyear": curyear,
    }).then((res) {
      if (res.body != 'failed') {
        var extractdata = json.decode(res.body);
        setState(() {
          buslist = extractdata["buses"];
        });
        _getLocation();
      }
      print(buslist);
    });
  }

  selectMarker(int index) async {
    double lat = double.parse(buslist[index]['latitude']);
    double lng = double.parse(buslist[index]['longitude']);
    _cameraPos = CameraPosition(target: LatLng(lat, lng), zoom: 14);

    gmcontroller = await _controller.future;
    gmcontroller.animateCamera(CameraUpdate.newCameraPosition(_cameraPos));
    MarkerId tempmarker = MarkerId(markerlist[index].toString());
    gmcontroller.showMarkerInfoWindow(tempmarker);
  }

  selectMyMarker() async {
    _cameraPos = CameraPosition(target: LatLng(latitude, longitude), zoom: 14);
    gmcontroller = await _controller.future;
    gmcontroller.animateCamera(CameraUpdate.newCameraPosition(_cameraPos));
    MarkerId tempmarker =
        MarkerId(markerlist[markerlist.length - 1].toString());
    gmcontroller.showMarkerInfoWindow(tempmarker);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    if (lat1 == null) {
      return 0;
    } else {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }
  }
}
