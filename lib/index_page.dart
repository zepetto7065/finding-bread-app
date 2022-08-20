import 'package:finding_bread_app/shop_list_page.dart';
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

    return Center(
      child: Container(
          width: 250,
          height: 150,
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
              Padding(padding: EdgeInsets.all(10.0)),
              Row(
                children: [
                  SizedBox(
                    width: 170,
                    height: 30,
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '이름, 지역을 검색해주세요.'
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(5.0)),
                  ElevatedButton(
                    child: Text('검색'),
                    onPressed: () {
                      Navigator.push(
                        context ,
                        MaterialPageRoute(builder: (context) => ShopListPage(_textController.text))
                      );
                    },
                  )
                ],
              ),
            ],
          )),
    );
  }
}
