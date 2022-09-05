import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ReviewWritePage extends StatefulWidget {
  int id;
  String? token;

  ReviewWritePage(this.id, this.token);

  @override
  State<ReviewWritePage> createState() => _ReviewWritePageState();
}

class _ReviewWritePageState extends State<ReviewWritePage> {
  Flavor? _flavor = Flavor.GOOD;
  Service? _service = Service.GOOD;
  final TextEditingController _favoriteBread = TextEditingController();
  final TextEditingController _detailReview = TextEditingController();
  File? _image;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text('후기'),
        backgroundColor: Colors.brown,
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all( 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('맛이 어때요?',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  child: RadioListTile<Flavor>(
                    title: Text('정말 맛있어요',
                    style: TextStyle(fontSize: 12.0),
                    ),
                    value: Flavor.GOOD,
                    groupValue: _flavor,
                    onChanged: (Flavor? value){
                      setState(() {
                        _flavor = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  child: RadioListTile<Flavor>(
                    title: Text('무난해요',
                      style: TextStyle(fontSize: 12.0),),
                    value: Flavor.SOSO,
                    groupValue: _flavor,
                    onChanged: (Flavor? value){
                      setState(() {
                        _flavor = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  child: RadioListTile<Flavor>(
                    title: Text('입맛에 안맞아요',
                      style: TextStyle(fontSize: 12.0),),
                    value: Flavor.BAD,
                    groupValue: _flavor,
                    onChanged: (Flavor? value){
                      setState(() {
                        _flavor = value;
                      });
                    },
                  ),
                )
              ],
            ),
            Padding(padding: EdgeInsets.all(2.0)),
            Text('서비스는 어때요?',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  child: RadioListTile<Service>(
                    title: Text('친절해요',
                      style: TextStyle(fontSize: 12.0),
                    ),
                    value: Service.GOOD,
                    groupValue: _service,
                    onChanged: (Service? value){
                      setState(() {
                        _service = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  child: RadioListTile<Service>(
                    title: Text('불친절해요',
                      style: TextStyle(fontSize: 12.0),
                    ),
                    value: Service.BAD,
                    groupValue: _service,
                    onChanged: (Service? value){
                      setState(() {
                        _service = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(2.0)),
            Text('최애빵이 궁금해요🥰',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
            Padding(padding: EdgeInsets.all(8.0)),
            SizedBox(
              height: 60,
              child: TextField(
                maxLength: 10,
                controller: _favoriteBread,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '내용을 입력해주세요.'
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(2.0)),
            Text('간략후기',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
            Padding(padding: EdgeInsets.all(2.0)),
            SizedBox(
              height: 60,
              child: TextField(
                controller: _detailReview,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                maxLength: 100,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '후기를 작성해주세요.'
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(4.0)),
            Text('업로드',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
            IconButton(
              onPressed: _getImage,
              icon: Icon(Icons.add_a_photo),
            ),
            _image == null ? Text('No Image') : Image.file(_image!),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                child: Text('추가!'),
                onPressed: (){
                  _postReviewRequest(widget.id);
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _postReviewRequest(int shopId) async {
    String url = 'http://zepetto.synology.me:9090/api/reviews';
    String flavor = "";
    String service = "";
    print(_image);

    flavor = getFlavor(flavor);
    service = getService(service);

    final prefs = await SharedPreferences.getInstance();
    final appToken = prefs.getString('token') ?? '';

    http.Response response = await http.post(Uri.parse(url),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept' : 'application/json',
        'Authorization' : 'Bearer ' + appToken
      },
      body:  jsonEncode({
        'shopId' : shopId,
        'flavor' : flavor,
        'service' : service,
        'favoriteBread' : _favoriteBread.text,
        'detailReview' : _detailReview.text
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

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  String getService(String service) {
    if(_service == Service.GOOD){
      service = "친절해요";
    }else{
      service = "불친절해요";
    }
    return service;
  }

  String getFlavor(String flavor) {
    if(_flavor == Flavor.GOOD){
      flavor = "정말 맛있어요.";
    }else if(_flavor == Flavor.SOSO){
      flavor = "무난해요.";
    }else{
      flavor = "입맛에 안맞아요.";
    }
    return flavor;
  }

  Future<void> _getImage() async {
    XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery
    );

    if(image != null){
      setState(() {
        _image = File(image.path);
      });
    }
  }
}

class Review {
  String flavor;
  String service;
  String favoriteBread;
  String review;

  Review(
      this.flavor, this.service, this.favoriteBread, this.review);

}
enum Flavor { GOOD, SOSO, BAD }
enum Service { GOOD, BAD }
