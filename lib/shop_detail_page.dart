import 'package:finding_bread_app/review_write_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShopDetailPage extends StatefulWidget {
  int id;

  ShopDetailPage(this.id);

  @override
  State<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  Future<Shop>? shop;
  String title = "";

  Future<Shop> getShop(shopId) async {
    String url = 'http://zepetto.synology.me:9090/api/shops/detail?shopId=';
    final response = await http.get(Uri.parse(url + shopId.toString()));
    var convertingData = utf8.decode(response.bodyBytes);
    var _data = jsonDecode(convertingData)['data'];

    if (response.statusCode == 200) {
      return Shop.fromJson(_data);
    } else {
      throw Exception('Failed to load Shop');
    }
  }

  @override
  void initState() {
    super.initState();
    shop = getShop(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Shop>(
      future: shop,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          title = snapshot.data!.title.toString();
          return buildArea(snapshot);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error} 에러!!');
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget buildArea(snapshot) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.send))],
        backgroundColor: Colors.brown,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
                width: 250.0,
                height: 250.0,
                child: Image.network(
                    "https://img.freepik.com/premium-vector/hand-drawn-bread-and-bakery-vector-illustration-with-colorful_266639-1983.jpg?w=2000")),
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          Text(' 주소  ' + snapshot.data!.address.toString(),
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w200,
              )),
          Padding(padding: EdgeInsets.all(4.0)),
          Text(' 연락처  01091085420'),
          Padding(padding: EdgeInsets.all(4.0)),
          Text(' 영업상황  영업중/오늘 휴무/영업전/알수없음'),
          Padding(padding: EdgeInsets.all(8.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(' 방문후기',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w200,
                  )
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.create),
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewWritePage(widget.id)));
                },
                label: Text('후기작성'),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  child: Row(
                    children: [
                      SizedBox(
                          width: 80.0,
                          height: 80.0,
                          child: Image.network(
                              "https://img.freepik.com/premium-vector/hand-drawn-bread-and-bakery-vector-illustration-with-colorful_266639-1983.jpg?w=2000")
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(' 맛 : 정말 맛있어요'),
                          Text(' 서비스 : 그냥그래요'),
                          Text(' 재방문 : 네!'),
                          Text(' 최애빵 : 소금빵'),
                          Text(' 간략후기 : 아주 맛있는 맛있에요'),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class Shop {
  final int id;
  final String title;
  final String link;
  final String address;

  final String? telephone;
  final String roadAddress;
  final int mapx;
  final int mapy;
  final String createdDate;
  final String modifiedDate;

  Shop(
      {required this.id,
      required this.title,
      required this.link,
      required this.address,
      this.telephone,
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
      telephone: json['telephone'] as String?,
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
