import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Center(
      child: Container(
          width: 200,
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
                    width: 150,
                    height: 30,
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Hint'
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(5.0)),
                  Text('검색')
                ],
              ),
            ],
          )),
    );
  }
}
