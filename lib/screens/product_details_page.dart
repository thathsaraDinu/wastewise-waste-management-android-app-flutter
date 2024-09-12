import 'package:flutter/material.dart';
import 'package:shoppingapp/common/custom_app_bar.dart';
import 'package:shoppingapp/views/product_images_list.dart';
import 'package:shoppingapp/views/product_details_view.dart';
import 'package:shoppingapp/common/background_image.dart';

class ProductPage extends StatelessWidget {
   const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(name: 'Details'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(children: [
                  const SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: ProductImages(),
                  ),
                  Positioned(
                    bottom: 125.0,
                    right: 20.0,
                    child: FloatingActionButton(
                      
                      splashColor: Colors.white,
                      backgroundColor: const Color.fromARGB(150, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      
                      onPressed: () {
                        // Add your action here
                      },
                      child: const Icon(Icons.navigate_next),
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 10,
                ),
                 const ProductDetails(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


