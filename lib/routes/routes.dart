import 'package:flutter/material.dart';
import 'package:shoppingapp/common/bottom_navigation_bar.dart';
import 'package:shoppingapp/screens/product_details_page.dart';
import 'package:shoppingapp/screens/recycled_items_main.dart';
import 'package:shoppingapp/screens/shopping_cart.dart';
// Make sure to import all your page files

class AppRoutes {
  static const String productpage = '/productpage';
  static const String shoppingpage = '/shoppingcart';
    static const String recycleditems= '/recycleditemsmain';
    static const String mainpage= '/';


  static Map<String, WidgetBuilder> getRoutes() {
    return {
      productpage: (context) => const ProductPage(),
      shoppingpage: (context) => const ShoppingCart(),
      recycleditems: (context) => const RecycledItems(),
      mainpage: (context) => const HomePage(),
    };
  }
}
