import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:products_repository/products_repository.dart';

class ProductCard extends StatelessWidget {
  final ProductModel item;

  const ProductCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Material(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            FocusScope.of(context).unfocus();
            Navigator.pushNamed(context, '/productpage', arguments: item);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                child: Hero(
                  tag: 'productimage${item.imageUrls[0]}',
                  child: Image(
                    image: NetworkImage(item.imageUrls[0]),
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.5,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // Handle overflow
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.description,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis, // Handle overflow
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${item.price} LKR',
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          RatingStars(
                            value: item.rating,
                            starBuilder: (index, color) => Icon(
                              size: 16,
                              Icons.star,
                              color: color,
                            ),
                            starCount: 5,
                            starSize: 16,
                            maxValue: 5,
                            starSpacing: 1,
                            maxValueVisibility: false,
                            valueLabelVisibility: false,
                            animationDuration:
                                const Duration(milliseconds: 1000),
                            starOffColor: const Color(0xffe7e8ea),
                            starColor: const Color.fromARGB(255, 255, 230, 0),
                          ),
                          const SizedBox(width: 5),
                          Text('${item.ratingCount}')
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ),
      );
    });
  }
}
