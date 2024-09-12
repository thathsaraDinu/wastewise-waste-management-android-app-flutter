import 'package:flutter/material.dart';
import 'package:shoppingapp/cards/product_card.dart';
import 'package:shoppingapp/models/dummy_data_products.dart';

GridView productslistgrid() {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(), // Disable internal scrolling
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 15.0,
      mainAxisSpacing: 15.0,
      childAspectRatio: 9 / 15,
    ),
    itemCount: items.length,
    itemBuilder: (BuildContext context, int index) {
      return Productcard(
        item: items[index],
        
      );
    },
  );
}
