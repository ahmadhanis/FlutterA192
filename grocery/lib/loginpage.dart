import 'package:flutter/material.dart';
import 'package:grocery/registerpage.dart';

void main() => runApp(LoginPage());

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isChecked;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Material App',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/grocery.png",
                  scale: 3,
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
                  child: TextField(
                      controller: null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email', icon: Icon(Icons.email))),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
                  child: TextField(
                    controller: null,
                    decoration: InputDecoration(
                        labelText: 'Password', icon: Icon(Icons.lock)),
                    obscureText: true,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 300,
                  height: 50,
                  child: Text('Login'),
                  color: Color.fromRGBO(212, 162, 200, 100),
                  textColor: Colors.black,
                  elevation: 15,
                  onPressed: _login,
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: _registerUser,
                  child: Text("Register"),
                ),
                Text("Forgot Password")
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() {}

  void _registerUser() {
    Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => RegisterPage()));
  }
}
