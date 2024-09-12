import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize; // Implement preferredSize

  final String name;
  const CustomAppBar({super.key, required this.name})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( horizontal: 20),
      child: AppBar(
        
        toolbarHeight: 100,
        actionsIconTheme: IconThemeData(color: Colors.green[900], size: 30),
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Text(name,
                style:  TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                  color: Colors.green[900]
                )),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
