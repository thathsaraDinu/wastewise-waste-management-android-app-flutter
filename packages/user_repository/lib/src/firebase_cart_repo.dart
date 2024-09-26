import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/src/entities/cart_entity.dart';
import 'models/models.dart';

class FirebaseCartRepo extends ChangeNotifier {
  final collection = FirebaseFirestore.instance.collection('users');

  Future<void> addCartItem(
      String userId,
      Color color,
      int amount,
      String productId,
      double price,
      String productname,
      String imageUrl,
      double unitPrice) async {
    try {
      final userCartRef = collection.doc(userId).collection('cart');

      // Query to find existing item with the same productId and color
      final existingItemsQuery = userCartRef
          .where('productId', isEqualTo: productId)
          .where('color', isEqualTo: color.value)
          .get();

      final existingItemsSnapshot = await existingItemsQuery;

      if (existingItemsSnapshot.docs.isNotEmpty) {
        // If an item exists, update the quantity and price
        final existingDoc = existingItemsSnapshot.docs.first;
        final existingData = existingDoc.data();

        final existingQuantity = (existingData['quantity'] as int?) ?? 0;
        final newQuantity = existingQuantity + amount;

        await existingDoc.reference.update({
          'quantity': newQuantity,
          'price': price * newQuantity, // Update price based on new quantity
        });
      } else {
        // If no item exists, add a new one
        final docRef = userCartRef.doc();

        // Get the auto-generated document ID
        final String docId = docRef.id;

        await docRef.set(CartItem(
          productId: productId,
          quantity: amount,
          color: color,
          price: price * amount,
          name: productname,
          imageUrl: imageUrl,
          unitPrice: unitPrice,
          date: Timestamp.fromDate(DateTime.now()),
          id: docId,
        ).toEntity().toDocument());
      }
    } on Exception catch (e) {
      throw Exception("Unable to add item. Please check your connection. $e");
    }
  }

  Stream<double> getTotalPrice(String userId) {
    final userCartRef = collection.doc(userId).collection('cart');

    return userCartRef.snapshots().map((snapshot) {
      double total = 0;

      for (var doc in snapshot.docs) {
        try {
          // Convert document data to CartItemEntity
          final cartItemEntity = CartItemEntity.fromDocument(doc.data());

          // Create CartItem from CartItemEntity
          final cartItem = CartItem.fromEntity(cartItemEntity);

          // Safeguard against missing or null fields
          double price = cartItem.price.toDouble();

          // Update total
          total += price;
        } catch (e) {
          if (kDebugMode) {
            print('Exception $e');
          }
        }
      }

      // Return total price
      return total;
    });
  }

  // Future<void> removeCartItem(String userId, String itemId) async {
  //   final userCartRef = collection
  //       .doc(userId)
  //       .collection('cart');

  //   try {
  //     // Print the itemId to check before deletion
  //     print('Attempting to remove item with ID: $itemId');

  //     // Fetch the document snapshot before deletion
  //     final docSnapshotBefore = await userCartRef.doc(itemId).get();
  //     if (docSnapshotBefore.exists) {
  //       // Print document details before deletion
  //       print('Item details before deletion: ${docSnapshotBefore.data()}');
  //     } else {
  //       print('Item with ID $itemId does not exist before deletion.');
  //       return; // Exit if the document does not exist
  //     }

  //     // Delete the cart item
  //     await userCartRef.doc(itemId).delete();

  //     print('Item with ID $itemId has been deleted.');

  //     // Verify if the item was deleted
  //     final docSnapshotAfter = await userCartRef.doc(itemId).get();
  //     if (!docSnapshotAfter.exists) {
  //       print('Item with ID $itemId has been successfully deleted.');
  //     } else {
  //       // Print document details if it still exists
  //       print(
  //           'Item with ID $itemId still exists after deletion attempt: ${docSnapshotAfter.data()}');
  //     }
  //   } catch (e) {
  //     print('Error removing item with ID $itemId: $e');
  //   }
  // }

  Future<void> removeCartItem(String userId, String itemId) async {
    final userCartRef = collection.doc(userId).collection('cart');

    try {
      // Delete the cart item from Firestore
      await userCartRef.doc(itemId).delete();
      print("Cart item removed: $itemId");
    } catch (e) {
      print("Error removing cart item: $e");
      throw Exception("Failed to remove item from cart");
    }
  }

  Future<void> updateCartItem(
      String userId, CartItem item, String itemId) async {
    final userCartRef = collection.doc(userId).collection('cart');
    await userCartRef.doc(itemId).update(item.toEntity().toDocument());
  }

//getitems
  Stream<List<CartItem>> getCartItems(String userId) {
    final userCartRef = collection.doc(userId).collection('cart');

    // Fetch cart items directly from the server
    return userCartRef
        .snapshots(includeMetadataChanges: false) // Real-time updates
        .map((snapshot) {
      final cartItems = snapshot.docs.map((doc) {
        return CartItem.fromEntity(
            CartItemEntity.fromDocument(doc.data(), doc.id));
      }).toList();

      // Sort the cart items by date in descending order
      cartItems.sort((a, b) {
        DateTime dateA = (a.date).toDate();
        DateTime dateB = (b.date).toDate();
        return dateB.compareTo(dateA); // Recent items first
      });

      return cartItems;
    }).handleError((error) {
      print('Error fetching cart items: $error');
      throw Exception('Failed to fetch cart items from the server.');
    });
  }

  Future<void> addSingleItem(
      String userId, String itemId, double unitPrice, int quantity) async {
    final userCartRef = collection.doc(userId).collection('cart');
    final docRef = userCartRef.doc(itemId);

    try {
      // Decrease the quantity and price
      await docRef.update({
        'quantity': FieldValue.increment(1),
        'price': FieldValue.increment(
            unitPrice), // Decrement total price by unit price
      });

      // If the quantity is 1, delete the document
    } catch (e) {
      print('Error updating item: $e');
      throw Exception("Unable to add item");
    }
  }

  Future<void> removeSingleItem(
      String userId, String itemId, double unitPrice, int quantity) async {
    final userCartRef = collection.doc(userId).collection('cart');
    final docRef = userCartRef.doc(itemId);

    try {
      if (quantity > 1) {
        // Decrease the quantity and price
        await docRef.update({
          'quantity': FieldValue.increment(-1),
          'price': FieldValue.increment(
              -unitPrice), // Decrement total price by unit price
        });
      } else {
        // If the quantity is 1, delete the document
        await docRef.delete();
      }
    } catch (e) {
      print('Error updating item: $e');
      throw Exception("Unable to remove item");
    }
  }

  // Future<void> removeSingleItem(String userId, String itemId) async {
  //   final userCartRef = collection.doc(userId).collection('cart');
  //   final docRef = userCartRef.doc(itemId);

  //   try {
  //     final docSnapshot = await docRef
  //         .get(GetOptions(source: Source.server)); // Fetch from the server

  //     if (docSnapshot.exists) {
  //       final data = docSnapshot.data() as Map<String, dynamic>;
  //       final int currentQuantity = data['quantity'] ?? 0;
  //       final double unitPrice =
  //           data['unitPrice'] ?? 0.0; // Fetch the unit price

  //       if (currentQuantity > 1) {
  //         // Decrease the quantity and price
  //         await docRef.update({
  //           'quantity': FieldValue.increment(-1),
  //           'price': FieldValue.increment(
  //               -unitPrice), // Decrement total price by unit price
  //         });
  //       } else {
  //         // If the quantity is 1, delete the document
  //         await docRef.delete();
  //       }
  //     }
  //   } catch (e) {
  //     print('Error removing item: $e');
  //     throw Exception("Unable to remove item");
  //   }
  // }

  Stream<int> getCartItemCount(String userId) {
    final userCartRef = collection.doc(userId).collection('cart');

    // Return a stream of the cart item count from the server only
    return userCartRef.snapshots().asyncMap((snapshot) async {
      try {
        // Force the request to only retrieve from the server
        final freshSnapshot = await userCartRef.get();

        return freshSnapshot.size; // Return the actual size
      } catch (e) {
        // If an error occurs or it's from cache, return 0
        if (kDebugMode) {
          print('Error fetching data: $e');
        }
        return 0; // Return 0 in case of error or cache fetch
      }
    });
  }
}
