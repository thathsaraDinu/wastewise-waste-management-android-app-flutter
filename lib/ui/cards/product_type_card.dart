import 'package:flutter/material.dart';

class ProductTypeCard extends StatefulWidget {
  final Map<String, dynamic> item;

  final int selectedIndex;
  final int index;

  const ProductTypeCard(
      {super.key,
      required this.item,
      required this.selectedIndex,
      required this.index});

  @override
  State<ProductTypeCard> createState() => _ProductTypeCardState();
}

class _ProductTypeCardState extends State<ProductTypeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 80,
        padding: const EdgeInsets.only(
          top: 5,
          bottom: 5,
          left: 10,
          right: 10,
        ),
        decoration: BoxDecoration(
            color: widget.selectedIndex == widget.index
                ? Colors.green[200]
                : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 33.0, // Adjust size accordingly
              backgroundImage: AssetImage(
                  'assets/images/${widget.item['image']}'), // Load image
            ),
            Text(
              widget.item['type'],
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
