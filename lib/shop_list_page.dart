import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShopListPage extends StatefulWidget {
  String data;

  ShopListPage(this.data);

  // final String data;
  //
  // ShopListPage(this.data);

  @override
  State<ShopListPage> createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage> {
  late List<Shop> shopList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Text('123'),
                  Text('123'),
                  Text('123'),
                  Text('123'),
                  Text('123'),
                ],
              ),
            ),
          )
        ));
  }

  _buildAppBar() {
    return AppBar(
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.send))],
    );
  }

  Future<List<Shop>> getShopList(query) async {
    String url = 'http://zepetto.synology.me:9090/api/shops?query=';
    var response = await http.get(Uri.parse(url + '금천'));
    var shopList = (jsonDecode(response.body)['data'] as List)
        .map((i) => Shop.fromJson(i))
        .toList();
    return shopList;
  }
}

class Shop {
  final int id;
  final String title;
  final String link;
  final String address;
  final String telephone;
  final String roadAddress;
  final String mapx;
  final String mapy;
  final String createdDate;
  final String modifiedDate;

  Shop({
    required this.id,
    required this.title,
    required this.link,
    required this.address,
    required this.telephone,
    required this.roadAddress,
    required this.mapx,
    required this.mapy,
    required this.createdDate,
    required this.modifiedDate
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'] as int,
      title: json['title'] as String,
      link: json['link'] as String,
      address: json['address'] as String,
      telephone: json['telephone'] as String,
      roadAddress: json['roadAddress'] as String,
      mapx: json['mapx'] as String,
      mapy: json['mapy'] as String,
      createdDate: json['createdDate'] as String,
      modifiedDate: json['modifiedDate'] as String,
    );
  }

}
