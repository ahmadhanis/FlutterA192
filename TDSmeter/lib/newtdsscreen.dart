import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class NewTDSScreen extends StatefulWidget {
  @override
  _NewTDSScreenState createState() => _NewTDSScreenState();
}

class _NewTDSScreenState extends State<NewTDSScreen> {
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = 'assets/images/phonecam.png';
  String titlecenter = "Loading...";
  final f = new DateFormat('dd-MM-yyyy hh:mm');

  TextEditingController tdsidctrl = new TextEditingController();
  TextEditingController tdsdescctrl = new TextEditingController();
  TextEditingController tdsdelayctrl = new TextEditingController();

  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Register New TDS Meter'),
      ),
      body: Container(
          alignment: Alignment.topCenter,
          child: ListView(
            children: <Widget>[
              Center(
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(children: <Widget>[
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
                            Text("Click image to take picture",
                                style: TextStyle(
                                    fontSize: 10.0, color: Colors.white)),
                            SizedBox(height: 5),
                            Card(
                                elevation: 10,
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(children: <Widget>[
                                      Table(
                                          defaultColumnWidth:
                                              FlexColumnWidth(1.0),
                                          children: [
                                            TableRow(children: [
                                              TableCell(
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 30,
                                                    child: Text("TDS Meter ID",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white))),
                                              ),
                                              TableCell(
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      5, 1, 5, 1),
                                                  height: 30,
                                                  child: TextFormField(
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                      controller: tdsidctrl,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      onFieldSubmitted: (v) {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                focus);
                                                      },
                                                      decoration:
                                                          new InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(5),

                                                        fillColor: Colors.white,
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
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 30,
                                                    child: Text(
                                                        "Delay (in minutes)",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white))),
                                              ),
                                              TableCell(
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      5, 1, 5, 1),
                                                  height: 30,
                                                  child: TextFormField(
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                      controller: tdsdelayctrl,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      onFieldSubmitted: (v) {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                focus);
                                                      },
                                                      decoration:
                                                          new InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(5),

                                                        fillColor: Colors.white,
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
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 30,
                                                    child: Text("Description",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white))),
                                              ),
                                              TableCell(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 50,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            5, 0, 0, 0),
                                                    child: TextFormField(
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                        controller: tdsdescctrl,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        onFieldSubmitted: (v) {
                                                          FocusScope.of(context)
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
                                              )
                                            ]),
                                          ]),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        minWidth: 200,
                                        height: 40,
                                        child: Text('Create'),
                                        color:
                                            Color.fromRGBO(101, 255, 218, 50),
                                        textColor: Colors.black,
                                        elevation: 5,
                                        onPressed: newTDSDialog,
                                      ),
                                    ])))
                          ]))))
            ],
          )),
    );
  }

  void _choose() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
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
            toolbarTitle: 'Resize',
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

  void newTDSDialog() {
    if (tdsidctrl.text == "") {
      Toast.show("Please enter TDS ID.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (tdsdelayctrl.text == "") {
      Toast.show("Please enter delay.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_image == null) {
      Toast.show("Please take pipe picture.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "New Meter id " + tdsidctrl.text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
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
                _registerNewPipe();
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

  void _registerNewPipe() async {
    int delay = int.parse(tdsdelayctrl.text) * 60;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "New pipe registration...");
    pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());
    String urlLoadJobs = "https://slumberjer.com/tdsmeter/register_new.php";
    await http.post(urlLoadJobs, body: {
      "tdsid": tdsidctrl.text,
      "encoded_string": base64Image,
      "desc": tdsdescctrl.text,
      "delay": delay.toString(),
    }).then((res) {
      pr.hide();
      print(res.body);
      if (res.body == "success") {
        Toast.show("Success.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      } else {
        Toast.show("Failed.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }
}
