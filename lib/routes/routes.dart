import 'package:flutter/material.dart';
import 'package:shoppingapp/common/main_page.dart';
import 'package:shoppingapp/common/widget_tree.dart';
import 'package:shoppingapp/screens/product_details_page.dart';
import 'package:shoppingapp/screens/recycled_items_main.dart';
import 'package:shoppingapp/screens/shopping_cart.dart';
import 'package:shoppingapp/screens/signup_login_page.dart';
// Make sure to import all your page files

class AppRoutes {
  static const String productpage = '/productpage';
  static const String shoppingpage = '/shoppingcart';
  static const String recycleditems = '/recycleditemsmain';
  static const String mainpage = '/mainpage';
  static const String widgettree = '/';
  static const String signupandlogin = '/signupandlogin';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      productpage: (context) => const ProductPage(),
      shoppingpage: (context) => const ShoppingCart(),
      recycleditems: (context) => const RecycledItems(),
      mainpage: (context) => const MainPage(),
      widgettree: (context) => const WidgetTree(),
      signupandlogin: (context) => const SignupLoginPage(),
    };
  }
}
