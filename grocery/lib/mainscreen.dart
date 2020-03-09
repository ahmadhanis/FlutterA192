import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String urlloadproduct =
      "https://slumberjer.com/grocery/php/load_products.php";
  List productdata;

  @override
  void initState() {
    super.initState();
    loadProduct();
  }

  @override
  Widget build(BuildContext context) {
    if (productdata == null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Loading..."),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return MaterialApp(
        title: 'Material App',
        home: Scaffold(
            appBar: AppBar(
              title: Text('Material App Bar'),
            ),
            drawer: mainDrawer(context),
            body: ListView.builder(
                itemCount: productdata == null ? 1 : productdata.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 10,
                    child: Column(
                      children: <Widget>[
                        Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        "https://slumberjer.com/grocery/productimage/${productdata[index]['id']}.jpg")))),
                        Text(productdata[index]['name']),
                        Text("RM " + productdata[index]['price']),
                        Text(productdata[index]['quantity']),
                        Text(productdata[index]['weigth'] + " gram"),
                      ],
                    ),
                  );
                })),
      );
    }
  }

  void loadProduct() {
    http.post(urlloadproduct, body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        productdata = extractdata["products"];
        print(productdata);
      });
    }).catchError((err) {
      print(err);
    });
  }

   Widget mainDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Ahmad Hanis"),
            accountEmail: Text("slumberjer@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              child: Text(
                "A",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            title: Text("Ttem 1"),
            trailing: Icon(Icons.arrow_forward),
          ),
          ListTile(
            title: Text("Item 2"),
            trailing: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }

}
