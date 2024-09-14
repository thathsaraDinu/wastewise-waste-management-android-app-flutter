import 'package:flutter/material.dart';
import 'package:shoppingapp/cards/shopping_cart_card.dart';
import 'package:shoppingapp/models/cart_model.dart';
import 'package:shoppingapp/screens/shopping_cart.dart';
import 'package:provider/provider.dart';

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