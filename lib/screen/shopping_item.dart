import 'package:flood_prediction_fyp/routes/pop_result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShoppingItemScreen extends StatelessWidget {
  final String itemId;

  const ShoppingItemScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return BackResultHandler(
      onBackWithResult: () => 'from shopping item',
      child: Scaffold(
        appBar: AppBar(
          title: Text("Item Details"),
          automaticallyImplyLeading: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              // onPressed: () => context.go('/shopping'),
              onPressed: () {
                context.pop('le');
              }),
        ),
        body: Center(
          child: Text(
            "🛍️ Viewing details for Item ID: $itemId",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
