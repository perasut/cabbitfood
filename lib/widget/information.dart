import 'package:cabbitfood/screens/add_info_shop.dart';
import 'package:cabbitfood/utils/my_style.dart';
import 'package:flutter/material.dart';

class Information extends StatefulWidget {
  Information({Key key}) : super(key: key);

  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        MyStyle().titlecenter(context, 'ยังไม่มีข้อมูล กรุณาเพิ่มข้อมูล'),
        addAndEditButton()
      ],
    );
  }

  Row addAndEditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
                child: FloatingActionButton(
                  child: Icon(Icons.edit),
                  onPressed: () {
                    roueToAddInfo();
                  },
                )),
          ],
        ),
      ],
    );
  }

  void roueToAddInfo() {
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => AddInfoShop(),
    );
    Navigator.push(context, materialPageRoute);
  }
}
