import 'dart:convert';
import 'dart:io';
import 'package:finding_bread_app/home/shop_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class ShopListPage extends StatefulWidget {
  String data;

  ShopListPage(this.data);

  @override
  State<ShopListPage> createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  List<Shop>? shopList;

  Future<List<Shop>> getShopList(query) async {
    String url = 'http://zepetto.synology.me:9090/api/shops?query=';
    final response = await http.get(Uri.parse(url + query));
    var _text = utf8.decode(response.bodyBytes);

    var dataObjsJson = jsonDecode(_text)['data'] as List;
    return dataObjsJson.map((e) => Shop.fromJson(e)).toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Shop>>(
        future: getShopList(widget.data),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            shopList = shopList ?? snapshot.data!;
            return _build();
          } else if (snapshot.hasError) {
            return Text('${snapshot.error} 에러!!');
          }
          return SpinKitWave(
            itemBuilder: (BuildContext context, int index){
              return DecoratedBox(decoration: BoxDecoration(
                color: index.isEven ? Colors.brown : Colors.white
              ));
            },
          );
        },
    );
  }

  Widget _build() {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.data),
          backgroundColor: Colors.brown,
        ),
        body: _buldBody()
    );
  }


  _buldBody() {
    if(shopList!.length == 0){
      return Center(
          child: Text(
              '검색 결과가 없습니다. 😋',
            style: TextStyle(fontSize: 25.0),
          )
      );
    }

    return RefreshIndicator(
      key: refreshKey,
      onRefresh: refreshList,
      child: ListView.builder(
        itemCount: shopList!.length,
        itemBuilder: (context, index) {
          final item = shopList![index];
          return Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 1)
            ),
            child: Row(
              children: [
                SizedBox(
                    width: 70.0,
                    height: 70.0,
                    child: Image.asset(
                        'images/shop.png',
                    )
                ),
                SizedBox(
                  width: 220,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>ShopDetailPage(item.id, null))
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                        ),
                        Text(
                          item.address,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                            '💬${item.reviewsCount}개'
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0));

    String url = 'http://zepetto.synology.me:9090/api/shops?query=';
    final response = await http.get(Uri.parse(url + widget.data));
    var _text = utf8.decode(response.bodyBytes);

    var dataObjsJson = jsonDecode(_text)['data'] as List;
    shopList = dataObjsJson.map((e) => Shop.fromJson(e)).toList();

    return;
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

  final int? reviewsCount;

  Shop({required this.id,
    required this.title,
    required this.link,
    required this.address,
    // required this.telephone,
    required this.roadAddress,
    required this.mapx,
    required this.mapy,
    required this.createdDate,
    required this.modifiedDate,
    required this.reviewsCount});

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['shopId'] as int,
      title: json['title'] as String,
      link: json['link'] as String,
      address: json['address'] as String,
      // telephone: json['telephone'] as String,
      roadAddress: json['roadAddress'] as String,
      mapx: json['mapx'] as int,
      mapy: json['mapy'] as int,
      createdDate: json['createdDate'] as String,
      modifiedDate: json['modifiedDate'] as String,
      reviewsCount: json['reviewsCount'] as int
    );
  }

  @override
  String toString() {
    return '{${this.title}, ${this.address}';
  }
}
