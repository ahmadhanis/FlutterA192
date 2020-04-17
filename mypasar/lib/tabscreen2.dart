import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mypasar/editproduct.dart';
import 'package:mypasar/product.dart';
import 'package:mypasar/sellersellscreen.dart';
import 'package:mypasar/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'newproductscreen.dart';

class TabScreen2 extends StatefulWidget {
  final User user;

  const TabScreen2({Key key, this.user}) : super(key: key);

  @override
  _TabScreen2State createState() => _TabScreen2State();
}

class _TabScreen2State extends State<TabScreen2> {
  double screenHeight, screenWidth;
  String pathAsset = 'assets/images/phonecam.png';
  String curaddress;
  String msg = "My.Pasar";
  double latitude, longitude;
  TextEditingController productEditingController = new TextEditingController();
  TextEditingController qtyEditingController = new TextEditingController();
  TextEditingController priceEditingController = new TextEditingController();
  TextEditingController deliEditingController = new TextEditingController();
  List productdata;
  var _tapPosition;
  ProgressDialog pr;
  
  @override
  void initState() {
    super.initState();
    print("Init tab 2");
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (productdata == null) {
      return Scaffold(
          body: Container(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  msg,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                  child: Icon(Icons.add),
                  label: "Tambah produk",
                  labelBackgroundColor: Colors.white,
                  onTap: _addProductDialog),
              SpeedDialChild(
                  child: Icon(Icons.shopping_cart),
                  label: "Penjualan Saya",
                  labelBackgroundColor: Colors.white,
                  onTap: _sellScreen),
            ],
          ));
    } else {
      if (pr != null) {
        pr.dismiss();
      }
      return Scaffold(
          resizeToAvoidBottomPadding: true,
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 5),
                Text("Senarai Produk Anda",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                Container(
                  height: 14,
                  child: Text("Klik pada produk utk menu pilihan",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                      )),
                ),
                Divider(height:2,color: Color.fromRGBO(101, 255, 218, 50)),
                SizedBox(height: 5),
                
                Flexible(
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (screenWidth / screenHeight) / 0.7,
                        children: List.generate(productdata.length, (index) {
                          return Card(
                              elevation: 10,
                              child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: GestureDetector(
                                    //onLongPress: () => _showPopupMenu(), //onLongTapCard(index),
                                    onTap: () => _showPopupMenu(index),
                                    onTapDown:
                                        _storePosition, //onTapCard(index),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: screenHeight / 5.5,
                                          width: screenWidth / 2.8,
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
                                        SizedBox(height: 3),
                                        Flexible(
                                            child: Text(
                                          productdata[index]['prname'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          maxLines: 1,
                                        )),
                                        SizedBox(height: 3),
                                        Text(
                                          "RM" +
                                              double.parse(productdata[index]
                                                      ['price'])
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "Terdapat " +
                                              productdata[index]['quantity'] +
                                              " unit",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "Terjual " +
                                              productdata[index]['sell'] +
                                              " unit",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )));
                        })))
              ],
            ),
          ),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                  child: Icon(Icons.add),
                  label: "Tambah produk",
                  labelBackgroundColor: Colors.white,
                  onTap: _addProductDialog),
              SpeedDialChild(
                  child: Icon(Icons.shopping_cart),
                  label: "Penjualan saya",
                  labelBackgroundColor: Colors.white,
                  onTap: _sellScreen),
            ],
          ));
    }
  }

  _addProductDialog() async {
    if (widget.user.name == "Tidak Berdaftar") {
      Toast.show("Sila daftar akaun dahulu", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  NewProductScreen(user: widget.user)));
      _loadData();
    }
  }

  void _loadData() {
    if(widget.user.name == "Tidak Berdaftar"){
      Toast.show("Sila daftar/login", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
   pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Memuat turun...");
    pr.show();

    String urlLoadJobs = "https://slumberjer.com/mypasar/php/load_products.php";
    http.post(urlLoadJobs, body: {
      "phone": widget.user.phone,
    }).then((res) {
      print(res.body);
      pr.dismiss();
      setState(() {
        if (res.body == "nodata"){
           productdata = null; 
           pr.dismiss();
        }else{
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
          pr.dismiss();
        }
        //pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    pr.dismiss();
  }

  void onDeleteProduct(int index) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Padam " + productdata[index]['prname'],
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: new Text(
            "Anda Pasti?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Ya",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deleteRequest(index);
              },
            ),
            new FlatButton(
              child: new Text(
                "Tidak",
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

  Future<String> deleteRequest(int index) async {
    String urlDelete = "http://slumberjer.com/mypasar/php/delete_product.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Memadam Produk...");
    pr.show();
    http.post(urlDelete, body: {
      "prid": productdata[index]['id'],
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Berjaya dibuang", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
        _loadData();
      } else {
        Toast.show("Tidak berjaya dibuang", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  onUpdateProduct(int index) async {
    Product _product = new Product(
        productdata[index]['id'],
        productdata[index]['phone'],
        productdata[index]['prname'],
        productdata[index]['quantity'],
        productdata[index]['price'],
        productdata[index]['delivery'],
        productdata[index]['imagename'],
        productdata[index]['datereg'],
        productdata[index]['latitude'],
        productdata[index]['longitude']);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                EditProduct(user: widget.user, product: _product)));
    _loadData();
  }

  _sellScreen() {
    if (widget.user.name == "Tidak Berdaftar") {
      Toast.show("Sila daftar akaun dahulu", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  SellerSellScreen(user: widget.user)));
    }
  }

  _showPopupMenu(int index) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        //onLongPress: () => _showPopupMenu(), //onLongTapCard(index),

        PopupMenuItem(
          child: GestureDetector(
              onTap: () =>
                  {Navigator.of(context).pop(), onUpdateProduct(index)},
              child: Text(
                "Kemaskini Produk",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () => {_deleteProd(index)},
              child: Text(
                "Buang Produk",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ),
      ],
      elevation: 8.0,
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  _deleteProd(int index) {
    Navigator.of(context).pop();
    onDeleteProduct(index);
  }
}
