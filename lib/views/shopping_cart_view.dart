import 'package:flutter/material.dart';
import 'package:shoppingapp/cards/shopping_cart_card.dart';
import 'package:user_repository/user_repository.dart';

StreamBuilder shoppingcartview(cart) {
  // final cartItemsList = cartitem.cartItems.map((item) {
  // return {
  //   'name': item['product']['name'],
  //   'quantity': item['quantity'],
  //  };
  // }).toList();

  // final cartItemsList = cart.cartItems.map((item) {
  //   return {
  //     'name': item['product'].name,
  //     'quantity': item['quantity'],
  //     'color': item['color'],
  //   };
  // }).toList();
  // return ListView.builder(
  //   itemBuilder: (context, index) => ShoppingCartCard(index: index),
  //   itemCount: cartItemsList.length,
  // );

  return StreamBuilder<List<CartItem>>(
    stream: cart,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return const Center(child: Text('An Error occured'));
      }
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('Your cart is empty.'));
      }

      final cartItems = snapshot.data!;
      // Log cartItems length to ensure it's correct

      return ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          // Log the current index to ensure it is valid

          // Ensure index is within valid range

          final cartItem = cartItems[index];
          return ShoppingCartCard(cartItem: cartItem);
        },
      );
    },
  );
}
