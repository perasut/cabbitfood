import 'package:cabbitfood/utils/my_style.dart';
import 'package:cabbitfood/utils/signout_process.dart';
import 'package:flutter/material.dart';

class Mainrider extends StatefulWidget {
  Mainrider({Key key}) : super(key: key);

  @override
  _MainriderState createState() => _MainriderState();
}

class _MainriderState extends State<Mainrider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Shop'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => signOutProcess(context),
          )
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
          homeMenu(),
        ],
      ),
    );

ListTile homeMenu() => ListTile(
      leading: Icon(Icons.home),
      title: Text('รายการอาหารที่ลูกค้าสั่ง'),
      subtitle: Text('รายการอาหารที่ยังไม่ได้ส่งให้ลูกค้า'),
    );
UserAccountsDrawerHeader showHeader() {
  return UserAccountsDrawerHeader(
      decoration: MyStyle().myBoxDecoration('rider.jpg'),
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text(
        'Rider',
        style: TextStyle(color: MyStyle().darkColor),
      ),
      accountEmail: Text(
        'log in',
        style: TextStyle(color: MyStyle().primaryColor),
      ));
}
