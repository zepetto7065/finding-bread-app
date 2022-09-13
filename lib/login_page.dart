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
    return SingleChildScrollView(
      child: Center(
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
                    obscureText: true,
                    controller: password,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '비밀번호 입력'
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(2.0)),
                  ElevatedButton(
                    onPressed: () async {
                      if(validCheck()){
                        setToken();
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
      ),
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

    if(response.statusCode == 200){
      var _text = utf8.decode(response.bodyBytes);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('token' ,jsonDecode(_text)['token']);
      prefs.setInt('userId' ,jsonDecode(_text)['userId']);
      prefs.setString('email' ,jsonDecode(_text)['email']);
      prefs.setString('nickname' ,jsonDecode(_text)['nickname']);
      final appToken = prefs.getString('token');

      Navigator.pop(context, appToken);
    }else{
      print('로그인 실패');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('로그인 실패'),
            );
          }
      );
    }

  }

  bool validCheck() {
    if(email.text == ""){
      showAlertDialog(context,"이메일을 입력해주세요.");
      return false;
    }
    if(password.text == ""){
      showAlertDialog(context,"비밀번호를 입력해주세요.");
      return false;
    }
    return true;
  }

  void showAlertDialog(BuildContext context, String text) async {
    await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(text),
            actions: <Widget>[
              TextButton(
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
}

