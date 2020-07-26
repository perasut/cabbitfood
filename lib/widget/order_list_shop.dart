import 'package:cabbitfood/model/user_model.dart';
import 'package:flutter/material.dart';


class OrderListShop extends StatefulWidget {
  OrderListShop({Key key}) : super(key: key);

  @override
  _OrderListShopState createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> { 

  UserModel userModel;
  @override
  void initState() {
    
    super.initState();
    

  }



  @override
  Widget build(BuildContext context) {
    return Text('รายการอาหาร ที่ลูกค้าสั่ง'
       
    );
  }
}