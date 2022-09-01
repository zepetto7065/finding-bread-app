import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordChecker = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController nickname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        backgroundColor: Colors.brown,
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text('간편 가입',
                  style: TextStyle(
                      fontSize: 30.0
                  ),
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                Text('이메일',
                  style: TextStyle(
                      fontSize: 20.0
                  ),
                ),
                Padding(padding: EdgeInsets.all(2.0)),
                SizedBox(
                  height: 40.0,
                  child: Row(
                    children: [
                      SizedBox(
                        width:210.0,
                        child: TextField(
                          controller: email,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '아이디 입력'
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left:8.0)),
                      ElevatedButton(
                          onPressed: () async {
                            var hasEmail = await _duplicateEmailCheck();
                            if(hasEmail) {
                              showAlertDialog(context);
                            }
                          },
                          child: Text('중복확인'))
                    ],
                  ),

                ),
              Padding(padding: EdgeInsets.all(4.0)),
              Text('이름',
                style: TextStyle(
                    fontSize: 20.0
                ),
              ),
              Padding(padding: EdgeInsets.all(2.0)),
              SizedBox(
                height: 40.0,
                child: TextField(
                  controller: userName,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '이름 입력'
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(4.0)),
              Text('닉네임',
                style: TextStyle(
                    fontSize: 20.0
                ),
              ),
              Padding(padding: EdgeInsets.all(2.0)),
              SizedBox(
                height: 40.0,
                child: TextField(
                  controller: nickname,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '이름 입력'
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(4.0)),
              Text('비밀번호',
                style: TextStyle(
                    fontSize: 20.0
                ),
              ),
                Padding(padding: EdgeInsets.all(2.0)),
                SizedBox(
                  height: 40.0,
                  child: TextField(
                    controller: password,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '비밀번호 입력'
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(4.0)),
                SizedBox(
                  height: 40.0,
                  child: TextField(
                    controller: passwordChecker,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '비밀번호 확인'
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                Center(
                  child: ElevatedButton(
                      onPressed: (){
                        _signupRequest();
                        Navigator.pop(context);
                      },
                      child: Text('회원가입')),
                )
              ]
          )
      ),
    );
  }

  Future<void> _signupRequest() async {
    String url = 'http://zepetto.synology.me:9090/api/user/signup';

    http.Response response = await http.post(Uri.parse(url),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept' : 'application/json'
      },
      body:  jsonEncode({
        'email' : email.text,
        'username' : userName.text,
        'nickname' : nickname.text,
        'password' : password.text,
      }),
    );

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<bool> _duplicateEmailCheck() async {
    String url = 'http://zepetto.synology.me:9090/api/user/is?email=';
    http.Response response = await http.get(Uri.parse(url + email.text));
    var _text = utf8.decode(response.bodyBytes);

    return jsonDecode(_text)['data'] as bool;
  }

  void showAlertDialog(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
      return AlertDialog(
        title: Text('ID 중복 체크'),
        content: Text('동일한 email 이 존재합니다.'),
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

}
