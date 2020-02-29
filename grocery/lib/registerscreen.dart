import 'package:flutter/material.dart';
import 'package:grocery/loginscreen.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.brown,
      ),
      title: 'Material App',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('User Registration'),
        ),
        body: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets/images/registration.jpg",
                  scale: 0.5,
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextField(
                            controller: null,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              icon: Icon(Icons.person),
                            )),
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
                              labelText: 'Password', icon: Icon(Icons.lock)),
                          obscureText: true,
                        ),
                        TextField(
                          controller: null,
                          decoration: InputDecoration(
                              labelText: 'Password', icon: Icon(Icons.lock)),
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minWidth: 300,
                          height: 50,
                          child: Text('Register'),
                          color: Colors.brown,
                          textColor: Colors.white,
                          elevation: 15,
                          onPressed: _onRegister,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: _loginScreen,
                          child: Text("Already Register"),
                        ),SizedBox(height: 10,)
                      ],
                    ),
                  ),
                  elevation: 10,
                  margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onRegister() {}

  void _loginScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }
}
