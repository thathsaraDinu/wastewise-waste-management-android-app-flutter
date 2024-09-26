import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartItemEntity {
  final String productId;
  final int quantity;
  final Color color;
  final String id;
  final double price;
  final String name;
  final String imageUrl;
  final Timestamp date;
  final double unitPrice;

  CartItemEntity({
    required this.productId,
    required this.quantity,
    required this.color,
    this.id = '',
    required this.price,
    this.name = '',
    this.imageUrl = '',
    required this.date,
    required this.unitPrice
  });

  static CartItemEntity fromDocument(Map<String, Object?> doc, [String? id]) {
    return CartItemEntity(
      productId: id ?? '',
      quantity:
          (doc['quantity'] as num?)?.toInt() ?? 0, // Convert int to double
      color: Color(doc['color'] as int? ?? 0xFFFFFFFF),
      id: doc['id'] as String? ?? '',
      price: (doc['price'] as num?)?.toDouble() ?? 0.0, // Convert int to double
      name: doc['name'] as String? ?? '',
      imageUrl: doc['imageUrl'] as String? ?? '',
      date: doc['date'] as Timestamp? ?? Timestamp.fromDate(DateTime.now()),
      unitPrice: doc['unitPrice'] as double? ?? 0.0
      // Convert Timestamp to DateTime
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'productId': productId,
      'quantity': quantity,
      'color': color.value,
      'id': id,
      'price': price,
      'name': name,
      'imageUrl': imageUrl,
      'date': date,
      'unitPrice': unitPrice
    };
  }
}
