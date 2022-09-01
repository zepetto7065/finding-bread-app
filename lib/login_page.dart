import 'dart:convert';

import 'package:finding_bread_app/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody(){
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: [
                Text('로그인',
                  style: TextStyle(
                    fontSize: 30.0
                  ),
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                TextField(
                  controller: email,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '아이디 입력'
                  ),
                ),
                Padding(padding: EdgeInsets.all(4.0)),
                TextField(
                  controller: password,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '비밀번호 입력'
                  ),
                ),
                Padding(padding: EdgeInsets.all(2.0)),
                ElevatedButton(
                  onPressed: () async {
                    setToken();
                    final prefs = await SharedPreferences.getInstance();
                    final appToken = prefs.getString('token') ?? '';
                    if(appToken != null){
                      Navigator.pop(context, appToken);
                    }
                  },
                  child: Text('로그인'),
                ),
                Row(
                  children: [
                    Text('아직 Finding Bread 계정이 없나요?'),
                    TextButton(
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()));
                        },
                        child: Text('회원가입'))
                  ],
                )
              ],
            ),
          ),
        )
    );
  }

  setToken() async {
    String url = 'http://zepetto.synology.me:9090/api/login';

    http.Response response = await http.post(Uri.parse(url),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept' : 'application/json'
      },
      body:  jsonEncode({
        'email' : email.text,
        'password' : password.text,
      }),
    );

    var _text = utf8.decode(response.bodyBytes);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token',jsonDecode(_text)['token']);
  }
}

