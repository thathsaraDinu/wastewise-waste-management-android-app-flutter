import 'package:flutter/material.dart';
import 'package:shoppingapp/common/custom_app_bar.dart';
import 'package:shoppingapp/views/product_images_list.dart';
import 'package:shoppingapp/views/product_details_view.dart';
import 'package:shoppingapp/common/background_image.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToWidth(double width) {
    _scrollController.animateTo(
      width,
      duration:
          const Duration(milliseconds: 500), // Duration of the scroll animation
      curve: Curves.easeInOut, // Curve of the scroll animation
    );
  }

  @override
  Widget build(BuildContext context) {
    return const BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        
        body: Stack(
          children: [Positioned.fill(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 400,
                      child: ProductImages(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ProductDetails(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 80,
            child: CustomAppBar(name: 'Details'),
          )]
        ),
      ),
    );
  }
}
