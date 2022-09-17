import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShopRequestPage extends StatefulWidget {
  @override
  State<ShopRequestPage> createState() => _ShopRequestPageState();
}

class _ShopRequestPageState extends State<ShopRequestPage> {
  final TextEditingController title = TextEditingController();
  final TextEditingController content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('빵집 요청'),
          backgroundColor: Colors.brown,
          ),
          body: Center(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children : [
                Padding(padding: EdgeInsets.all(4.0)),
                Text('원하시는 빵집을 등록해드립니다.'),
                Padding(padding: EdgeInsets.all(8.0)),
                TextField(
                    maxLength: 10,
                    controller: title,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: '가게 이름을 입력해주세요.')),
                  Padding(padding: EdgeInsets.all(4.0)),
                  TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  maxLength: 100,
                  controller: content,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '위치/메뉴 등 상세 정보를 입력해주세요.'),
                ),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: Text('요청하기'),
                    onPressed: (){
                      request();
                      Navigator.pop(context);
                    },
                  ),
                )
              ]
              ),
            ),
          )
      ),
    );
  }

  Future<void> request() async {
    String url = "http://zepetto.synology.me:9090/api/tendinous";
    final prefs = await SharedPreferences.getInstance();
    final appToken = prefs.getString('token') ?? '';
    final userId = prefs.getInt('userId') ?? '';

    http.Response response = await http.post(Uri.parse(url),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $appToken'
      },
      body:  jsonEncode({
        'title' : title.text,
        'content' : content.text,
        'userId' : userId,
      }),
    );

    if(response.statusCode == 401){
      showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('권한이 없습니다.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context, "OK");
                  },
                ),
              ],
            );
          }
      );
    }

    if(response.statusCode == 200){
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('등록이 완료되었습니다..'),
            );
          }
      );
    }
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}
