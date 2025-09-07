import 'package:flood_prediction_fyp/routes/pop_result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShoppingItemScreen extends StatelessWidget {
  final String itemId;

  const ShoppingItemScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return BackResultHandler(
      onBackWithResult: () => 'from shopping item $itemId',
      child: Scaffold(
        appBar: AppBar(
          title: Text("Item Details"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.pop('from shopping item $itemId');
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("🛍️ Viewing details for Item ID: $itemId"),
              ElevatedButton(
                onPressed: () {
                  context.pop('Added item $itemId to cart');
                },
                child: Text('Add to Cart & Go Back'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pop('Viewed item $itemId');
                },
                child: Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
