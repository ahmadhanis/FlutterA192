import 'package:eve/mainpage.dart';
import 'package:eve/registerpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:progress_dialog/progress_dialog.dart';

bool _isChecked = false;
bool _success;
String _userEmail;

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() => runApp(LoginPage());

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'EvE',
      theme: ThemeData.dark(),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('EvE'),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/uumlogo.png",
                  scale: 2.5,
                ),
                TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: Icon(Icons.email),
                      errorText: validate(_emailController.text),
                    )),
                TextField(
                  controller: _passController,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      icon: Icon(Icons.lock),
                      errorText: validate(_passController.text)),
                  obscureText: true,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    minWidth: 350,
                    height: 50,
                    child: Text('Login'),
                    color: Colors.cyanAccent,
                    textColor: Colors.black,
                    elevation: 15,
                    onPressed: _signInWithEmailAndPassword,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool value) {
                        _onChange(value);
                      },
                    ),
                    Text('Remember Me', style: TextStyle(fontSize: 16))
                  ],
                ),
                GestureDetector(
                    onTap: _registerUser,
                    child: Text('Register New Account',
                        style: TextStyle(fontSize: 16))),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: null,
                    child:
                        Text('Forgot Account', style: TextStyle(fontSize: 16))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String validate(String value) {
    if (!(value.length > 5) && value.isNotEmpty) {
      return "Please enter";
    }
    return null;
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      //savepref(value);
    });
  }

  void _signInWithEmailAndPassword() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Login...");
    pr.show();
    try {
      final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passController.text,
      ))
          .user;
      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email;
          pr.dismiss();
          
          Navigator.push(
        this.context, MaterialPageRoute(builder: (context) => MainPage()));
        messageDialog("Login Success", "");
        });
      } else {
        _success = false;
        pr.dismiss();
      }
    } on Exception catch (e) {
      pr.dismiss();
      print(e.toString());
      messageDialog("Login Failed", "");
      return;
    }
  }

  void messageDialog(String msja, String msjb) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(msja),
          content: Text(msjb),
          actions: <Widget>[
            FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _registerUser() {
    Navigator.push(
        this.context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }
}
