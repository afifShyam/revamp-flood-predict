import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shopping Page")),
      body: ListView(
        shrinkWrap: true,
        primary: false,
        padding: EdgeInsets.all(16),
        children: [
          Text("🛍️ Available Items", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemBuilder: (_, index) => _buildItem(context, '$index', "Laptop"),
              separatorBuilder: (_, __) => SizedBox(height: 10),
              itemCount: 100)
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, String id, String name) {
    return Card(
      elevation: 5,
      child: ListTile(
        title: Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text("Tap to view details"),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () async {
          final result = await context.push('/shopping/item/$id'); // Navigate to item page

          log('what is result: $result');
        },
      ),
    );
  }
}
