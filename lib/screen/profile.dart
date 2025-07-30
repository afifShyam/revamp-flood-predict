import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Page")),
      body: Center(child: Text("👤 Welcome to the Profile Page", style: TextStyle(fontSize: 20))),
    );
  }
}
