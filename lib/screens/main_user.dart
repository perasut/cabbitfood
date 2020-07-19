import 'package:cabbitfood/utils/my_style.dart';
import 'package:cabbitfood/utils/signout_process.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainUser extends StatefulWidget {
  MainUser({Key key}) : super(key: key);

  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String nameUser;

  @override
  void initState() {
    super.initState();
    findUser();
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
