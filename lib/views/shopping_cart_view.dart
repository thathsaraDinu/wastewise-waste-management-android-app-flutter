import 'package:flutter/material.dart';
import 'package:shoppingapp/cards/shopping_cart_card.dart';

ListView shoppingcartview(cart){
 // final cartItemsList = cartitem.cartItems.map((item) {
   // return {
   //   'name': item['product']['name'],
   //   'quantity': item['quantity'],
  //  };
 // }).toList();

final cartItemsList = cart.cartItems.map((item) {
    return {
      'name': item['product']['name'],
      'quantity': item['quantity'],
      'color': item['color'],
    };
  }).toList();
  return ListView.builder(
    
    itemBuilder: (context, index) => ShoppingCartCard(index: index),
    itemCount: cartItemsList.length,

  );
}