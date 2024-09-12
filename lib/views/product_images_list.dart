import 'package:flutter/material.dart';
import 'package:shoppingapp/models/dummy_colors_product_images.dart';

class ProductImages extends StatelessWidget {
  const ProductImages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemBuilder: (context, index) {
        Color color = colors[index % colors.length];
        return Stack(children: [
          Container(
            width: screenWidth,
            decoration: BoxDecoration(
              color: color,
            ),
          ),
          
        ]);
      },
      scrollDirection: Axis.horizontal,
      itemCount: 10,
    );
  }
}
