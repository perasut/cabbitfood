import 'package:cabbitfood/utils/my_style.dart';
import 'package:cabbitfood/utils/signout_process.dart';
import 'package:cabbitfood/widget/information.dart';
import 'package:cabbitfood/widget/list_food_menu_shop.dart';
import 'package:cabbitfood/widget/order_list_shop.dart';
import 'package:flutter/material.dart';

class MainShop extends StatefulWidget {
  @override
  _MainShopState createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  Widget currentWidget = OrderListShop();
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
      body: currentWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeader(),
            homeMenu(),
            foodMenu(),
            informationMenu(),
            signoutMenu(),
          ],
        ),
      );

  ListTile homeMenu() => ListTile(
        leading: Icon(Icons.home),
        title: Text('รายการอาหารที่ลูกค้าสั่ง'),
        subtitle: Text('รายการอาหารที่ยังไม่ได้ส่งให้ลูกค้า'),
        onTap: () {
          setState(() {
            currentWidget = OrderListShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile foodMenu() => ListTile(
        leading: Icon(Icons.fastfood),
        title: Text('รายการอาหาร'),
        subtitle: Text('รายการอาหาร ของร้าน'),
        onTap: () {
          setState(() {
            currentWidget = ListFoodMenuShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile informationMenu() => ListTile(
        leading: Icon(Icons.info),
        title: Text('รายละเอียดของร้าน'),
        subtitle: Text('รายละเอียดของร้าน พร้อมedit'),
        onTap: () {
          setState(() {
            currentWidget = Information();
          });
          Navigator.pop(context);
        },
      );

  ListTile signoutMenu() => ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Sign Out'),
        subtitle: Text('Sign Out และกลับไปหน้าแรก'),
        onTap: () => signOutProcess(context),
      );

  UserAccountsDrawerHeader showHeader() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxDecoration('shop.jpg'),
        currentAccountPicture: MyStyle().showLogo(),
        accountName: Text(
          'shop',
          style: TextStyle(color: MyStyle().darkColor),
        ),
        accountEmail: Text(
          'sudo@gmail.com',
          style: TextStyle(color: MyStyle().primaryColor),
        ));
  }
}
