import 'package:flutter/cupertino.dart';

class Troop {

}

class Event {
  String title;
  String description;
  DateTime date;
  int troop;
  bool cashAccepted;
  bool enableLocation;
}

class Order {
  List<Cookie> cookies = [];
  String name;
  String number;
  String email;
  String address;
  String city;
  String state;
  String zipcode;
  String country;

  Image getCookieImage(String name) {
    /*
    List<String> images = ['cookie_images/ABCSmores.jpg', 'cookie_images/Dosidos.jpg',
      'cookie_images/LemonUps.jpg', 'cookie_images/Samoas.jpg', 'cookie_images/Tagalongs.jpg',
      'cookie_images/ThinMints.jpg', 'cookie_images/ToffeeTastics.jpg',
      'cookie_images/Trefoils.jpg'];

    this.cookies.asMap().forEach((index, cookie) {
      if (cookie.name == name) {
        print(name + images[index]);
        return images[index];
      }
    });

     */

    for (var cookie in this.cookies) {
      if (name == cookie.name) {
        return cookie.image;
      }
    }

  }

  void reset() {
    for (var cookie in this.cookies) {
      cookie.boxes = 0;
    }
  }

  Order() {
    Cookie smore = Cookie('Girl Scout S\'mores', Image.asset('cookie_images/ABCSmores.jpg'),
        "Crispy graham cookies double-dipped in creme icing and coated in delicious fudge", 6.00);
    Cookie dosidos = Cookie('Do-si-dos', Image.asset('cookie_images/Dosidos.jpg'),
        "Oatmeal sandwhich cookies with peanut butter filling", 5.00);
    Cookie lemon_up = Cookie('Lemon-Ups', Image.asset('cookie_images/LemonUps.jpg'),
        "Crispy lemon cookies baked with inspiring messages to lift your spirits", 5.00);
    Cookie samoa = Cookie('Samoas', Image.asset('cookie_images/Samoas.jpg'),
        "Crispy cookies topped with caramel, toasted coconut, and fudge stripes", 6.00);
    Cookie tagalong = Cookie('Tagalongs', Image.asset('cookie_images/Tagalongs.jpg'),
        "Crispy cookies layered with peanut butter and covered with a chocolaty coating", 5.00);
    Cookie thin_mint = Cookie('Thin Mints', Image.asset('cookie_images/ThinMints.jpg'),
        "Crispy chocolate wafers dipped in a mint fudge coating", 5.00);
    Cookie toffee_tastic = Cookie('Toffee-tastic', Image.asset('cookie_images/ToffeeTastics.jpg'),
        "Rich, buttery cookies with sweet, crunchy toffee bits", 5.00);
    Cookie trefoil = Cookie('Trefoils', Image.asset('cookie_images/Trefoils.jpg'),
        "Traditional shortbread cookies", 5.00);

    this.cookies.add(smore);
    this.cookies.add(dosidos);
    this.cookies.add(lemon_up);
    this.cookies.add(samoa);
    this.cookies.add(tagalong);
    this.cookies.add(thin_mint);
    this.cookies.add(toffee_tastic);
    this.cookies.add(trefoil);
  }

  void setCustomerInfo(String name, String phoneNumber, String email,
      String address, String city, String state, String zipCode, String country) {
    this.name = name;
    this.number = phoneNumber;
    this.email = email;
    this.address = address;
    this.city = city;
    this.state = state;
    this.zipcode = zipCode;
    this.country = country;
  }
}

class Cookie {
  String name;
  Image image;
  String description;
  double price;
  int boxes;

  Cookie(String name, Image image, String description, double price) {
    this.name = name;
    this.image = image;
    this.description = description;
    this.price = price;
    this.boxes = 0;
  }
}
