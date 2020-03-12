import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List productdata;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (productdata == null) {
      return MaterialApp(
          title: 'Material App',
          home: Scaffold(
              appBar: AppBar(
                title: Text('Products List'),
              ),
              body: Center(child: CircularProgressIndicator())));
    } else {
      return Scaffold(
        drawer: mainDrawer(context),
        appBar: AppBar(
          title: Text('Products List'),
        ),
        body: ListView.builder(
            itemCount: productdata == null ? 1 : productdata.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                new IconButton(
                                    iconSize: 50,
                                    icon: new Icon(Icons.local_drink),
                                    onPressed: () =>_sortItem("Drink")),
                                Text("Drink")
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                new IconButton(
                                    iconSize: 50,
                                    icon: new Icon(Icons.fastfood),
                                    onPressed: () =>_sortItem("Canned Food")),
                                Text("Canned Food")
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                new IconButton(
                                    iconSize: 50,
                                    icon: new Icon(Icons.nature),
                                    onPressed: () =>_sortItem("Vegetable")),
                                Text("Vegetable")
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (index == productdata.length) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Text("Footer"),
                    ],
                  ),
                );
              }
              index -= 1;
              return Card(
                  elevation: 10,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        "http://slumberjer.com/grocery/productimage/${productdata[index]['id']}.jpg")))),
                        Text(productdata[index]['name']),
                        Text("RM " + productdata[index]['price']),
                        Text("Quantity available:" +
                            productdata[index]['quantity']),
                        Text(productdata[index]['weigth'] + " gram"),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minWidth: 100,
                          height: 50,
                          child: Text('Add to Cart'),
                          color: Colors.brown,
                          textColor: Colors.white,
                          elevation: 10,
                          onPressed: _addtoCart,
                        ),
                      ],
                    ),
                  ));
            }),
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

  void _addtoCart() {}

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
