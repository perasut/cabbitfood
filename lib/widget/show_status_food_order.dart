import 'dart:convert';

import 'package:cabbitfood/model/order_model.dart';
import 'package:cabbitfood/utils/my_constant.dart';
import 'package:cabbitfood/utils/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowStatusFoodOrder extends StatefulWidget {
  @override
  _ShowStatusFoodOrderState createState() => _ShowStatusFoodOrderState();
}

class _ShowStatusFoodOrderState extends State<ShowStatusFoodOrder> {
  String idUser;
  bool statusOrder = true;
  List<OrderModel> orderModels = List();
  List<List<String>> listMenuFoods = List();
  List<List<String>> listPrices = List();
  List<List<String>> listAmounts = List();
  List<List<String>> listSums = List();
  List<int> totalInts = List();

  @override
  void initState() {
    super.initState();
    findUser();
  }

  @override
  Widget build(BuildContext context) {
    return statusOrder ? buildNoneOrder() : buildContent();
  }

  Widget buildContent() => ListView.builder(
        padding: EdgeInsets.all(16),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: orderModels.length,
        itemBuilder: (context, index) => Column(
          children: [
            MyStyle().mySizeBox(),
            buildNameShop(index),
            buildDatetimeOrder(index),
            buildDistance(index),
            buildTransport(index),
            buildHead(),
            buildListViewMenuFood(index),
            showTotal(index),
            MyStyle().mySizeBox(),
          ],
        ),
      );

  Widget showTotal(int index) => Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyStyle().showText3red('รวมราคาอาหาร '),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyStyle().showText3Purple(totalInts[index].toString()),
              ],
            ),
          ),
        ],
      );

  ListView buildListViewMenuFood(int index) => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: listMenuFoods.length,
        itemBuilder: (context, index2) => Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(listMenuFoods[index][index2]),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(listPrices[index][index2]),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(listAmounts[index][index2]),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    listSums[index][index2],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Container buildHead() {
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(color: Colors.grey),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: MyStyle().showText3White('รายการอาหาร'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showText3White('ราคา'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showText3White('จำนวน'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showText3White('ผลรวม'),
          ),
        ],
      ),
    );
  }

  Row buildTransport(int index) {
    return Row(
      children: [
        MyStyle()
            .showText3Purple('ค่าขนส่ง ${orderModels[index].transport}บาท'),
      ],
    );
  }

  Row buildDistance(int index) {
    return Row(
      children: [
        MyStyle()
            .showText3red('ระยะทาง ${orderModels[index].distance}กิโลเมตร'),
      ],
    );
  }

  Row buildDatetimeOrder(int index) {
    return Row(
      children: [
        MyStyle()
            .showText3('วันเวลาที่ order ${orderModels[index].orderDateTime}'),
      ],
    );
  }

  Row buildNameShop(int index) {
    return Row(
      children: [
        MyStyle().showText2('ร้าน ${orderModels[index].nameShop}'),
      ],
    );
  }

  Center buildNoneOrder() => Center(child: Text('ยังไม่มีข้อมูล การสั่งอาหาร'));

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idUser = preferences.getString('id');
    print('idUser= $idUser');
    readOrderFromIdUser();
  }

  Future<Null> readOrderFromIdUser() async {
    if (idUser != null) {
      String url =
          '${MyConstant().domain}/UngPHP3/getOrderWhereIdUser.php?isAdd=true&idUser=$idUser';

      Response response = await Dio().get(url);
      print('respose ==> $response');
      if (response.toString() != 'null') {
        var result = json.decode(response.data);
        for (var map in result) {
          OrderModel model = OrderModel.fromJson(map);
          List<String> menuFoods = changeArrey(model.nameFood);
          List<String> prices = changeArrey(model.price);
          List<String> amounts = changeArrey(model.amount);
          List<String> sums = changeArrey(model.sum);
          // print('menuFoods ==>> $menuFoods');

          int total = 0;
          for (var string in sums) {
            total = total + int.parse(string.trim());
          }
          print('total = $total');
          setState(() {
            statusOrder = false;
            orderModels.add(model);
            listMenuFoods.add(menuFoods);
            listPrices.add(prices);
            listAmounts.add(amounts);
            listSums.add(sums);
            totalInts.add(total);
          });
        }
      }
    }
  }

  List<String> changeArrey(String string) {
    List<String> list = List();
    String myString = string.substring(1, string.length - 1);
    print('= $myString');
    list = myString.split(',');
    int index = 0;
    for (var string in list) {
      list[index] = string.trim();
      index++;
    }
    return list;
  }
}
