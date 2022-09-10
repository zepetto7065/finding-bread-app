import 'package:finding_bread_app/login_page.dart';
import 'package:finding_bread_app/review_write_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopDetailPage extends StatefulWidget {
  int shopId;
  int? userId;
  String? token;

  ShopDetailPage(this.shopId, this.userId);

  @override
  State<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  Future<Shop>? shop;
  String title = "";
  List<Review> reviews = [];
  String link = "";

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
    shop = getShop(widget.shopId);
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
    link = shop.link!;
    link = link ==  '' ? '정보없음' : link;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                  child: Image.network(
                      "https://finding-bread-app.s3.ap-northeast-2.amazonaws.com/review/118_1662629387789782.jpg",
                      fit: BoxFit.fill,
                  ),

              ),
            ),
            Padding(padding: EdgeInsets.all(4.0)),
            Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Text(' 주소 ',
                      style: TextStyle(
                        fontSize: 15.0,
                      )),
                ),
                SizedBox(
                  width: 220,
                  child: Text('${shop.address}',
                    style: TextStyle(
                      fontSize: 13.0,
                    ),
                    overflow: TextOverflow.fade,
                  ),
                ),
                IconButton(
                  onPressed: (){
                    Clipboard.setData(ClipboardData(text:shop.address));
                  },
                  icon: Icon(Icons.copy),
                ),
              ]
            ),
            Padding(padding: EdgeInsets.all(2.0)),
            // Row(
            //   children: [
            //     SizedBox(
            //       width: 50,
            //       child: Text(' 연락처 ',
            //           style: TextStyle(
            //             fontSize: 15.0,
            //           )),
            //     ),
            //     Text('01091085420'),
            //   ]
            // ),
            // Padding(padding: EdgeInsets.all(2.0)),
            Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Text(' 링크')
                ),
                SizedBox(
                  width: 250,
                  child: InkWell(
                   child: Text(link,
                          overflow: TextOverflow.fade   ,
                          ),
                    onTap: _launchUrl
                  )
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(2.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(' 방문후기 '+shop.reviewsCount.toString(),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w200,
                    )),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    onPressedReviewBtn();
                  },
                )
              ],
            ),
            _buildReview()
          ],
        ),
      ),
    );
  }

   onPressedReviewBtn() async {
    final prefs = await SharedPreferences.getInstance();
    final appToken = prefs.getString('token') ?? '';

    if(appToken == ''){
      widget.token = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage()));

    }else{
         Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReviewWritePage(widget.shopId, widget.token)));
    }
  }

  _buildReview() {
    if(reviews.isEmpty){
      return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 1)
        ),
        child: Center(
            child: Text(
              '아직 후기가 없어요! 😋',
              style: TextStyle(fontSize: 25.0),
            )
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true, //list in list
      physics: NeverScrollableScrollPhysics(),
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
                width: 230,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('👤${review.nickname}'),
                        Padding(padding: EdgeInsets.all(3.0)),
                        Text(review.createdDate,style: const TextStyle(fontSize: 10.0),),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(3.0)),
                    Text(' 맛 : ${review.flavor}'),
                    Text(' 서비스 : ${review.service}'),
                    Text(' 최애빵 : ${review.favoriteBread}'),
                    Text(' 상세후기 : ${review.detailReview}'),
                  ],
                ),
              ),
              SizedBox(
                  width: 70.0,
                  height: 70.0,
                  child: Image.network(
                      "https://img.freepik.com/premium-vector/hand-drawn-bread-and-bakery-vector-illustration-with-colorful_266639-1983.jpg?w=2000")
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _launchUrl() async{
    Uri url = Uri.parse(link);
    if(!await launchUrl(url)){
      throw 'could not launch';
    }
  }

}

class Shop {
  final int id;
  final String title;
  final String? link;
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
       this.link,
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
        link: json['link'] as String?,
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
  //nickname
  //날짜
  final int reviewId;
  final int userId;
  final String nickname;
  final String flavor;
  final String service;
  final String favoriteBread;
  final String detailReview;
  final String createdDate;
  final String modifiedDate;

  Review({
    required this.reviewId,
    required this.userId,
    required this.nickname,
    required this.flavor,
    required this.service,
    required this.favoriteBread,
    required this.detailReview,
    required this.createdDate,
    required this.modifiedDate
});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['reviewId'] as int,
      userId: json['userId'] as int,
      nickname: json['nickname'] as String,
      flavor: json['flavor'] as String,
      service: json['service'] as String,
      favoriteBread: json['favoriteBread'] as String,
      detailReview: json['detailReview'] as String,
      createdDate: json['createdDate'] as String,
      modifiedDate: json['modifiedDate'] as String,
    );
  }
}

class User{

  final int id;
  final String name;

  User(this.id, this.name);


}