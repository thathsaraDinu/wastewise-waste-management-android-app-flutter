import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './models/models.dart';
import './entities/entities.dart';

class ProductService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch a single product by its ID
  Future<ProductModel> getProductById(String productId) async {
    try {
      // Get the product document from Firestore
      DocumentSnapshot productSnapshot =
          await _firestore.collection('products').doc(productId).get();

      if (productSnapshot.exists) {
        // Convert the Firestore document data to a ProductModel
        return ProductModel.fromEntity(
          ProductEntity.fromDocument(
            productSnapshot.data() as Map<String, dynamic>,
          ),
        );
      } else {
        return ProductModel.empty;
      }
    } catch (e) {
      return ProductModel.empty;
    }
  }

  // Fetch all products from the 'products' collection
  Future<List<ProductModel>> getAllProducts(int sortType) async {
    try {
      // Get all product documents from the 'products' collection
      QuerySnapshot querySnapshot =
          await _firestore.collection('products').get();

      // Convert each document into a ProductModel and return the list
      final products = querySnapshot.docs.map((doc) {
        return ProductModel.fromEntity(
          ProductEntity.fromDocument(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        );
      }).toList();

      // Sort the products by name
      switch (sortType) {
        case 1:
          products.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 2:
          products.sort((a, b) => b.name.compareTo(a.name));
          break;
        case 3:
          products.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 4:
          products.sort((a, b) => b.price.compareTo(a.price));
          break;
      }

      return products;
    } catch (e) {
      return [];
    }
  }

  // Future <ProductModel> getProductById(productId) async{
  //   try {
  //     DocumentSnapshot productSnapshot = await _firestore.collection('products').doc(productId).get();
  //     if (productSnapshot.exists) {
  //       return ProductModel.fromEntity(ProductEntity.fromDocument(productSnapshot.data() as Map<String, dynamic>));
  //     } else {
  //       print('Product not found');
  //       return ProductModel.empty;
  //     }
  //   } catch (e) {
  //     print('Error fetching product: $e');
  //     return ProductModel.empty;
  //   }
  // }
}
