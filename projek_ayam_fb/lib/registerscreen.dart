import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'mainscreen.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final dbref = Firestore.instance;
  double screenHeight, screenWidth;
  File _image;
  String _uploadedFileURL;
  Position _currentPosition;
  double latitude, longitude;
  String selectedLocation;
  String pathAsset = 'assets/images/camera.png';
  String urlRegister = "https://slumberjer.com/ayam/php/register_user.php";
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _icnoEditingController = new TextEditingController();
  TextEditingController _phoneditingController = new TextEditingController();
  TextEditingController _homeAddressEditingController =
      new TextEditingController();
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();
  bool _gpsfound = false;
  List<String> loclist = [
    "Changlun",
    "Kerasak",
  ];

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          upperHalf(context),
          lowerHalf(context),
          pageTitle(),
        ],
      ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 2,
      child: Image.asset(
        'assets/images/login.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
      height: screenHeight / 1.2,
      margin: EdgeInsets.only(top: screenHeight / 5),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(2.0),
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Pendaftaran Peserta",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 5),
              GestureDetector(
                  onTap: () => {_choose()},
                  child: Container(
                    height: screenHeight / 4.5,
                    width: screenWidth / 1.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _image == null
                            ? AssetImage(pathAsset)
                            : FileImage(_image),
                        fit: BoxFit.fitHeight,
                      ),
                      // border: Border.all(
                      //   width: 3.0,
                      //   //color: Colors.grey,
                      // ),
                      borderRadius: BorderRadius.all(Radius.circular(
                              5.0) //         <--- border radius here
                          ),
                    ),
                  )),
              SizedBox(height: 5),
              Container(
                  alignment: Alignment.center,
                  child: RichText(
                      softWrap: true,
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                          style: TextStyle(
                            color: Colors.white,
                            //fontWeight: FontWeight.w500,
                            fontSize: 10.0,
                          ),
                          text:
                              "Klik utk ambil gambar peserta. Gambar peserta tidak boleh diubah kemudian hari."
                          //children: getSpan(),
                          ))),
              TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: _nameEditingController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focus);
                  },
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    icon: Icon(Icons.person),
                  )),
              TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: _icnoEditingController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  focusNode: focus,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focus1);
                  },
                  decoration: InputDecoration(
                    labelText: 'No IC',
                    icon: Icon(MdiIcons.idCard),
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(width: 15),
                    Container(
                      height: 40,
                      child: DropdownButton(
                        //sorting dropdownoption
                        hint: Text(
                          'Pilih Lokasi',
                          style: TextStyle(
                            color: Color.fromRGBO(101, 255, 218, 50),
                          ),
                        ), // Not necessary for Option 1
                        value: selectedLocation,
                        onChanged: (newValue) {
                          setState(() {
                            selectedLocation = newValue;
                            print(selectedLocation);
                          });
                        },
                        items: loclist.map((selectedLocation) {
                          return DropdownMenuItem(
                            child: new Text(selectedLocation,
                                style: TextStyle(
                                    color: Color.fromRGBO(101, 255, 218, 50))),
                            value: selectedLocation,
                          );
                        }).toList(),
                      ),
                    ),
                    Flexible(
                      child: Tooltip(
                          message: "Buka Googlemap",
                          child: FlatButton(
                            onPressed: () => {_openGooglemap()},
                            child: Icon(MdiIcons.googleMaps,
                                color: _gpsfound
                                    ? Color.fromRGBO(101, 255, 218, 50)
                                    : Color.fromRGBO(255, 0, 0, 50)),
                          )),
                    ),
                  ],
                ),
              ),
              TextFormField(
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: _phoneditingController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                focusNode: focus1,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focus2);
                },
                decoration: InputDecoration(
                  labelText: 'Telefon',
                  icon: Icon(Icons.phone),
                ),
              ),
              TextFormField(
                  minLines: 4,
                  maxLines: 4,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: _homeAddressEditingController,
                  keyboardType: TextInputType.multiline,
                  focusNode: focus2,
                  decoration: InputDecoration(
                    labelText: 'Alamat Rumah',
                    icon: Icon(MdiIcons.officeBuilding),
                  )),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                minWidth: screenWidth / 1,
                height: 50,
                child: Text('Daftar'),
                color: Color.fromRGBO(101, 255, 218, 50),
                textColor: Colors.black,
                elevation: 10,
                onPressed: _onRegister,
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Ke skrin utama? ",
                      style: TextStyle(fontSize: 16.0, color: Colors.white)),
                  GestureDetector(
                    onTap: _mainScreen,
                    child: Text(
                      "Kembali",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _openGooglemap() async {
    if (latitude == null || longitude == null) {
      Toast.show("Lokasi belum dijumpai. Sila tunggu", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Buka lokasi sekarang menggunakan aplikasi Googlemap?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () async {
                Navigator.of(context).pop(false);

                String googleUrl =
                    'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                if (await canLaunch(googleUrl)) {
                  await launch(googleUrl);
                } else {
                  throw 'Could not open the map.';
                }
              },
              child: Text(
                "Ya",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Tidak",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ],
      ),
    );
  }

  Widget pageTitle() {
    return Container(
      //color: Color.fromRGBO(255, 200, 200, 200),
      margin: EdgeInsets.only(top: 60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.shopping_basket,
            size: 40,
            color: Colors.white,
          ),
          Text(
            " MY.AYAM",
            style: TextStyle(
                fontSize: 36, color: Colors.white, fontWeight: FontWeight.w900),
          )
        ],
      ),
    );
  }

  void _choose() async {
    final picker = ImagePicker();
    // _image = await ImagePicker.pickImage(
    //     source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    _cropImage();
    setState(() {});
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blueAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  bool isPasswordCompliant(String password, [int minLength = 6]) {
    if (password == null || password.isEmpty) {
      return false;
    }

//  bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    // bool hasSpecialCharacters = password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length > minLength;

    return hasDigits & hasLowercase & hasMinLength;
  }

  void _onRegister() {
    String name = _nameEditingController.text;
    String icno = _icnoEditingController.text;
    String phone = _phoneditingController.text;
    String homeadd = _homeAddressEditingController.text;

    if (name.length < 5) {
      Toast.show("Maklumat tidak lengkap", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }
    if (icno.length < 5) {
      Toast.show("Maklumat tidak lengkap", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }

    if (phone.length < 8) {
      Toast.show("Maklumat tidak lengkap", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }
    if (homeadd.length < 10) {
      Toast.show("Maklumat tidak lengkap", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }
    if (selectedLocation == null) {
      Toast.show("Sila pilih lokasi", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }
    if (_image == null) {
      Toast.show("Sila ambil gambar peserta", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }

    if (latitude == null && longitude == null) {
      _getLocation();
      Toast.show("Hidupkan GPS dan Sila tunggu hingga pencarian lokasi selesai",
          context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
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
            "Daftar Peserta?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content:
              new Text("Anda Pasti?", style: TextStyle(color: Colors.white)),
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
                registerUserFS();
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

  Future<void> registerUserFS() async {
    String name = _nameEditingController.text;
    String icno = _icnoEditingController.text;
    String phone = _phoneditingController.text;
    String homeadd = _homeAddressEditingController.text;
    //String base64Image = base64Encode(_image.readAsBytesSync());
    final fc = new DateFormat('dd-MM-yyyy hh:mm a');
    bool found = false;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Pendaftaran sedang dilakukan");
    await pr.show();

    dbref.collection("participants").getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        if (result.data["icno"] == icno) {
          print("FOUND IC");
          Toast.show("No IC telah didaftarkan.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
          found = true;
        }
      });
      print("continue");
      if (!found) {
        dbref.collection("participants").add({
          "name": name,
          "icno": icno,
          "address": homeadd,
          "phone": phone,
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
          "location": selectedLocation,
          "datejoin": fc.format(DateTime.now()),
          "status": "active"
        }).then((value) {
          print("DOC ID");
          print(value.documentID);
          if (value.documentID != null) {
            uploadFile();
          }
        });
      }
    });

    await pr.hide();
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profileimages/${_icnoEditingController.text}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
        print("FILEURL:" + _uploadedFileURL);
        Toast.show("Berjaya didaftarkan.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        Navigator.pop(context,
            MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
      });
    });
  }

  Future<void> registerUser() async {
    String name = _nameEditingController.text;
    String icno = _icnoEditingController.text;
    String phone = _phoneditingController.text;
    String homeadd = _homeAddressEditingController.text;
    String base64Image = base64Encode(_image.readAsBytesSync());

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Pendaftaran sedang dilakukan");
    await pr.show();

    http.post(urlRegister, body: {
      "name": StringUtils.capitalize(name, allWords: true),
      "icno": icno,
      "phone": phone,
      "location": selectedLocation,
      "homeadd": homeadd,
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "encoded_string": base64Image,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Navigator.pop(context,
            MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
        Toast.show("Pendaftara berjaya", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      } else {
        Toast.show("Pendaftaran gagal", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  _getLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    _currentPosition = await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .timeout(Duration(seconds: 15), onTimeout: () {
      return;
    });

    setState(() {
      latitude = _currentPosition.latitude;
      longitude = _currentPosition.longitude;
      _gpsfound = true;
      Toast.show("Lokasi sekarang berjaya di tetapkan", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
    });
  }

  void _mainScreen() {
    Navigator.pop(context,
        MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
  }
}
