import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  // A list to store items along with their quantity.
  final List<Map<String, dynamic>> _cartItems = [];

  // Getter to access the cart items.
  List<Map<String, dynamic>> get cartItems => _cartItems;

  // Method to add items to the cart, increasing the quantity if the item already exists.
  void addSingleItem(int index) {
    // Check if the item is already in the cart.

    print('added single item');
    // If the item is already in the cart, just increase its quantity.
    _cartItems[index]['quantity'] += 1;
    _cartItems[index]['price'] += _cartItems[index]['product']['price'];

    // Notify listeners to update the UI.
    notifyListeners();
  }

  double get getTotalPrice {
    double total = 0;
    for (var item in _cartItems) {
      // Ensure quantity is treated as a number and cast to int if needed
      total += (item['price'] as num).toDouble();
    }
    return total;
  }

  void removeSingleItem(int index) {
    // Check if the item is already in the cart.

    if (_cartItems[index]['quantity'] > 1) {
      _cartItems[index]['quantity'] -= 1;
      print('removed single item');
      _cartItems[index]['price'] -= _cartItems[index]['product']['price'];
    } else {}

    // Notify listeners to update the UI.
    notifyListeners();
  }

  void addItemToCartWithAmount(
      Map<String, dynamic> item, int amount, Color color) {
    // Check if an item with the same product and color exists in the cart.
    final existingItemIndex = _cartItems.indexWhere(
      (cartItem) => cartItem['product'] == item && cartItem['color'] == color,
    );

    if (existingItemIndex != -1) {
      // If the item with the same product and color is found, update the quantity.
      _cartItems[existingItemIndex]['quantity'] += amount;
      _cartItems[existingItemIndex]['price'] += item['price'] * amount;
    } else {
      // If the item is not found, add it as a new entry.
      _cartItems.add({'product': item, 'quantity': amount, 'color': color, 'price': item['price'] * amount});
    }

    // Notify listeners to update the UI.
    notifyListeners();
  }

  // Method to remove items from the cart, decreasing the quantity or removing the item.
  void removeItemFromCart(int index) {
    // Check if the item is already in the cart.
    print('removed product entirely');
    // If the item is already in the cart, just increase its quantity.
    _cartItems.removeAt(index);

    // Notify listeners to update the UI.
    notifyListeners();
  }

  // Method to get the total count of items in the cart (sum of all quantities).
  int get totalCartItems {
    int total = 0;
    for (var item in _cartItems) {
      // Ensure quantity is treated as a number and cast to int if needed
      total += (item['quantity'] as num).toInt();
    }
    return total;
  }
}
