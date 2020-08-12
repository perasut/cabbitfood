import 'package:cabbitfood/screens/show_cart.dart';
import 'package:flutter/material.dart';

class MyStyle {
  Color darkColor = Colors.blue.shade900;
  Color primaryColor = Colors.green.shade900;

  Widget iconShowCart(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add_shopping_cart),
      onPressed: () {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowCart(),
        );
        Navigator.push(context, route);
      },
    );
  }

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  TextStyle mainTitle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.purple,
  );

  TextStyle mainH2Title = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.green.shade700,
  );

  BoxDecoration myBoxDecoration(String namePic) {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/$namePic'), fit: BoxFit.cover));
  }

  SizedBox mySizeBox() => SizedBox(
        width: 8.0,
        height: 16.0,
      );

  Widget titlecenter(BuildContext context, String string) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
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

  Text showText3(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blue.shade900,
          fontWeight: FontWeight.bold,
        ),
      );

        Text showText3red(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.red.shade900,
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
