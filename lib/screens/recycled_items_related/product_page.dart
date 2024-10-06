import 'package:flutter/material.dart';
import 'package:waste_wise/common_widgets/custom_app_bar.dart';
import 'package:waste_wise/ui/views/product_images_list.dart';
import 'package:waste_wise/ui/views/product_details_view.dart';
import 'package:waste_wise/common_widgets/background_image_wrapper.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      height: 400,
                      child: ProductImages(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ProductDetails(parentContext: context),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 80,
            child: CustomAppBar(name: 'Details'),
          )
        ]),
      ),
    );
  }
}
