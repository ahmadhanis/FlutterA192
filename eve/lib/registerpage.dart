import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eve/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String _userEmail;
bool _success;

TextEditingController _emailController = new TextEditingController();
TextEditingController _passController = new TextEditingController();
TextEditingController _pass2Controller = new TextEditingController();
TextEditingController _phoneController = new TextEditingController();

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('User Registration'),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/registration.png",
                  scale: 1,
                ),
                TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: Icon(Icons.email),
                      //errorText: validate(_emailController.text),
                    )),
                TextField(
                  controller: _passController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.lock),
                    //errorText: validate(_passController.text)),
                  ),
                  obscureText: true,
                ),
                TextField(
                  controller: _pass2Controller,
                  decoration: InputDecoration(
                    labelText: 'Retype Password',
                    icon: Icon(Icons.lock),
                    //errorText: validate(_passController.text)),
                  ),
                  obscureText: true,
                ),
                TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number (01xxxxxxxx)',
                      icon: Icon(Icons.phone),
                      //errorText: validate(_emailController.text),
                    )),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    minWidth: 350,
                    height: 50,
                    child: Text('Register'),
                    color: Colors.cyanAccent,
                    textColor: Colors.black,
                    elevation: 15,
                    onPressed: _registerUser,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: _goback,
                    child: Text('Already Register',
                        style: TextStyle(fontSize: 16))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _registerUser() {
    //final context = navigatorKey.currentState.overlay.context;

    _userEmail = _emailController.text;
    if (_userEmail == null || !(EmailValidator.validate(_userEmail))) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Check Email?'),
            content: Text('Invalid Email format'),
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
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Register?'),
          content: Text('This action will register $_userEmail'),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('ACCEPT'),
              onPressed: () {
                _register();
              },
            )
          ],
        );
      },
    );
  }

  void _goback() {
    Navigator.pop(
        this.context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void _register() async {
    Navigator.of(context).pop();
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Registration in progress");
    pr.show();
    try {
      final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passController.text,
      ))
          .user;
      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email;
          Firestore.instance
              .collection('user')
              .document(_userEmail)
              .setData({'phone': _phoneController.text});
          pr.dismiss();
          Navigator.pop(this.context,
              MaterialPageRoute(builder: (context) => LoginPage()));
          messageDialog("Success", "Registration success");
        });
      } else {
        _success = false;
        pr.dismiss();
      }
    } on Exception catch (e) {
      pr.dismiss();
      print(e.toString());
      messageDialog("Error", "Registration error");
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
}
