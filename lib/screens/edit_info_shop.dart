import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cabbitfood/model/user_model.dart';
import 'package:cabbitfood/utils/my_constant.dart';
import 'package:cabbitfood/utils/my_style.dart';
import 'package:cabbitfood/utils/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInfoShop extends StatefulWidget {
  @override
  _EditInfoShopState createState() => _EditInfoShopState();
}

class _EditInfoShopState extends State<EditInfoShop> {
  UserModel userModel;
  String nameShop, address, phone, urlPicture;
  Location location = Location();
  double lat, lng;
  File file;

  @override
  void initState() {
    super.initState();
    readCurrentInform();

      location.onLocationChanged.listen((event) {
      setState(() {
        lat = event.latitude;
        lng = event.longitude;
        // print('lat = $lat, lng = $lng');
      });
    });
  }

  Future<Null> readCurrentInform() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String idShop = sharedPreferences.getString('id');
    print('idShop==>$idShop');

    String url =
        '${MyConstant().domain}/UngPHP3/getUserWhereId.php?isAdd=true&id=$idShop';

    Response response = await Dio().get(url);
    print('response ==>$response');
    var result = json.decode(response.data);
    print('result===>$result');

    for (var map in result) {
      print('map==>$map');
      setState(() {
        userModel = UserModel.fromJson(map);
        nameShop = userModel.nameShop;
        address = userModel.address;
        phone = userModel.phone;
        // phone = userModel.password;
        urlPicture = userModel.urlPicture;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userModel == null ? MyStyle().showProgress() : showContent(),
      appBar: AppBar(
        title: Text('ปรับปรุง รายละเอียดร้าน'),
      ),
    );
  }

  Widget showContent() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            nameShopForm(),
            showImage(),
            addressForm(),
            phoneForm(),
            lat == null ? MyStyle().showProgress() : showMap(),
            editButton()
          ],
        ),
      );
  Widget editButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
          color: MyStyle().primaryColor,
          onPressed: () => confirmDialog(),
          icon: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          label: Text(
            'ปรับปรุงรายละเอียดร้าน',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณแน่ใจว่าจะปรับปรุงรายละเอียดร้าน'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                onPressed: () {
                  Navigator.pop(context);
                  editThred();
                },
                child: Text('แน่ใจ'),
              ),
              OutlineButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ไม่แน่ใจ'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> editThred() async {
    Random random = Random();
    int i = random.nextInt(100000);
    String namefile = 'editShop$i.jpg';    

    Map<String, dynamic> map = Map();
    map['file'] = await MultipartFile.fromFile(file.path, filename: namefile);
    FormData formData = FormData.fromMap(map);

    String urlUpload = '${MyConstant().domain}/UngPHP3/saveShop.php';
    await Dio().post(urlUpload, data: formData).then((value) async {
      urlPicture = '/UngPHP3/Shop/$namefile';
      String id = userModel.id;
      print('id==>$id');
      String url =
          '${MyConstant().domain}/UngPHP3/editUserWhereId.php?isAdd=true&id=$id&NameShop=$nameShop&Address=$address&Phone=$phone&UrlPicture=$urlPicture&Lat=$lat&Lng=$lng';
      // 'http://202.43.47.251/UngPHP3/editUserWhereId.php?isAdd=true&id=$id&NameShop=$nameShop&Address=$address&Phone=$phone&UrlPicture=$urlPicture&Lat=$lat&Lng=$lng';
      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ยัง update ไม่ได้');
      }
    });
  }

  Set<Marker> currentMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('myMarker'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
              title: 'ร้านอยู่ที่นี่', snippet: 'lat = $lat , lng = $lng'))
    ].toSet();
  }

  Container showMap() {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 16.0,
    );
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      height: 250,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: currentMarker(),
      ),
    );
  }

  Widget showImage() => Container(
        margin: EdgeInsetsDirectional.only (top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () => chooseImage(ImageSource.camera),
            ),
            Container(
                width: 250.0,
                height: 250.0,
                child: file == null
                    ? Image.network('${MyConstant().domain}$urlPicture')
                    : Image.file(file)),
            IconButton(
              icon: Icon(Icons.add_photo_alternate),
              onPressed: () => chooseImage(ImageSource.gallery),
            ),
          ],
        ),
      );

  Future<Null> chooseImage(ImageSource source) async {
    // try {
    //   var object = await ImagePicker.pickImage(
    //     source: source,
    //     maxWidth: 800.0,
    //     maxHeight: 800.0,
    //   );
    //   setState(() {
    //     file = object;
    //   });
    // } catch (e) {}
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );

      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget nameShopForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => nameShop = value,
              initialValue: nameShop,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ชื่อของร้าน',
              ),
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => address = value,
              initialValue: address,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ที่อยู่ของร้าน',
              ),
            ),
          ),
        ],
      );

  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => phone = value,
              initialValue: phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'เบอร์ติดต่อของร้าน',
              ),
            ),
          ),
        ],
      );
}
