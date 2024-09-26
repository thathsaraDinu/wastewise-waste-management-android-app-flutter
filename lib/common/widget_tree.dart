import 'package:flutter/material.dart';
import 'package:shoppingapp/common/background_image.dart';
import 'package:shoppingapp/common/login_checker.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return const BackgroundWrapper(child: LoginChecker(routeName: '/mainpage'));
  }
}
