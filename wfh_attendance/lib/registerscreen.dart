import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:recase/recase.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'loginscreen.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  double screenHeight;
  String urlRegister = "https://slumberjer.com/wfh/register_user.php";
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _idEditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
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
        'assets/images/login.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
      height: 400,
      margin: EdgeInsets.only(top: screenHeight / 3.5),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextField(
                      controller: _nameEditingController,
                      style: TextStyle(color: Colors.white,),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        icon: Icon(Icons.person),
                      )),
                  TextField(
                      controller: _idEditingController,
                      style: TextStyle(color: Colors.white,),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Staff ID',
                        icon: Icon(Icons.perm_identity),
                      )),
                  TextField(
                    controller: _passEditingController,
                    style: TextStyle(color: Colors.white,),

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
                        borderRadius: BorderRadius.circular(5.0)),
                    minWidth: 350,
                    height: 50,
                    child: Text('Register'),
                    color: Color.fromRGBO(101, 255, 218, 50),
                    textColor: Colors.black,
                    elevation: 10,
                    onPressed: _regDialog,
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
              Text("Already register? ", style: TextStyle(fontSize: 16.0,color: Colors.white,)),
              GestureDetector(
                onTap: _loginScreen,
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.white,),
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
            Icons.location_on,
            size: 40,
            color: Colors.white,
          ),
          Text(
            " UUM.ATTENDANCE",
            style: TextStyle(
                fontSize: 28, color: Colors.white, fontWeight: FontWeight.w900),
          )
        ],
      ),
    );
  }

  void _regDialog() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Register your account?',style: TextStyle(color: Colors.white,),),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _onRegister();
                
              },
              child: Text("Yes",style: TextStyle(color: Color.fromRGBO(101, 255, 218, 50),),)),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel",style: TextStyle(color: Color.fromRGBO(101, 255, 218, 50),),)),
        ],
      ),
    );
  }

  Future<void> _onRegister() async {
    String name = _nameEditingController.text;
    String id = _idEditingController.text;
    String password = _passEditingController.text;

    if (name.length < 3 && id.length < 2 && password.length < 3) {
      Toast.show("Please enter your credential", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
 ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Registration...");
    await pr.show();
    http.post(urlRegister, body: {
      "name": name.titleCase,
      "id": id,
      "password": password,
    }).then((res) async {
      if (res.body == "success") {
        await pr.hide();
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
        Toast.show("Registration success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Registration failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  void _loginScreen() {
    Navigator.pop(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }
}
