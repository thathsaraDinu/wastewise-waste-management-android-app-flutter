import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/controller/firestore_provider.dart';
import 'package:user_repository/user_repository.dart';

class ShoppingCartCard extends StatelessWidget {
  final CartItem cartItem;

  const ShoppingCartCard({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<FirebaseCartRepo>(context, listen: false);
    final user = Provider.of<FirebaseUserRepo>(context, listen: false);
    final userid = user.currentUser!.uid;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[900],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Text(
                'LKR ${cartItem.price}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Stack(children: [
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Delete Item"),
                              content: const Text(
                                "Are you sure you want to delete this item?",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 16),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    await _removeCartItem(cartService, userid,
                                        context); // Close the popup
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(
                                        color: Colors.redAccent, fontSize: 16),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the popup
                                  },
                                  child: const Text("Close",
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 16)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.network(
                          cartItem.imageUrl,
                          fit: BoxFit.cover,
                        ),
                        // Image widget for product image can go here
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItem.name,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Quantity: ${cartItem.quantity}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
                const Divider(
                  height: 20,
                  thickness: 1.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove,
                              color: Colors.redAccent, size: 30),
                          onPressed: () async {
                            await _removeSingleItem(
                                context, cartService, userid);
                            // Logic to decrease quantity
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.grey[400]!, width: 1),
                          ),
                          child: Text(
                            '${cartItem.quantity}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        IconButton(
                            icon: const Icon(Icons.add,
                                color: Colors.green, size: 30),
                            onPressed: () async {
                              // Call performFirestoreOperation method
                              await _addSingleItem(
                                  context, cartService, userid);

                              // Logic to increase quantity (if needed)
                            }),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Color : ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black45,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: cartItem.color,
                            border: Border.all(color: Colors.black38, width: 1),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addSingleItem(
      BuildContext context, FirebaseCartRepo cartService, String userId) async {
    final firestoreProvider =
        Provider.of<FirestoreProvider>(context, listen: false);

    try {
      await firestoreProvider.performFirestoreOperation(() async {
        // Perform the actual Firestore operation (addSingleItem)
        await cartService.addSingleItem(
            userId, cartItem.id, cartItem.unitPrice, cartItem.quantity);
      }, context);
    } catch (e) {
      // Handle any errors that occur during the Firestore operation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _removeSingleItem(
      BuildContext context, FirebaseCartRepo cartService, String userId) async {
    // Get the FirestoreProvider from the context
    final firestoreProvider =
        Provider.of<FirestoreProvider>(context, listen: false);

    // Call performFirestoreOperation method
    try {
      await firestoreProvider.performFirestoreOperation(() async {
        // Perform the actual Firestore operation (addSingleItem)
        await cartService.removeSingleItem(
            userId, cartItem.id, cartItem.unitPrice, cartItem.quantity);
      }, context);
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error removing item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _removeCartItem(
      FirebaseCartRepo cartService, String userid, BuildContext context) async {
    final firestoreProvider =
        Provider.of<FirestoreProvider>(context, listen: false);
    try {
      await firestoreProvider.performFirestoreOperation(() async {
        await cartService.removeCartItem(userid, cartItem.id);
      }, context);
    } on Exception {
      // TODO
    } finally {
      Navigator.of(context).pop();
    }
  }
}
