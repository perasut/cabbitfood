import 'package:cabbitfood/model/cart_model.dart';
import 'package:cabbitfood/utils/my_style.dart';
import 'package:cabbitfood/utils/sqlite_helper.dart';
import 'package:flutter/material.dart';

class ShowCart extends StatefulWidget {
  ShowCart({Key key}) : super(key: key);

  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<CartModel> cartModels = List();
  int total = 0;

  @override
  void initState() {
    super.initState();
    readSQLite();
  }

  Future<Null> readSQLite() async {
    var object = await SQLiteHelper().readAllDataFromSQLite();

    for (var model in object) {
      String sumString = model.sum;
      int sumInt = int.parse(sumString);
      setState(() {
        cartModels = object;
        total = total + sumInt;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตะกร้าของฉัน'),
      ),
      body: cartModels.length == 0 ? MyStyle().showProgress() : buildContent(),
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildNameShop(),
            buildHeadTitle(),
            buildListFood(),
            Divider(),
            buildTotal(),
          ],
        ),
      ),
    );
  }

  Widget buildTotal() => Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyStyle().showText2('Total : '),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: MyStyle().showText3red(
                total.toString(),
              )),
        ],
      );

  Widget buildNameShop() {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        children: [
          Row(
            children: [
              MyStyle().showText2('ร้าน ${cartModels[0].nameShop}'),
            ],
          ),
          Row(
            children: [
              MyStyle()
                  .showText3('ระยะทาง = ${cartModels[0].distance}กิโลเมตร'),
            ],
          ),
          Row(
            children: [
              MyStyle().showText3('ค่าขนส่ง = ${cartModels[0].transport}บาท'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeadTitle() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: MyStyle().showText2('รายการอาหาร'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showText2('ราคา'),
          ),
          Expanded(
            flex: 2,
            child: MyStyle().showText2('จำนวน'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showText2('รวม'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().mySizeBox(),
          )
        ],
      ),
    );
  }

  Widget buildListFood() => ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: cartModels.length,
      itemBuilder: (context, index) => Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(cartModels[index].nameFood),
              ),
              Expanded(
                flex: 1,
                child: Text(cartModels[index].price),
              ),
              Expanded(
                flex: 2,
                child: Text(cartModels[index].amount),
              ),
              Expanded(
                flex: 1,
                child: Text(cartModels[index].sum),
              ),
              Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.delete_forever),
                    onPressed: () async {
                      int id = cartModels[index].id;
                      print('u click delete id = $id');
                      await SQLiteHelper().deleteDataWhereId(id).then((value) {
                        print('Sucess delete id =$id');
                        readSQLite();
                      });
                    },
                  ))
            ],
          ));
}
