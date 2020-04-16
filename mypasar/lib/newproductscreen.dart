import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mypasar/registerscreen.dart';
import 'package:mypasar/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class NewProductScreen extends StatefulWidget {
  final User user;

  const NewProductScreen({Key key, this.user}) : super(key: key);

  @override
  _NewProductScreenState createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = 'assets/images/phonecam.png';
  Position _currentPosition;
  String curaddress;
  double latitude, longitude;
  TextEditingController productEditingController = new TextEditingController();
  TextEditingController qtyEditingController = new TextEditingController();
  TextEditingController priceEditingController = new TextEditingController();
  TextEditingController deliEditingController = new TextEditingController();
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();

  @override
  void initState() {
    super.initState();
    print("New Product");
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Produk Baru'),
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
                "Mencari Lokaliti Anda",
                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
              )
            ],
          ),
        )),
      );
    } else {
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = MediaQuery.of(context).size.width;
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Produk Baru'),
          ),
          body: Container(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  GestureDetector(
                                      onTap: () => {_choose()},
                                      child: Container(
                                        height: screenHeight / 3,
                                        width: screenWidth / 1.8,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: _image == null
                                                ? AssetImage(pathAsset)
                                                : FileImage(_image),
                                            fit: BoxFit.fill,
                                          ),
                                          border: Border.all(
                                            width: 3.0,
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  5.0) //         <--- border radius here
                                              ),
                                        ),
                                      )),
                                  SizedBox(height: 5),
                                  Text("Klik imej untuk ambil gambar jualan",
                                      style: TextStyle(fontSize: 10.0,color: Colors.white)),
                                  SizedBox(height: 5),
                                  Card(
                                      elevation: 10,
                                      child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: <Widget>[
                                              Table(
                                                  defaultColumnWidth:
                                                      FlexColumnWidth(1.0),
                                                  children: [
                                                    TableRow(children: [
                                                      TableCell(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 30,
                                                            child: Text(
                                                                "Nama Produk",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white))),
                                                      ),
                                                      TableCell(
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  5, 1, 5, 1),
                                                          height: 30,
                                                          child: TextFormField(
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              controller:
                                                                  productEditingController,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .text,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                              onFieldSubmitted:
                                                                  (v) {
                                                                FocusScope.of(
                                                                        context)
                                                                    .requestFocus(
                                                                        focus);
                                                              },
                                                              decoration:
                                                                  new InputDecoration(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .all(5),

                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                border:
                                                                    new OutlineInputBorder(
                                                                  borderRadius:
                                                                      new BorderRadius
                                                                              .circular(
                                                                          5.0),
                                                                  borderSide:
                                                                      new BorderSide(),
                                                                ),

                                                                //fillColor: Colors.green
                                                              )),
                                                        ),
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      TableCell(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 30,
                                                            child: Text(
                                                                "Harga(RM)",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white))),
                                                      ),
                                                      TableCell(
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  5, 1, 5, 1),
                                                          height: 30,
                                                          child: TextFormField(
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              controller:
                                                                  priceEditingController,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                              focusNode: focus,
                                                              onFieldSubmitted:
                                                                  (v) {
                                                                FocusScope.of(
                                                                        context)
                                                                    .requestFocus(
                                                                        focus1);
                                                              },
                                                              decoration:
                                                                  new InputDecoration(
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                border:
                                                                    new OutlineInputBorder(
                                                                  borderRadius:
                                                                      new BorderRadius
                                                                              .circular(
                                                                          5.0),
                                                                  borderSide:
                                                                      new BorderSide(),
                                                                ),
                                                                //fillColor: Colors.green
                                                              )),
                                                        ),
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      TableCell(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 30,
                                                            child: Text(
                                                                "Kuantiti",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white))),
                                                      ),
                                                      TableCell(
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  5, 1, 5, 1),
                                                          height: 30,
                                                          child: TextFormField(
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              controller:
                                                                  qtyEditingController,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                              focusNode: focus1,
                                                              onFieldSubmitted:
                                                                  (v) {
                                                                FocusScope.of(
                                                                        context)
                                                                    .requestFocus(
                                                                        focus2);
                                                              },
                                                              decoration:
                                                                  new InputDecoration(
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                border:
                                                                    new OutlineInputBorder(
                                                                  borderRadius:
                                                                      new BorderRadius
                                                                              .circular(
                                                                          5.0),
                                                                  borderSide:
                                                                      new BorderSide(),
                                                                ),
                                                                //fillColor: Colors.green
                                                              )),
                                                        ),
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      TableCell(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 30,
                                                            child: Text(
                                                                "Kos Hantar (RM/KM)",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white))),
                                                      ),
                                                      TableCell(
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  5, 1, 5, 1),
                                                          height: 30,
                                                          child: TextFormField(
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              controller:
                                                                  deliEditingController,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              focusNode: focus2,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              decoration:
                                                                  new InputDecoration(
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                border:
                                                                    new OutlineInputBorder(
                                                                  borderRadius:
                                                                      new BorderRadius
                                                                              .circular(
                                                                          5.0),
                                                                  borderSide:
                                                                      new BorderSide(),
                                                                ),
                                                                //fillColor: Colors.green
                                                              )),
                                                        ),
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      TableCell(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 30,
                                                            child: Text(
                                                                "Lokaliti Penjual",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white))),
                                                      ),
                                                      TableCell(
                                                          child: Container(
                                                        height: 30,
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 30,
                                                            child: Text(
                                                              " " + curaddress,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )),
                                                      )),
                                                    ]),
                                                  ]),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)),
                                                minWidth: 200,
                                                height: 40,
                                                child: Text('Simpan'),
                                                color: Color.fromRGBO(
                                                    101, 255, 218, 50),
                                                textColor: Colors.black,
                                                elevation: 5,
                                                onPressed: newProductDialog,
                                              ),
                                            ],
                                          ))),
                                ],
                              )))))));
    }
  }

  void _choose() async {
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 400, maxWidth: 300);
    setState(() {});
  }

  _getLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    _currentPosition = await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
        .timeout(Duration(seconds: 5), onTimeout: () {
      Toast.show("Lokaliti anda tidak dapat dikesan", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    });
    final coordinates =
        new Coordinates(_currentPosition.latitude, _currentPosition.longitude);
    var addresses = await Geocoder.local
        .findAddressesFromCoordinates(coordinates)
        .timeout(Duration(seconds: 5), onTimeout: () {
      Toast.show("Alamat anda tidak dapat dikesan", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    });
    var first = addresses.first;
    setState(() {
      curaddress = first.locality;
      print(curaddress);
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });

    print("${first.featureName} : ${first.addressLine}");
  }

  newProductDialog() {
    if (widget.user.phone == null) {
      Toast.show("Sila daftar sebelum menggunakan ciri ini", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => RegisterScreen()));
      return;
    }
    if (_image == null) {
      Toast.show("Sila ambil gambar produk dahulu", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (productEditingController.text.length < 4) {
      Toast.show("Sila masukkan nama produk", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (qtyEditingController.text.length < 1) {
      Toast.show("Sila masukkan jumlah produk", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (priceEditingController.text.length < 1) {
      Toast.show("Sila masukkan harga produk", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (deliEditingController.text.length < 1) {
      Toast.show("Sila masukkan harga cas penghantaran", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
              "Kemasukan produk baru " + productEditingController.text,style: TextStyle(
                              color: Colors.white,
                            ),),
          content: new Text("Anda Pasti?",style: TextStyle(
                              color: Colors.white,
                            ),),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ya",style: TextStyle(
                          color: Color.fromRGBO(101, 255, 218, 50),
                        ),),
              onPressed: () {
                Navigator.of(context).pop();
                addProduct();
              },
            ),
            new FlatButton(
              child: new Text("Tidak",style: TextStyle(
                          color: Color.fromRGBO(101, 255, 218, 50),
                        ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void addProduct() {
    print(widget.user.phone);

    String base64Image = base64Encode(_image.readAsBytesSync());
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Sedang memuatnaik produk...");
    pr.show();
    double price = double.parse(priceEditingController.text);
    double delivery = double.parse(deliEditingController.text);

    http.post("https://slumberjer.com/mypasar/php/insert_product.php", body: {
      "phone": widget.user.phone,
      "prname": productEditingController.text,
      "quantity": qtyEditingController.text,
      "price": price.toStringAsFixed(2),
      "delivery": delivery.toStringAsFixed(2),
      "encoded_string": base64Image,
      "latitude": _currentPosition.latitude.toString(),
      "longitude": _currentPosition.longitude.toString(),
      "locality": curaddress,
    }).then((res) {
      print("RESBODY " + res.body);

      if (res.body == "success") {
        Toast.show("Kemasukan produk berjaya", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        pr.dismiss();
      } else {
        Toast.show("Kemasukan produk tidak berjaya", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    pr.dismiss();
  }
}
