import 'package:flutter/material.dart';
import 'cookie.dart';

class EditCookieMenu extends StatelessWidget {
  // This widget is the root of your application.
  static const routeName = '/editMenu';
  @override
  Widget build(BuildContext context) {
    final appTitle = "Edit Cookie Menu";
    final Order order = ModalRoute.of(context).settings.arguments as Order;

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: EditCookieMenuList(order: order),
    );
  }
}

//Define a custom form widget
class EditCookieMenuList extends StatefulWidget {
  EditCookieMenuList({Key key, this.order}) : super(key: key);

  Order order;

  @override
  EditCookieMenuState createState() {
    return EditCookieMenuState();
  }
}

class EditCookieMenuState extends State<EditCookieMenuList> {

  //List<Cookie> cookies = [];

  void _changeBoxes(Cookie cookie, int value) {
    setState(() {
      cookie.boxes += value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: _getListData());
  }

  _getListData() {
    List<Widget> widgets = [];
    for (Cookie cookie in widget.order.cookies) {
      widgets.add(GestureDetector(
        child: Container (
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
              FittedBox(
                fit: BoxFit.contain,
                child: cookie.image,
              ),
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
        onTap: () {
          print('row tapped');
        },
      ));
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
                Navigator.pop(context, widget.order);
              },


              icon: Icon(Icons.shopping_cart),
              label: Text("Return to confirmation"),
            )
        )
    );
    return widgets;
  }
}
