import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'flutter_routes.dart';
import 'cookie.dart';

class Orders extends StatelessWidget {
  static const routeTitle = "Sales";
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OrderList());
  }
}

class OrderList extends StatefulWidget {
  @override
  OrderListState createState() {
    return OrderListState();
  }
}

class OrderListState extends State<OrderList> {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: orders.get(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        if (snapshot.connectionState == ConnectionState.done) {

          return ListView(children: _getListData(snapshot));
        }

        return CircularProgressIndicator();
      },
    );
  }

  //Returns a widgets of cookies. Cookie image and qty
  List<Widget> getCookieNames(DocumentSnapshot doc) {
    List<String> cookieNames = ['Girl Scout S\'mores', 'Do-si-dos', 'Lemon-Ups', 'Samoas',
      'Tagalongs', 'Thin Mints', 'Toffee-tastic', 'Trefoils'];
    Order order =  Order();
    Map<String, int> orderedCookies = new Map();
    int cookieCount = 0;
    for (String cookie in cookieNames) {
      try {
        cookieCount = doc[cookie];
      } catch(e) {
        continue;
      }

      orderedCookies[cookie] = cookieCount;
    }
    List<Widget> cookies = [];
    orderedCookies.forEach((key, value) {
      cookies.add(Column(children: [

        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          height: 100,
          child:  ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              //padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                height: 100,
                child: order.getCookieImage(key)
            ),
          ),
        ),

        Text(key),
        Text("Count " + value.toString()),
      ]));
    });
    return cookies;
  }

  List<Widget> _getListData(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Widget> widgets = [];
    List<String> cookies = [];
    List<Widget> cookieWidgets = [];
    String s = "";
    snapshot.data.docs.forEach((doc) => {
      cookieWidgets = List.from(getCookieNames(doc)),
      widgets.add(Card(shadowColor: Colors.green, child: Container(
          padding: new EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //crossAxisAlignment defaults to 0
              Container(
                alignment: Alignment.bottomLeft,
                child: RichText(text: TextSpan(text: "Name: ", style: TextStyle(color: Colors.black), children: [TextSpan(
                  text: doc["name"], style: TextStyle(color: Colors.black))
                ])),
              ),
              Container(
                  alignment: Alignment.bottomLeft,
                  child: Text("Order ID: " + doc.id, textAlign: TextAlign.left,)
              ),
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(top: 8.0),
                child: Text("Cookies ordered", style: TextStyle(fontSize: 20),),
              ),
              SizedBox(
                height: 132,
                child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var cookie in cookieWidgets) cookie
                    ]
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 8), child:
              Text("Address", style: TextStyle(fontSize: 20, decoration:
                TextDecoration.underline),)),
              Text(doc["address"]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(doc["city"] + ", "),
                  Text(doc["state"]),
                  Text(" " + doc["zip"]),

                ],
              ),
              Text(doc["country"]),
              Padding(padding: EdgeInsets.only(top: 8), child:
              Text("Contact Information", style: TextStyle(fontSize: 20, decoration:
              TextDecoration.underline),)),
              Text("Email: " + doc["email"]),
              Text("Phone: " + doc["number"]),
            ])
        )
      ),
      )
    });
    return widgets;
  }
}