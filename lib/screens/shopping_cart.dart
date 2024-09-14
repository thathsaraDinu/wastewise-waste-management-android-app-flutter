import 'package:flutter/material.dart';
import 'package:shoppingapp/common/custom_app_bar.dart';
import 'package:shoppingapp/models/cart_model.dart';
import 'package:shoppingapp/views/shopping_cart_view.dart';
import 'package:provider/provider.dart';

class ShoppingCart extends StatefulWidget{
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();

}

class _ShoppingCartState extends State<ShoppingCart>{
  
  @override
  Widget build(BuildContext context) {

      final cart = Provider.of<CartModel>(context);

    // TODO: implement build
    return Scaffold(
      appBar: CustomAppBar(name: 'Shopping cart',),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: shoppingcartview(cart),
        ),
      ),
    );
  }
}