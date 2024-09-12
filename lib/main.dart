import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shoppingapp/routes/routes.dart';
import 'package:shoppingapp/screens/recycled_items_main.dart';

void main() {
  debugPaintSizeEnabled = false; // Optionally enable for debugging
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: AppRoutes.getRoutes(),
      home: const RecycledItems(),
      title: 'WasteWise',
    );
  }
}
