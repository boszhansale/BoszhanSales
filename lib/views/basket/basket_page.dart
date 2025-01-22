import 'dart:convert';

import 'package:boszhan_sales/services/order_isolate_service.dart';
import 'package:boszhan_sales/services/sales_rep_api_provider.dart';
import 'package:boszhan_sales/utils/const.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  TextEditingController phoneController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  String deliveryDate = "";
  DateTime selectedDate = DateTime.now();

  List<dynamic> products = [];
  List<dynamic> returns = [];

  double sumBuy = 0;
  double sumReturn = 0;
  double sumAll = 0;

  bool isActive = true;

  List<dynamic> orderHistory = [];

  Object? _value = 1;
  Object? _value2 = 1;

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

    // Формирование корзины (как у вас)
    List<dynamic> basket = prepareBasket();

    // Сохранение данных в SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> orderHistory = saveOrderToPreferences(prefs, basket);

    // Обновление состояния
    setState(() {
      AppConstants.basket = [];
      AppConstants.basketIDs = [];
      AppConstants.basket_return = [];
      AppConstants.basketIDs_return = [];
    });

    await prefs.setBool("isBasketCompleted", true);

    // Проверка подключения
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      sendLocationData();

      // Запуск изолятов
      RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
      bool orderHistoryResult =
          await OrderIsolateService.runSendOrderHistoryIsolate(
        orderHistory,
        rootIsolateToken,
      );
      print(orderHistoryResult);
    }

    setState(() {
      isActive = true;
    });

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomePage()),
      (Route<dynamic> route) => false,
    );
  }

  List<dynamic> saveOrderToPreferences(
      SharedPreferences prefs, List<dynamic> basket) {
    String mobileId = DateTime.now().millisecondsSinceEpoch.toString();

    // Новый заказ
    Map<String, dynamic> currentOrder = {
      'basket': basket,
      'outletId': widget.outletId,
      'outletName': widget.outletName,
      'mobileId': mobileId,
      'isSended': false,
      'purchase_buy': sumBuy,
      'purchase_return': sumReturn,
      'payment_type': int.parse(_value.toString()),
      'payment_partial': int.parse(_value2.toString()) == 1,
      'amount': amountController.text,
      'delivery_date':
          deliveryDate != DateFormat("yyyy-MM-dd").format(DateTime.now())
              ? deliveryDate
              : "",
    };

    // Чтение предыдущих заказов
    List<dynamic> orderHistory = [];
    if (prefs.getString('OrderHistory') != null) {
      String? savedData = prefs.getString('OrderHistory');
      if (savedData != null && savedData != 'Error') {
        orderHistory = List.from(jsonDecode(savedData));
      }
    }

    // Добавление нового заказа
    orderHistory.add(currentOrder);

    // Сохранение обновлённой истории
    prefs.setString("OrderHistory", jsonEncode(orderHistory));

    return orderHistory;
  }

  List<dynamic> prepareBasket() {
    List<dynamic> basket = [];

    // Обработка продуктов
    for (int i = 0; i < products.length; i++) {
      basket.add({
        'product_id': products[i]['product']['id'],
        'count': products[i]['count'],
        'type': products[i]['type'],
        'name': products[i]['product']['name'],
        'price': products[i]['product']['prices'][0]['price'],
      });

      // Обработка подарков
      if (products[i]['action'] == 1) {
        int giftCount = (products[i]['count'] / 5).truncate();
        if (giftCount > 0) {
          int giftProductId;
          if (products[i]['product']['id'] == 2216) {
            giftProductId = 2707;
          } else if (products[i]['product']['id'] == 2212) {
            giftProductId = 2708;
          } else if (products[i]['product']['id'] == 798) {
            giftProductId = 2709;
          } else {
            continue;
          }

          basket.add({
            'product_id': giftProductId,
            'count': giftCount,
            'type': products[i]['type'],
            'name': "${products[i]['product']['name']} ПОДАРОК",
            'price': 1 * giftCount,
          });

          showGiftAlertDialog(
              "${products[i]['product']['name']} ПОДАРОК - $giftCount шт");
        }
      }
    }

    // Обработка возвратов
    for (int i = 0; i < returns.length; i++) {
      basket.add({
        'product_id': returns[i]['product']['id'],
        'count': returns[i]['count'],
        'type': returns[i]['type'],
        'name': returns[i]['product']['name'],
        'price': returns[i]['product']['prices'][0]['price'],
        'reason_refund_id': returns[i]['causeId'],
        'comment': returns[i]['causeComment'],
      });
    }

    return basket;
  }

  showGiftAlertDialog(String content) async {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Поздравляю!"),
      content: Text("Вы получили продукт $content по акции!"),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void sendLocationData() async {
    if (widget.outlet['lat'] == null) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      var response = await SalesRepProvider().updateOutlet(
        widget.outletId,
        position.latitude,
        position.longitude,
      );

      print(response);
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
                        const Spacer(),
                        Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                                color: Colors.yellow[700],
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 60,
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Text(
                                        'Контрагент: ${widget.counteragentName}',
                                        style: const TextStyle(fontSize: 16)),
                                    const Spacer(),
                                    Text('Торговая точка: ${widget.outletName}',
                                        style: const TextStyle(fontSize: 16)),
                                    const Spacer(),
                                    Text('Долг: ${widget.debt} тг',
                                        style: const TextStyle(fontSize: 16)),
                                    const Spacer(),
                                  ],
                                )),
                          ],
                        ),
                        const Spacer(),
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
                            const Spacer(),
                            Text('Сумма покупок: $sumBuy тг',
                                style: const TextStyle(fontSize: 16)),
                            const Spacer(),
                            Text('Сумма возврата: $sumReturn тг',
                                style: const TextStyle(fontSize: 16)),
                            const Spacer(),
                            Text('Итого к оплате: $sumAll тг',
                                style: const TextStyle(fontSize: 16)),
                            const Spacer(),
                          ],
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Row(children: [
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Icon(
                              Icons.menu,
                              size: 44,
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              share();
                            },
                            label: const Text(
                              "Отправить заказ клиенту",
                              style: TextStyle(color: Colors.black),
                            ),
                            icon: const Icon(
                              Icons.share,
                              color: Colors.black,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              // NEW
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: SizedBox(
                              width: 140,
                              child: Text(" Когда доставить: $deliveryDate",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold))),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (sumAll > 0) {
                                isActive ? displayPaymentTypeDialog() : null;
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Итоговая сумма некорректна.",
                                      style: TextStyle(fontSize: 20)),
                                ));
                              }
                            },
                            label: const Text(
                              "Подтвердить заказ",
                              style: TextStyle(color: Colors.black),
                            ),
                            icon: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.black,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              // NEW
                            ),
                          ),
                        ),
                        const Spacer(),
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
      const DataColumn(label: Text('Название')),
      const DataColumn(label: Text('кл.')),
      const DataColumn(label: Text('цена')),
      const DataColumn(label: Text('итого')),
      const DataColumn(label: Text('')),
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
                  child: const Icon(Icons.remove),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700]),
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
                  child: const Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700]),
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
            child: const Icon(
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
                      child: const Icon(Icons.remove),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[700]),
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
                      child: const Icon(Icons.add),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[700]),
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
                child: const Icon(
                  Icons.cancel,
                  size: 35,
                ),
              ))
            ]),
    ];
  }

  Future<void> displayPaymentTypeDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Выберите способ оплаты'),
            content: SizedBox(
              height: 270,
              child: Column(
                children: [
                  SizedBox(
                      height: 60,
                      child: DropdownButton(
                          value: _value,
                          items: const [
                            DropdownMenuItem(
                              child: Text("Наличный"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Без наличный"),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text("Отсрочка платежа"),
                              value: 3,
                            ),
                            DropdownMenuItem(
                              child: Text("Kaspi.kz"),
                              value: 4,
                            )
                          ],
                          onChanged: (value) {
                            setState(() {
                              _value = value;
                              Navigator.pop(context);
                              displayPaymentTypeDialog();
                            });
                          },
                          hint: const Text("Select item"))),
                  // _value == 4
                  //     ? TextFormField(
                  //         controller: phoneController,
                  //         decoration: const InputDecoration(
                  //             hintText: "Номер телефона kaspi.kz"),
                  //         keyboardType: TextInputType.phone,
                  //         inputFormatters: <TextInputFormatter>[
                  //           FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  //           _mobileFormatter,
                  //         ],
                  //         maxLength: 12,
                  //         validator: (value) {
                  //           if (value!.isEmpty) {
                  //             return 'Номер телефона';
                  //           } else if (!value.contains('+')) {
                  //             return 'Введите корректный номер телефона';
                  //           }
                  //           return null;
                  //         },
                  //       )
                  //     : Container(),
                  // _value == 4 ||
                  _value == 1
                      ? SizedBox(
                          height: 60,
                          child: DropdownButton(
                              value: _value2,
                              items: const [
                                DropdownMenuItem(
                                  child: Text("Полное погашение"),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text("Частичное погашение"),
                                  value: 2,
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _value2 = value;
                                  Navigator.pop(context);
                                  displayPaymentTypeDialog();
                                });
                              },
                              hint: const Text("Select item")))
                      : Container(),
                  // (_value2 == 2 && _value == 4) ||
                  (_value == 1 && _value2 == 2)
                      ? TextFormField(
                          controller: amountController,
                          decoration:
                              const InputDecoration(hintText: "Введите сумму"),
                          keyboardType: TextInputType.phone,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          maxLength: 30,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Введите сумму';
                            }
                            return null;
                          },
                        )
                      : Container(),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  textStyle: const TextStyle(color: Colors.white),
                ),
                child: const Text('Отмена'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  textStyle: const TextStyle(color: Colors.white),
                ),
                child: const Text('Сохранить'),
                onPressed: () async {
                  var connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    createOrder();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Соединение с интернетом отсутствует.",
                          style: TextStyle(fontSize: 20)),
                    ));
                  }
                },
              ),
            ],
          );
        });
  }
}
