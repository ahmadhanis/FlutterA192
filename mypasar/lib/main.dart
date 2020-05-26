import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Pasar',
      home: Scaffold(
        appBar: AppBar(
          title: Text('My Pasar'),
        ),
        body: Center(
          child: Container(
              child: Column(
               
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 10,),
              Container(
                height: 150,
                width: 150,
                decoration: myBoxDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.attach_money),
                      tooltip: 'Masuk sebagai pembeli',
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                    Text('Pembeli',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20))
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                height: 150,
                width: 150,
                decoration: myBoxDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.motorcycle,size: 30,),
                      tooltip: 'Masuk sebagai rider',
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                    Text('Rider',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20))
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                height: 150,
                width: 150,
                decoration: myBoxDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.shop),
                      tooltip: 'Masuk sebagai peniaga',
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                    Text('Peniaga',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                  ],
                ),
              ),
              SizedBox(height: 10,),
            ],
          )),
        ),
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    border: Border.all(
      width: 3.0,
      color: Colors.amber
    ),
    borderRadius: BorderRadius.all(
        Radius.circular(5.0) //         <--- border radius here
    ),
  );
}
}
