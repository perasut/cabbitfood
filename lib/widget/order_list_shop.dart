import 'dart:convert';

import 'package:cabbitfood/model/order_model.dart';
import 'package:cabbitfood/utils/my_api.dart';
import 'package:cabbitfood/utils/my_constant.dart';
import 'package:cabbitfood/utils/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderListShop extends StatefulWidget {
  OrderListShop({Key key}) : super(key: key);

  @override
  _OrderListShopState createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> {
  String idShop;
  List<OrderModel>orderModels = List();
  List<List<String>>listNameFoods = List();
  List<List<String>>listPrices = List();
  List<List<String>>listAmounts = List();
  List<List<String>>listSums = List();
  @override
  void initState() {
    super.initState();
    findIdShopAndReadOrder();
  }

  Future<Null> findIdShopAndReadOrder() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idShop = preferences.getString(MyConstant().keyID);
    // print('idshop = $idShop');

    String path =
        '${MyConstant().domain}/UngPHP3/getOrderWhereIdShop.php?isAdd=true&idShop=$idShop';
    await Dio().get(path).then((value) {
      print('value = $value');
      var result = json.decode(value.data);
      // print('result = $result');
      for (var item in result) {
        OrderModel model = OrderModel.fromJson(item);
        // print('orderDateTime = ${model.orderDateTime}');
        List<String> nameFoods = MyAPI().createStringArray(model.nameFood);
        List<String> prices = MyAPI().createStringArray(model.price);
        List<String> amountss = MyAPI().createStringArray(model.amount);
        List<String> sums = MyAPI().createStringArray(model.sum);

        setState(() {
          orderModels.add(model);
          listNameFoods.add(nameFoods);
          listPrices.add(prices);
          listAmounts.add(amountss);
          listSums.add(sums);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: orderModels.length == 0
          ? MyStyle().showProgress()
          : ListView.builder(
              itemCount: orderModels.length,
              itemBuilder: (context, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyStyle().showText2(orderModels[index].nameUser),
                  MyStyle().showText3(orderModels[index].orderDateTime),
                  buildTitle(),
                  ListView.builder(
                    itemCount: listNameFoods[index].length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index2) => Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(listNameFoods[index][index2]),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(listPrices[index][index2]),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(listAmounts[index][index2]),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(listSums[index] [index2]),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Container buildTitle() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text('Name Food')),
          Expanded(flex: 1, child: Text('Price')),
          Expanded(flex: 1, child: Text('Amount')),
          Expanded(flex: 1, child: Text('Sum')),
        ],
      ),
    );
  }
}
