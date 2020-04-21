import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypasar/mainscreen.dart';
import 'package:mypasar/registerscreen.dart';
import 'package:mypasar/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() => runApp(LoginScreen());
bool rememberMe = false;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double screenHeight;
  TextEditingController _phoneEditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    print("Hello i'm in INITSTATE");
    this.loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Stack(
            children: <Widget>[
              upperHalf(context),
              lowerHalf(context),
              pageTitle(),
            ],
          )),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 1.8,
      child: Image.asset(
        'assets/images/login.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
      height: screenHeight / 1.8,
      margin: EdgeInsets.only(top: screenHeight / 2.5),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Log Masuk",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      controller: _phoneEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'No Telefon',
                        icon: Icon(Icons.phone),
                      )),
                  TextField(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    controller: _passEditingController,
                    decoration: InputDecoration(
                      labelText: 'Kata Laluan',
                      icon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Checkbox(
                        value: rememberMe,
                        onChanged: (bool value) {
                          _onRememberMeChanged(value);
                        },
                      ),
                      Text('Ingat Info Saya ',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 50,
                        child: Text(
                          'Log Masuk',
                        ),
                        color: Color.fromRGBO(101, 255, 218, 50),
                        textColor: Colors.black,
                        elevation: 10,
                        onPressed: this._userLogin,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Tiada Akaun?",
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
              GestureDetector(
                onTap: _registerUser,
                child: Text(
                  "Cipta Akaun",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Terlupa Kata Laluan?",
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
              GestureDetector(
                onTap: _forgotPassword,
                child: Text(
                  "Tetapkan Semula",
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
            " MY.PASAR",
            style: TextStyle(
                fontSize: 36, color: Colors.white, fontWeight: FontWeight.w900),
          )
        ],
      ),
    );
  }

  void _userLogin() async {
    String urlLogin = "https://slumberjer.com/mypasar/php/login_user.php";
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Log Masuk...");
      pr.show();
      String _phone = _phoneEditingController.text;
      String _password = _passEditingController.text;
      http
          .post(urlLogin, body: {
            "phone": _phone,
            "password": _password,
          })
          .timeout(const Duration(seconds: 5))
          .then((res) {
            print(res.body);
            var string = res.body;
            List userdata = string.split(",");
            if (userdata[0] == "success") {
              print(userdata[4]);
              User _user = new User(
                  name: userdata[1],
                  phone: _phone,
                  password: _password,
                  datereg: userdata[2],
                  credit: userdata[3],
                  radius: userdata[4],
                  state : userdata[5],
                  locality: userdata[6],
                  latitude: userdata[7],
                  longitude: userdata[8]);
              pr.dismiss();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MainScreen(
                            user: _user,
                          )));
              Toast.show("Log masuk berjaya", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            } else {
              pr.dismiss();
              Toast.show("Log masuk gagal", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            }
          })
          .catchError((err) {
            print(err);
            pr.dismiss();
          });
    } on Exception catch (_) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _registerUser() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  void _forgotPassword() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: new Container(
            height: screenHeight / 5.5,
            child: Expanded(child:Column(
              children: <Widget>[
                Text(
            "Terlupa katalaluan?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
                Text(
                  "Masukkan no telefon anda",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                TextField(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      labelText: 'No Telefon',
                      icon: Icon(Icons.phone),
                    ))
              ],
            )),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Hantar",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  phoneController.text,
                );
              },
            ),
            new FlatButton(
              child: new Text(
                "Batal",
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

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        print(rememberMe);
        if (rememberMe) {
          savepref(true);
        } else {
          savepref(false);
        }
      });

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Keluar dari aplikasi',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: new Text(
              'Anda pasti?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Keluar",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: Text(
                    "Batal",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
            ],
          ),
        ) ??
        false;
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = (prefs.getString('phone')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (phone.length > 1) {
      setState(() {
        _phoneEditingController.text = phone;
        _passEditingController.text = password;
        rememberMe = true;
      });
    }
  }

  void savepref(bool value) async {
    String phone = _phoneEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      await prefs.setString('phone', phone);
      await prefs.setString('pass', password);
      Toast.show("Maklumat ditetapkan", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      //delete preference
      await prefs.setString('phone', '');
      await prefs.setString('pass', '');
      setState(() {
        _phoneEditingController.text = '';
        _passEditingController.text = '';
        rememberMe = false;
      });
      Toast.show("Preferences have removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}
