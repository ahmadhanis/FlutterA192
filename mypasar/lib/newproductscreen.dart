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
import 'package:image_cropper/image_cropper.dart';

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
  String curstate;
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
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              )
            ],
          ),
        )),
      );
    } else {
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = MediaQuery.of(context).size.width;
      return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text('Produk Baru'),
          ),
          body: Container(
              alignment: Alignment.topCenter,
              child: ListView(children: <Widget>[
                Center(
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
                                          fit: BoxFit.cover,
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
                                    style: TextStyle(
                                        fontSize: 10.0, color: Colors.white)),
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
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                5, 1, 5, 1),
                                                        height: 30,
                                                        child: TextFormField(
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                                                  Colors.white,
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
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                5, 1, 5, 1),
                                                        height: 30,
                                                        child: TextFormField(
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                                                  Colors.white,
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
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                5, 1, 5, 1),
                                                        height: 30,
                                                        child: TextFormField(
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                                                  Colors.white,
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
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                5, 1, 5, 1),
                                                        height: 30,
                                                        child: TextFormField(
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                                                  Colors.white,
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
                                                          child: Text("Negeri",
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
                                                            " " + curstate,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )),
                                                    )),
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
                                                              color:
                                                                  Colors.white,
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
                            ))))
              ])));
    }
  }

  void _choose() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }

    _cropImage();
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                //CropAspectRatioPreset.ratio3x2,
                //CropAspectRatioPreset.original,
                //CropAspectRatioPreset.ratio4x3,
                //CropAspectRatioPreset.ratio16x9
              ]
            : [
                //CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                //CropAspectRatioPreset.ratio3x2,
                //CropAspectRatioPreset.ratio4x3,
                //CropAspectRatioPreset.ratio5x3,
                //CropAspectRatioPreset.ratio5x4,
                //CropAspectRatioPreset.ratio7x5,
                //CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Potong',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  _getLocation() async {
    if (_determinePosition() != null) {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final coordinates =
          new Coordinates(_currentPosition.latitude, _currentPosition.longitude);
      var addresses = await Geocoder.local
          .findAddressesFromCoordinates(coordinates)
          .timeout(Duration(seconds: 15), onTimeout: () {
        Toast.show("Alamat anda tidak dapat dikesan", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      });
      var first = addresses.first;
      setState(() {
        curaddress = first.locality;
        curstate = first.adminArea;
        print(curstate);
        if (curaddress != null) {
          latitude = _currentPosition.latitude;
          longitude = _currentPosition.longitude;
          return;
        }
      });

      print("${first.featureName} : ${first.addressLine}");
    }
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
            "Kemasukan produk baru " + productEditingController.text,
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
            new TextButton(
              child: new Text(
                "Ya",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                addProduct();
              },
            ),
            new TextButton(
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

  void addProduct() {
    print(widget.user.phone);

    String base64Image = base64Encode(_image.readAsBytesSync());
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Sedang memuatnaik produk...");
    pr.show();
    double price = double.parse(priceEditingController.text);
    double delivery = double.parse(deliEditingController.text);

    http.post(
        Uri.parse("https://slumberjer.com/mypasar/php/insert_product.php"),
        body: {
          "phone": widget.user.phone,
          "prname": productEditingController.text,
          "quantity": qtyEditingController.text,
          "price": price.toStringAsFixed(2),
          "delivery": delivery.toStringAsFixed(2),
          "encoded_string": base64Image,
          "latitude": _currentPosition.latitude.toString(),
          "longitude": _currentPosition.longitude.toString(),
          "state": curstate,
          "locality": curaddress,
        }).then((res) {
      print("RESBODY " + res.body);

      if (res.body == "success") {
        Toast.show("Kemasukan produk berjaya", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        pr.hide();
      } else {
        Toast.show("Kemasukan produk tidak berjaya", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.hide();
      }
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    pr.hide();
  }
}
