import 'package:flutter/material.dart';
import 'package:shoppingapp/cards/product_type.dart';
import 'package:shoppingapp/models/dummy_data_product_type.dart';

ListView producttypeslist() {
  return ListView.builder(
    itemBuilder: (context, index) => ProductType(
      item: productTypes[index],
    ),
    scrollDirection: Axis.horizontal,
    itemCount: productTypes.length,
  );
}
