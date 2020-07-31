import 'package:cabbitfood/screens/add_food_menu.dart';
import 'package:flutter/material.dart';

class ListFoodMenuShop extends StatefulWidget {
  ListFoodMenuShop({Key key}) : super(key: key);

  @override
  _ListFoodMenuShopState createState() => _ListFoodMenuShopState();
}

class _ListFoodMenuShopState extends State<ListFoodMenuShop> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[Text('รายการอาหาร'), addMenuButton()],
    );
  }

  Widget addMenuButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 16.0, right: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => AddFoodMenu(),
                  );
                  Navigator.push(context, route);
                },
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
