import 'dart:async';
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
  TextEditingController authNum = TextEditingController();

  bool isDuplicateEmailCheck = false;
  bool isPasswordEnable = false;
  bool isCheckPasswordEnable = false;

  int timerCount = 0;
  Timer? timer;
  bool isTimerRunning = false;

  var emailAuthNum;


  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

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
    return SingleChildScrollView(
      child: Padding(
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
                  Padding(padding: EdgeInsets.all(4.0)),
                  SizedBox(
                    height: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width:210.0,
                          child: TextField(
                            controller: email,
                            enabled: isDuplicateEmailCheck == false ? true : false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: '아이디 입력'
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left:8.0)),
                        ElevatedButton(
                            onPressed: () async {
                              bool isAvailable = await emailCheck();

                              setState(() {
                                timerCount = 180;
                                isDuplicateEmailCheck = isAvailable;
                              });

                              timer = Timer.periodic(const Duration(seconds: 5), (timer) {
                                setState(() {
                                  timerCount--;
                                  if(timerCount == 0){
                                    timer.cancel();
                                  }
                                });
                              });
                            },
                            child: isDuplicateEmailCheck == false ? Text('인증') : Text('재전송'))
                      ],
                    ),
                  ),
                Padding(padding: EdgeInsets.all(4.0)),
                isDuplicateEmailCheck == true ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children : [
                    Stack (
                      alignment: Alignment.centerRight,
                      children : [
                          SizedBox(
                            width: 210.0,
                            height: 40.0,
                            child: TextField(
                              controller: authNum,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '인증번호 입력'),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('$timerCount'),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(left:8.0)),
                    ElevatedButton(
                        onPressed: () async {
                          if(timerCount == 0){
                            showDialog(context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text('인증시간이 초과되었습니다.'),
                                  );
                                });
                            return;
                          }
                          if(emailAuthNum.toString() == authNum.text){
                            setState((){
                              isPasswordEnable = true;
                              isCheckPasswordEnable = true;
                              isDuplicateEmailCheck = false;
                              timer?.cancel();
                            });
                            showDialog(context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text('이메일 인증이 완료되었습니다.'),
                                  );
                                });
                          }else{
                            showDialog(context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text('인증번호가 동일하지 않습니다.'),
                                  );
                              });
                          }
                        },
                      child: Text('확인'))
                  ]
                ) : SizedBox(),
                Padding(padding: EdgeInsets.all(2.0)),
                Text('비밀번호',
                  style: TextStyle(
                      fontSize: 20.0
                  ),
                ),
                Padding(padding: EdgeInsets.all(4.0)),
                SizedBox(
                  height: 40.0,
                  child: TextField(
                    obscureText: true,
                    enabled: isPasswordEnable,
                    controller: password,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '비밀번호 입력',
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(4.0)),
                SizedBox(
                  height: 40.0,
                  child: TextField(
                    obscureText: true,
                    enabled: isCheckPasswordEnable,
                    controller: passwordChecker,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '비밀번호 확인'
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(2.0)),
                Text('이름',
                  style: TextStyle(
                      fontSize: 20.0
                  ),
                ),
                Padding(padding: EdgeInsets.all(4.0)),
                SizedBox(
                  height: 60.0,
                  child: TextField(
                    maxLength: 10,
                    controller: userName,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '이름 입력'
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(2.0)),
                Text('닉네임',
                  style: TextStyle(
                      fontSize: 20.0
                  ),
                ),
                Padding(padding: EdgeInsets.all(4.0)),
                SizedBox(
                  height: 60.0,
                  child: TextField(
                    controller: nickname,
                    maxLength: 10,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '닉네임 입력'
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(4.0)),

                Center(
                    child: ElevatedButton(
                        onPressed : () async {
                          if (signUpValidCheck()) {
                          await showDialog(context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text('회원가입을 성공하였습니다.'),
                                );
                              });
                            _signupRequest();
                            Navigator.pop(context, true);
                          }
                          return;
                        },
                        child: Text('회원가입')),
                  ),
                ]
            )
        ),
      ),

    );
  }

  Future<bool> emailCheck() async {
    var validEmailFormat = isValidEmailFormat(email.text);

    if(email.text == "" || !validEmailFormat){
      showAlertDialog(context,"올바른 Email을 입력하세요.");
      return false;
    }

    var response = await requestApi();
    var statusCode = jsonDecode(response)['code'];

    if(statusCode == 'ERR0001'){
      showAlertDialog(context,"동일한 Email 이 존재합니다.");
      return false;
    }
    setState(() {
      emailAuthNum = jsonDecode(response)['data'];
    });
    return true;
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

  Future<String> requestApi() async {
    String url = 'http://zepetto.synology.me:9090/api/user/signup/available?email=';
    http.Response response = await http.get(Uri.parse(url + email.text));
    return utf8.decode(response.bodyBytes);
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

  bool isValidEmailFormat(String email) {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool isValidPasswordFormat(String Password) {
    return RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,15}$')
        .hasMatch(Password);
  }

  bool isValidSpecialCharFormat(String text) {
    return RegExp(
        r'[!@#$%^&*(),.?":{}|<>]')
        .hasMatch(text);
  }

  bool signUpValidCheck() {
    if(email.text == "" || password.text == ""
        || passwordChecker.text == "" || userName.text == "" || nickname.text == ""){
      showAlertDialog(context, "빈 필드가 존재합니다.");
      return false;
    }

    if(password.text != passwordChecker.text){
      showAlertDialog(context, "비밀번호가 일치하지 않습니다.");
      return false;
    }

    if(!isValidPasswordFormat(password.text)){
      showAlertDialog(context, '비밀번호는 특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내로 입력하세요.');
      return false;
    }

    if (isValidSpecialCharFormat(userName.text) ||
        userName.text.length > 10 ||
        isValidSpecialCharFormat(nickname.text) ||
        nickname.text.length > 10) {
      showAlertDialog(context, '이름과 닉네임은 특수문자를 제외한 10자 내외로 입력하세요.');
      return false;
    }

    return true;
  }

  bool authNumCheck() {
    return true;
  }

}
