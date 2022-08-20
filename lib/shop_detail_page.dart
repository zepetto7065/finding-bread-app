import 'package:flutter/material.dart';

class ShopDetailPage extends StatefulWidget {
  @override
  State<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Text('detail'),
            actions: [IconButton(onPressed: () {}, icon: Icon(Icons.send))],
            backgroundColor: Colors.brown,
      ),
      body: Text('detail'),
    );
  }
}
