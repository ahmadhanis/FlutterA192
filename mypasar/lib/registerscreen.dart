import 'package:flutter/material.dart';
import 'package:mypasar/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  double screenHeight;
  bool _isChecked = false;
  String urlRegister = "https://slumberjer.com/mypasar/php/register_user.php";
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _phoneditingController = new TextEditingController();
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
                      "Daftar Akaun",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextField( style: TextStyle(
                              color: Colors.white,
                            ),
                      controller: _nameEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Nama Anda',
                        icon: Icon(Icons.person),
                      )),
                  TextField( style: TextStyle(
                              color: Colors.white,
                            ),
                      controller: _phoneditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Nombor Telefon',
                        icon: Icon(Icons.phone),
                      )),
                  TextField( style: TextStyle(
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
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool value) {
                          _onChange(value);
                        },
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: _showEULA,
                          child: Text('Setuju dengan terma dan syarat  ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white)),
                        ),
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 115,
                        height: 50,
                        child: Text('Daftar'),
                        color: Color.fromRGBO(101, 255, 218,50),
                            textColor: Colors.black,
                        elevation: 10,
                        onPressed: _onRegister,
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
              Text("Sudah mendaftar? ", style: TextStyle(fontSize: 16.0,color: Colors.white)),
              GestureDetector(
                onTap: _loginScreen,
                child: Text(
                  "Log masuk",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.white),
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

  void _onRegister() {
    String name = _nameEditingController.text;
    String phone = _phoneditingController.text;
    String password = _passEditingController.text;
    if (!_isChecked) {
      Toast.show("Please Accept Term", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Sedang mendaftar...");
      pr.show();

    http.post(urlRegister, body: {
      "name": name,
      "password": password,
      "phone": phone,
    }).then((res) {

      print(res.body);
      if (res.body == "success") {
      pr.dismiss();
        Toast.show("Pendaftaran anda berjaya", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            
              Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
      } else {
        Toast.show("Pendaftaran gagal", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            FocusScope.of(context).requestFocus(new FocusNode());
            pr.dismiss();
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }

  void _loginScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      //savepref(value);
    });
  }

  void _showEULA() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("EULA", style: TextStyle(
                              color: Colors.white,
                            ),),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.white,
                              //fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            text:
                                "Perjanjian Lesen Pengguna Akhir ini adalah perjanjian sah antara anda dan Slumberjer Perjanjian EULA ini mengatur perolehan dan penggunaan perisian (Perisian) MY.PASAR kami secara langsung dari Slumberjer atau secara tidak langsung melalui penjual atau pengedar sah Slumberjer (seorang Penjual Semula). Sila baca perjanjian EULA ini dengan teliti sebelum menyelesaikan proses pemasangan dan menggunakan perisian MY.PASAR. Ini memberikan lesen untuk menggunakan perisian MY.PASAR dan mengandungi maklumat jaminan dan penafian liabiliti. Sekiranya anda mendaftar untuk percubaan percuma perisian MY.PASAR, perjanjian EULA ini juga akan mengatur percubaan tersebut. Dengan mengklik terima atau memasang dan / atau menggunakan perisian MY.PASAR, anda mengesahkan penerimaan Perisian anda dan bersetuju untuk terikat dengan syarat-syarat perjanjian EULA ini. Sekiranya anda membuat perjanjian EULA ini bagi pihak syarikat atau entiti undang-undang lain, anda menyatakan bahawa anda mempunyai kuasa untuk mengikat entiti tersebut dan gabungannya dengan terma dan syarat ini. Sekiranya anda tidak mempunyai kewibawaan tersebut atau jika anda tidak bersetuju dengan terma dan syarat perjanjian EULA ini, jangan pasang atau gunakan Perisian ini, dan anda tidak harus menerima perjanjian EULA ini. Perjanjian EULA ini akan terpakai hanya untuk Perisian yang dibekalkan oleh Slumberjer dengan ini tanpa mengira sama ada perisian lain dirujuk atau dijelaskan di sini. Syarat-syarat ini juga berlaku untuk sebarang kemas kini, suplemen, perkhidmatan berasaskan Internet, dan perkhidmatan sokongan Slumberjer untuk Perisian, kecuali syarat-syarat lain menyertai barang-barang tersebut semasa penghantaran. Sekiranya demikian, syarat-syarat tersebut terpakai. EULA ini dibuat oleh EULA Template untuk MY.PASAR. Slumberjer akan sentiasa memiliki hak milik Perisian seperti yang dimuat turun oleh anda dan semua muat turun Perisian yang seterusnya oleh anda. Perisian (dan hak cipta, dan hak kekayaan intelektual lain apa pun dalam Perisian, termasuk apa-apa pengubahsuaian yang dibuat padanya) adalah dan akan tetap menjadi hak milik Slumberjer. Slumberjer berhak memberikan lesen untuk menggunakan Perisian ini kepada pihak ketiga"
                            ),
                            //children: getSpan(),
                            )),
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Setuju",style: TextStyle(
                          color: Color.fromRGBO(101, 255, 218, 50),
                        ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
