import 'dart:async';
import 'package:flutter/material.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:scout/shopping_cart.dart';

import 'cookie.dart';


/*
void main() {
  runApp(MyApp());
}

 */


class CustomerInfo extends StatelessWidget {
  // This widget is the root of your application.
  static const routeName = '/order';

  @override
  Widget build(BuildContext context) {
    final appTitle = "Order Form";
    //final List<Cookie> cookies = ModalRoute.of(context).settings.arguments as List<Cookie>;
    final Order order = ModalRoute.of(context).settings.arguments as Order;
    return Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: OrderForm(order: order)
    );
  }
}

//Define a custom form widget
class OrderForm extends StatefulWidget {
  OrderForm({Key key, this.order}) : super(key: key);

  //final List<Cookie> cookies;
  final Order order;

  @override
  OrderFormState createState() {
    return OrderFormState();
  }
}

//Define a corresponding state class
//This class holds data related to the form
class OrderFormState extends State<OrderForm> {
  //Create global key that uniquely identifies the Form widget
  //and allows validation of the form

  //Note: this is a GlobalKey<FormState>
  //not a Global<MyCustomFormState>
  final _formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNumber = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  final city = TextEditingController();
  final zipCode = TextEditingController();


  String stateValue = "";


  @override
  Widget build(BuildContext context) {
    //Build a form using the _formKey created above
    int id = 0;

    //ListView is laggy
    return SingleChildScrollView(
    child: Form(
        key: _formKey,
        child: Column(children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'First name',
                hintText: 'John'),
            onSaved: (String value) {
              //This block of code can be run when user saves form
              print("onSaved value $value");
            },
            validator: (String value) {
              if (value.isEmpty) {
                return "Field can't be empty.";
              }
              return null;
            },
            controller: firstName,
          ),
          TextFormField(
            decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Last name',
                hintText: 'Doe'),
            onSaved: (String value) {
              //This block of code can be run when user saves form
              print("onSaved value $value");
            },
            validator: (String value) {
              if (value.isEmpty) {
                return "Field can't be empty.";
              }
              return null;
            },
            controller: lastName,
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.phone),
              labelText: 'Phone',
              hintText: '0000000000',
            ),
            keyboardType: TextInputType.phone,
            validator: (String value) {
              if (value.isEmpty) {
                return "Field can't be empty.";
              }
              //String pattern = '^(\+0?1\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}\$';
              String pattern = '^(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]?\\d{3}[\\s.-]?\\d{4}\$';
              RegExp regExp = new RegExp(pattern);
              if (!regExp.hasMatch(value)) {
                return "Invalid phone number. Enter only US numbers";
              }
              return null;
            },
            controller: phoneNumber,
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.email),
              labelText: 'E-mail',
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return "Field can't be empty.";
              }
              if (!value.contains("@")) {
                return "Email has no @";
              }
              return null;
            },
            controller: email,
          ),
          TextFormField(
            decoration: const InputDecoration(
                icon: Icon(Icons.house), labelText: 'Address', hintText: '702 W 5th St'),
            validator: (String value) {
              if (value.isEmpty) {
                return "Address is a required field";
              }
              return null;
            },
            controller: address,
          ),
          TextFormField(
            decoration: const InputDecoration(
                icon: Icon(Icons.location_city),
                labelText: 'City', hintText: 'Chico'
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return "City is a required field";
              }
              return null;
            },
            controller: city,
          ),
          Container(
            padding: EdgeInsets.only(top: 8),
            child: SelectState(
              onStateChanged: (value) {
                setState(() {
                  stateValue = value;
                });
              },
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
                labelText: 'Zip Code', hintText: '95928'
            ),
            validator: (String value) {
              if (value.length != 5) {
                return "5 digit zip codes only";
              }
              return null;
            },
            controller: zipCode,
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey[300]),
              ),
            ),
            child: Text("Country: 🇺🇸 United States",
              style: TextStyle(color: Colors.black, fontSize: 20,
              /*decoration: TextDecoration.underline*/),
              textAlign: TextAlign.left,
            ),
          ),
          //Expanded with flex will not work here. Neeed something scrollable
          ElevatedButton.icon(
            onPressed: () {
              if (stateValue == "") {
                Widget okButton = FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                );

                // set up the AlertDialog
                AlertDialog alert = AlertDialog(
                  title: Text("Select State"),
                  content: Text("Orders are valid only in the United States"),
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

              if (_formKey.currentState.validate()) {
                //If the form is valid, display a snack bar. In real world
                //you'd often call server or store in database
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing data')));

                widget.order.setCustomerInfo(firstName.text.trim() + " " +
                    lastName.text.trim(), phoneNumber.text, email.text, address.text.trim(),
                    city.text.trim(), stateValue, zipCode.text.trim(), "United States");
                /*
              ConfirmOrder order = ConfirmOrder(widget.cookies, lastName.text,
                  phoneNumber.text, email.text, address.text, city.text,
                  stateValue, zipCode.text, "United States");

               */

                Navigator.pushNamed(context, Checkout.routeName, arguments: widget.order);
              }

            },
            icon: Icon(Icons.shopping_cart),
            label: Text("Checkout"),
          ),
        ])));
  }
}
