import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'product.dart';
import 'user.dart';

class EditProduct extends StatefulWidget {
  final User user;
  final Product product;

  const EditProduct({Key key, this.user, this.product}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  TextEditingController prnameEditingController = new TextEditingController();
  TextEditingController priceEditingController = new TextEditingController();
  TextEditingController qtyEditingController = new TextEditingController();
  TextEditingController typeEditingController = new TextEditingController();
  TextEditingController weigthEditingController = new TextEditingController();
  double screenHeight, screenWidth;
  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  String selectedType;
  List<String> listType = [
    "Drink",
    "Canned Food","Vegetable",
    "Meat",
    "Bread",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    print("edit Product");
    prnameEditingController.text = widget.product.name;
    priceEditingController.text = widget.product.price;
    qtyEditingController.text = widget.product.quantity;
    typeEditingController.text = widget.product.type;
    weigthEditingController.text = widget.product.weigth;
    selectedType = widget.product.type;
    print(weigthEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Update Your Product'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Container(
              height: screenHeight / 3,
              width: screenWidth / 1.5,
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl:
                    "http://slumberjer.com/grocery/productimage/${widget.product.pid}.jpg",
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
            SizedBox(height: 6),
            Container(
                width: screenWidth / 1.2,
                //height: screenHeight / 2,
                child: Card(
                    elevation: 6,
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Table(
                                defaultColumnWidth: FlexColumnWidth(1.0),
                                children: [
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("ID Produk",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ))),
                                    ),
                                    TableCell(
                                        child: Container(
                                      height: 30,
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text(
                                            " " + widget.product.pid,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          )),
                                    )),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Product Name",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            controller: prnameEditingController,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus0);
                                            },
                                            decoration: new InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(5),
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),

                                              //fillColor: Colors.green
                                            )),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Price (RM)",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            controller: priceEditingController,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus0,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus1);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            )),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Quantity",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            controller: qtyEditingController,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus1,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus2);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            )),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Type",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 40,
                                        child: Container(
                                          height: 40,
                                          child: DropdownButton(
                                            //sorting dropdownoption
                                            hint: Text(
                                              'Type',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    101, 255, 218, 50),
                                              ),
                                            ), // Not necessary for Option 1
                                            value: selectedType,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedType = newValue;
                                                print(selectedType);
                                              });
                                            },
                                            items: listType.map((selectedType) {
                                              return DropdownMenuItem(
                                                child: new Text(selectedType,
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            101,
                                                            255,
                                                            218,
                                                            50))),
                                                value: selectedType,
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Weigth (gram)",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            controller: weigthEditingController,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus2,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus3);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            )),
                                      ),
                                    ),
                                  ]),
                                ]),
                            SizedBox(height: 3),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              minWidth: screenWidth / 1.5,
                              height: 40,
                              child: Text('Update Product'),
                              color: Color.fromRGBO(101, 255, 218, 50),
                              textColor: Colors.black,
                              elevation: 5,
                              onPressed: () =>
                                  updateProductDialog(),
                            ),
                          ],
                        )))),
          ],
        )),
      ),
    );
  }


  updateProductDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Update Product Id " + widget.product.pid,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content:
              new Text("Are you sure?", style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                updateProduct();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  updateProduct() {
    if (prnameEditingController.text.length < 4) {
      Toast.show("Please enter product name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (qtyEditingController.text.length < 1) {
      Toast.show("Please enter product quantity", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (priceEditingController.text.length < 1) {
      Toast.show("Please enter product price", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (weigthEditingController.text.length < 1) {
      Toast.show("Please enter product weight", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    double price = double.parse(priceEditingController.text);
    double weigth = double.parse(weigthEditingController.text);

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating product...");
    pr.show();

    http.post("https://slumberjer.com/grocery/php/update_product.php", body: {
      "prid": widget.product.pid,
      "prname": prnameEditingController.text,
      "quantity": qtyEditingController.text,
      "price": price.toStringAsFixed(2),
      "type": typeEditingController.text,
      "weight": weigth.toStringAsFixed(2),
    }).then((res) {
      print(res.body);
      pr.dismiss();
      if (res.body == "success") {
        Toast.show("Update success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      } else {
        Toast.show("Update failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }
}
