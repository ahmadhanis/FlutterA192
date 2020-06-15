import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'package:intl/intl.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final User user;

  const PaymentHistoryScreen({Key key, this.user}) : super(key: key);

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List _paymentdata;
  List _orderdetails;

  String titlecenter = "Loading payment history...";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;
  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Text(
            "Payment History",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _paymentdata == null
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
                      //Step 6: Count the data
                      itemCount: _paymentdata == null ? 0 : _paymentdata.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: InkWell(
                                onTap: () => loadOrderDetails(index),
                                child: Card(
                                  elevation: 10,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            (index + 1).toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            "RM " +
                                                _paymentdata[index]['total'],
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      Expanded(
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                _paymentdata[index]['orderid'],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                _paymentdata[index]['billid'],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          )),
                                      Expanded(
                                        child: Text(
                                          f.format(DateTime.parse(
                                              _paymentdata[index]['date'])),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        flex: 3,
                                      ),
                                    ],
                                  ),
                                )));
                      }))
        ]),
      ),
    );
  }

  Future<void> _loadPaymentHistory() async {
    String urlLoadJobs =
        "https://slumberjer.com/grocery/php/load_paymenthistory.php";
    await http
        .post(urlLoadJobs, body: {"email": widget.user.email}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _paymentdata = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _paymentdata = extractdata["payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> _loadOrderDetails(int index) async {
    String urlLoadJobs =
        "https://slumberjer.com/grocery/php/load_carthistory.php";
    await http.post(urlLoadJobs, body: {
      "orderid": _paymentdata[index]['orderid'],
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _orderdetails = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _orderdetails = extractdata["payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> loadOrderDetails(int index) async {
    await _loadOrderDetails(index);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                'Order Details',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: SingleChildScrollView(
                  child: Column(children: <Widget>[
                Text(
                  "Order ID: " + _paymentdata[index]['orderid'],
                  style: TextStyle(color: Colors.white),
                ),
                Container(
                  height: screenHeight /1,
                  
                    child: ListView.builder(
                        itemCount: _paymentdata == null ? 1 : _paymentdata.length,
                        itemBuilder: (context, index) {
                          return Text(_paymentdata[index]['name']);
                        }
                ))
              ])));
        });
  }
}
