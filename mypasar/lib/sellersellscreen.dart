import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mypasar/user.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:sms/sms.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class SellerSellScreen extends StatefulWidget {
  final User user;

  const SellerSellScreen({Key key, this.user}) : super(key: key);

  @override
  _SellerSellScreenState createState() => _SellerSellScreenState();
}

class _SellerSellScreenState extends State<SellerSellScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List productdata;
  List delivList;
  double screenHeight, screenWidth;
  String option = "Baru";
  String info = "Maklumat Penjualan Anda";
  @override
  void initState() {
    super.initState();
    //_getCurrentLocation();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData("Baru"));
    loadDelivery();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final f = new DateFormat('dd-MM-yyyy hh:mm a');
    if (productdata == null) {
      return Scaffold(
          appBar: AppBar(
            title: Container(
                child: Text('Penjualan Saya',
                    style: GoogleFonts.anaheim(
                        fontWeight: FontWeight.bold, fontSize: 24))),
          ),
          body: RefreshIndicator(
              key: refreshKey,
              color: Color.fromRGBO(101, 255, 218, 50),
              onRefresh: () async {
                await _loadData("Baru");
                loadDelivery();
              },
              child: Container(
                  child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      info,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    )
                  ],
                ),
              ))),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                  child: Icon(Icons.fiber_new),
                  label: "Pesanan baru",
                  labelBackgroundColor: Colors.white,
                  onTap: () => _loadData("Baru")),
              SpeedDialChild(
                  child: Icon(Icons.play_circle_outline),
                  label: "Pesanan sedang dihantar",
                  labelBackgroundColor: Colors.white,
                  onTap: () => _loadData("Penghantaran")),
              SpeedDialChild(
                  child: Icon(Icons.done_all),
                  label: "Pesanan selesai",
                  labelBackgroundColor: Colors.white,
                  onTap: () => _loadData("Selesai")),
              SpeedDialChild(
                  child: Icon(MdiIcons.truckDeliveryOutline),
                  label: "Penghantar",
                  labelBackgroundColor: Colors.white,
                  onTap: () => _loadPenghantar()),
            ],
          ));
    }
    return Scaffold(
        appBar: AppBar(
          title: Container(
              child: Text('Penjualan Saya',
                  style: GoogleFonts.anaheim(
                      fontWeight: FontWeight.bold, fontSize: 24))),
        ),
        body: RefreshIndicator(
            key: refreshKey,
            color: Color.fromRGBO(101, 255, 218, 50),
            onRefresh: () async {
              await _loadData("Baru");
              loadDelivery();
            },
            child: Column(
              children: <Widget>[
                Text("Status Pesanan: " + option,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Expanded(
                    child: ListView.builder(
                        itemCount: productdata == null ? 1 : productdata.length,
                        itemBuilder: (context, index) {
                          index -= 0;
                          return Card(
                              elevation: 10,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          height: screenWidth / 4.8,
                                          width: screenWidth / 4.8,
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
                                      ],
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 1, 10, 1),
                                        child: SizedBox(
                                            width: 2,
                                            child: Container(
                                              height: screenWidth / 2,
                                              color: Colors.grey,
                                            ))),
                                    GestureDetector(
                                      onTap: () => updateStatus(index),
                                      child: Container(
                                          width: screenWidth / 1.5,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                productdata[index]["prname"],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                f.format(DateTime.parse(
                                                  productdata[index]["dateodr"],
                                                )),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 1, 10, 1),
                                                  child: SizedBox(
                                                      height: 2,
                                                      child: Container(
                                                        width:
                                                            screenWidth / 1.5,
                                                        color: Colors.grey,
                                                      ))),
                                              Table(
                                                  defaultColumnWidth:
                                                      FlexColumnWidth(1.0),
                                                  children: [
                                                    TableRow(children: [
                                                      TableCell(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 16,
                                                            child: Text(
                                                                "Order ID",
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
                                                            height: 16,
                                                            child: Text(
                                                              productdata[index]
                                                                  ["orderid"],
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )),
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      TableCell(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 16,
                                                            child: Text(
                                                                "Kuantiti",
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
                                                            height: 16,
                                                            child: Text(
                                                              productdata[index]
                                                                      [
                                                                      'odrqty'] +
                                                                  " unit",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )),
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      TableCell(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 16,
                                                            child: Text("Harga",
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
                                                            height: 16,
                                                            child: Text(
                                                                "RM" +
                                                                    productdata[
                                                                            index]
                                                                        [
                                                                        'total'],
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white))),
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      TableCell(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 16,
                                                            child: Text(
                                                                "Pembeli",
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
                                                            height: 16,
                                                            child: Text(
                                                              productdata[index]
                                                                  ['name'],
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )),
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      TableCell(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 16,
                                                            child: Text(
                                                                "Hantar",
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
                                                            height: 16,
                                                            child: Text(
                                                              "RM " +
                                                                  productdata[
                                                                          index]
                                                                      [
                                                                      'delcost'],
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )),
                                                      ),
                                                    ]),
                                                  ]),
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 1, 10, 1),
                                                  child: SizedBox(
                                                      height: 2,
                                                      child: Container(
                                                        width:
                                                            screenWidth / 1.5,
                                                        color: Colors.grey,
                                                      ))),
                                              Text("Alamat",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                              Container(
                                                  child: Text(
                                                      productdata[index]
                                                          ['address'],
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.white))),
                                              Container(
                                                height: 25,
                                                width: 200,
                                                child: Row(
                                                  children: <Widget>[
                                                    Flexible(
                                                        child: Tooltip(
                                                      message:
                                                          "Whatsupp pembeli",
                                                      child: FlatButton(
                                                        onPressed: () => {
                                                          _whatsupPhone(index)
                                                        },
                                                        child: Icon(
                                                          MdiIcons.whatsapp,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    )),
                                                    Flexible(
                                                      child: Tooltip(
                                                          message:
                                                              "SMS pembeli",
                                                          child: FlatButton(
                                                            onPressed: () => {
                                                              _sendSMS(index)
                                                            },
                                                            child: Icon(
                                                              MdiIcons.message,
                                                              color: Colors
                                                                  .blueGrey,
                                                            ),
                                                          )),
                                                    ),
                                                    Flexible(
                                                      child: Tooltip(
                                                        message:
                                                            "Telefon pembeli",
                                                        child: FlatButton(
                                                            onPressed: () => {
                                                                  _callPhone(
                                                                      index)
                                                                },
                                                            child: Icon(
                                                              MdiIcons.phone,
                                                              color: Colors
                                                                  .blueGrey,
                                                            )),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Tooltip(
                                                          message:
                                                              "Buka Googlemap",
                                                          child: FlatButton(
                                                            onPressed: () => {
                                                              _openGooglemap(
                                                                  index)
                                                            },
                                                            child: Icon(
                                                              MdiIcons
                                                                  .googleMaps,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          )),
                                                    ),
                                                    Flexible(
                                                      child: FlatButton(
                                                        onPressed: () => {
                                                          _sendtoDelivery(index)
                                                        },
                                                        child: Icon(
                                                          MdiIcons
                                                              .truckDelivery,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ));
                        }))
              ],
            )),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
                child: Icon(Icons.fiber_new),
                label: "Pesanan baru",
                labelBackgroundColor: Colors.white,
                onTap: () => {_loadData("Baru")}),
            SpeedDialChild(
                child: Icon(Icons.play_circle_outline),
                label: "Pesanan sedang dihantar",
                labelBackgroundColor: Colors.white,
                onTap: () => {_loadData("Penghantaran")}),
            SpeedDialChild(
                child: Icon(Icons.done_all),
                label: "Pesanan selesai",
                labelBackgroundColor: Colors.white,
                onTap: () => {_loadData("Selesai")}),
            SpeedDialChild(
                child: Icon(MdiIcons.truckDeliveryOutline),
                label: "Penghantar",
                labelBackgroundColor: Colors.white,
                onTap: () => {_loadPenghantar()}),
          ],
        ));
  }

  _whatsupPhone(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Whatsup kepada pembeli?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                FlutterOpenWhatsapp.sendSingleMessage(
                    "+60" + productdata[index]['phone'],
                    "Status berkenaan dengan order id " +
                        productdata[index]['orderid'] +
                        " untuk produk " +
                        productdata[index]['prname'] +
                        " dari My.Pasar");
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

  void _sendSMS(int index) async {
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
          "Status berkenaan dengan order id " +
              productdata[index]['orderid'] +
              " untuk produk " +
              productdata[index]['prname'] +
              " dari My.Pasar",
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
                    "Status berkenaan dengan order id " +
                        productdata[index]['orderid'] +
                        " untuk produk " +
                        productdata[index]['prname'] +
                        " dari My.Pasar"));
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

  _loadData(String op) {
    print(op);
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Memuat turun...");
    pr.show();
    String urlLoadJobs =
        "https://slumberjer.com/mypasar/php/load_cart_seller.php";
    http.post(urlLoadJobs, body: {
      "phone": widget.user.phone,
      "option": op,
    }).then((res) {
      print(res.body);
      pr.dismiss();
      setState(() {
        if (res.body == "Cart Empty") {
          productdata = null;
          info = "Tiada Maklumat";
          if (op == "Baru") {
            info = "Tiada Pesanan Baru";
          }
          if (op == "Penghantaran") {
            info = "Tiada Pesanan Dalam Penghantaran";
          }
          if (op == "Selesai") {
            info = "Tiada Pesanan Telah Selesai";
          }
        } else {
          var extractdata = json.decode(res.body);
          productdata = extractdata["usercart"];
        }

        option = op;
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    pr.dismiss();
  }

  updateStatus(int index) {
    String selectedStatus;
    List<String> listStatus = [
      //"Baru",
      "Penghantaran",
    ];
    String orderid = productdata[index]['orderid'];
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                'Kemaskini pesanan #' + productdata[index]['orderid'] + "?",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Center(
                    child: DropdownButton(
                      hint: Text(
                        'Pilihan Kemaskini',
                        style: TextStyle(
                          color: Color.fromRGBO(101, 255, 218, 50),
                        ),
                      ), // Not necessary for Option 1
                      value: selectedStatus,
                      onChanged: (newValue) {
                        newSetState(() {
                          selectedStatus = newValue;
                        });
                      },
                      items: listStatus.map((location) {
                        return DropdownMenuItem(
                          child: new Text(
                            location,
                            style: TextStyle(
                              color: Color.fromRGBO(101, 255, 218, 50),
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
                      child: Text('Kemaskini Status'),
                      color: Color.fromRGBO(101, 255, 218, 50),
                      textColor: Colors.black,
                      elevation: 5,
                      onPressed: () =>
                          changeStatus(selectedStatus, newSetState, orderid)),
                ],
              ),
            );
          });
        });
  }

  changeStatus(String selectedStatus, newSetState, String orderid) {
    print(orderid);
    if (selectedStatus == "" || selectedStatus == null) {
      Toast.show("Sila pilih status", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Sedang kemaskini status...");
    pr.show();

    http.post("https://slumberjer.com/mypasar/php/update_order_status.php",
        body: {
          "orderid": orderid,
          "status": selectedStatus,
        }).then((res) {
      print(res.body);
      pr.dismiss();
      if (res.body == "success") {
        Toast.show("Kemaskini status berjaya", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        _loadData(selectedStatus);
      } else {
        Toast.show("Kemaskini status tidak berjaya", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }

  _openGooglemap(int index) async {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Buka lokasi penerima menggunakan aplikasi Googlemap?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () async {
                Navigator.of(context).pop(false);
                String clatitude = productdata[index]['clat'];
                String clongitude = productdata[index]['clong'];
                String googleUrl =
                    'https://www.google.com/maps/search/?api=1&query=$clatitude,$clongitude';
                if (await canLaunch(googleUrl)) {
                  await launch(googleUrl);
                } else {
                  throw 'Could not open the map.';
                }
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

  _sendtoDelivery(int indexproduct) {
    if (delivList == null) {
      Toast.show(
          "Senarai penghantar belum ada. Sila daftar penghantar.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      _loadPenghantar();
      return;
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, newSetState) {
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  title: new Text(
                    'Pilih Penghantar untuk hantar ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  content: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      Container(
                          height: screenHeight / 2.5,
                          child: Column(
                            children: <Widget>[
                              Divider(
                                  height: 2,
                                  color: Color.fromRGBO(101, 255, 218, 50)),
                              Expanded(
                                  child: ListView.builder(
                                      itemCount: delivList.length,
                                      itemBuilder:
                                          (BuildContext ctxt, int index) {
                                        return new GestureDetector(
                                            child: Container(
                                                //color: Colors.red,
                                                //width: screenWidth/1.5,
                                                height: 30,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Text(
                                                      delivList[index]['name'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    )),
                                                    Container(
                                                        width: 100,
                                                        child: Text(
                                                          delivList[index]
                                                              ['dphone'],
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        )),
                                                    Flexible(
                                                      child: FlatButton(
                                                        onPressed: () => {
                                                          _sendDelivery(index,
                                                              indexproduct)
                                                        },
                                                        child: Icon(
                                                          MdiIcons
                                                              .arrowRightBoldCircleOutline,
                                                          color: Color.fromRGBO(
                                                              101,
                                                              255,
                                                              218,
                                                              50),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )));
                                      })),
                            ],
                          )),
                    ],
                  )));
            });
          });
    }
  }

  loadDelivery() async {
    String urlLoadDeli = "https://slumberjer.com/mypasar/php/load_delivery.php";
    http.post(urlLoadDeli, body: {
      "phone": widget.user.phone,
    }).then((res) {
      var extractdata = json.decode(res.body);
      setState(() {
        delivList = extractdata["delivery"];
        print(delivList);
      });
    });
  }

  loadDeliveryupd(newSetState) async {
    String urlLoadDeli = "https://slumberjer.com/mypasar/php/load_delivery.php";
    http.post(urlLoadDeli, body: {
      "phone": widget.user.phone,
    }).then((res) {
      var extractdata = json.decode(res.body);
      newSetState(() {
        delivList = extractdata["delivery"];
        print(delivList);
      });
    });
  }

  _loadPenghantar() {
    print(delivList);
    TextEditingController nameEditingController = new TextEditingController();
    TextEditingController phoneEditingController = new TextEditingController();
    if (delivList == null) {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, newSetState) {
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  title: new Text(
                    'Daftar Penghantar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  content: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      Container(
                          height: screenHeight / 2,
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                    height: 30,
                                    child: TextFormField(
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        controller: nameEditingController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        decoration: new InputDecoration(
                                          hintText: "Nama Penghantar",
                                          contentPadding:
                                              const EdgeInsets.all(5),

                                          fillColor: Colors.white,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0),
                                            borderSide: new BorderSide(),
                                          ),

                                          //fillColor: Colors.green
                                        )),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                    height: 30,
                                    child: TextFormField(
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        controller: phoneEditingController,
                                        keyboardType: TextInputType.phone,
                                        textInputAction: TextInputAction.next,
                                        decoration: new InputDecoration(
                                          hintText: "No Telefon",
                                          contentPadding:
                                              const EdgeInsets.all(5),

                                          fillColor: Colors.white,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0),
                                            borderSide: new BorderSide(),
                                          ),

                                          //fillColor: Colors.green
                                        )),
                                  ),
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    minWidth: 200,
                                    height: 40,
                                    child: Text('Simpan'),
                                    color: Color.fromRGBO(101, 255, 218, 50),
                                    textColor: Colors.black,
                                    elevation: 5,
                                    onPressed: () => insertDelivery(
                                        nameEditingController.text,
                                        phoneEditingController.text,
                                        newSetState),
                                  ),
                                ],
                              ),
                              Divider(
                                  height: 2,
                                  color: Color.fromRGBO(101, 255, 218, 50)),
                              Text(
                                "Tiada data penghantar",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          )),
                    ],
                  )));
            });
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, newSetState) {
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  title: new Text(
                    'Daftar Penghantar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  content: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      Container(
                          height: screenHeight / 2,
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                    height: 30,
                                    child: TextFormField(
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        controller: nameEditingController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        decoration: new InputDecoration(
                                          hintText: "Nama Penghantar",
                                          contentPadding:
                                              const EdgeInsets.all(5),

                                          fillColor: Colors.white,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0),
                                            borderSide: new BorderSide(),
                                          ),

                                          //fillColor: Colors.green
                                        )),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                    height: 30,
                                    child: TextFormField(
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        controller: phoneEditingController,
                                        keyboardType: TextInputType.phone,
                                        textInputAction: TextInputAction.next,
                                        decoration: new InputDecoration(
                                          hintText: "No Telefon",
                                          contentPadding:
                                              const EdgeInsets.all(5),

                                          fillColor: Colors.white,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0),
                                            borderSide: new BorderSide(),
                                          ),

                                          //fillColor: Colors.green
                                        )),
                                  ),
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    minWidth: 200,
                                    height: 40,
                                    child: Text('Simpan'),
                                    color: Color.fromRGBO(101, 255, 218, 50),
                                    textColor: Colors.black,
                                    elevation: 5,
                                    onPressed: () => insertDelivery(
                                        nameEditingController.text,
                                        phoneEditingController.text,
                                        newSetState),
                                  ),
                                ],
                              ),
                              Divider(
                                  height: 2,
                                  color: Color.fromRGBO(101, 255, 218, 50)),
                              Expanded(
                                  child: ListView.builder(
                                      itemCount: delivList.length,
                                      itemBuilder:
                                          (BuildContext ctxt, int index) {
                                        return new GestureDetector(
                                            onLongPress: () => {
                                                  _deleteDialog(
                                                    index,newSetState
                                                  )
                                                },
                                            child:Container(
                                              height: 30,
                                              child: 
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                    child: Text(
                                                  delivList[index]['name'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                )),
                                                Container(
                                                    width: 100,
                                                    child: Text(
                                                      delivList[index]
                                                          ['dphone'],
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    )),
                                                Flexible(
                                                  child: FlatButton(
                                                    onPressed: () =>
                                                        {_deleteDialog(index,newSetState)},
                                                    child: Icon(
                                                      MdiIcons.deleteCircle,
                                                      color: Color.fromRGBO(
                                                          101, 255, 218, 50),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )));
                                      })),
                            ],
                          )),
                    ],
                  )));
            });
          });
    }
  }

  void insertDelivery(String name, String phone, newSetState) {
    if (name == "" && phone == "") {
      Toast.show("Masukkan maklumat yang diperlukan", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    String urlLoadJobs =
        "https://slumberjer.com/mypasar/php/insert_delivery.php";
    http.post(urlLoadJobs, body: {
      "ophone": widget.user.phone,
      "dphone": phone,
      "dname": name,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Berjaya", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        //Navigator.of(context).pop(false);
        newSetState(() {
          loadDeliveryupd(newSetState);
        });
        
      } else {
        Toast.show("Gagal", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    });
  }

  _deleteDialog(int index,newSetState) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Buang ' +
              delivList[index]['name'] +
              ' dengan no telefon ' +
              delivList[index]['dphone'] +
              '?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () async {
                Navigator.of(context).pop(false);
                deleteDelivery(delivList[index]['dphone'],newSetState);
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

  void deleteDelivery(String phone,newSetState) {
    String urlLoadJobs =
        "https://slumberjer.com/mypasar/php/delete_delivery.php";
    http.post(urlLoadJobs, body: {
      "ophone": widget.user.phone,
      "dphone": phone,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Berjaya", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        //Navigator.of(context).pop(false);
        newSetState(() {
          loadDeliveryupd(newSetState);
        });
        
      } else {
        Toast.show("Gagal", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    });
  }

  _sendDelivery(int index, int indexproduct) {
    print("#");
    print(productdata[indexproduct]['orderid']);
    print(productdata[indexproduct]['prname']);

    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Whatsup perincian kepada penghantar?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                FlutterOpenWhatsapp.sendSingleMessage(
                    "+60" + delivList[index]['dphone'],
                    "Penghantaran baru order no " +
                        productdata[indexproduct]['orderid'] +
                        " untuk produk " +
                        productdata[indexproduct]['prname'] +
                        ". Harga RM " +
                        productdata[indexproduct]['price'] +
                        " Alamat:" +
                        productdata[indexproduct]['address'] +
                        " dari kedai " +
                        widget.user.name +
                        ". Kos hantar RM " +
                        productdata[indexproduct]['delcost'] +
                        ". Lokasi hantar: " +
                        "https://www.google.com/maps/@" +
                        productdata[indexproduct]['clat'] +
                        "," +
                        productdata[indexproduct]['clong'] +
                        ",15z");
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