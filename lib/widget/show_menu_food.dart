import 'dart:convert';

import 'package:cabbitfood/model/cart_model.dart';
import 'package:cabbitfood/model/food_model.dart';
import 'package:cabbitfood/model/user_model.dart';
import 'package:cabbitfood/utils/my_api.dart';
import 'package:cabbitfood/utils/my_constant.dart';
import 'package:cabbitfood/utils/my_style.dart';
import 'package:cabbitfood/utils/normal_dialog.dart';
import 'package:cabbitfood/utils/sqlite_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:toast/toast.dart';

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
  int amount = 1;
  double lat1, lng1, lat2, lng2;
  Location location = Location();

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    readFoodMenu();
    findLocation();
  }

  Future<Null> findLocation() async {
    location.onLocationChanged.listen((event) {
      lat1 = event.latitude;
      lng1 = event.longitude;
      // print('lat1= $lat1 ,lng1= $lng1');
    });
  }

  Future<Null> readFoodMenu() async {
    idShop = userModel.id;
    String url =
        '${MyConstant().domain}/UngPHP3/getFoodWhereIdShop.php?isAdd=true&idShop=$idShop';
    Response response = await Dio().get(url);
    // print('resp= $response');

    var result = json.decode(response.data);
    // print('=$result');

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
                // print('index = $index');
                amount = 1;
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
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                foodModels[index].nameFood,
                style: MyStyle().mainH2Title,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 200.0,
                height: 140.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                        image: NetworkImage(
                            '${MyConstant().domain}${foodModels[index].pathImage}'),
                        fit: BoxFit.cover)),
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
                    onPressed: () {
                      setState(() {
                        amount++;
                        // print('amount = $amount');
                      });
                    },
                  ),
                  Text(
                    amount.toString(),
                    style: MyStyle().mainTitle,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      size: 36,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      if (amount > 1) {
                        setState(() {
                          amount--;
                          // print('amount = $amount');
                        });
                      }
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 110,
                    child: RaisedButton(
                      color: MyStyle().primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () {
                        Navigator.pop(context);
                        // print(
                        //     'Order ${foodModels[index].nameFood} amount = $amount');
                        addOrderToCart(index);
                      },
                      child: Text(
                        'order',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: 110,
                    child: RaisedButton(
                      color: MyStyle().primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> addOrderToCart(int index) async {
    String nameShop = userModel.nameShop;
    String idFood = foodModels[index].id;
    String nameFood = foodModels[index].nameFood;
    String price = foodModels[index].price;

    int priceInt = int.parse(price);
    int sumInt = priceInt * amount;

    lat2 = double.parse(userModel.lat);
    lng2 = double.parse(userModel.lng);
    double distance = MyAPI().calculateDistance(lat1, lng1, lat2, lng2);

    var myFormat = NumberFormat('##0.0#', 'en_us');
    String distanceString = myFormat.format(distance);

    int transport = MyAPI().calculateTransport(distance);

    print(
        'idShop=$idShop,nameShop =$nameShop,idFood =$idFood,nameFood=$nameFood,price=$price,amount=$amount,sum = $sumInt, distance = $distanceString,transport = $transport');

    Map<String, dynamic> map = Map();

    map['idShop'] = idShop;
    map['nameShop'] = nameShop;
    map['idFood'] = idFood;
    map['nameFood'] = nameFood;
    map['price'] = price;
    map['amount'] = amount.toString();
    map['sum'] = sumInt.toString();
    map['distance'] = distanceString;
    map['transport'] = transport.toString();

    print('map=${map.toString()}');

    CartModel cartModel = CartModel.fromJson(map);

    var object = await SQLiteHelper().readAllDataFromSQLite();
    print('object lenght= ${object.length}');

    if (object.length == 0) {
      await SQLiteHelper().insertDataToSQLite(cartModel).then((value) {
        print('insert success');
        showToast('insert success');
      });
    } else {
      String idShopSQLite = object[0].idShop;
      print('idShopSQLite = $idShopSQLite');
      if (idShop == idShopSQLite) {
        await SQLiteHelper().insertDataToSQLite(cartModel).then((value) {
          print('insert success');
          showToast('insert success');
        });
      } else {
        normalDialog(
          context,
          'ตะกร้ามีรายการอาหารของ ร้าน${object[0].nameShop}อยู่ กรุณาซื้อจากร้านนี้ให้จบก่อน',
        );
      }
    }
  }

  void showToast(String string) {
    Toast.show(
      string,
      context,
      duration: Toast.LENGTH_LONG,
    );
  }
}
