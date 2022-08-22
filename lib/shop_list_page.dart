import 'dart:convert';
import 'package:finding_bread_app/shop_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShopListPage extends StatefulWidget {
  String data;

  ShopListPage(this.data);

  @override
  State<ShopListPage> createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage> {
  List<Shop> _datas = [];
  var _text = "";

  void getShopList(query) async {
    String url = 'http://zepetto.synology.me:9090/api/shops?query=';
    final response = await http.get(Uri.parse(url + query));
    _text = utf8.decode(response.bodyBytes);

    var dataObjsJson = jsonDecode(_text)['data'] as List;
    List<Shop> parsedResponse =
    dataObjsJson.map((e) => Shop.fromJson(e)).toList();

    setState(() {
      _datas.clear();
      _datas.addAll(parsedResponse);
    });
  }

  @override
  void initState() {
    super.initState();
    getShopList(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buldBody());
  }

  _buildAppBar() {
    return AppBar(
      title: Text(widget.data),
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.send))],
      backgroundColor: Colors.brown,
    );
  }

  _buldBody() {
    return ListView.builder(
      itemCount: _datas.length,
      itemBuilder: (context, index) {
        final shop = _datas[index];
        return Card(
          child: Row(
            children: [
              SizedBox(
                  width: 80.0,
                  height: 80.0,
                  child: Image.network(
                      "https://img.freepik.com/premium-vector/hand-drawn-bread-and-bakery-vector-illustration-with-colorful_266639-1983.jpg?w=2000")
              ),
              SizedBox(
                width: 300,
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>ShopDetailPage(shop.id))
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.title,
                      ),
                      Text(
                        shop.address,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                          'review 28개'
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class Shop {
  final int id;
  final String title;
  final String link;
  final String address;

  // final String telephone;
  final String roadAddress;
  final int mapx;
  final int mapy;
  final String createdDate;
  final String modifiedDate;

  Shop({required this.id,
    required this.title,
    required this.link,
    required this.address,
    // required this.telephone,
    required this.roadAddress,
    required this.mapx,
    required this.mapy,
    required this.createdDate,
    required this.modifiedDate});

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'] as int,
      title: json['title'] as String,
      link: json['link'] as String,
      address: json['address'] as String,
      // telephone: json['telephone'] as String,
      roadAddress: json['roadAddress'] as String,
      mapx: json['mapx'] as int,
      mapy: json['mapy'] as int,
      createdDate: json['createdDate'] as String,
      modifiedDate: json['modifiedDate'] as String,
    );
  }

  @override
  String toString() {
    return '{${this.title}, ${this.address}';
  }
}
