import 'package:flutter/material.dart';
import 'package:products_repository/products_repository.dart';
import 'package:shoppingapp/cards/product_card.dart';

GridView productslistgrid(List<ProductModel> items) {
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
      ProductModel product = items[index];
      return Productcard(
        item: product,
      );
    },
  );
}
