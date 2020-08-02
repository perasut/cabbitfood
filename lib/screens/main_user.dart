import 'dart:convert';

import 'package:cabbitfood/model/user_model.dart';
import 'package:cabbitfood/utils/my_constant.dart';
import 'package:cabbitfood/utils/my_style.dart';
import 'package:cabbitfood/utils/signout_process.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainUser extends StatefulWidget {
  MainUser({Key key}) : super(key: key);

  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String nameUser;
  List<UserModel> userModels = List();

  @override
  void initState() {
    super.initState();
    findUser();
    readShop();
  }

  Future<Null> readShop() async {
    String url =
        '${MyConstant().domain}//UngPHP3/getUserWhereChooseType.php?isAdd=true&ChooseType=Shop';
    await Dio().get(url).then((value) {
      // print('value = $value');
      var result = json.decode(value.data);
      for (var map in result) {
        UserModel model = UserModel.fromJson(map);
        // print('nameShop = ${model.nameShop}');
        String nameShop = model.nameShop;
       if (nameShop.isNotEmpty) {
         print('nameShop = ${model.nameShop}');
          setState(() {
          userModels.add(model);
        });
       }

        
      }
    });
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameUser == null ? 'Main User' : '$nameUser login'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => signOutProcess(context))
        ],
      ),
      drawer: showDrawer(),
    );
  }
}

Drawer showDrawer() => Drawer(
      child: ListView(
        children: <Widget>[
          showHeader(),
        ],
      ),
    );
UserAccountsDrawerHeader showHeader() {
  return UserAccountsDrawerHeader(
      decoration: MyStyle().myBoxDecoration('user.jpg'),
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text(
        'sdo',
        style: TextStyle(color: MyStyle().darkColor),
      ),
      accountEmail: Text(
        'sudo@gmail.com',
        style: TextStyle(color: MyStyle().primaryColor),
      ));
}
