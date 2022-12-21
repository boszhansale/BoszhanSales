import 'dart:convert';

import 'package:boszhan_sales/utils/const.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/sales_rep_api_provider.dart';
import '../home_page.dart';

class BasketPage extends StatefulWidget {
  BasketPage(
      this.outletName,
      this.outletId,
      this.counteragentID,
      this.counteragentName,
      this.discount,
      this.priceTypeId,
      this.debt,
      this.outlet);

  final String outletName;
  final int outletId;
  final int counteragentID;
  final String counteragentName;
  final int discount;
  final int priceTypeId;
  final String debt;
  final Map<String, dynamic> outlet;

  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  List<TextEditingController> productsTextFieldControllers = [];
  List<TextEditingController> returnsTextFieldControllers = [];

  String deliveryDate = "";
  DateTime selectedDate = DateTime.now();

  List<dynamic> products = [];
  List<dynamic> returns = [];

  double sumBuy = 0;
  double sumReturn = 0;
  double sumAll = 0;

  bool isActive = true;

  List<dynamic> orderHistory = [];

  @override
  void initState() {
    getBasket();
    calculateSum();
    createTextFieldControllers();

    String datetime = DateFormat("yyyy-MM-dd").format(selectedDate);
    deliveryDate = datetime;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectDate(context);
    });

    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.weekday != 6 || selectedDate.weekday != 7
          ? selectedDate
          : selectedDate.weekday == 6
              ? selectedDate.add(const Duration(days: 1))
              : selectedDate.add(const Duration(days: 2)),
      firstDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime val) =>
          val.weekday == 6 || val.weekday == 7 ? false : true,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        deliveryDate = DateFormat("yyyy-MM-dd").format(picked);
      });
    }
  }

  void getOrderHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("OrderHistory") != 'Error' &&
        prefs.getString('OrderHistory') != null) {
      setState(() {
        var data = prefs.getString("OrderHistory")!;
        orderHistory = List.from(jsonDecode(data));
        orderHistory = orderHistory.reversed.toList();
      });
    }
  }

  void sendDataToServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < orderHistory.length; i++) {
      try {
        if (orderHistory[i]['isSended'] == false) {
          var response = await SalesRepProvider().createOrder(
              orderHistory[i]['outletId'],
              orderHistory[i]['mobileId'],
              orderHistory[i]['basket'],
              orderHistory[i]['delivery_date']);

          if (response != 'Error') {
            setState(() {
              orderHistory[i]['isSended'] = true;
              prefs.setString("OrderHistory", jsonEncode(orderHistory));
            });

            print(
                'Succes, store ID: ' + orderHistory[i]['outletId'].toString());
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false);
          } else {
            print('Error, store ID: ' + orderHistory[i]['outletId'].toString());
          }
          setState(() {
            isActive = true;
          });
        }
      } catch (error) {
        setState(() {
          isActive = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("Something went wrong.", style: TextStyle(fontSize: 20)),
        ));
      }
    }
  }

  void checkAndSendLocation() async {
    if (widget.outlet['lat'] == null) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      var response = await SalesRepProvider()
          .updateOutlet(widget.outletId, position.latitude, position.longitude);
      print(response);
    }
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
    products = AppConstants.basket;
    returns = AppConstants.basket_return;
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
    setState(() {
      isActive = false;
    });
    List<dynamic> basket = [];
    for (int i = 0; i < products.length; i++) {
      basket.add({
        'product_id': products[i]['product']['id'],
        'count': products[i]['count'],
        'type': products[i]['type'],
        'name': products[i]['product']['name'],
        'price': products[i]['product']['prices'][0]['price'],
      });
    }

    for (int i = 0; i < returns.length; i++) {
      basket.add({
        'product_id': returns[i]['product']['id'],
        'count': returns[i]['count'],
        'type': returns[i]['type'],
        'name': returns[i]['product']['name'],
        'price': returns[i]['product']['prices'][0]['price'],
        'reason_refund_id': returns[i]['causeId'],
        'comment': returns[i]['causeComment']
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
      thisMap['purchase_buy'] = sumBuy;
      thisMap['purchase_return'] = sumReturn;
      thisMap['isSended'] = false;
      if (deliveryDate != DateFormat("yyyy-MM-dd").format(DateTime.now())) {
        thisMap['delivery_date'] = deliveryDate;
      } else {
        thisMap['delivery_date'] = "";
      }

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
          thisMap['purchase_buy'] = sumBuy;
          thisMap['purchase_return'] = sumReturn;
          if (deliveryDate != DateFormat("yyyy-MM-dd").format(DateTime.now())) {
            thisMap['delivery_date'] = deliveryDate;
          } else {
            thisMap['delivery_date'] = "";
          }

          savedData.add(thisMap);
          prefs.setString("OrderHistory", jsonEncode(savedData));
        });
      }
    }

    setState(() {
      AppConstants.basket = [];
      AppConstants.basketIDs = [];
      AppConstants.basket_return = [];
      AppConstants.basketIDs_return = [];
    });
    prefs.setBool("isBasketCompleted", true);

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      getOrderHistory();
      sendDataToServer();
      checkAndSendLocation();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      getOrderHistory();
      sendDataToServer();
      checkAndSendLocation();
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false);
    }
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
        child: WillPopScope(
          onWillPop: () async => false,
          child: Stack(
            children: [
              Image.asset(
                "assets/images/bbq_bg.jpg",
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Scaffold(
                  backgroundColor: Colors.transparent,
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
                                    Text(
                                        'Контрагент: ${widget.counteragentName}',
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
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Icon(
                              Icons.menu,
                              size: 44,
                            ),
                          ),
                        ),
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
                        GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: SizedBox(
                              width: 140,
                              child: Text(" Когда доставить: $deliveryDate",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold))),
                        ),
                        Spacer(),
                        SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (sumAll > 0) {
                                isActive ? createOrder() : null;
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Итоговая сумма некорректна.",
                                      style: TextStyle(fontSize: 20)),
                                ));
                              }
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
          ),
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
                calculateSum();
                // products.remove(products[i]);
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
                    AppConstants.basketIDs_return
                        .remove(returns[i]['product']['id']);
                    AppConstants.basket_return.remove(returns[i]);
                    // returns.remove(returns[i]);
                    calculateSum();
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
