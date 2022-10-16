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
  File? _image1;
  File? _image2;
  File? _image3;
  String imageUrl1 = "";
  String imageUrl2 = "";
  String imageUrl3 = "";


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar:  AppBar(
          title: Text('후기'),
          backgroundColor: Colors.brown,
        ),
        body: buildBody(),
      ),
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
            Padding(padding: EdgeInsets.all(4.0)),
            SizedBox(
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
            Row(
              children: [
                IconButton(
                  iconSize: 30,
                  onPressed: _getImage,
                  icon: Icon(Icons.add_a_photo_outlined),
                ),
                Padding(padding: EdgeInsets.all(2.0)),
                _image1 != null ? SizedBox(
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.file(_image1!)
                  ),
                ) : Text('사진을 추가해주세요! (최대 3장)') ,
                Padding(padding: EdgeInsets.all(2.0)),
                _image2 != null ? SizedBox(
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.file(_image2!)
                  ),
                ) : Text('') ,
                Padding(padding: EdgeInsets.all(2.0)),
                _image3 != null ? SizedBox(
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.file(_image3!)
                  ),
                ) : Text('') ,
              ],
            ),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                child: Text('추가!'),
                onPressed: (){
                  if(_image1 != null || _image1 != ''){
                    postImageRequest();
                  }
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text('후기를 등록하시겠습니까?'),
                          actions: [
                            TextButton(
                              child: Text('등록'),
                              onPressed: () {
                                _postReviewRequest(widget.id);
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text('취소'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      }
                  );
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
    List<String> imageUrl =[imageUrl1,imageUrl2,imageUrl3];

    flavor = getFlavor(flavor);
    service = getService(service);

    final prefs = await SharedPreferences.getInstance();
    final appToken = prefs.getString('token') ?? '';
    final userId = prefs.getInt('userId') ?? '';

    http.Response response = await http.post(Uri.parse(url),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $appToken'
      },
      body:  jsonEncode({
        'shopId' : shopId,
        'userId' : userId,
        'flavor' : flavor,
        'service' : service,
        'favoriteBread' : _favoriteBread.text,
        'detailReview' : _detailReview.text,
        'imageUrlList' : imageUrl
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
    List<XFile>? images = await ImagePicker().pickMultiImage();


    if(images != null){
      if(images.length <= 3){
        setState(() {
          _image1 = null;
          _image2 = null;
          _image3 = null;
          if(images.length == 3){
            _image1 = File(images[0].path);
            _image2 = File(images[1].path);
            _image3 = File(images[2].path);
          }else if(images.length == 2){
            _image1 = File(images[0].path);
            _image2 = File(images[1].path);
          }else if(images.length == 1){
            _image1 = File(images[0].path);
          }
        });
      }else{
        print('이미지는 최대 3개까지 등록이 가능합니다.');
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('이미지는 최대 3개까지 등록이 가능합니다.'),
              );
            }
        );
      }
    }
  }

  postImageRequest()  {
    print('후기 사진을 업로드');
    String baseUrl = "https://finding-bread-app.s3.ap-northeast-2.amazonaws.com/review/";
    if(_image1 != null){
      var split = _image1!.path.split('.');
      var extension = split[split.length-1];

      String fileName = '${widget.id}_${DateTime.now().microsecondsSinceEpoch}.${extension}';
      imageUrl1 = fileName;

      requestUpload(extension, baseUrl + fileName, _image1! );
    }
    if(_image2 != null){
      var split = _image2!.path.split('.');
      var extension = split[split.length-1];

      String fileName = '${widget.id}_${DateTime.now().microsecondsSinceEpoch}.${extension}';
      imageUrl2 = fileName;

      requestUpload(extension, baseUrl + fileName, _image2! );
    }
    if(_image3 != null){
      var split = _image3!.path.split('.');
      var extension = split[split.length-1];

      String fileName = '${widget.id}_${DateTime.now().microsecondsSinceEpoch}.${extension}';
      imageUrl3 = fileName;

      requestUpload(extension, baseUrl + fileName, _image3! );
    }
  }

  Future<void> requestUpload(String extension, String uri, File image) async {
    try {
      var response = await http.put(
          Uri.parse(uri),
          body: image.readAsBytesSync(),
          headers: {
            'Content-Type': 'image/$extension'
          }
      );
      if (response.statusCode == 200) {
        print('${image.path} ::: 성공적으로 업로드했습니다.');
      }
    }catch(e){
      print(e);
    }
  }

}

class Review {
  String flavor;
  String service;
  String favoriteBread;
  List<String> imageUrl;

  Review(
      this.flavor, this.service, this.favoriteBread, this.imageUrl);

}
enum Flavor { GOOD, SOSO, BAD }
enum Service { GOOD, BAD }
