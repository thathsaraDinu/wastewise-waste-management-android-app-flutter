import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int itemAmount = 1;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> item =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['name'],
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            '${item['price']} LKR',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ratingstars(item),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            item['longDescription'],
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          sizeselectarea(),
          colorselectarea(), //color select
          buybuttons(),
        ],
      ),
    );
  }

  Column colorselectarea() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Color',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.blue[100],
                            border: Border.all(
                              color: Colors.blue,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            itemcountarea(),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  Column sizeselectarea() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Size',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Container(
                height: 35,
                width: 50,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    color: Colors.green[100],
                    border: Border.all(
                      color: Colors.green,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text(
                    '6',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  Container itemcountarea() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(50)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              if (itemAmount > 1) {
                setState(() {
                  itemAmount--;
                });
              }
            },
            child: amountbuttons('remove'),
          ),
          const SizedBox(
            width: 15.0,
          ),
          SizedBox(
            width: 30,
            child: Text(
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              '$itemAmount',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            width: 15.0,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              setState(() {
                itemAmount++;
              });
            },
            child: amountbuttons('add'),
          ),
        ],
      ),
    );
  }

  Container amountbuttons(String name) {
    IconData icon;
    // Determine the icon based on the name
    if (name == 'add') {
      icon = Icons.add;
    } else if (name == 'remove') {
      icon = Icons.remove;
    } else {
      throw Exception(
          'Invalid icon name'); // Handle cases where the name isn't "add" or "remove"
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        icon, // Use the determined icon here
        size: 30.0,
        color: Colors.black,
      ),
    );
  }

  Column buybuttons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          ),
          onPressed: () {},
          child: const Text('Add to Cart', style: TextStyle(fontSize: 18.0)),
        ),
        const SizedBox(
          height: 10.0,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          ),
          onPressed: () {},
          child: const Text('Buy Now', style: TextStyle(fontSize: 18.0)),
        ),
      ],
    );
  }

  RatingStars ratingstars(Map<String, dynamic> item) {
    return RatingStars(
      value: item['rating'],
      starBuilder: (index, color) => Icon(
        size: 25,
        Icons.star,
        color: color,
      ),
      starCount: 5,
      starSize: 25,
      maxValue: 5,
      starSpacing: 1,
      maxValueVisibility: true,
      valueLabelVisibility: true,
      valueLabelColor: const Color.fromARGB(255, 113, 113, 113),
      animationDuration: const Duration(milliseconds: 1000),
      valueLabelPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
      valueLabelMargin: const EdgeInsets.only(right: 8),
      starOffColor: const Color(0xffe7e8ea),
      starColor: const Color.fromARGB(255, 255, 230, 0),
    );
  }
}
