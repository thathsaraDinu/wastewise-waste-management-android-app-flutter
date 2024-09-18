import 'package:flutter/material.dart';
import 'package:shoppingapp/models/cart_model.dart';
import 'package:provider/provider.dart'; // Make sure you are using Provider for state management

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize; // Implement preferredSize

  final String name;

  const CustomAppBar({super.key, required this.name})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Fetch the cart item count using Provider
    int cartItemCount = context.watch<CartModel>().totalCartItems;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: AppBar(
        toolbarHeight: 100,
        actionsIconTheme: IconThemeData(color: Colors.green[900], size: 30),
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Text(name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: Colors.green[900])),
          ],
        ),
        actions: [
          if (name != 'Shopping cart')
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.pushNamed(context, '/shoppingcart');
                    },
                  ),
                  if (cartItemCount >
                      0) // Only show the badge if items exist in cart
                    Positioned(
                      right: 5,
                      top: 5,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Center(
                          child: Text(
                            cartItemCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
