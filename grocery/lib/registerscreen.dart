import 'package:flutter/material.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text('User Registration'),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 5, 40, 0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/images/registration.jpg"),
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
                SizedBox(height: 20,),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 300,
                  height: 50,
                  child: Text('Register'),
                  color: Colors.purple,
                  textColor: Colors.white,
                  elevation: 15,
                  onPressed: _onRegister,
                ),
                SizedBox(height: 10,),
                GestureDetector(child: Text("Already Register"),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onRegister() {}
}
