import 'package:flutter/material.dart';

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Something went wrong"),
            ],
          ),
        )
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DecoratedBox( // here is where I added my DecoratedBox
          decoration: BoxDecoration(color: Colors.lightBlueAccent),
          child: Text('Loading'),
        ),
      ),
    );
  }
}