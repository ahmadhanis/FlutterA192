import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'user.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final User user;

  const PaymentHistoryScreen({Key key, this.user}) : super(key: key);

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List paymentdata;
  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History'),
      ),
      body: Center(
        child: Container(
            child: ListView.builder(
                //Step 6: Count the data
                itemCount: paymentdata == null ? 0 : paymentdata.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap:()=> loadOrderDetails(index),
                      child: Card(
                          elevation: 10,
                          child: Column(
                            children: <Widget>[
                              Text(
                                paymentdata[index]['orderid'],
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                paymentdata[index]['billid'],
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                paymentdata[index]['total'],
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          )));
                })),
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
        //titlecenter = "No product found";
        setState(() {
          paymentdata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          paymentdata = extractdata["payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void loadOrderDetails(int index) {
    print(paymentdata[index]['orderid']);
  }
}
