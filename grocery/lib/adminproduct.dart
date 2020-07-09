import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery/editproduct.dart';
import 'package:grocery/newproduct.dart';
import 'package:grocery/product.dart';
import 'package:grocery/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'cartscreen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AdminProduct extends StatefulWidget {
  final User user;

  const AdminProduct({Key key, this.user}) : super(key: key);

  @override
  _AdminProductState createState() => _AdminProductState();
}

class _AdminProductState extends State<AdminProduct> {
  List productdata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "Recent";
  String cartquantity = "0";
  int quantity = 1;
  String titlecenter = "Loading products...";
  var _tapPosition;
  String server = "https://slumberjer.com/grocery";
  String scanPrId;

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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Your Products',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
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
                                    color: Color.fromRGBO(101, 255, 218, 50),
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(MdiIcons.update,
                                            color: Colors.black),
                                        Text(
                                          "Recent",
                                          style: TextStyle(color: Colors.black),
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
                                    color: Color.fromRGBO(101, 255, 218, 50),
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.beer,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Drink",
                                          style: TextStyle(color: Colors.black),
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
                                    onPressed: () => _sortItem("Grocery"),
                                    color: Color.fromRGBO(101, 255, 218, 50),
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.rice,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Grocery",
                                          style: TextStyle(color: Colors.black),
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
                                    color: Color.fromRGBO(101, 255, 218, 50),
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.foodVariant,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Canned",
                                          style: TextStyle(color: Colors.black),
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
                                    onPressed: () => _sortItem("Baby"),
                                    color: Color.fromRGBO(101, 255, 218, 50),
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.babyBottle,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Baby",
                                          style: TextStyle(color: Colors.black),
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
                                    onPressed: () => _sortItem("Household"),
                                    color: Color.fromRGBO(101, 255, 218, 50),
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.homeAutomation,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Household",
                                          style: TextStyle(color: Colors.black),
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
                                    color: Color.fromRGBO(101, 255, 218, 50),
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.foodApple,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Vegetable",
                                          style: TextStyle(color: Colors.black),
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
                                    color: Color.fromRGBO(101, 255, 218, 50),
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.fish,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Fish&Meat",
                                          style: TextStyle(color: Colors.black),
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
                                    onPressed: () => _sortItem("Pet"),
                                    color: Color.fromRGBO(101, 255, 218, 50),
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          Icons.pets,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Pet",
                                          style: TextStyle(color: Colors.black),
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
                                    color: Color.fromRGBO(101, 255, 218, 50),
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.breadSlice,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Bread",
                                          style: TextStyle(color: Colors.black),
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
                                    onPressed: () => _sortItem("Others"),
                                    color: Color.fromRGBO(101, 255, 218, 50),
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.ornament,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Others",
                                          style: TextStyle(color: Colors.black),
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
                    height: screenHeight / 12.5,
                    margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Flexible(
                            child: Container(
                          height: 30,
                          child: TextField(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              autofocus: false,
                              controller: _prdController,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.search),
                                  border: OutlineInputBorder())),
                        )),
                        Flexible(
                            child: MaterialButton(
                                color: Color.fromRGBO(101, 255, 218, 50),
                                onPressed: () =>
                                    {_sortItembyName(_prdController.text)},
                                elevation: 5,
                                child: Text(
                                  "Search Product",
                                  style: TextStyle(color: Colors.black),
                                )))
                      ],
                    ),
                  ),
                )),
            Text(curtype,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
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
                : Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (screenWidth / screenHeight) / 0.65,
                        children: List.generate(productdata.length, (index) {
                          return Container(
                              child: InkWell(
                                  onTap: () => _showPopupMenu(index),
                                  onTapDown: _storePosition,
                                  child: Card(
                                      elevation: 10,
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: screenHeight / 5.9,
                                              width: screenWidth / 3.5,
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  imageUrl: server +
                                                      "/productimage/${productdata[index]['id']}.jpg",
                                                  placeholder: (context, url) =>
                                                      new CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            Text(productdata[index]['name'],
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            Text(
                                              "RM " +
                                                  productdata[index]['price'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "Avail/Sold:" +
                                                  productdata[index]
                                                      ['quantity'] +
                                                  "/" +
                                                  productdata[index]['sold'],
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              "Weight:" +
                                                  productdata[index]['weigth'] +
                                                  " gram",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))));
                        })))
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: Icon(Icons.new_releases),
              label: "New Product",
              labelBackgroundColor: Colors.white,
              onTap: createNewProduct),
          SpeedDialChild(
              child: Icon(MdiIcons.barcodeScan),
              label: "Scan Product",
              labelBackgroundColor: Colors.white, //_changeLocality()
              onTap: () => scanProductDialog()),
          SpeedDialChild(
              child: Icon(Icons.report),
              label: "Product Report",
              labelBackgroundColor: Colors.white, //_changeLocality()
              onTap: () => null),
        ],
      ),
    );
  }

  void scanProductDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Select scan options:",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MaterialButton(
                  color: Color.fromRGBO(101, 255, 218, 50),
                  onPressed: scanBarcodeNormal,
                  elevation: 5,
                  child: Text(
                    "Bar Code",
                    style: TextStyle(color: Colors.black),
                  )),
              MaterialButton(
                  color: Color.fromRGBO(101, 255, 218, 50),
                  onPressed: scanQR,
                  elevation: 5,
                  child: Text(
                    "QR Code",
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          ),
        );
      },
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (barcodeScanRes == "-1") {
        scanPrId = "";
      } else {
        scanPrId = barcodeScanRes;
        Navigator.of(context).pop();
        _loadSingleProduct(scanPrId);
      }
    });
  }

  void _loadSingleProduct(String prid) {
    String urlLoadJobs = server + "/php/load_products.php";
    http.post(urlLoadJobs, body: {
      "prid": prid,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        Toast.show("Not found", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
          print(productdata);
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (barcodeScanRes == "-1") {
        scanPrId = "";
      } else {
        scanPrId = barcodeScanRes;
        Navigator.of(context).pop();
        _loadSingleProduct(scanPrId);
      }
    });
  }

  void _loadData() {
    String urlLoadJobs = server + "/php/load_products.php";
    http.post(urlLoadJobs, body: {}).then((res) {
      print(res.body);
      setState(() {
        var extractdata = json.decode(res.body);
        productdata = extractdata["products"];
        cartquantity = widget.user.quantity;
      });
    }).catchError((err) {
      print(err);
    });
  }

  void _sortItem(String type) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs = server + "/php/load_products.php";
      http.post(urlLoadJobs, body: {
        "type": type,
      }).then((res) {
        if (res.body == "nodata") {
          setState(() {
            curtype = type;
            titlecenter = "No product found";
            productdata = null;
          });
          pr.dismiss();
          return;
        } else {
          setState(() {
            curtype = type;
            var extractdata = json.decode(res.body);
            productdata = extractdata["products"];
            FocusScope.of(context).requestFocus(new FocusNode());
            pr.dismiss();
          });
        }
      }).catchError((err) {
        print(err);
        pr.dismiss();
      });
      pr.dismiss();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _sortItembyName(String prname) {
    try {
      print(prname);
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs = server + "/php/load_products.php";
      http
          .post(urlLoadJobs, body: {
            "name": prname.toString(),
          })
          .timeout(const Duration(seconds: 4))
          .then((res) {
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
          })
          .catchError((err) {
            pr.dismiss();
          });
      pr.dismiss();
    } on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  gotoCart() {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CartScreen(
                    user: widget.user,
                  )));
    }
  }

  _onProductDetail(int index) async {
    print(productdata[index]['name']);
    Product product = new Product(
        pid: productdata[index]['id'],
        name: productdata[index]['name'],
        price: productdata[index]['price'],
        quantity: productdata[index]['quantity'],
        weigth: productdata[index]['weigth'],
        type: productdata[index]['type'],
        date: productdata[index]['date']);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EditProduct(
                  user: widget.user,
                  product: product,
                )));
    _loadData();
  }

  _showPopupMenu(int index) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      color: Colors.white,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        //onLongPress: () => _showPopupMenu(), //onLongTapCard(index),

        PopupMenuItem(
          child: GestureDetector(
              onTap: () =>
                  {Navigator.of(context).pop(), _onProductDetail(index)},
              child: Text(
                "Update Product?",
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () =>
                  {Navigator.of(context).pop(), _deleteProductDialog(index)},
              child: Text(
                "Delete Product?",
                style: TextStyle(color: Colors.black),
              )),
        ),
      ],
      elevation: 8.0,
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _deleteProductDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Delete Product Id " + productdata[index]['id'],
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content:
              new Text("Are you sure?", style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct(index);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(int index) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting product...");
    pr.show();
    String prid = productdata[index]['id'];
    print("prid:"+prid);
    http.post(server + "/php/delete_product.php", body: {
      "prodid": prid,
    }).then((res) {
      print(res.body);
      pr.dismiss();
      if (res.body == "success") {
        Toast.show("Delete success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadData();
        Navigator.of(context).pop();
      } else {
        Toast.show("Delete failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }

  Future<void> createNewProduct() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => NewProduct()));
    _loadData();
  }
}
