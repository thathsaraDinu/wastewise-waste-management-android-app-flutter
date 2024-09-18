import 'package:flutter/material.dart';
import 'package:shoppingapp/views/product_cards_grid.dart';
import 'package:shoppingapp/views/product_types_list.dart';
import 'package:shoppingapp/common/custom_app_bar.dart';

class RecycledItems extends StatefulWidget {
  const RecycledItems({super.key});

  @override
  State<RecycledItems> createState() => RecycledItemsState();
}

class RecycledItemsState extends State<RecycledItems> {
  final FocusNode _focusNode = FocusNode();
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure the TextField is unfocused when the widget is first built
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const CustomAppBar(name: 'WasteWise'),
      body: GestureDetector(
        onTap: () {
          _focusNode.unfocus(); // Unfocus TextField when tapping outside
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    focusNode: _focusNode,
                    autofocus: false,
                    decoration: InputDecoration(
                      prefixIconColor: const Color.fromARGB(255, 174, 174, 174),
                      contentPadding: const EdgeInsets.all(8.0),
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            width: 2.0,
                            color: Color.fromARGB(255, 174, 174, 174)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            width: 2.0,
                            color: Color.fromARGB(255, 124, 124, 124)),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search Recycled Products',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 174, 174, 174),
                        fontSize: 16.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  height: 100,
                  child: producttypeslist(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'All Products',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        child: const Row(
                          children: [
                            Text('Sort'),
                            SizedBox(width: 5),
                            Icon(
                              Icons.sort,
                              size: 20.0,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: productslistgrid(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
