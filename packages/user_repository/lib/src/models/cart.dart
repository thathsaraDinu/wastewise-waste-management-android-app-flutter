import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/src/entities/cart_entity.dart';

class CartItem {
  String productId;
  int quantity;
  Color color;
  String id;
  double price;
  String name;
  String imageUrl;
  Timestamp date;
  double unitPrice;

  CartItem({
    required this.productId,
    required this.quantity,
    required this.color,
    required this.price,
    this.id = '',
    this.name = '',
    this.imageUrl = '',
    required this.date,
    required this.unitPrice
  });

  static final CartItem empty = CartItem(
    productId: '',
    quantity: 0,
    color: Colors.white,
    id: '',
    price: 0.0,
    name: '',
    imageUrl: '',
    date: Timestamp.fromDate(DateTime.now()),
    unitPrice: 0.0
  );

  CartItemEntity toEntity() {
    return CartItemEntity(
      productId: productId,
      quantity: quantity,
      color: color,
      id: id,
      price: price,
      name: name,
      imageUrl: imageUrl,
      date: date,
      unitPrice: unitPrice
    );
  }

  static CartItem fromEntity(CartItemEntity entity) {
    return CartItem(
      productId: entity.productId,
      quantity: entity.quantity,
      color: entity.color,
      id: entity.id,
      price: entity.price,
      name: entity.name,
      imageUrl: entity.imageUrl,
      date: entity.date,
      unitPrice: entity.unitPrice
    );
  }
}
