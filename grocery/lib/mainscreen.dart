import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:toast/toast.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List productdata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    Icon _iconmore = Icon(Icons.expand_more);
    Icon _iconless = Icon(Icons.expand_less);

    if (productdata == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Products List'),
          ),
          body: Center(child: CircularProgressIndicator()));
    } else {
      return Scaffold(
        drawer: mainDrawer(context),
        appBar: AppBar(
          title: Text('Products List'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  if (_visible) {
                    print("Hello");
                    _visible = false;
                  } else {
                    _visible = true;
                    print("auch");
                  }
                });
                print(_visible);
              },
            ),

            //
          ],
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: _visible,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextField(
                    onChanged: (value) {},
                    controller: null,
                    decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
              ),
              Visibility(
                visible: _visible,
                child: Card(
                    elevation: 10,
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                               Column(
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () => _sortItem("Recent"),
                                      color: Colors.brown[400],
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(Icons.new_releases),
                                          Text("Recent")
                                        ],
                                      )),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () => _sortItem("Drink"),
                                      color: Colors.brown[400],
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(Icons.local_drink),
                                          Text("Drink")
                                        ],
                                      )),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () => _sortItem("Canned Food"),
                                      color: Colors.brown[400],
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(Icons.fastfood),
                                          Text("Canned")
                                        ],
                                      )),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () => _sortItem("Vegetable"),
                                      color: Colors.brown[400],
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(Icons.nature),
                                          Text("Vegetable")
                                        ],
                                      )),
                                ],
                              ),
                               Column(
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () => _sortItem("Vegetable"),
                                      color: Colors.brown[400],
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(Icons.nature),
                                          Text("Vegetable")
                                        ],
                                      )),
                                ],
                              ),
                            ],
                          ),
                          
                        ))),
              ),
              Flexible(
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 100 / 130,
                      children: List.generate(productdata.length, (index) {
                        return Card(
                            elevation: 10,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      height: screenWidth / 4,
                                      width: screenWidth / 4,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.black),
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  "http://slumberjer.com/grocery/productimage/${productdata[index]['id']}.jpg")))),
                                  Text(productdata[index]['name'],
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text("RM " + productdata[index]['price']),
                                  Text("Quantity available:" +
                                      productdata[index]['quantity']),
                                  Text("Weight:" +
                                      productdata[index]['weigth'] +
                                      " gram"),
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    minWidth: 100,
                                    height: 40,
                                    child: Text('Add to Cart'),
                                    color: Colors.brown,
                                    textColor: Colors.white,
                                    elevation: 10,
                                    onPressed: () => _showQuantity(index),
                                  ),
                                ],
                              ),
                            ));
                      })))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          child: Icon(Icons.shopping_cart),
          //backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _loadData() {
    String urlLoadJobs = "https://slumberjer.com/grocery/php/load_products.php";
    http.post(urlLoadJobs, body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        productdata = extractdata["products"];
       
      });
    }).catchError((err) {
      print(err);
    });
  }

  Widget mainDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.name),
            accountEmail: Text(widget.user.email),
            otherAccountsPictures: <Widget>[
              Text("RM " + widget.user.credit,
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
            ],
            currentAccountPicture: CircleAvatar(
              backgroundColor:
                  Theme.of(context).platform == TargetPlatform.android
                      ? Colors.white
                      : Colors.white,
              child: Text(
                widget.user.name.toString().substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            title: Text("Search product"),
            trailing: Icon(Icons.arrow_forward),
          ),
          ListTile(
            title: Text("Shopping Cart"),
            trailing: Icon(Icons.arrow_forward),
          ),
          ListTile(
            title: Text("Purchased History"),
            trailing: Icon(Icons.arrow_forward),
          ),
          ListTile(
            title: Text("User Profile"),
            trailing: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }

  void _showQuantity(int index) {
    curnumber = 1;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: new Text("Select Quantity"),
            content: new Container(
              height: screenHeight / 2.5,
              child: Column(
                children: <Widget>[
                  NumberPicker.integer(
                      initialValue: 1,
                      minValue: 1,
                      maxValue: int.parse(productdata[index]['quantity']) - 10,
                      highlightSelectedValue: true,
                      onChanged: (newValue) =>
                          setState(() => curnumber = newValue)),
                  new IconButton(
                    iconSize: 50,
                    icon: new Icon(Icons.add_shopping_cart),
                    onPressed: _showcurnumber,
                  )
                ],
              ),
            ));
      },
    );
  }

  void _showcurnumber() {
    print(curnumber);
  }

  void _addtoCart(int index) {
    double price = curnumber * double.parse(productdata[index]["price"]);
    print(price);
    print(productdata[index]["name"]);
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Add to cart...");
    pr.show();
    String urlLoadJobs = "https://slumberjer.com/grocery/php/insert_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
      "proid": productdata[index]["id"],
      "price": price.toString(),
      "quantity": curnumber.toString(),
      "prname": productdata[index]["name"]
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Added to cart", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Failed add to cart", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
      pr.dismiss();
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    pr.dismiss();
  }

  void _sortItem(String type) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Searching...");
    pr.show();
    String urlLoadJobs = "https://slumberjer.com/grocery/php/load_products.php";
    http.post(urlLoadJobs, body: {
      "type": type,
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        productdata = extractdata["products"];
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    pr.dismiss();
  }
}
