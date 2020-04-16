import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypasar/tabscreen1.dart';
import 'package:mypasar/tabscreen2.dart';
import 'package:mypasar/tabscreen3.dart';
import 'package:mypasar/user.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  List<Widget> tabchildren;
  String maintitle = "Pembeli";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      TabScreen1(user: widget.user),
      TabScreen2(user: widget.user),
      TabScreen3(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            title: Container(
                child: Text(maintitle,
                    style: GoogleFonts.anaheim(
                        fontWeight: FontWeight.bold, fontSize: 24))),
            
          ),

          body: tabchildren[_currentIndex], // new
          bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped, // new
            currentIndex: _currentIndex, // new
            items: [
              new BottomNavigationBarItem(
                icon: Icon(Icons.attach_money, color: Colors.white),
                title: Text('Pembeli'),
              ),
              new BottomNavigationBarItem(
                icon: Icon(Icons.store_mall_directory, color: Colors.white),
                title: Text('Penjual'),
              ),
              new BottomNavigationBarItem(
                  icon: Icon(Icons.person, color: Colors.white),
                  title: Text(
                    'Profil',
                  ))
            ],
          ),
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        maintitle = "Pembeli";
      }
      if (_currentIndex == 1) {
        maintitle = "Penjual";
      }
      if (_currentIndex == 2) {
        maintitle = "Profil";
      }
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
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
                    "Ya",
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
                    "Tidak",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
            ],
          ),
        ) ??
        false;
  }
}
