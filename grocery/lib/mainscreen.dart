import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'cartscreen.dart';

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
  String curtype = "Recent";
  String cartquantity="0";
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _prdController = new TextEditingController();

    if (productdata == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Products List'),
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
                  "Loading Products",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          )));
    } else {
      return Scaffold(
        drawer: mainDrawer(context),
        appBar: AppBar(
          title: Text('Products List'),
          actions: <Widget>[
            IconButton(
              icon: _visible
                  ? new Icon(Icons.expand_more)
                  : new Icon(Icons.expand_less),
              onPressed: () {
                setState(() {
                  if (_visible) {
                    _visible = false;
                  } else {
                    _visible = true;
                  }
                });
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
                                      color: Colors.blue[500],
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.update,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Recent",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Column(
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () => _sortItem("Drink"),
                                      color: Colors.blue[500],
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.beer,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Drink",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Column(
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () => _sortItem("Canned Food"),
                                      color: Colors.blue[500],
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.foodVariant,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Canned",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Column(
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () => _sortItem("Vegetable"),
                                      color: Colors.blue[500],
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.foodApple,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Vegetable",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Column(
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () => _sortItem("Meat"),
                                      color: Colors.blue[500],
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.fish,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Fish&Meat",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Column(
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () => _sortItem("Bread"),
                                      color: Colors.blue[500],
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.breadSlice,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Bread",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ))),
              ),
              Visibility(
                  visible: _visible,
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
                                autofocus: false,
                                controller: _prdController,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.search),
                                    border: OutlineInputBorder())),
                          )),
                          Flexible(
                              child: MaterialButton(
                                  color: Colors.blue[500],
                                  onPressed: () =>
                                      {_sortItembyName(_prdController.text)},
                                  elevation: 5,
                                  child: Text(
                                    "Search Product",
                                    style: TextStyle(color: Colors.white),
                                  )))
                        ],
                      ),
                    ),
                  )),
              Text(curtype,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Flexible(
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (screenWidth / screenHeight) / 0.8,
                      children: List.generate(productdata.length, (index) {
                        return Card(
                            elevation: 10,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () => _onImageDisplay(index),
                                    child: Container(
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
                                  ),
                                  Text(productdata[index]['name'],
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    "RM " + productdata[index]['price'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
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
                                    color: Colors.blue[500],
                                    textColor: Colors.white,
                                    elevation: 10,
                                    onPressed: () => _addtocartdialog(index),
                                  ),
                                ],
                              ),
                            ));
                      })))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => CartScreen(
                      user: widget.user,
                    )));
          },
          icon: Icon(Icons.add_shopping_cart),
          label: Text(cartquantity),
        ),
      );
    }
  }

  _onImageDisplay(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: new Container(
          height: screenHeight / 2.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: screenWidth / 2,
                  width: screenWidth / 2,
                  decoration: BoxDecoration(
                      //border: Border.all(color: Colors.black),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "http://slumberjer.com/grocery/productimage/${productdata[index]['id']}.jpg")))),
            ],
          ),
        ));
      },
    );
  }

  void _loadData() {
    String urlLoadJobs = "https://slumberjer.com/grocery/php/load_products.php";
    http.post(urlLoadJobs, body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        productdata = extractdata["products"];
        cartquantity= widget.user.quantity;

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
                    onPressed: null,
                  )
                ],
              ),
            ));
      },
    );
  }

  _addtocartdialog(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Add to Cart?'),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _addtoCart(index);
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

  void _addtoCart(int index) {
    int quantity = int.parse(productdata[index]["quantity"]);
    print(quantity);
    print(productdata[index]["id"]);
    print(widget.user.email);
    if (quantity > 0) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Add to cart...");
      pr.show();
      String urlLoadJobs = "https://slumberjer.com/grocery/php/insert_cart.php";
      http.post(urlLoadJobs, body: {
        "email": widget.user.email,
        "proid": productdata[index]["id"],
      }).then((res) {
        print(res.body);
        if (res.body == "failed") {
          Toast.show("Failed add to cart", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        } else {
          List respond = res.body.split(",");
          setState(() {
            cartquantity = respond[1];  
          });
          
          Toast.show("Success add to cart", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
        pr.dismiss();
      }).catchError((err) {
        print(err);
        pr.dismiss();
      });
      pr.dismiss();
    } else {
      Toast.show("Out of stock", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
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
        curtype = type;
        var extractdata = json.decode(res.body);
        productdata = extractdata["products"];
        FocusScope.of(context).requestFocus(new FocusNode());
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    pr.dismiss();
  }

  void _sortItembyName(String prname) {
    print(prname);
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Searching...");
    pr.show();
    String urlLoadJobs = "https://slumberjer.com/grocery/php/load_products.php";
    http.post(urlLoadJobs, body: {
      "name": prname.toString(),
    }).then((res) {
      if (res.body == "nodata") {
        Toast.show("Product not found", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
        FocusScope.of(context).requestFocus(new FocusNode());
        return;
      }
      setState(() {
        var extractdata = json.decode(res.body);
        productdata = extractdata["products"];
        FocusScope.of(context).requestFocus(new FocusNode());
        curtype = prname;
        pr.dismiss();
      });
    }).catchError((err) {
      pr.dismiss();
    });
    pr.dismiss();
  }
}
