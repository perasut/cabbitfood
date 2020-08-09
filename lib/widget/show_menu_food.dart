import 'dart:convert';

import 'package:cabbitfood/model/food_model.dart';
import 'package:cabbitfood/model/user_model.dart';
import 'package:cabbitfood/utils/my_constant.dart';
import 'package:cabbitfood/utils/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ShowMenuFoodNav extends StatefulWidget {
  final UserModel userModel;
  ShowMenuFoodNav({Key key, this.userModel}) : super(key: key);

  @override
  _ShowMenuFoodNavState createState() => _ShowMenuFoodNavState();
}

class _ShowMenuFoodNavState extends State<ShowMenuFoodNav> {
  UserModel userModel;
  String idShop;
  List<FoodModel> foodModels = List();

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    readFoodMenu();
  }

  Future<Null> readFoodMenu() async {
    idShop = userModel.id;
    String url =
        '${MyConstant().domain}/UngPHP3/getFoodWhereIdShop.php?isAdd=true&idShop=$idShop';
    Response response = await Dio().get(url);
    print('resp= $response');

    var result = json.decode(response.data);
    print('=$result');

    for (var map in result) {
      FoodModel foodModel = FoodModel.fromJson(map);
      setState(() {
        foodModels.add(foodModel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return foodModels.length == 0
        ? MyStyle().showProgress()
        : ListView.builder(
            itemCount: foodModels.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                print('index = $index');
                confirmOrder(index);
              },
              child: Row(
                children: [
                  showFoodImage(context, index),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              foodModels[index].nameFood,
                              style: MyStyle().mainTitle,
                            ),
                          ],
                        ),
                        Text(
                          ' ${foodModels[index].price} บาท',
                          style: TextStyle(
                              fontSize: 25,
                              color: MyStyle().darkColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.5 - 8.0,
                              child: Text(foodModels[index].detail),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Container showFoodImage(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      width: MediaQuery.of(context).size.width * 0.5 - 16,
      height: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(
                '${MyConstant().domain}${foodModels[index].pathImage}'),
            fit: BoxFit.cover,
          )),
    );
  }

  Future<Null> confirmOrder(int index) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              foodModels[index].nameFood,
              style: MyStyle().mainH2Title,
            ),
          ],
        ),
        children: [
          Container(
            width: 150.0,
            height: 130.0,
            child: Image.network(
              '${MyConstant().domain}${foodModels[index].pathImage}',
              fit: BoxFit.contain,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    size: 36,
                    color: Colors.green,
                  ),
                  onPressed: null),
              Text(
                '1',
                style: MyStyle().mainTitle,
              ),
              IconButton(
                  icon: Icon(
                    Icons.remove_circle,
                    size: 36,
                    color: Colors.red,
                  ),
                  onPressed: null)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(width: 130,
                child: RaisedButton(
                  onPressed: () {},
                  child: Text('order'),
                ),
              ),
              Container(width: 130,
                child: RaisedButton(
                  onPressed: () {},
                  child: Text('Cancel'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
