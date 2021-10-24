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
import 'package:google_fonts/google_fonts.dart';

class CustBuyScreen extends StatefulWidget {
  final User user;

  const CustBuyScreen({Key key, this.user}) : super(key: key);

  @override
  _CustBuyScreenState createState() => _CustBuyScreenState();
}

class _CustBuyScreenState extends State<CustBuyScreen> {
  List productdata;
  double screenHeight, screenWidth;
  String option = "Baru";
  String info = "Maklumat pembelian anda";
  String titlecenter ="";
  @override
  void initState() {
    super.initState();
    //_getCurrentLocation();

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData("Baru"));
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
   
    return Scaffold(
        appBar: AppBar(
          title: Container(
              child: Text('Pembelian Saya',
                  style: GoogleFonts.anaheim(
                      fontWeight: FontWeight.bold, fontSize: 24))),
        ),
        body: Column(
          children: <Widget>[
             productdata == null
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
                      :
            Expanded(
              child: ListView.builder(
                  itemCount: productdata == null ? 1 : productdata.length,
                  itemBuilder: (context, index) {
                    index -= 0;
                    return Column(
                      children: <Widget>[
                        Card(
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
                                              height: screenWidth / 3.5,
                                              color: Colors.grey,
                                            ))),
                                    GestureDetector(
                                        onTap: () => updateStatus(index),
                                        child: Container(
                                            width: screenWidth / 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  productdata[index]["prname"],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
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
                                                                productdata[
                                                                        index]
                                                                    ["orderid"],
                                                                style:
                                                                    TextStyle(
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
                                                                style:
                                                                    TextStyle(
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
                                                                  "Harga",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white,
                                                                  ))),
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
                                                                          'price'],
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white,
                                                                  ))),
                                                        ),
                                                      ]),
                                                      TableRow(children: [
                                                        TableCell(
                                                          child: Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              height: 16,
                                                              child: Text(
                                                                  "Penjual",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white,
                                                                  ))),
                                                        ),
                                                        TableCell(
                                                          child: Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              height: 16,
                                                              child: Text(
                                                                productdata[
                                                                        index]
                                                                    ['name'],
                                                                style:
                                                                    TextStyle(
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
                                                                  "Kos Hantar",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white,
                                                                  ))),
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
                                                                          'delcost'],
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white,
                                                                  ))),
                                                        ),
                                                      ]),
                                                      TableRow(children: [
                                                        TableCell(
                                                          child: Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              height: 16,
                                                              child: Text(
                                                                  "Status",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white,
                                                                  ))),
                                                        ),
                                                        TableCell(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                height: 16,
                                                                child: Text(
                                                                  productdata[
                                                                          index]
                                                                      [
                                                                      "status"],
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ))),
                                                      ]),
                                                    ]),
                                              ],
                                            ))),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 1, 10, 1),
                                        child: SizedBox(
                                            width: 2,
                                            child: Container(
                                              height: screenWidth / 3.5,
                                              color: Colors.grey,
                                            ))),
                                    Container(
                                      height: 80,
                                      width: 40,
                                      child: Column(
                                        children: <Widget>[
                                          Flexible(
                                            child: TextButton (
                                              onPressed: () =>
                                                  {_whatsupPhone(index)},
                                              child: Icon(
                                                MdiIcons.whatsapp,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: TextButton (
                                              onPressed: () =>
                                                  {_sendSMS(index)},
                                              child: Icon(
                                                MdiIcons.message,
                                                color: Colors.blueGrey,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: TextButton (
                                              onPressed: () =>
                                                  {_callPhone(index)},
                                              child: Icon(
                                                MdiIcons.phone,
                                                color: Colors.blueGrey,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )))
                      ],
                    );
                  }),
            )
          ],
        ),
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
          'Whatsup kepada penjual?',
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
                    "Pertanyaan berkenaan dengan order id " +
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
          'Hantar SMS ini kepada ' + productdata[index]['name'],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        content: Text("Pertanyaan berkenaan dengan order id " +
            productdata[index]['orderid'] +
            " untuk produk " +
            productdata[index]['prname'] +
            " dari My.Pasar", style: TextStyle(
                              color: Colors.white,
                            ),),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);

                SmsSender sender = new SmsSender();
                String address = "+60" + productdata[index]['phone'];
                sender.sendSms(new SmsMessage(
                    address,
                    "Pertanyaan berkenaan dengan order id " +
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
        title: new Text('Telefon penjual ' + productdata[index]['name'] + '?',  style: TextStyle(
                              color: Colors.white,
                            ),),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _makePhoneCall('tel:' + productdata[index]['phone']);
              },
              child: Text("Ya",style: TextStyle(
                          color: Color.fromRGBO(101, 255, 218, 50),
                        ),)),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Tidak",style: TextStyle(
                          color: Color.fromRGBO(101, 255, 218, 50),
                        ),)),
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
    String urlLoadJobs = "https://slumberjer.com/mypasar/php/load_cart.php";
    http.post(Uri.parse(urlLoadJobs), body: {
      "phone": widget.user.phone,
      "option": op,
    }).then((res) {
      print(res.body);
      pr.hide();
      setState(() {
        if (res.body == "Cart Empty") {
          productdata = null;
          if (op == "Baru") {
            info = "Tiada Pembelian Baru";
            titlecenter = info;
          }
          if (op == "Penghantaran") {
            info = "Tiada Pembelian Dalam Penghantaran";
            titlecenter = info;
          }
          if (op == "Selesai") {
            info = "Tiada Pembelian Telah Selesai";
            titlecenter = info;
          }
        } else {
          var extractdata = json.decode(res.body);
          productdata = extractdata["usercart"];
        }

        option = op;
      });
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    pr.hide();
  }

  updateStatus(int index) {
    if (option == "Selesai"){
      print("SELESAI");
      return;
    }
    String selectedStatus = "Selesai";
    
    String orderid = productdata[index]['orderid'];
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                'Penghantaran selesai untuk pesanan :' +
                    productdata[index]['orderid'] +
                    "?",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 200,
                      height: 40,
                      child: Text('Penghantaran Selesai'),
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
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Sedang kemaskini status...");
    pr.show();

    http.post(Uri.parse("https://slumberjer.com/mypasar/php/update_order_status.php"),
        body: {
          "orderid": orderid,
          "status": "Selesai",
        }).then((res) {
      print(res.body);
      pr.hide();
      if (res.body == "success") {
        Toast.show("Kemaskini Penghantaran berjaya", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        _loadData(selectedStatus);
      } else {
        Toast.show("Kemaskini Penghantaran tidak berjaya", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.hide();
    });
  }
}
