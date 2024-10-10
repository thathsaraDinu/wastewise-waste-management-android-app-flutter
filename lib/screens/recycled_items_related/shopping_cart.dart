import 'package:flutter/material.dart';
import 'package:waste_wise/common_widgets/background_image_wrapper.dart';
import 'package:waste_wise/common_widgets/custom_app_bar.dart';
import 'package:waste_wise/ui/cards/address_card.dart';
import 'package:waste_wise/ui/cards/shopping_cart_card.dart';
import 'package:provider/provider.dart';
import 'package:user_repository/user_repository.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<FirebaseCartRepo>(context);
    final user = Provider.of<FirebaseUserRepo>(context);
    Stream<List<CartItem>> cart = cartItems.getCartItems(user.currentUser!.uid);

    return BackgroundImageWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(name: 'Shopping cart'),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 20.0,
                  bottom: 0.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const AddressCard(),
                      const SizedBox(height: 10),
                      StreamBuilder<List<CartItem>>(
                        stream: cart,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('An Error occurred'));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('Your cart is empty.'));
                          }

                          final cartItems = snapshot.data!;
                          return Column(
                            children: cartItems.map((cartItem) {
                              return ShoppingCartCard(cartItem: cartItem);
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(
                          height: 10), // To add some space at the bottom
                    ],
                  ),
                ),
              ),
            ),
            // Positioned Total Amount at the bottom
            StreamBuilder<double>(
              stream: cartItems.getTotalPrice(user.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('0.0'));
                }
                if (!snapshot.hasData) {
                  return const Center(
                      child: Text('Total amount not available'));
                }
                final totalAmount = snapshot.data!;
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '$totalAmount LKR',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/checkout',
                              arguments: totalAmount);
                          // Proceed to checkout
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 12.0),
                          elevation: 5.0,
                        ),
                        child: const Text(
                          'Proceed to checkout',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
