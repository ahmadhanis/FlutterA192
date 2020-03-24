import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:grocery/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CartScreen extends StatefulWidget {
  final User user;

  const CartScreen({Key key, this.user}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List cartData;
  double screenHeight, screenWidth;
  bool _selfPickup = false;
  bool _homeDelivery = false;
  double _weight = 0.0, _totalprice = 0.0;
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
                    height: screenHeight / 2.4,
                    width: screenWidth / 2.5,
                    child: Card(
                      color: Colors.yellow,
                      elevation: 5,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Text("Delivery Option",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold)),
                          Text("Weight:" + _weight.toString() + " KG",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                          Expanded(
                              child: Row(
                            children: <Widget>[
                              Container(
                                // color: Colors.red,
                                width: screenWidth / 2,
                                height: screenHeight / 3,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                          value: _selfPickup,
                                          onChanged: (bool value) {
                                            _onSelfPickUp(value);
                                          },
                                        ),
                                        Text("Self Pickup"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(2, 1, 2, 1),
                                  child: SizedBox(
                                      width: 2,
                                      child: Container(
                                        height: screenWidth / 2,
                                        color: Colors.grey,
                                      ))),
                              Expanded(
                                  child: Container(
                                //color: Colors.blue,
                                width: screenWidth / 2,
                                height: screenHeight / 3,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                          value: _homeDelivery,
                                          onChanged: (bool value) {
                                            _onHomeDelivery(value);
                                          },
                                        ),
                                        Text("Home Delivery"),
                                      ],
                                    ),
                                    FlatButton(
                                      color: Colors.blue,
                                      onPressed: () =>
                                          {_updateCart(index, "add")},
                                      child: Icon(
                                        MdiIcons.locationEnter,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "597 Jalan Teja 21, Taman Teja Fasa 2, Jalan Teja",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              )),
                            ],
                          ))
                        ],
                      ),
                    ));
              }
              if (index == cartData.length + 1) {
                return Container(
                    height: screenHeight / 4,
                    child: Card(
                      elevation: 5,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Text("Payment",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                          Text("Total RM " + _totalprice.toString(),
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold))
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
                        Column(
                          children: <Widget>[
                            Container(
                                height: screenWidth / 4.8,
                                width: screenWidth / 4.8,
                                decoration: BoxDecoration(
                                    //shape: BoxShape.circle,
                                    //border: Border.all(color: Colors.black),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            "http://slumberjer.com/grocery/productimage/${cartData[index]['id']}.jpg")))),
                            Text(
                              "RM " + cartData[index]['price'],
                            ),
                          ],
                        ),
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
                                      Text("Available " +
                                          cartData[index]['quantity'] +
                                          " unit"),
                                      Text("Your Quantity " +
                                          cartData[index]['cquantity']),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          FlatButton(
                                            onPressed: () =>
                                                {_updateCart(index, "add")},
                                            child: Icon(
                                              MdiIcons.plus,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(cartData[index]['cquantity']),
                                          FlatButton(
                                            onPressed: () =>
                                                {_updateCart(index, "remove")},
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
    _weight = 0.0;
    _totalprice = 0.0;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating cart...");
    pr.show();
    String urlLoadJobs = "https://slumberjer.com/grocery/php/load_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      pr.dismiss();
      setState(() {
        var extractdata = json.decode(res.body);
        cartData = extractdata["cart"];
        for (int i = 0; i < cartData.length; i++) {
          _weight = double.parse(cartData[i]['weight']) *
                  int.parse(cartData[i]['cquantity']) +
              _weight;
          _totalprice = double.parse(cartData[i]['yourprice']) + _totalprice;
        }
        _weight = _weight / 1000;
        print(_weight);
        print(_totalprice);
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    pr.dismiss();
  }

  _updateCart(int index, String op) {
    int curquantity = int.parse(cartData[index]['quantity']);
    int quantity = int.parse(cartData[index]['cquantity']);
    if (op == "add") {
      quantity++;
      if (quantity > (curquantity - 2)) {
        Toast.show("Quantity not available", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    }
    if (op == "remove") {
      quantity--;
      if (quantity == 0) {
        _deleteCart(index);
        return;
      }
    }
    String urlLoadJobs = "https://slumberjer.com/grocery/php/update_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
      "prodid": cartData[index]['id'],
      "quantity": quantity.toString()
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Cart Updated", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadCart();
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  _deleteCart(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Delete item?'),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post("https://slumberjer.com/grocery/php/delete_cart.php",
                    body: {
                      "email": widget.user.email,
                      "prodid": cartData[index]['id'],
                    }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text("Yes")),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel")),
        ],
      ),
    );
  }

  void _onSelfPickUp(bool newValue) => setState(() {
        _selfPickup = newValue;
        if (_selfPickup) {
          _homeDelivery = false;
        } else {}
      });

  void _onHomeDelivery(bool newValue) => setState(() {
        _homeDelivery = newValue;
        if (_homeDelivery) {
          _selfPickup = false;
        } else {}
      });
}
