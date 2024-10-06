import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_repository/user_repository.dart'; // Make sure you are using Provider for state management

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize; // Implement preferredSize

  final String name;

  const CustomAppBar({super.key, required this.name})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Fetch the cart item count using Provider
    final user = Provider.of<FirebaseUserRepo>(context).currentUser;
    final cartItemCount =
        Provider.of<FirebaseCartRepo>(context).getCartItemCount(user!.uid);

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: AppBar(
          leading: name == 'WasteWise'
              ? null
              : Container(
                  margin: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
                  child: IconButton(
                    iconSize: 20,
                    icon: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: name == 'Details'
                              ? Colors.white
                              : Colors.green[900],
                        )), // Custom icon
                    onPressed: () {
                      Navigator.of(context)
                          .pop(); // Custom action for the back button
                    },
                  ),
                ),
          backgroundColor: name == 'Details' ? Colors.black38 : Colors.white10,
          toolbarHeight: 100,
          actionsIconTheme: IconThemeData(
              color: name == 'Details' ? Colors.white : Colors.green[900],
              size: 30),
          foregroundColor: Colors.black,
          title: Row(
            children: [
              Text(name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: name == 'Details'
                          ? Colors.white
                          : Colors.green[900])),
            ],
          ),
          actions: [
            if (name == 'WasteWise' || name == 'Details')
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.pushNamed(context, '/shoppingcart');
                      },
                    ),
                    // Only show the badge if items exist in cart
                    StreamBuilder<int>(
                        stream: cartItemCount,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox
                                .shrink(); // Show a loading indicator
                          } else if (snapshot.hasError) {
                            return const Center(child: SizedBox.shrink());
                          } else if (!snapshot.hasData) {
                            return const SizedBox
                                .shrink(); // Handle case where no data is returned
                          }
                          final cartItemCount = snapshot.data!;
                          return cartItemCount > 0
                              ? Positioned(
                                  right: 5,
                                  top: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 20,
                                      minHeight: 20,
                                    ),
                                    child: Center(
                                      child: Text(
                                        cartItemCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink();
                        }),
                  ],
                ),
              ),
          ],
        ));
  }
}
