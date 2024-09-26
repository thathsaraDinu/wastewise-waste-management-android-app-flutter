import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:products_repository/products_repository.dart';
import 'package:shoppingapp/controller/dependency_injection.dart';
import 'package:shoppingapp/views/product_cards_grid.dart';
import 'package:shoppingapp/views/product_types_list.dart';
import 'package:shoppingapp/common/custom_app_bar.dart';
import 'package:provider/provider.dart';

class RecycledItems extends StatefulWidget {
  const RecycledItems({super.key});

  @override
  State<RecycledItems> createState() => RecycledItemsState();
}

class RecycledItemsState extends State<RecycledItems> {
  final FocusNode _focusNode = FocusNode();
  int selectedIndex = 0;
  List<ProductModel> _products = [];
  bool isLoading = false;
  int sortingType = 0;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    DependencyInjection.init();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure the TextField is unfocused when the widget is first built
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    });
  }

  Future<void> _fetchProducts() async {
    try {
      setState(() {
        isLoading = true;
      });
      final productService =
          Provider.of<ProductService>(context, listen: false);
      final products = await productService.getAllProducts(sortingType);
      setState(() {
        _products = products;
        isLoading = false;
      });
    } on Exception catch (e) {
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print('Error: $e');
      }
    }
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
                      Material(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.white,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Sort By'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        selected:
                                            sortingType == 0 ? true : false,
                                        selectedColor: Colors.green[800],
                                        title: const Text('Name: A to Z'),
                                        onTap: () {
                                          setState(() {
                                            sortingType = 0;
                                          });
                                          _fetchProducts();
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        selected:
                                            sortingType == 2 ? true : false,
                                        selectedColor: Colors.green[800],
                                        title: const Text('Name: Z to A'),
                                        onTap: () {
                                          setState(() {
                                            sortingType = 2;
                                          });
                                          _fetchProducts();

                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        selected:
                                            sortingType == 3 ? true : false,
                                        selectedColor: Colors.green[800],
                                        title: const Text('Price: Low to High'),
                                        onTap: () {
                                          setState(() {
                                            sortingType = 3;
                                          });
                                          _fetchProducts();
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        selected:
                                            sortingType == 4 ? true : false,
                                        selectedColor: Colors.green[800],
                                        title: const Text('Price: High to Low'),
                                        onTap: () {
                                          setState(() {
                                            sortingType = 4;
                                          });
                                          _fetchProducts();

                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
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
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: isLoading
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : productslistgrid(_products),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
