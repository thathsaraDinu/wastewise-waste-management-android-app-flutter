import 'package:flutter/material.dart';
import 'package:products_repository/products_repository.dart';
import 'package:waste_wise/common_widgets/background_image_wrapper.dart';
import 'package:waste_wise/common_widgets/custom_app_bar.dart';
import 'package:waste_wise/ui/cards/address_card.dart';
import 'package:waste_wise/ui/cards/shopping_bag_card.dart';

class ShoppingBagPage extends StatefulWidget {
  const ShoppingBagPage({super.key});

  @override
  _ShoppingBagPageState createState() => _ShoppingBagPageState();
}

class _ShoppingBagPageState extends State<ShoppingBagPage> {
  int quantity = 1;
  double singlePrice = 0.0;
  double totalPrice = 0.0;
  ProductModel item = ProductModel.empty;
  Color color = Colors.white;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    item = arguments['item']; // First argument
    singlePrice = item.price; // Single price from item
    quantity = arguments['quantity']; // Set initial quantity from arguments
    totalPrice = singlePrice * quantity; // Calculate total price
    color = arguments['color']; // Set color from arguments
  }

  void updateTotalPrice() {
    setState(() {
      totalPrice = singlePrice * quantity; // Recalculate totalPrice
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(
          name: 'Shopping Bag',
        ),
        body: Stack(
          children: [
            // Dynamic bottom padding for footer space
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery address section
                  const AddressCard(),
                  const SizedBox(height: 10),

                  const SizedBox(height: 10),
                  ShoppingBagCard(
                    color: color,
                    productItem: item,
                    quantity: quantity,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Single Price",
                          style: TextStyle(fontSize: 16)),
                      Text("${singlePrice.toStringAsFixed(2)} LKR",
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Number of Pieces",
                          style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (quantity > 1) {
                                  quantity--;
                                  updateTotalPrice(); // Update total price
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              size: 30,
                            ),
                          ),
                          Text(
                            "$quantity",
                            style: const TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                quantity++;
                                updateTotalPrice(); // Update total price
                              });
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Order Total", style: TextStyle(fontSize: 16)),
                      Text(
                        "${totalPrice.toStringAsFixed(2)} LKR",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: 80), // Extra space for the fixed footer
                ],
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${totalPrice.toStringAsFixed(2)} LKR",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/checkout',
                            arguments: totalPrice);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        elevation: 5.0,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 12.0),
                      ),
                      child: const Text(
                        "Checkout",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
