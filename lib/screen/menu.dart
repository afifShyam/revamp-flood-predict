import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu Page")),
      body: Center(child: Text("📖 Welcome to the Menu Page", style: TextStyle(fontSize: 20))),
    );
  }
}
