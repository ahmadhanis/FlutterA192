import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mypasar/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:geocoder/geocoder.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:sms/sms.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mypasar/custbuyscreen.dart';
import 'package:intl/intl.dart';
import 'package:android_intent/android_intent.dart';

class TabScreen1 extends StatefulWidget {
  final User user;

  const TabScreen1({Key key, this.user}) : super(key: key);

  @override
  _TabScreen1State createState() => _TabScreen1State();
}

class _TabScreen1State extends State<TabScreen1> {
    GlobalKey<RefreshIndicatorState> refreshKey;

  double screenHeight, screenWidth;
  List productdata;
  Position _currentPosition;
  String curaddress;
  double latitude, longitude;
  int _orderqty = 1;
  bool locality = false;
  String selectedLocation;
  String selectedSort;
  bool _visiblesearch = false;
  bool _visiblelist = false;
  String states;
  String homeaddress;
  ProgressDialog pr;
  final f = new DateFormat('dd-MM-YYYY hh:mm');
  List<String> listSenarai = [
    "Paling Murah",
    "Paling Mahal",
    "Paling Baru",
    "Paling Lama",
  ];
  @override
  void initState() {
    super.initState();
    print("Init tab 1");
    refreshKey = GlobalKey<RefreshIndicatorState>();
    //WidgetsBinding.instance.addPostFrameCallback((_) => _getLocation());
    _getLocation();
  }

  @override
  void dispose() {
    print("in dispose");
    if (pr != null) {
      pr.dismiss();
    }

    //productdata = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _prdController = new TextEditingController();

    if (_currentPosition == null || productdata == null) {
      return Scaffold(
          body: RefreshIndicator(
              key: refreshKey,
              color: Color.fromRGBO(101, 255, 218, 50),
              onRefresh: () async {
                await refreshList();
              },
          child:Container(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "My.Pasar",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white),
                )
              ],
            ),
          ))),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                  child: Icon(Icons.shopping_cart),
                  label: "Pembelian saya",
                  labelBackgroundColor: Colors.white,
                  onTap: () => _buyScreen()),
              SpeedDialChild(
                  child: Icon(Icons.location_city),
                  labelBackgroundColor: Colors.white,
                  label: "Tukar lokaliti sementara",
                  onTap: () => _changeLocality()),
              SpeedDialChild(
                  child: Icon(Icons.search),
                  label: "Carian produk",
                  labelBackgroundColor: Colors.white,
                  onTap: () => _searchProduct()),
              SpeedDialChild(
                  child: Icon(Icons.list),
                  label: "Senarai ikut",
                  labelBackgroundColor: Colors.white,
                  onTap: () => _searchList()),
            ],
          ));
    } else {
      return Scaffold(
          resizeToAvoidBottomPadding: true,
           body: RefreshIndicator(
              key: refreshKey,
              color: Color.fromRGBO(101, 255, 218, 50),
              onRefresh: () async {
                await refreshList();
              },
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 2),
                Text("Produk sekitar " + curaddress,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Container(
                  height: 14,
                  child: Text("Klik pada produk melihat perincian",
                      style: TextStyle(fontSize: 12.0, color: Colors.white)),
                ),
               
                Divider(height:2,color: Color.fromRGBO(101, 255, 218, 50)),
                SizedBox(height: 5),
                Visibility(
                    visible: _visiblesearch,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        height: screenHeight / 12,
                        margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Flexible(
                                child: Container(
                              height: 30,
                              child: TextField(
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  autofocus: false,
                                  controller: _prdController,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.search),
                                      border: OutlineInputBorder())),
                            )),
                            Flexible(
                                child: MaterialButton(
                                    color: Color.fromRGBO(101, 255, 218, 50),
                                    onPressed: () => {
                                          _searchItembyName(_prdController.text)
                                        },
                                    elevation: 5,
                                    child: Text(
                                      "Carian Produk",
                                      style: TextStyle(color: Colors.black),
                                    )))
                          ],
                        ),
                      ),
                    )),
                Visibility(
                    visible: _visiblelist,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        height: screenHeight / 12,
                        margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Flexible(
                                child: Container(
                              height: 30,
                              child: DropdownButton(
                                //sorting dropdownoption
                                hint: Text(
                                    'Pilihan',style: TextStyle(
                          color: Color.fromRGBO(101, 255, 218, 50),
                        ),), // Not necessary for Option 1
                                value: selectedSort,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedSort = newValue;
                                    print(selectedSort);
                                    if (selectedSort == "Paling Mahal") {
                                      _loadDataSort("priceup");
                                    }
                                    if (selectedSort == "Paling Murah") {
                                      _loadDataSort("pricedown");
                                    }
                                    if (selectedSort == "Paling Baru") {
                                      _loadDataSort("dateup");
                                    }
                                    if (selectedSort == "Paling Lama") {
                                      _loadDataSort("datedown");
                                    }
                                  });
                                },
                                items: listSenarai.map((selectedSort) {
                                  return DropdownMenuItem(
                                    child: new Text(selectedSort,
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                101, 255, 218, 50))),
                                    value: selectedSort,
                                  );
                                }).toList(),
                              ),
                            )),
                          ],
                        ),
                      ),
                    )),
                Flexible(
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (screenWidth / screenHeight) / 0.65,
                        children: List.generate(productdata.length, (index) {
                          return Card(
                              elevation: 10,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: GestureDetector(
                                    onTap: () => loadProduct(index),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: screenHeight / 5.5,
                                          width: screenWidth / 2.8,
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                "http://slumberjer.com/mypasar/productimages/${productdata[index]['imagename']}.jpg",
                                            placeholder: (context, url) =>
                                                new CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        //Text(productdata[index]['phone']),
                                        //SizedBox(height: 3),
                                        Flexible(
                                            child: Text(
                                          productdata[index]['prname'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          maxLines: 1,
                                        )),
                                        SizedBox(height: 3),

                                        Text(
                                          "RM" +
                                              double.parse(productdata[index]
                                                      ['price'])
                                                  .toStringAsFixed(2),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                            productdata[index]['quantity'] +
                                                " unit",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    )),
                              ));
                        })))
              ],
            ),
           )),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                  child: Icon(Icons.shopping_cart),
                  label: "Pembelian saya",
                  labelBackgroundColor: Colors.white,
                  onTap: () => _buyScreen()),
              SpeedDialChild(
                  child: Icon(Icons.location_city),
                  label: "Tukar lokaliti sementara",
                  labelBackgroundColor: Colors.white,
                  onTap: () => _changeLocality()),
              SpeedDialChild(
                  child: Icon(Icons.search),
                  label: "Carian produk",
                  labelBackgroundColor: Colors.white,
                  onTap: () => _searchProduct()),
              SpeedDialChild(
                  child: Icon(Icons.list),
                  label: "Senarai ikut",
                  labelBackgroundColor: Colors.white,
                  onTap: () => _searchList()),
            ],
          ));
    }
  }
Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
   _getLocation();
    return null;
  }

  _getLocation() async {
    try {
      final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
      _currentPosition = await geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
          .timeout(Duration(seconds: 10), onTimeout: () {
        print("timeout gps");
        Toast.show("Lokaliti anda tidak dapat dikesan", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        openLocationSetting();
        return;
      });
      final coordinates = new Coordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      var addresses = await Geocoder.local
          .findAddressesFromCoordinates(coordinates)
          .timeout(Duration(seconds: 5), onTimeout: () {
        Toast.show("Lokaliti anda tidak dapat dikesan", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        openLocationSetting();
        return;
      });
      var first = addresses.first;
      states = first.adminArea;
      print(states);
      setState(() {
        curaddress = first.locality;
        homeaddress = first.addressLine;
        print("feature name:" + curaddress);
        if (curaddress != null) {
          latitude = _currentPosition.latitude;
          longitude = _currentPosition.longitude;
          _loadData("no");
          return;
        }
      });

      print("${first.subLocality} ");
    } catch (exception) {
      print(exception.message);
      return;
    }
  }

  void openLocationSetting() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  void _loadData(String ignore) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(
      message: "Memuat turun...",
      backgroundColor: Colors.white,
    );
    pr.show();
    if (locality) {
      curaddress = selectedLocation;
    }
    String urlLoadProd =
        "https://slumberjer.com/mypasar/php/load_product_cust.php";
    http
        .post(urlLoadProd, body: {
          "phone": widget.user.phone.toString(),
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
          "locality": curaddress,
          "ignore": ignore,
          "radius": widget.user.radius,
        })
        .then((res) {
          print(res.body);
          setState(() {
            if (res.body == "nodata") {
              productdata = null;
              Toast.show("Produk tiada di lokaliti dipilih", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.dismiss();
            } else {
              var extractdata = json.decode(res.body);
              productdata = extractdata["products"];
              pr.dismiss();
            }
            pr.dismiss();
          });
          pr.dismiss();
        })
        .catchError((err) {
          print(err);
          pr.dismiss();
        })
        .timeout(const Duration(seconds: 10))
        .then((value) => {pr.dismiss()});
    pr.dismiss();
  }

  void _loadDataSort(String sortoption) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Menyusun");
    pr.show();
    if (locality) {
      curaddress = selectedLocation;
    }
    String urlLoadProd =
        "https://slumberjer.com/mypasar/php/load_product_cust.php";
    http
        .post(urlLoadProd, body: {
          "phone": widget.user.phone.toString(),
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
          "locality": curaddress,
          "ignore": 'no',
          "sort": sortoption,
          "radius": widget.user.radius,
        })
        .then((res) {
          print(res.body);
          setState(() {
            if (res.body == "nodata") {
              productdata = null;
              Toast.show("Produk tiada di lokaliti dipilih", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            } else {
              var extractdata = json.decode(res.body);
              productdata = extractdata["products"];
            }
          });
          pr.dismiss();
        })
        .catchError((err) {
          print(err);
          pr.dismiss();
        })
        .timeout(const Duration(seconds: 10))
        .then((value) => {print("timeout"), pr.dismiss()});
    pr.dismiss();
  }

  loadProduct(int index) async {
    _orderqty = 0;
    //double dist = calculateDistance(latitude,longitude,double.parse( productdata[index]['latitude']),double.parse( productdata[index]['longitude']));
    final double distance = await Geolocator().distanceBetween(
        latitude,
        longitude,
        double.parse(productdata[index]['latitude']),
        double.parse(productdata[index]['longitude']));

    double delicost =
        (distance / 1000) * double.parse(productdata[index]['delivery']);
    print(delicost);
    double diskm = distance / 1000;
    if (diskm < 1) {
      delicost = 1.00;
    }
    var parsedDate = DateTime.parse(productdata[index]['datereg']);
    final f = new DateFormat('dd-MM-yyyy hh:mm a');
    print(f.format(parsedDate));

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                //title: Center(child: Text("Beli?")),
                titlePadding: EdgeInsets.all(5),
                content: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[
                        Text("Beli dari " + productdata[index]['name'],
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),

                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: screenHeight / 3,
                          width: screenWidth / 1.5,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl:
                                "http://slumberjer.com/mypasar/productimages/${productdata[index]['imagename']}.jpg",
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          ),
                        ),

                        SizedBox(height: 6),
                        Text(productdata[index]['prname'],
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),

                        Text("Diiklan pada " + f.format(parsedDate),
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                        SizedBox(height: 4),
                        Table(
                            defaultColumnWidth: FlexColumnWidth(1.0),
                            children: [
                              TableRow(children: [
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 20,
                                      child: Text("Harga/unit",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                ),
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 20,
                                      child: Text(
                                          "RM " +
                                              double.parse(productdata[index]
                                                      ['price'])
                                                  .toStringAsFixed(2),
                                          style:
                                              TextStyle(color: Colors.white))),
                                ),
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 20,
                                      child: Text("Kos hantar",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                ),
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 20,
                                      child: Text(
                                          "RM " + delicost.toStringAsFixed(2),
                                          style:
                                              TextStyle(color: Colors.white))),
                                ),
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 20,
                                      child: Text("Terdapat",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                ),
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 20,
                                      child: Text(
                                          productdata[index]['quantity'] +
                                              " unit",
                                          style:
                                              TextStyle(color: Colors.white))),
                                ),
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 20,
                                      child: Text("Jarak",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                ),
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 20,
                                      child: Text(
                                          diskm.toStringAsFixed(2) + " km",
                                          style:
                                              TextStyle(color: Colors.white))),
                                ),
                              ]),
                            ]),

                        //Text(f.format(DateTime.parse(productdata[index]['datereg']))),
                        SizedBox(height: 3),

                        Container(
                          height: 30,
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: FlatButton(
                                  onPressed: () => {_gotoShop(index)},
                                  child: Icon(
                                    MdiIcons.store,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: FlatButton(
                                  onPressed: () => {_whatsupPhone(index)},
                                  child: Icon(
                                    MdiIcons.whatsapp,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: FlatButton(
                                  onPressed: () => {_sendSMS(index)},
                                  child: Icon(
                                    MdiIcons.message,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: FlatButton(
                                  onPressed: () => {_callPhone(index)},
                                  child: Icon(
                                    MdiIcons.phone,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: FlatButton(
                                  onPressed: () => {_reportAdmin(index)},
                                  child: Icon(
                                    Icons.report,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                onPressed: () =>
                                    {_updateCart(index, "add", newSetState)},
                                child: Icon(
                                  MdiIcons.plus,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(_orderqty.toString(),
                                  style: TextStyle(
                                      color:
                                          Color.fromRGBO(101, 255, 218, 50))),
                              FlatButton(
                                onPressed: () =>
                                    {_updateCart(index, "minus", newSetState)},
                                child: Icon(
                                  MdiIcons.minus,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            minWidth: 200,
                            height: 40,
                            child: Text('Beli'),
                            color: Color.fromRGBO(101, 255, 218, 50),
                            textColor: Colors.black,
                            elevation: 5,
                            onPressed: () => _buyNow(index, delicost)),
                      ],
                    )));
          });
        });
  }

  _updateCart(int index, String op, newSetState) {
    int curqtty = int.parse(productdata[index]['quantity']);

    newSetState(() {
      if (op == "add" && _orderqty < curqtty) {
        _orderqty = _orderqty + 1;
      }
      if (op == "minus" && _orderqty != 0) {
        _orderqty = _orderqty - 1;
      }
    });
  }

  _whatsupPhone(int index) {
    if (widget.user.name == "Tidak Berdaftar") {
      Toast.show("Sila login/daftar akaun", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Hubungi penjual di Whatsup?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: new Text(
            "Anda pasti?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Ya",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();

                FlutterOpenWhatsapp.sendSingleMessage(
                    "+60" + productdata[index]['phone'],
                    "Berminat untuk " +
                        productdata[index]['prname'] +
                        " dari My.Pasar");
              },
            ),
            new FlatButton(
              child: new Text(
                "Tidak",
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

  void _sendSMS(int index) async {
    if (widget.user.name == "Tidak Berdaftar") {
      Toast.show("Sila login/daftar akaun", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Hantar SMS ini kepada ' + productdata[index]['phone'],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        content: Text(
          "Saya berminat untuk " +
              productdata[index]['prname'] +
              " dari My.Pasar. Masih dalam stok?",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);

                SmsSender sender = new SmsSender();
                String address = "+60" + productdata[index]['phone'];
                sender.sendSms(new SmsMessage(
                  address,
                  "Saya berminat untuk " +
                      productdata[index]['prname'] +
                      " dari My.Pasar. Masih dalam stok?",
                ));
              },
              child: Text(
                "Ya",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Tidak",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ],
      ),
    );
  }

  void _callPhone(int index) async {
    if (widget.user.name == "Tidak Berdaftar") {
      Toast.show("Sila login/daftar akaun", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Telefon ' + productdata[index]['name'] + '?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _makePhoneCall('tel:' + productdata[index]['phone']);
              },
              child: Text(
                "Ya",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Tidak",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _buyNow(int index, double delicost) {
    if (widget.user.name == "Tidak Berdaftar") {
      Toast.show("Sila login/daftar akaun", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_orderqty < 1) {
      Toast.show("Quantiti kurang dari 1", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    double total = (_orderqty * double.parse(productdata[index]['price']));

    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text('Setuju untuk beli?',
            style: TextStyle(color: Colors.white)),
        content: Text(productdata[index]['prname'],
            style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _insertOrder(index, total, delicost);
              }, // color: Color.fromRGBO(101, 255, 218, 50),
              child: Text("Ya",
                  style: TextStyle(color: Color.fromRGBO(101, 255, 218, 50)))),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Tidak",
                  style: TextStyle(color: Color.fromRGBO(101, 255, 218, 50)))),
        ],
      ),
    );
  }

  void _insertOrder(int index, double total, double delicost) {
    if (double.parse(productdata[index]['km']) > double.parse(widget.user.radius)) {
      Toast.show("Lokaliti produk melebihi 5km. Sila hubungi pembeli", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Pembelian...");
    pr.show();

    String prid = productdata[index]['id'];
    String ophone = productdata[index]['phone'];
    String bphone = widget.user.phone;
    String odrqty = _orderqty.toString();

    String urlLoadProd = "https://slumberjer.com/mypasar/php/insert_order.php";
    http
        .post(urlLoadProd, body: {
          "prid": prid,
          "ophone": ophone,
          "bphone": bphone,
          "odrqty": odrqty,
          "clatitude": latitude.toString(),
          "clongitude": longitude.toString(),
          "total": total.toStringAsFixed(2),
          "delcost": delicost.toStringAsFixed(2),
          "address": homeaddress,
        })
        .then((res) {
          print(res.body);
          if (res.body == "success") {
            Toast.show("Berjaya Beli", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            Navigator.of(context, rootNavigator: true).pop();
            pr.dismiss();
            _loadData("no");
          } else {
            Toast.show("Pembelian tidak berjaya", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            pr.dismiss();
          }
        })
        .catchError((err) {
          print(err);
          pr.dismiss();
        })
        .timeout(const Duration(seconds: 10))
        .then((value) => {print("timeout"), pr.dismiss()});
    //Navigator.of(context, rootNavigator: true).pop();
  }

  _changeLocality() {
    List<String> listloc;

    if (states == "Kedah") {
      listloc = [
        "Bukit Kayu Hitam",
        "Changlun",
        "Jitra",
        "Sintok",
        "Kubang Pasu"
      ];
    }

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                'Tukar Lokaliti?',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    states,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                  new Center(
                    child: DropdownButton(
                      hint: Text(
                        'Pilih dari pilihan di bawah',
                        style: TextStyle(
                          color: Color.fromRGBO(101, 255, 218, 50),
                        ),
                      ), // Not necessary for Option 1
                      value: selectedLocation,
                      onChanged: (newValue) {
                        newSetState(() {
                          selectedLocation = newValue;
                        });
                      },
                      items: listloc.map((location) {
                        return DropdownMenuItem(
                          child: new Text(
                            location,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          value: location,
                        );
                      }).toList(),
                    ),
                  ),
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 200,
                      height: 40,
                      child: Text('Tukar'),
                      color: Color.fromRGBO(101, 255, 218, 50),
                      textColor: Colors.black,
                      elevation: 5,
                      onPressed: () =>
                          changeLoc(selectedLocation, newSetState)),
                ],
              ),
            );
          });
        });
  }

  void changeLoc(String newloc, newSetState) {
    print(newloc);
    print(curaddress);
    print(latitude);
    print(longitude);
    if (newloc == null || newloc == "") {
      Toast.show("Sila pilih lokaliti baru", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    locality = true;

    newSetState(() {});
    Navigator.of(context, rootNavigator: true).pop();
    _loadData("yes");
  }

  _searchProduct() {
    print(_visiblesearch);

    if (_visiblesearch) {
      _visiblesearch = false;
    } else {
      _visiblesearch = true;
    }
    setState(() {
      _visiblelist = false;
    });
  }

  void _searchItembyName(String prname) {
    try {
      print(widget.user.radius);
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "https://slumberjer.com/mypasar/php/load_product_cust.php";
      http
          .post(urlLoadJobs, body: {
            "name": prname.toString(),
            "phone": widget.user.phone.toString(),
            "latitude": latitude.toString(),
            "longitude": longitude.toString(),
            "locality": curaddress,
            "ignore": "yes",
            "radius": widget.user.radius,
          })
          .timeout(const Duration(seconds: 10))
          .then((res) {
            if (res.body == "nodata") {
              Toast.show("Carian tidak dijumpai", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.dismiss();
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            }
            setState(() {
              var extractdata = json.decode(res.body);
              productdata = extractdata["products"];
              FocusScope.of(context).requestFocus(new FocusNode());
              pr.dismiss();
            });
          })
          .catchError((err) {
            pr.dismiss();
          });
      pr.dismiss();
    } on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

void _searchItembySeller(String sellerphone) {
    try {
      print(widget.user.radius);
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "https://slumberjer.com/mypasar/php/load_product_cust.php";
      http
          .post(urlLoadJobs, body: {
            "phone": widget.user.phone.toString(),
            "latitude": latitude.toString(),
            "longitude": longitude.toString(),
            "locality": curaddress,
            "ignore": "yes",
            "radius": widget.user.radius,
            "seller": sellerphone,
          })
          .timeout(const Duration(seconds: 10))
          .then((res) {
            if (res.body == "nodata") {
              Toast.show("Carian tidak dijumpai", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.dismiss();
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            }
            setState(() {
              var extractdata = json.decode(res.body);
              productdata = extractdata["products"];
              FocusScope.of(context).requestFocus(new FocusNode());
              pr.dismiss();
            });
          })
          .catchError((err) {
            pr.dismiss();
          });
      pr.dismiss();
    } on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  _searchList() {
    print(_visiblelist);
    if (_visiblelist) {
      _visiblelist = false;
    } else {
      _visiblelist = true;
    }
    setState(() {
      _visiblesearch = false;
    });
  }

  _buyScreen() {
    if (widget.user.name == "Tidak Berdaftar") {
      Toast.show("Sila daftar akaun dahulu", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  CustBuyScreen(user: widget.user)));
    }
  }

  _reportAdmin(int index) {
    if (widget.user.name == "Tidak Berdaftar") {
      Toast.show("Sila login/daftar akaun", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Laporkan produk ini - ' + productdata[index]['prname'],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        content: Text(
          "Maklumat produk melanggar peraturan aplikasi?",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                _onReport(index);
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Ya",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Tidak",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ],
      ),
    );
  }

  void _onReport(int index) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Melaporkan...");
    pr.show();
    String urlReport = "https://slumberjer.com/mypasar/php/insert_report.php";
    http
        .post(urlReport, body: {
          "prodid": productdata[index]['id'],
          "rephone": widget.user.phone,
        })
        .then((res) {
          print(res.body);
          if (res.body == "success") {
            Navigator.pop(
                context,
                Toast.show("Laporan anda berjaya", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
            pr.dismiss();
          } else {
            Toast.show("Laporan anda gagal", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            pr.dismiss();
          }
        })
        .catchError((err) {
          print(err);
          pr.dismiss();
        })
        .timeout(const Duration(seconds: 10))
        .then((value) => {print("timeout"), pr.dismiss()});
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  _gotoShop(int index) {
    if (widget.user.name == "Tidak Berdaftar") {
      Toast.show("Sila login/daftar akaun", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Senaraikan semua produk dari ' + productdata[index]['name'],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                Navigator.of(context).pop(false);
                _searchItembySeller(productdata[index]['phone']);
              },
              child: Text(
                "Ya",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Tidak",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ],
      ),
    );
  }
}
