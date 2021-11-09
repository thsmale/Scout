// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Bar chart example
// EXCLUDE_FROM_GALLERY_DOCS_START
import 'dart:math';
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'flutter_routes.dart';


class SimpleBarChart extends StatelessWidget {
  List<charts.Series> seriesList;
  final bool animate = true;
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');


  //SimpleBarChart(this.seriesList, {this.animate});

  static List<charts.Series<CookieSales, String>> _readCookieData(
      AsyncSnapshot<QuerySnapshot> snapshot) {
    List<CookieSales> data = [
      CookieSales('Girl Scout S\'mores', 0),
      CookieSales('Do-si-dos', 0),
      CookieSales('Lemon-Ups', 0),
      CookieSales('Samoas', 0),
      CookieSales('Tagalongs', 0),
      CookieSales('Thin Mints', 0),
      CookieSales('Toffee-tastic', 0),
      CookieSales('Trefoils', 0)
    ];
    final List<String> cookieNames = [
      'Girl Scout S\'mores',
      'Do-si-dos',
      'Lemon-Ups',
      'Samoas',
      'Tagalongs',
      'Thin Mints',
      'Toffee-tastic',
      'Trefoils'
    ];

    snapshot.data.docs.forEach((doc) {
      int cookieCount = 0;
      for (String cookie in cookieNames) {
        try {
          cookieCount = doc[cookie];
        } catch (e) {
          continue;
        }
        //print(data[cookieNames.indexOf(doc[cookie])].count.toString() + cookieCount.toString());
        //data[cookieNames.indexOf(doc[cookie])].count += cookieCount;
        //print(doc[cookie] + cookieCount.toString());
        var index = cookieNames.indexOf(cookie);
        if (index == -1) {
          print("COOKIE NOT FOUND" + doc[cookie]);
        }
        data[index].count += cookieCount;
      }
    });

    return [
      new charts.Series<CookieSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (CookieSales sales, _) => sales.name,
        measureFn: (CookieSales sales, _) => sales.count,
        data: data,
      )
    ];
  }

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

          return new charts.BarChart(
            _readCookieData(snapshot),
            animate: animate,
            vertical: false,
          );;
        }

        return CircularProgressIndicator();
      },
    );
  }
}

class CookieSales {
  final String name;
  int count;

  CookieSales(this.name, this.count);
}