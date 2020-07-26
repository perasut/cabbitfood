import 'dart:convert';

import 'package:cabbitfood/model/user_model.dart';
import 'package:cabbitfood/screens/main_rider.dart';
import 'package:cabbitfood/screens/main_shop.dart';
import 'package:cabbitfood/screens/main_user.dart';
import 'package:cabbitfood/utils/my_constant.dart';
import 'package:cabbitfood/utils/my_style.dart';
import 'package:cabbitfood/utils/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String user, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
                colors: <Color>[Colors.white, MyStyle().primaryColor],
                center: Alignment(0, -0.3),
                radius: 1.0)),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MyStyle().showLogo(),
                MyStyle().mySizeBox(),
                MyStyle().showText('Cabbit Food'),
                MyStyle().mySizeBox(),
                userForm(),
                MyStyle().mySizeBox(),
                passwordForm(),
                MyStyle().mySizeBox(),
                loginButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton() {
    return Container(
      width: 250.0,
      child: RaisedButton(
        color: MyStyle().darkColor,
        onPressed: () {
          if (user == null ||
              user.isEmpty ||
              password == null ||
              password.isEmpty) {
            normalDialog(context, 'มีช่องว่าง กรอกให้ครบด้วย');
          } else {
            checkAuthen();
          }
        },
        child: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<Null> checkAuthen() async {
    String url =
        '${MyConstant().domain}/UngPHP3/getUserWhereUser.php?isAdd=true&User=$user';
    try {
      Response response = await Dio().get(url);
      print('res = $response');
      var result = json.decode(response.data);
      print('result = $result');
      for (var map in result) {
        UserModel userModel = UserModel.fromJson(map);
        if (password == userModel.password) {
          String chooseType = userModel.chooseType;
          if (chooseType == 'User') {
            routeToService(MainUser(), userModel);
          } else if (chooseType == 'Shop') {
            routeToService(MainShop(), userModel);
          } else if (chooseType == 'Rider') {
            routeToService(Mainrider(), userModel);
          } else {
            normalDialog(context, 'error');
          }
        } else {
          normalDialog(context, 'Password ผิด กรุณาลองใหม่');
        }
      }
    } catch (e) {}
  }

  Future<Null> routeToService(Widget myWidget, UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('id', userModel.id);
    preferences.setString('ChooseType', userModel.chooseType);
    preferences.setString('Name', userModel.name);

    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget userForm() => Container(
      width: 250.0,
      child: TextField(
        onChanged: (value) => user = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.account_box,
            color: MyStyle().darkColor,
          ),
          labelStyle: TextStyle(color: MyStyle().darkColor),
          labelText: 'User',
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().darkColor)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().primaryColor)),
        ),
      ));
  Widget passwordForm() => Container(
      width: 250.0,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: MyStyle().darkColor,
          ),
          labelStyle: TextStyle(color: MyStyle().darkColor),
          labelText: 'Password',
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().darkColor)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().primaryColor)),
        ),
      ));
}
