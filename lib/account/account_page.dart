import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Future<User>? user;

  Future<User> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance() ;
    String token = prefs.getString('token') ?? '';
    String email = prefs.getString('email') ?? '';
    String nickname = prefs.getString('nickname') ?? '';
    return User(token,email,nickname);
  }

  @override
  void initState() {
    super.initState();
    user = getToken();
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
            title: Text('MyFB'),
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
                        child: CircleAvatar(
                          backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOL8Ye-jw6iyBKmdD-PHzvBZgyAR0B4MuCOr2cysTlTw&s'),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(4.0)),
                      Text('${snapshot.data!.nickname}님'),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(4.0)),
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
                                          '안녕하세요.\n'
                                          'Finding Bread ver 1.0.0을 Open 하였습니다.\n'
                                          '항상 발전하는 서비스가 되겠습니다. \n'
                                          'Finding Bread을 이용해주셔서 감사합니다.',
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                      title: Text('공지사항'),
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
                                        '1. 빵집을 찾는다.\n'
                                        '2. 후기를 등록한다.\n'
                                        '3. 맛난 빵집을 등록한다.'
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
                                  return AlertDialog(
                                    content: Text('약관입니다.'),
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
                  Padding(padding: EdgeInsets.all(10.0)),
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
