
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Future<User>? user;
  String terms = "";
  String notice = "";

  Future<User> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance() ;
    String token = prefs.getString('token') ?? '';
    String email = prefs.getString('email') ?? '';
    String nickname = prefs.getString('nickname') ?? '';
    return User(token,email,nickname);
  }

  getTextInfo() async {
    String response_terms = await rootBundle.loadString('texts/comm_terms');
    String response_notice = await rootBundle.loadString('texts/notice');
    setState(() {
      terms = response_terms;
      notice = response_notice;
    });
  }

  @override
  void initState() {
    super.initState();
    user = getToken();
    getTextInfo();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: user,
        builder: (context, snapshot){
          if(snapshot.hasData){
            if(snapshot.data!.token != '') return buildPage(snapshot);
          }else if (snapshot.hasError) {
            return Text('${snapshot.error} 에러!!');
          }
          return const SizedBox(
              height: 10.0,
              width: 10.0,
              child: CircularProgressIndicator()
          );
        }
    );
  }

  Widget buildPage(snapshot){
    return WillPopScope(
      onWillPop: (){
        return Future(() => false);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('My Page'),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.brown,
          ),
          body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.all(8.0)),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.all(4.0)),
                      SizedBox(
                        width: 60.0,
                        height: 60.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset(
                        'images/profile.png',
                        fit: BoxFit.cover,
                      ),
                    )
                      ),
                      Padding(padding: EdgeInsets.all(4.0)),
                      Text('${snapshot.data!.nickname}님'),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(4.0)),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(8.0),
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text(
                                        notice,
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                      title: const Text('공지사항'),
                                    );
                                  }
                              );
                            },
                            child: Text('공지사항'),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text(
                                        '▷빵집 검색\n'+
                                        '* 더 빨리 가게를 찾고 싶다면 전체 가게명 입력하세요.\n'+
                                        '▷빵집 등록 요청\n'+
                                        '* 보고싶은 빵집이 없으면 \'Home - 원하는 빵집을 요청할 수 있어요!\'를 통해 요청주세요.\n'+
                                        '▷후기\n'+
                                        '* 후기 사진을 클릭하면 상세 이미지를 볼 수 있어요.',
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                    title: Text('이용가이드'),
                                  );
                                }
                            );
                          },
                          child: Text('이용가이드'),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    child: AlertDialog(
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context); //close Dialog
                                          },
                                          child: Text('Close'),
                                        ),
                                      ],
                                      content: Text(terms,
                                        style: const TextStyle(fontSize: 12.0)
                                      ),
                                    ),
                                  );
                                }
                            );
                          },
                          child: Text('약관'),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: OutlinedButton(
                        onPressed: (){
                          logOut();
                          Navigator.pop(context);
                        },
                        child:  Text('로그아웃')
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(10.0)),
                ],
              )
          ),
        ),
    );
  }

  Future<void> logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance() ;
    prefs.clear();
  }
}

class User{
  String token;
  String email;
  String nickname;

  User(this.token, this.email, this.nickname);
}
