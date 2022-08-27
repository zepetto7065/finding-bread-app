import 'package:finding_bread_app/review_write_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
  List<Review> reviews = [];

  Future<Shop> getShop(shopId) async {
    String url = 'http://zepetto.synology.me:9090/api/shops/';
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
          reviews = snapshot.data!.reviews;
          title = snapshot.data!.title.toString();
          return buildArea(snapshot);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error} 에러!!');
        }
        return SizedBox(
            height: 10.0,
            width: 10.0,
            child: CircularProgressIndicator()
        );
      },
    );
  }

  Widget buildArea(snapshot) {
    Shop shop = snapshot.data!;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.brown,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
                width: 300.0,
                height: 150.0,
                child: Image.network(
                    "https://img.freepik.com/premium-vector/hand-drawn-bread-and-bakery-vector-illustration-with-colorful_266639-1983.jpg?w=2000")),
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          Text(' 주소  ${shop.address}',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w200,
              )),
          Padding(padding: EdgeInsets.all(4.0)),
          const Text(' 연락처  01091085420'),
          Padding(padding: EdgeInsets.all(4.0)),
          const Text(' 영업상황  영업중/오늘 휴무/영업전/알수없음'),
          Padding(padding: EdgeInsets.all(8.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(' 방문후기',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w200,
                  )),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewWritePage(widget.id)));
                },
              )
            ],
          ),
          Expanded(
            child: _buildReview(),
          )
        ],
      ),
    );
  }

  _buildReview() {
    if(reviews.isEmpty){
      return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 1)
        ),
        child: Center(
            child: Text(
              '데이터가 없습니다 😋',
              style: TextStyle(fontSize: 30.0),
            )
        ),
      );
    }
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        Review review = reviews[index];
        return Container(
          decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 1)
          ),
          child: Row(
            children: [
              SizedBox(
                  width: 70.0,
                  height: 70.0,
                  child: Image.network(
                      "https://img.freepik.com/premium-vector/hand-drawn-bread-and-bakery-vector-illustration-with-colorful_266639-1983.jpg?w=2000")),
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(' 맛 : ${review.flavor}'),
                    Text(' 서비스 : ${review.service}'),
                    Text(' 재방문 : ${review.revisit}'),
                    Text(' 최애빵 : ${review.favoriteBread}'),
                    Text(
                      ' 간략후기 : ${review.detailReview}',
                      maxLines: 5,
                    ),
                  ],
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

  // final String? telephone;
  final String roadAddress;
  final int mapx;
  final int mapy;
  final String createdDate;
  final String modifiedDate;

  final List<Review> reviews;
  final int reviewsCount;

  Shop(
      {required this.id,
      required this.title,
      required this.link,
      required this.address,
      // this.telephone,
      required this.roadAddress,
      required this.mapx,
      required this.mapy,
      required this.createdDate,
      required this.modifiedDate,
      required this.reviews,
      required this.reviewsCount});

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
        id: json['shopId'] as int,
        title: json['title'] as String,
        link: json['link'] as String,
        address: json['address'] as String,
        // telephone: json['telephone'] as String?,
        roadAddress: json['roadAddress'] as String,
        mapx: json['mapx'] as int,
        mapy: json['mapy'] as int,
        createdDate: json['createdDate'] as String,
        modifiedDate: json['modifiedDate'] as String,
        reviews: (json['reviews'] as List).map((e) => Review.fromJson(e)).toList(),
        reviewsCount: json['reviewsCount'] as int);
  }

  @override
  String toString() {
    return '{${this.title}, ${this.address}';
  }
}

class Review {
  final int id;
  final String flavor;
  final String service;
  final String revisit;
  final String favoriteBread;
  final String detailReview;
  final String createdDate;
  final String modifiedDate;

  Review({
    required this.id,
    required this.flavor,
    required this.service,
    required this.revisit,
    required this.favoriteBread,
    required this.detailReview,
    required this.createdDate,
    required this.modifiedDate
});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      flavor: json['flavor'] as String,
      service: json['service'] as String,
      revisit: json['revisit'] as String,
      favoriteBread: json['favoriteBread'] as String,
      detailReview: json['detailReview'] as String,
      createdDate: json['createdDate'] as String,
      modifiedDate: json['modifiedDate'] as String,
    );
  }
}
