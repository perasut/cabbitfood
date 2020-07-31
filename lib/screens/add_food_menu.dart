import 'dart:io';

import 'package:cabbitfood/utils/my_style.dart';
import 'package:cabbitfood/utils/normal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddFoodMenu extends StatefulWidget {
  AddFoodMenu({Key key}) : super(key: key);

  @override
  _AddFoodMenuState createState() => _AddFoodMenuState();
}

class _AddFoodMenuState extends State<AddFoodMenu> {
  File file;
  String nameFood, priceFood, detail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มรายการเมนูอาหาร'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            showTitleFood('รูปอาหาร'),
            groupImage(),
            showTitleFood('รายละเอียดอาหาร'),
            nameForm(),
            MyStyle().mySizeBox(),
            priceForm(),
            MyStyle().mySizeBox(),
            detailForm(),
            MyStyle().mySizeBox(),
            saveButton()
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
          color: MyStyle().primaryColor,
          onPressed: () {
            if (file == null) {
              normalDialog(context, 'กรุณา เลือกรูปภาพอาหาร ');
            } else if (nameFood == null ||
                nameFood.isEmpty ||
                priceFood == null ||
                priceFood.isEmpty ||
                detail == null ||
                detail.isEmpty) {
              normalDialog(context, 'กรุณากรอกข้อมูลทุกช่อง');
            } else {}
            {}
          },
          icon: Icon(
            Icons.save,
            color: Colors.white,
          ),
          label: Text(
            'Save food menu',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget nameForm() => Container(
      width: 250.0,
      child: TextField(
        onChanged: (value) => nameFood = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.fastfood),
          labelText: 'ชื่ออาหาร',
          border: OutlineInputBorder(),
        ),
      ));

  Widget priceForm() => Container(
      width: 250.0,
      child: TextField(keyboardType: TextInputType.number,
        onChanged: (value) => priceFood = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.attach_money),
          labelText: 'ราคาอาหาร',
          border: OutlineInputBorder(),
        ),
      ));

  Widget detailForm() => Container(
      width: 250.0,
      child: TextField(
        onChanged: (value) => detail = value.trim(),
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.details),
          labelText: 'รายละเอียดอาหาร',
          border: OutlineInputBorder(),
        ),
      ));

  Row groupImage() {
    return Row(
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
              ? Image.asset('images/foodmenu.png')
              : Image.file(file),
        ),
        IconButton(
          icon: Icon(Icons.add_photo_alternate),
          onPressed: () => chooseImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
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

  Widget showTitleFood(String string) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          MyStyle().showText2(string),
        ],
      ),
    );
  }
}
