import 'package:flutter/material.dart';

class MyStyle {
  Color darkColor = Colors.blue.shade900;
  Color primaryColor = Colors.green.shade900;

  BoxDecoration myBoxDecoration(String namePic) {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/$namePic'), fit: BoxFit.cover));
  }

  SizedBox mySizeBox() => SizedBox(
        width: 8.0,
        height: 16.0,
      );

  Widget titlecenter(BuildContext context,String string) {
    return Center(
      child: Container(width: MediaQuery.of(context).size.width*0.5,
        child: Text(
          string,
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Text showText(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 24.0,
          color: Colors.blue.shade900,
          fontWeight: FontWeight.bold,
        ),
      );

  Text showText2(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.blue.shade900,
          fontWeight: FontWeight.bold,
        ),
      );

  Container showLogo() {
    return Container(
      width: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  MyStyle();
}
