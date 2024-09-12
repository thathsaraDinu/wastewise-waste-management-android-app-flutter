import 'package:flutter/material.dart';
import 'package:shoppingapp/screens/product_details_page.dart';
// Make sure to import all your page files


class AppRoutes {
  static const String productpage = '/productpage';
  

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      productpage: (context) =>  const ProductPage(),
     
    };
  }
}
