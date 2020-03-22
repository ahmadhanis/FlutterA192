import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery/user.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  final User user;

  const CartScreen({Key key, this.user}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List cartData;
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (cartData == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text('My Cart'),
          ),
          body: Container(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Loading Your Cart",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          )));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Cart'),
        ),
        body: ListView.builder(
            itemCount: cartData == null ? 1 : cartData.length,
            itemBuilder: (context, index) {
              return Card(
                  elevation: 10,
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(children: <Widget>[
                        Container(
                            height: screenWidth/5,
                            width : screenWidth/5,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        "http://slumberjer.com/grocery/productimage/${cartData[index]['id']}.jpg")))),
                        SizedBox(width:10),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(cartData[index]['name'],
                                      maxLines: 1)),
                            Column(children: <Widget>[
                              RaisedButton(child:Text("+")),
                              Text(cartData[index]['cquantity']),
                              RaisedButton(child:Text("-")),
                            ],)
                            ],
                          ),
                        )
                      ])));
            }),
      );
    }
  }

  void _loadCart() {
    String urlLoadJobs = "https://slumberjer.com/grocery/php/load_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      setState(() {
        var extractdata = json.decode(res.body);
        cartData = extractdata["cart"];
      });
    }).catchError((err) {
      print(err);
    });
  }
}
