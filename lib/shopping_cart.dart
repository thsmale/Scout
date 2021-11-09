import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scout/edit_menu.dart';
import 'cookie.dart';
import 'order_form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'flutter_routes.dart';
import 'package:intl/intl.dart' as intl;


class Checkout extends StatelessWidget {
  // This widget is the root of your application.
  static const routeName = '/confirmation';
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    final routeTitle = "Confirm Order";
    //final ConfirmOrder order = ModalRoute.of(context).settings.arguments as ConfirmOrder;
    final Order order = ModalRoute.of(context).settings.arguments as Order;
    return Scaffold(
        appBar: AppBar(
          title: Text(routeTitle),
        ),
        body: ShoppingCart(order: order));
  }
}

//Define a custom form widget
class ShoppingCart extends StatefulWidget {
  ShoppingCart({Key key, this.order}) : super(key: key);

  Order order;

  @override
  ShoppingCartState createState() {
    return ShoppingCartState();
  }
}

//Define a corresponding state class
//This class holds data related to the form
class ShoppingCartState extends State<ShoppingCart> {

  CollectionReference order = FirebaseFirestore.instance.collection('orders');

  Future<void> addOrder() {
    List<Cookie> selectedCookies = [];
    for (Cookie cookie in widget.order.cookies) {
      if (cookie.boxes > 0) {
        selectedCookies.add(cookie);
      }
    }

    var cookieMap = Map<String, dynamic>.fromIterable(selectedCookies,
        key: (cookie) => cookie.name, value: (cookie) => cookie.boxes);

    cookieMap.addAll({
      "name": widget.order.name,
      "number": widget.order.number,
      "email": widget.order.email,
      "address": widget.order.address,
      "city": widget.order.city,
      "state": widget.order.state,
      "zip": widget.order.zipcode,
      "country": widget.order.country,
      "paid": false
    });

    return order.add(cookieMap)
        .then((value) => loadSuccess())
        .catchError((error) => loadError());
  }

  void loadSuccess() {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: ()  {
        Navigator.popAndPushNamed(context, '/');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Order successful!"),
      content: Text("A confirmation email will be sent to you shortly."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  void loadError() {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Order unsuccessful"),
      content: Text("We are currently having problems, please try again later."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return ListView(children: _getListData());
  }

  _getListData() {
    List<Widget> widgets = [];
    int _total_packages = 0;
    double total_cost = 0.0;
    for (Cookie cookie in widget.order.cookies) {
      if (cookie.boxes > 0) {
        _total_packages += cookie.boxes;
        double cost = cookie.boxes * cookie.price;
        total_cost += cost;
        //All the cookies
        widgets.add(Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: cookie.image,
                  height: 90,
                  //fit: BoxFit.fitWidth,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cookie.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Price: \$" + cookie.price.toStringAsFixed(2),
                        textAlign: TextAlign.left),
                    Text("Boxes: " + cookie.boxes.toString()),
                    Text("Cost: " + cost.toStringAsFixed(2),
                        textAlign: TextAlign.left)
                  ],
                ),
              ],
            )
        ));
      }
    }
    //Totals
    widgets.add(
        Column(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "Total packages: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black
                          , fontSize: 16)
                  ),
                  TextSpan(text: _total_packages.toString(), style: TextStyle(
                      color: Colors.black,
                      fontSize: 16))
                ],
              ),
              textAlign: TextAlign.center,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "Amount due: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black
                          , fontSize: 16)
                  ),
                  TextSpan(
                      text: intl.NumberFormat.currency(
                          symbol: "\$", decimalDigits: 0)
                          .format(total_cost), style: TextStyle(
                      color: Colors.black,
                      fontSize: 16))
                ],
              ),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(child: Text("Edit Cookies"),
              onPressed: () {
                _navigateAndDisplayMenu(context);
              },
            )
          ],
        )
    );
    widgets.add(Container(
        padding: EdgeInsets.only(top: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.order.name),
            Text(widget.order.address),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.order.city + ", "),
                Text(widget.order.state),
                Text(" " + widget.order.zipcode)
              ],
            ),
            Text(widget.order.country),
            Text(""),
            Text("Email: " + widget.order.email),
            Text("Phone: " + widget.order.number)
          ],
        )
    ));
    widgets.add(
        Center(
            child: ElevatedButton(child: Text("Edit Information"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
        )
    );
    widgets.add(
        ElevatedButton.icon(onPressed: () {
          addOrder();
          widget.order.reset();
        }, label: Text("Finish",
            style: TextStyle(fontWeight: FontWeight.bold,)),
            icon: Icon(Icons.check_box))
    );
    return widgets;
  }

  _navigateAndDisplayMenu(BuildContext context) async {
    await Navigator.pushNamed(context, EditCookieMenu.routeName,
        arguments: widget.order);
    setState(() {
      _getListData();
    });
    for (Cookie cookie in widget.order.cookies) {
      if (cookie.boxes > 0) {
        print(cookie.name);
      }
    }
  }
}
