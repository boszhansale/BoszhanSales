import 'dart:convert';

import 'package:boszhan_sales/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';

class BasketPage extends StatefulWidget {
  BasketPage(this.outletName, this.outletId, this.counteragentID,
      this.counteragentName, this.discount, this.priceTypeId, this.debt);
  final String outletName;
  final int outletId;
  final int counteragentID;
  final String counteragentName;
  final int discount;
  final int priceTypeId;
  final String debt;
  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  List<TextEditingController> productsTextFieldControllers = [];
  List<TextEditingController> returnsTextFieldControllers = [];

  List<dynamic> products = [];
  List<dynamic> returns = [];

  double sumBuy = 0;
  double sumReturn = 0;
  double sumAll = 0;

  @override
  void initState() {
    getBasket();
    calculateSum();
    createTextFieldControllers();
    super.initState();
  }

  void createTextFieldControllers() {
    for (int i = 0; i < products.length; i++) {
      final controller = TextEditingController();
      controller.text = products[i]['count'].toString();
      productsTextFieldControllers.add(controller);
    }

    for (int i = 0; i < returns.length; i++) {
      final controller = TextEditingController();
      controller.text = returns[i]['count'].toString();
      returnsTextFieldControllers.add(controller);
    }
  }

  getBasket() async {
    products = [];
    returns = [];
    for (int i = 0; i < AppConstants.basket.length; i++) {
      if (AppConstants.basket[i]['type'] == 0) {
        products.add(AppConstants.basket[i]);
      } else {
        returns.add(AppConstants.basket[i]);
      }
    }
  }

  void calculateSum() {
    double sum1 = 0;
    double sum2 = 0;

    for (int i = 0; i < products.length; i++) {
      sum1 += (products[i]['count'] *
          (products[i]['product']['prices']
                  .where((e) => e['price_type_id'] == widget.priceTypeId)
                  .toList()[0]['price'] *
              (100 -
                  (widget.discount == 0
                      ? products[i]['product']['discount']
                      : widget.discount)) /
              100));
    }

    for (int j = 0; j < returns.length; j++) {
      sum2 += (returns[j]['count'] *
          (returns[j]['product']['prices']
                  .where((e) => e['price_type_id'] == widget.priceTypeId)
                  .toList()[0]['price'] *
              (100 -
                  (widget.discount == 0
                      ? returns[j]['product']['discount']
                      : widget.discount)) /
              100));
    }

    sumBuy = sum1;
    sumReturn = sum2;
    sumAll = sumBuy - sumReturn;
  }

  void createOrder() async {
    List<dynamic> basket = [];
    for (int i = 0; i < products.length; i++) {
      basket.add({
        'product_id': products[i]['product']['id'],
        'count': products[i]['count'],
        'type': products[i]['type']
      });
    }

    for (int i = 0; i < returns.length; i++) {
      basket.add({
        'product_id': returns[i]['product']['id'],
        'count': returns[i]['count'],
        'type': returns[i]['type']
      });
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mobileId = DateTime.now().millisecondsSinceEpoch.toString();

    if (prefs.getString('OrderHistory') == null) {
      List<Map<String, dynamic>> savedData = [];
      Map<String, dynamic> thisMap = {};
      thisMap['basket'] = basket;
      thisMap['outletId'] = widget.outletId;
      thisMap['outletName'] = widget.outletName;
      thisMap['mobileId'] = mobileId;
      thisMap['isSended'] = false;
      savedData.add(thisMap);
      prefs.setString("OrderHistory", jsonEncode(savedData));
    } else {
      var data = prefs.getString("OrderHistory")!;
      if (data != 'Error') {
        setState(() {
          List<dynamic> savedData = List.from(jsonDecode(data));
          Map<String, dynamic> thisMap = {};
          thisMap['basket'] = basket;
          thisMap['outletId'] = widget.outletId;
          thisMap['outletName'] = widget.outletName;
          thisMap['mobileId'] = mobileId;
          thisMap['isSended'] = false;
          savedData.add(thisMap);
          prefs.setString("OrderHistory", jsonEncode(savedData));
        });
      }
    }

    setState(() {
      AppConstants.basket = [];
      AppConstants.basketIDs = [];
      Navigator.of(context).pop();
    });
    prefs.setBool("isBasketCompleted", true);
  }

  Future<void> share() async {
    String text = '';
    for (int i = 0; i < products.length; i++) {
      text += products[i]['product']['name'] +
          "  " +
          products[i]['count'].toString() +
          'шт - покупка; ' +
          "\n";
    }
    for (int i = 0; i < returns.length; i++) {
      text += returns[i]['product']['name'] +
          "  " +
          returns[i]['count'].toString() +
          'шт - возврат; ' +
          "\n";
    }
    await FlutterShare.share(
      title: 'Первомайские деликатесы',
      text: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: [
            Image.asset(
              "assets/images/bbq_bg.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Scaffold(
                backgroundColor: Colors.white.withOpacity(0.85),
                body: SingleChildScrollView(
                    child: Column(children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          },
                          child: SizedBox(
                            child: Image.asset("assets/images/logo.png"),
                            width: MediaQuery.of(context).size.width * 0.2,
                          )),
                      Spacer(),
                      Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                              color: Colors.yellow[700],
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 60,
                              child: Row(
                                children: [
                                  Spacer(),
                                  Text('Контрагент: ${widget.counteragentName}',
                                      style: TextStyle(fontSize: 16)),
                                  Spacer(),
                                  Text('Торговая точка: ${widget.outletName}',
                                      style: TextStyle(fontSize: 16)),
                                  Spacer(),
                                  Text('Долг: ${widget.debt} тг',
                                      style: TextStyle(fontSize: 16)),
                                  Spacer(),
                                ],
                              )),
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                  Divider(
                    color: Colors.yellow[700],
                  ),
                  _createDataTable(),
                  Container(
                      color: Colors.yellow[700],
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Row(
                        children: [
                          Spacer(),
                          Text('Сумма покупок: $sumBuy тг',
                              style: TextStyle(fontSize: 16)),
                          Spacer(),
                          Text('Сумма возврата: $sumReturn тг',
                              style: TextStyle(fontSize: 16)),
                          Spacer(),
                          Text('Итого к оплате: $sumAll тг',
                              style: TextStyle(fontSize: 16)),
                          Spacer(),
                        ],
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Row(children: [
                      Spacer(),
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            share();
                          },
                          label: Text(
                            "Отправить заказ клиенту",
                            style: TextStyle(color: Colors.black),
                          ),
                          icon: Icon(
                            Icons.share,
                            color: Colors.black,
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            // NEW
                          ),
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            createOrder();
                          },
                          label: Text(
                            "Подтвердить заказ",
                            style: TextStyle(color: Colors.black),
                          ),
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.black,
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green[700],
                            // NEW
                          ),
                        ),
                      ),
                      Spacer(),
                    ]),
                  )
                ]))),
          ],
        ));
  }

  Theme _createDataTable() {
    return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.yellow[700]),
        child: SizedBox(
          // height: MediaQuery.of(context).size.height * 0.55,
          width: MediaQuery.of(context).size.width,
          child: DataTable(
            showCheckboxColumn: false,
            columns: _createColumns(),
            rows: _createRows(),
            dataRowHeight: 80,
          ),
        ));
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('Название')),
      DataColumn(label: Text('кл.')),
      DataColumn(label: Text('цена')),
      DataColumn(label: Text('итого')),
      DataColumn(label: Text('')),
    ];
  }

  List<DataRow> _createRows() {
    return [
      for (int i = 0; i < products.length; i++)
        DataRow(onSelectChanged: (newValue) {}, cells: [
          DataCell(Text(products[i]['product']['name'])),
          DataCell(Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (products[i]['count'] > 1) {
                        products[i]['count'] -= 1;
                        productsTextFieldControllers[i].text =
                            products[i]['count'].toString();
                      }
                      calculateSum();
                    });
                  },
                  child: Icon(Icons.remove),
                  style: ElevatedButton.styleFrom(primary: Colors.yellow[700]),
                ),
              ),
              SizedBox(
                width: 40,
                child: TextFormField(
                  onChanged: (text) {
                    setState(() {
                      try {
                        products[i]['count'] = double.parse(text);
                      } catch (e) {
                        print(e);
                      }
                    });
                  },
                  textAlign: TextAlign.center,
                  controller: productsTextFieldControllers[i],
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      products[i]['count'] += 1;
                      productsTextFieldControllers[i].text =
                          products[i]['count'].toString();
                      calculateSum();
                    });
                  },
                  child: Icon(Icons.add),
                  style: ElevatedButton.styleFrom(primary: Colors.yellow[700]),
                ),
              ),
            ],
          )),
          DataCell(Text((products[i]['product']['prices']
                      .where((e) => e['price_type_id'] == widget.priceTypeId)
                      .toList()[0]['price'] *
                  (100 -
                      (widget.discount == 0
                          ? products[i]['product']['discount']
                          : widget.discount)) /
                  100)
              .toString())),
          DataCell(Text((products[i]['count'] *
                  (products[i]['product']['prices']
                          .where(
                              (e) => e['price_type_id'] == widget.priceTypeId)
                          .toList()[0]['price'] *
                      (100 -
                          (widget.discount == 0
                              ? products[i]['product']['discount']
                              : widget.discount)) /
                      100))
              .toString())),
          DataCell(GestureDetector(
            onTap: () {
              setState(() {
                AppConstants.basketIDs.remove(products[i]['product']['id']);
                AppConstants.basket.remove(products[i]);
                products.remove(products[i]);
              });
            },
            child: Icon(
              Icons.cancel,
              size: 35,
            ),
          ))
        ]),
      for (int i = 0; i < returns.length; i++)
        DataRow(
            color: MaterialStateColor.resolveWith(
                (states) => Colors.redAccent.withOpacity(0.3)),
            onSelectChanged: (newValue) {},
            cells: [
              DataCell(Text(returns[i]['product']['name'])),
              DataCell(Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (returns[i]['count'] > 1) {
                            returns[i]['count'] -= 1;
                            returnsTextFieldControllers[i].text =
                                returns[i]['count'].toString();
                          }
                          calculateSum();
                        });
                      },
                      child: Icon(Icons.remove),
                      style:
                          ElevatedButton.styleFrom(primary: Colors.yellow[700]),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: TextFormField(
                      onChanged: (text) {
                        setState(() {
                          try {
                            returns[i]['count'] = double.parse(text);
                          } catch (e) {
                            print(e);
                          }
                        });
                      },
                      textAlign: TextAlign.center,
                      controller: returnsTextFieldControllers[i],
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          returns[i]['count'] += 1;
                          returnsTextFieldControllers[i].text =
                              returns[i]['count'].toString();
                          calculateSum();
                        });
                      },
                      child: Icon(Icons.add),
                      style:
                          ElevatedButton.styleFrom(primary: Colors.yellow[700]),
                    ),
                  ),
                ],
              )),
              DataCell(Text((returns[i]['product']['prices']
                          .where(
                              (e) => e['price_type_id'] == widget.priceTypeId)
                          .toList()[0]['price'] *
                      (100 -
                          (widget.discount == 0
                              ? returns[i]['product']['discount']
                              : widget.discount)) /
                      100)
                  .toString())),
              DataCell(Text((returns[i]['count'] *
                      (returns[i]['product']['prices']
                              .where((e) =>
                                  e['price_type_id'] == widget.priceTypeId)
                              .toList()[0]['price'] *
                          (100 -
                              (widget.discount == 0
                                  ? returns[i]['product']['discount']
                                  : widget.discount)) /
                          100))
                  .toString())),
              DataCell(GestureDetector(
                onTap: () {
                  setState(() {
                    AppConstants.basketIDs.remove(returns[i]['product']['id']);
                    AppConstants.basket.remove(returns[i]);
                    returns.remove(returns[i]);
                  });
                },
                child: Icon(
                  Icons.cancel,
                  size: 35,
                ),
              ))
            ]),
    ];
  }
}
