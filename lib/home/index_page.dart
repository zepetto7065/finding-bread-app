import 'package:finding_bread_app/home/shop_list_page.dart';
import 'package:finding_bread_app/home/shop_request_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class IndexPage extends StatefulWidget {

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Finding Bread',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 2.0,
                    color: Colors.brown
                ),
              ),
              Padding(padding: EdgeInsets.all(5.0)),
              Text(
                '빵집을 찾아드립니다',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 2.0,
                    color: Colors.brown
                ),
              ),
              Padding(padding: EdgeInsets.all(5.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 170,
                    height: 30,
                    child: _textField(),
                  ),
                  Padding(padding: EdgeInsets.all(5.0)),
                  ElevatedButton(
                    child: Text('검색'),
                    onPressed: () {
                      onGenerate();
                    },
                  )
                ],
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          ShopRequestPage())
                  );
                },
                child: Text(
                    '원하는 빵집을 요청할 수 있어요!',
                  style: TextStyle(
                      fontSize: 10.0,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onGenerate() {
    Navigator.push(
      context ,
      MaterialPageRoute(builder: (context) => ShopListPage(_textController.text.trim()))
    );
  }

  StatefulWidget _textField() {
      return TextField(
        controller: _textController,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: '이름/지역을 검색하세요'
        )
      );
  }
}
