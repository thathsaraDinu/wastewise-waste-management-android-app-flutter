import 'package:flutter/material.dart';

class ProductType extends StatelessWidget {
  final Map<String, dynamic> item;

  const ProductType({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 60,
        padding: const EdgeInsets.all(0.0),
        margin: const EdgeInsets.only(
          top: 5,
          bottom: 5,
          left: 10,
          right: 10,
        ),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CircleAvatar(
              radius: 33.0, // Adjust size accordingly
              backgroundImage:
                  AssetImage('assets/images/unsplash_OYYE4g-I5ZQ.png'),
            ),
            Text(
              item['type'],
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ));
  }
}
