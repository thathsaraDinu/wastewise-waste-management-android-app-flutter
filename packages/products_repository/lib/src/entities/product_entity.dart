import 'package:flutter/material.dart';

class ProductEntity {
  String id;
  String name;
  double price;
  String description;
  String longDescription;
  double rating;
  int ratingCount;
  List<String> imageUrls;
  List<Color> colors = [];

  ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.longDescription,
    required this.rating,
    required this.ratingCount,
    required this.imageUrls,
    required this.colors,
  });

  static ProductEntity fromDocument(Map<String, Object?> doc, [String? id]) {
    return ProductEntity(
      id: id ?? '', // Provide default empty string if null
      name: doc['name'] as String? ?? 'Unknown Product', // Handle null case
      price:
          (doc['price'] as num?)?.toDouble() ?? 0.0, // Default to 0.0 if null
      description: doc['description'] as String? ?? '',
      longDescription: doc['longDescription'] as String? ?? '',
      rating: (doc['rating'] as num?)?.toDouble() ?? 0.0, // Handle null case
      ratingCount: doc['ratingCount'] as int? ?? 0, // Default to 0 if null
      imageUrls: List<String>.from(
          doc['imageUrls'] as List? ?? []), // Handle null list
      colors: (doc['colorsAsDecimal'] as List?)
              ?.map((colorCode) =>
                  Color(colorCode as int)) // Convert color code to Color
              .toList() ??
          [], // Convert to Color
    );
  }
}
