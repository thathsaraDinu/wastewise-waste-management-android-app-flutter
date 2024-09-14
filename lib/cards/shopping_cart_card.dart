import 'package:flutter/material.dart';
import 'package:shoppingapp/models/cart_model.dart';
import 'package:provider/provider.dart';

class ShoppingCartCard extends StatefulWidget {
  final int index;
  const ShoppingCartCard({super.key, required this.index});

  @override
  State<ShoppingCartCard> createState() => _ShoppingCartCardState();
}

class _ShoppingCartCardState extends State<ShoppingCartCard> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    final cartItemsList = cart.cartItems.map((item) {
      return {
        'name': item['product']['name'],
        'quantity': item['quantity'],
        'color': item['color'],
      };
    }).toList();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                // Image or product color representation
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: cartItemsList[widget.index]['color'],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 16),
                // Product name and quantity
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItemsList[widget.index]['name'],
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
                        'Quantity: ${cartItemsList[widget.index]['quantity']}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Delete button
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    setState(() {
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
                                onPressed: () {
                                  cart.removeItemFromCart(widget.index);
                                  Navigator.of(context)
                                      .pop(); // Close the popup
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
                    });
                  },
                ),
              ],
            ),
            const Divider(
              height: 20,
              thickness: 1.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Decrease quantity button
                    IconButton(
                      icon: const Icon(Icons.remove,
                          color: Colors.redAccent, size: 30),
                      onPressed: () {
                        setState(() {
                          cart.removeSingleItem(widget.index);
                        });
                      },
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[400]!, width: 1),
                      ),
                      child: Text(
                        cartItemsList[widget.index]['quantity'].toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    IconButton(
                      icon:
                          const Icon(Icons.add, color: Colors.green, size: 30),
                      onPressed: () {
                        setState(() {
                          cart.addSingleItem(widget.index);
                        });
                      },
                    ),
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
                    const SizedBox(
                      width: 8,
                    ),
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: cartItemsList[widget.index]['color'],
                        border: Border.all(
                          color: Colors.black38,
                          width: 1,
                        ),
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
    );
  }
}
