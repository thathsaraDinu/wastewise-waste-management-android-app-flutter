import 'package:flutter/material.dart';
import 'package:products_repository/products_repository.dart';

class ShoppingBagCard extends StatefulWidget {
  final ProductModel productItem;
  final int quantity;
  final Color color;

  const ShoppingBagCard({
    super.key,
    required this.productItem,
    required this.quantity,
    required this.color,
  });

  @override
  State<ShoppingBagCard> createState() => _ShoppingBagCardState();
}

class _ShoppingBagCardState extends State<ShoppingBagCard> {
  late Color selectedcolor;

  @override
  void initState() {
    super.initState();
    selectedcolor = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enlarged Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image(
                image: NetworkImage(widget.productItem.imageUrls[0]),
                fit: BoxFit.cover,
                height: 180, // Increase image height
                width: double.infinity, // Make the image full-width
              ),
            ),
            const SizedBox(height: 12.0),

            // Product Name
            Text(
              widget.productItem.name, // Display the product's name
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8.0),
            // Quantity
            Text(
              'Quantity: ${widget.quantity}', // Display the quantity
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8.0),
            // Color (Now positioned below Quantity)
            Row(
              children: [
                Text(
                  'Selected Color: ',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                  ),
                ),
                InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Select Color'),
                        content: SingleChildScrollView(
                          child: Builder(
                            builder: (context) => Row(
                              children: widget.productItem.colors.map((color) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedcolor =
                                            color; // Update selected color
                                      });
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: Container(
                                      height: color == selectedcolor ? 35 : 28,
                                      width: color == selectedcolor ? 35 : 28,
                                      decoration: BoxDecoration(
                                        color: color,
                                        border: Border.all(
                                          color: color == selectedcolor
                                              ? darkenColor(color)
                                              : Colors.black38,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),

                                      child: selectedcolor == color
                                          ? const Icon(Icons.check,
                                              color: Colors
                                                  .white) // Show checkmark if selected
                                          : null, // No checkmark if not selected
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              // Save selected color and close the dialog
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Cancel the selection and close the dialog
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      color: selectedcolor,
                      border: Border.all(color: darkenColor(selectedcolor)),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    // No checkmark if not selected
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Color darkenColor(Color color, [double factor = 0.3]) {
  assert(factor >= 0 && factor <= 1, 'Factor should be between 0 and 1');

  // Convert the color to HSL (Hue, Saturation, Lightness)
  final hslColor = HSLColor.fromColor(color);

  // Darken the color by reducing the lightness
  final darkenedHsl =
      hslColor.withLightness((hslColor.lightness - factor).clamp(0.0, 1.0));

  // Return the color with reduced lightness, which makes it appear darker
  return darkenedHsl.toColor();
}
