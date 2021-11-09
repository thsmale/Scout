import 'package:flutter/material.dart';
import 'package:scout/add_event.dart';
import 'package:scout/order_form.dart';
import 'chart.dart';
import 'cookie.dart';
import 'edit_menu.dart';
import 'flutter_routes.dart';
import 'shopping_cart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'orders.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App()
  );
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();

}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if(_error) {
      return MaterialApp(home: SomethingWentWrong());
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return MaterialApp(home: Loading());
    }

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: CookieMenu(),
      //initialRoute: '/',
      routes: {
        //When navigating to / route build the FirstScreenWidget
        CustomerInfo.routeName: (context) => CustomerInfo(),
        Checkout.routeName: (context) => Checkout(),
        //'/': (context) => CookieMenu(),
        EditCookieMenu.routeName: (context) => EditCookieMenu()
      },
    );
  }
}


class CookieMenu extends StatelessWidget {
  // This widget is the root of your application.

  final Order order = Order();
  @override
  Widget build(BuildContext context) {
    return CookieMenuList(order: order);
  }
}

//Define a custom form widget
class CookieMenuList extends StatefulWidget {
  CookieMenuList({Key key, this.order}) : super(key: key);

  Order order;

  @override
  CookieMenuState createState() {
    return CookieMenuState();
  }
}

class CookieMenuState extends State<CookieMenuList> {

  //List<Cookie> cookies = [];
  final List<String> appTitles = ["Place order", "Sales", "Create Event", "Control sheeet"];
  String appTitle = "Cookie Menu";

  void _changeBoxes(Cookie cookie, int value) {
    setState(() {
      cookie.boxes += value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            // Your code goes here.
            // To get index of current tab use tabController.index
            setState(() {
              appTitle = appTitles[tabController.index];
            });
          }
        });
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(appTitle),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.restaurant_menu), text: "Order"),
                Tab(icon: Icon(Icons.contact_mail), text: "Sales"),
                Tab(icon: Icon(Icons.event), text: "Event"),
                Tab(icon: Icon(Icons.pending_actions), text: "Stats")
              ],
            ),
          ),
          body: TabBarView(
              children: [
                ListView(children: _getListData()),
                Orders(),
                FormWidgetsDemo(),
                SimpleBarChart()
              ]
          ),
        );
      }),
    );
  }

  _getListData() {
    List<Widget> widgets = [];
    for (Cookie cookie in widget.order.cookies) {
      widgets.add(
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget> [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(cookie.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Price \$" + cookie.price.toStringAsFixed(2),
                  textAlign: TextAlign.right),
                ],
              ),
              cookie.image,
              Text(cookie.description),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                        if (cookie.boxes <= 0) {
                          return;
                        }
                        _changeBoxes(cookie, -1);
                      },
                    icon: Icon(Icons.remove),
                    label: Text("Remove"),
                  ),
                  Text("Boxes: " + cookie.boxes.toString()),
                  ElevatedButton.icon(
                      onPressed: () {_changeBoxes(cookie, 1);},
                      icon: Icon(Icons.add),
                      label: Text("Add"),
                  )
                ],
              )

            ],
          ),
        ),
      );
    }
    widgets.add(
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              bool order_complete = false;
              for (Cookie cookie in widget.order.cookies) {
                if (cookie.boxes > 0) {
                  order_complete = true;
                }
              }
              if(!order_complete) {
                // set up the button
                Widget okButton = FlatButton(
                  child: Text("OK"),
                  onPressed: () {Navigator.of(context).pop();},
                );

                // set up the AlertDialog
                AlertDialog alert = AlertDialog(
                  title: Text("Cart is empty"),
                  content: Text("To checkout you must have selected at least one box."),
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
                return;
                //return AlertDialog(title: Text("Cart is empty"),);
              }
              //Navigator.pushNamed(context, '/cart');
              /*
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Order())
              );

               */
              Navigator.pushNamed(context, CustomerInfo.routeName, arguments: widget.order);
            },


            icon: Icon(Icons.contact_mail),
            label: Text("Order Form"),
          )
      )
    );
    return widgets;
  }
}
