import 'package:flutter/material.dart';
import 'package:grocery/registerscreen.dart';

void main() => runApp(LoginScreen());

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text('Login'),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/grocery.png",
                  scale: 3,
                ),
                TextField(
                    controller: null,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: Icon(Icons.email),
                    )),
                TextField(
                  controller: null,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 350,
                  height: 50,
                  child: Text('Login'),
                  color: Colors.purple,
                  textColor: Colors.white,
                  elevation: 20,
                  onPressed: _userLogin,
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: _registerUser,
                  child: Text("Register new Account"),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("Forgot Password")
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _userLogin() {}

  void _registerUser() {
     Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }
}
