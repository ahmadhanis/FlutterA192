import 'package:flutter/material.dart';
 
void main() => runApp(RegisterPage());
 
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
                  "assets/images/grocery.png",
                  scale: 3,
                ),
                TextField(
                    controller: null,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: Icon(Icons.email),
                      //errorText: validate(_emailController.text),
                    )),
                TextField(
                  controller: null,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.lock),
                    //errorText: validate(_passController.text)),
                  ),
                  obscureText: true,
                ),
                TextField(
                  controller: null,
                  decoration: InputDecoration(
                    labelText: 'Retype Password',
                    icon: Icon(Icons.lock),
                    //errorText: validate(_passController.text)),
                  ),
                  obscureText: true,
                ),
                TextField(
                    controller: null,
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
                                        onTap: null,
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
  }
}