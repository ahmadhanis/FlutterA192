import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mypasar/registerscreen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mypasar/user.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'loginscreen.dart';
import 'package:recase/recase.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TabScreen3 extends StatefulWidget {
  final User user;

  const TabScreen3({Key key, this.user}) : super(key: key);

  @override
  _TabScreen3State createState() => _TabScreen3State();
}

class _TabScreen3State extends State<TabScreen3> {
  double screenHeight, screenWidth;
  String msg = "My.Pasar";
  User user;
  String urlupdate = "https://slumberjer.com/mypasar/php/update_profile.php";
  @override
  void initState() {
    super.initState();
    print("Init tab 3");
    user = new User();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    if (user.phone == null) {
      return Container(
          child: Column(
        children: <Widget>[],
      ));
    } else {
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = MediaQuery.of(context).size.width;
      return Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 5),
            Container(
                width: screenWidth / 1,
                child: Column(
                  children: <Widget>[
                    Card(
                      elevation: 10,
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onTap: _takePicture,
                                child: Container(
                                  height: screenHeight / 4.5,
                                  width: screenWidth / 3,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    //border: Border.all(color: Colors.black),
                                  ),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "http://slumberjer.com/mypasar/profile/${user.phone}.jpg?" ??
                                            "0194702493",
                                    placeholder: (context, url) =>
                                        new CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        new Icon(MdiIcons.cameraAccount,
                                            size: 32.0),
                                  ),
                                ),
                              ),
                              SizedBox(width: 4),
                              Flexible(
                                  child: Container(
                                child: Table(
                                    defaultColumnWidth: FlexColumnWidth(1.0),
                                    columnWidths: {
                                      0: FlexColumnWidth(3.5),
                                      1: FlexColumnWidth(6.5),
                                    },
                                    children: [
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 20,
                                              child: Text("Nama",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 20,
                                            child: Text(user.name,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 20,
                                              child: Text("Telefon",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white))),
                                        ),
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 20,
                                              child: Text(
                                                user.phone,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 20,
                                              child: Text("Daftar",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white))),
                                        ),
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 20,
                                              child: Text(
                                                user.datereg,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 20,
                                              child: Text("Kredit",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white))),
                                        ),
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 20,
                                              child: Text(
                                                user.credit,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 20,
                                              child: Text("Jarak",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white))),
                                        ),
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 20,
                                              child: Text(
                                                user.radius + " KM",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 20,
                                              child: Text("Terjual",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white))),
                                        ),
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 20,
                                              child: Text(
                                                user.total + " unit",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 20,
                                              child: Text("Jum Produk",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white))),
                                        ),
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 20,
                                              child: Text(
                                                user.tproduk + " jenis",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ),
                                      ]),
                                    ]),
                              ))
                            ],
                          )),
                    ),
                    Container(
                      color: Color.fromRGBO(101, 255, 218, 50),
                      child: Center(
                        child: Text("TETAPAN PROFIL ",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                    ),
                    Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                  ],
                )),
            Divider(
              height: 2,
              color: Colors.grey,
            ),
            Expanded(
              child: new ListView(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                shrinkWrap: true,
                children: <Widget>[
                  MaterialButton(
                    onPressed: _changeName,
                    child: Text("TUKAR NAMA"),
                  ),
                  Divider(
                    height: 2,
                    color: Color.fromRGBO(101, 255, 218, 50),
                  ),
                  MaterialButton(
                    onPressed: _changePassword,
                    child: Text("TUKAR KATA LALUAN"),
                  ),
                  Divider(
                    height: 2,
                    color: Color.fromRGBO(101, 255, 218, 50),
                  ),
                  MaterialButton(
                    onPressed: _changeRadius,
                    child: Text("TUKAR JARAK"),
                  ),
                  Divider(
                    height: 2,
                    color: Color.fromRGBO(101, 255, 218, 50),
                  ),
                  MaterialButton(
                    onPressed: null,
                    child: Text("BELI KREDIT"),
                  ),
                  Divider(
                    height: 2,
                    color: Color.fromRGBO(101, 255, 218, 50),
                  ),
                  MaterialButton(
                    onPressed: _registerAccount,
                    child: Text("DAFTAR AKAUN BARU"),
                  ),
                  Divider(
                    height: 2,
                    color: Color.fromRGBO(101, 255, 218, 50),
                  ),
                  MaterialButton(
                    onPressed: _gotologinPage,
                    child: Text("KE SKRIN LOGIN"),
                  ),
                  Divider(
                    height: 2,
                    color: Color.fromRGBO(101, 255, 218, 50),
                  ),
                  MaterialButton(
                    onPressed: _callHelp,
                    child: Text("HUBUNGI KAMI"),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }
  }

  void _gotologinPage() {
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Pergi ke page login?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: new Text(
            "Anda pasti?",
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()));
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

  void _changePassword() {
    TextEditingController passController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    if (user.name == "Tidak Berdaftar") {
      Toast.show("Sila daftar/login", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Tukar kata laluan anda?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: new TextField(
            style: TextStyle(
              color: Colors.white,
            ),
            controller: passController,
            decoration: InputDecoration(
              labelText: 'Katalaluan Baru',
              icon: Icon(
                Icons.lock,
                color: Color.fromRGBO(101, 255, 218, 50),
              ),
            ),
            obscureText: true,
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
                if (passController.text.length < 5) {
                  Toast.show("Katalaluan terlalu pendek", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "phone": user.phone,
                  "password": passController.text,
                }).then((res) {
                  if (res.body == "success") {
                    print('in success');
                    setState(() {
                      Toast.show("Success", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      //savepref(passController.text);
                      Navigator.of(context).pop();
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
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

  void _changeName() {
    TextEditingController nameController = TextEditingController();
    // flutter defined function

    if (user.name == "Tidak Berdaftar") {
      Toast.show("Sila daftar/login", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Tukar nama anda?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: new TextField(
              style: TextStyle(
                color: Colors.white,
              ),
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nama',
                icon: Icon(
                  Icons.person,
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
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
                if (nameController.text.length < 2) {
                  Toast.show("Nama hendaklah lebih dari 3 aksara", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "phone": user.phone,
                  "name": nameController.text,
                }).then((res) {
                  if (res.body == "success") {
                    print('in success');
                    ReCase rc = new ReCase(nameController.text);
                    setState(() {
                      user.name = rc.titleCase;
                    });
                    Toast.show("Success", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    Navigator.of(context).pop();
                    return;
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Toast.show("Gagal", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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

  void _registerAccount() {
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Daftar akaun baru?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: new Text(
            "Anda pasti?",
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

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => RegisterScreen()));
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

  void _takePicture() async {
    if (user.name == "Tidak Berdaftar") {
      Toast.show("Sila daftar/login", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Ambil gambar profile?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: new Text(
            "Anda pasti?",
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
              onPressed: () async {
                Navigator.of(context).pop();
                File _image = await ImagePicker.pickImage(
                    source: ImageSource.camera, maxHeight: 400, maxWidth: 300);
                print(_image.lengthSync());
                String base64Image = base64Encode(_image.readAsBytesSync());

                http.post(
                    "https://slumberjer.com/mypasar/php/update_profile.php",
                    body: {
                      "encoded_string": base64Image,
                      "phone": user.phone,
                    }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    setState(() {
                      DefaultCacheManager manager = new DefaultCacheManager();
                      manager.emptyCache();
                    });
                  } else {
                    Toast.show("Tidak berjaya", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
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

  _loadData() {
    final f = new DateFormat('dd-MM-yyyy hh:mm a');
    var parsedDate = DateTime.parse(widget.user.datereg);
    DefaultCacheManager manager = new DefaultCacheManager();
    manager.emptyCache();
    print(f.format(parsedDate));
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Memuat turun...");
    pr.show();
    String urlLoadJobs = "https://slumberjer.com/mypasar/php/load_profile.php";
    http.post(urlLoadJobs, body: {
      "phone": widget.user.phone,
    }).then((res) {
      print(res.body);
      var string = res.body;
      List dres = string.split(",");
      user = new User(
          name: dres[0],
          phone: dres[1],
          datereg: f.format(DateTime.parse(dres[2])),
          credit: dres[3],
          radius: dres[4],
          tproduk: dres[5],
          total: dres[6]);

      pr.dismiss();
      setState(() {
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    pr.dismiss();
  }

  _callHelp() {
    if (widget.user.name == "Tidak Berdaftar") {
      Toast.show("Sila daftar/login", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Hubungi kami di Whatsup?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: new Text(
            "Anda pasti?",
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

                FlutterOpenWhatsapp.sendSingleMessage("+60194702493",
                    "Bantuan berkenaan dengan My.Pasar dari " + user.name);
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

  void _changeRadius() {
    TextEditingController radiusController = TextEditingController();

    if (user.name == "Tidak Berdaftar") {
      Toast.show("Sila daftar/login", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Tukar jarak baru (km)?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: new TextField(
              style: TextStyle(
                color: Colors.white,
              ),
              keyboardType: TextInputType.number,
              controller: radiusController,
              decoration: InputDecoration(
                labelText: 'Jarak Baru',
                icon: Icon(
                  Icons.map,
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
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
                if (radiusController.text.length < 1) {
                  Toast.show("Masukkan jarak  ", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                if (double.parse(radiusController.text) >= 10) {
                  Toast.show("Jarak lokaliti melebihi jarak 10km  ", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "phone": user.phone,
                  "radius": radiusController.text,
                }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    setState(() {
                      user.radius = radiusController.text;
                      Toast.show("Berjaya", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      Navigator.of(context).pop();
                      return;
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Toast.show("Gagal ", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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
}
