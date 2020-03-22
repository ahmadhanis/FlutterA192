import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
            itemCount: cartData == null ? 1 : cartData.length + 2,
            itemBuilder: (context, index) {
              if (index == cartData.length) {
                return Container(
                  height: screenHeight/4,

                    child: Card(
                      elevation: 5,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10,),
                      Text("Delivery Option",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
                    ],
                  ),
                ));
              }
              if (index == cartData.length+1) {
                return Container(
                  height: screenHeight/4,

                    child: Card(
                      elevation: 5,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10,),
                      Text("Payment",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
                    ],
                  ),
                ));
              }
              index -= 0;
              return Card(
                  elevation: 10,
                  child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(children: <Widget>[
                        Container(
                            height: screenWidth / 5,
                            width: screenWidth / 5,
                            decoration: BoxDecoration(
                                //shape: BoxShape.circle,
                                //border: Border.all(color: Colors.black),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        "http://slumberjer.com/grocery/productimage/${cartData[index]['id']}.jpg")))),
                        Padding(
                            padding: EdgeInsets.fromLTRB(5, 1, 10, 1),
                            child: SizedBox(
                                width: 2,
                                child: Container(
                                  height: screenWidth / 3.5,
                                  color: Colors.grey,
                                ))),
                        Container(
                            width: screenWidth / 1.45,
                            //color: Colors.blue,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        cartData[index]['name'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                        maxLines: 1,
                                      ),
                                      Text(
                                        "RM " +
                                            cartData[index]['price'] +
                                            "/unit",
                                      ),
                                      Text("Available " +
                                          cartData[index]['quantity'] +
                                          " unit"),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          FlatButton(
                                            onPressed: () => {},
                                            child: Icon(
                                              MdiIcons.plus,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(cartData[index]['cquantity']),
                                          FlatButton(
                                            onPressed: () => {},
                                            child: Icon(
                                              MdiIcons.minus,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text("RM " + cartData[index]['yourprice'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                )
                              ],
                            )),
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
