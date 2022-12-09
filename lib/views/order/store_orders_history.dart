import 'dart:convert';

import 'package:boszhan_sales/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/sales_rep_api_provider.dart';
import '../basket/basket_page.dart';
import '../home_page.dart';

class StoreOrdersHistory extends StatefulWidget {
  StoreOrdersHistory(
      this.outletName,
      this.outletDiscount,
      this.outletId,
      this.counteragentID,
      this.counteragentName,
      this.counteragentDiscount,
      this.priceTypeId,
      this.debt,
      this.outlet,
      this.discount);

  final String outletName;
  final int outletDiscount;
  final int outletId;
  final int counteragentID;
  final String counteragentName;
  final int counteragentDiscount;
  final int priceTypeId;
  final String debt;
  final Map<String, dynamic> outlet;
  final int discount;

  @override
  State<StoreOrdersHistory> createState() => _StoreOrdersHistoryState();
}

class _StoreOrdersHistoryState extends State<StoreOrdersHistory> {
  List<dynamic> orders = [];
  List<dynamic> products = [];

  @override
  void initState() {
    getData();
    getProductsFromPrefs();
    super.initState();
  }

  void getProductsFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("responseProducts")!;
    setState(() {
      products = List.from(jsonDecode(data));
    });
  }

  void getData() async {
    var response = await SalesRepProvider().getHistoryOrders(widget.outletId);
    // print(response);

    if (response != 'Error') {
      setState(() {
        orders = response;
      });
    }
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
                backgroundColor: Colors.white.withOpacity(0.85),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
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
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                    color: Colors.yellow[700],
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: 60,
                                    child: Row(
                                      children: [
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.22,
                                          child: Text(
                                            'Контрагент: ${widget.counteragentName}',
                                            style: TextStyle(fontSize: 16),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.28,
                                          child: Text(
                                            'Торговая точка: ${widget.outletName}',
                                            style: TextStyle(fontSize: 16),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          child: Text(
                                            'Долг: ${widget.debt} тг',
                                            style: TextStyle(fontSize: 16),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BasketPage(
                                                            widget.outletName,
                                                            widget.outletId,
                                                            widget
                                                                .counteragentID,
                                                            widget
                                                                .counteragentName,
                                                            widget.discount,
                                                            widget.priceTypeId,
                                                            widget.debt,
                                                            widget
                                                                .outlet))).then(
                                                (_) => setState(() {}));
                                          },
                                          child: Icon(
                                            Icons.shopping_cart_outlined,
                                            size: 40,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                      Divider(
                        color: Colors.yellow[700],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: ListView(
                            children: [
                              for (int i = 0; i < orders.length; i++)
                                Card(
                                  child: ExpansionTile(
                                    title: Text("ID заказа: " +
                                        orders[i]['id'].toString()),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "Сумма покупки: " +
                                                    orders[i]['purchase_price']
                                                        .toString() +
                                                    " тг",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              for (int j = 0;
                                                  j <
                                                      orders[i]['baskets']
                                                          .length;
                                                  j++)
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 3.0),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                        child: Text(
                                                          orders[i]['baskets']
                                                                  [j]['product']
                                                              ['name'],
                                                          style: TextStyle(
                                                              color: orders[i]['baskets']
                                                                              [
                                                                              j]
                                                                          [
                                                                          'type'] ==
                                                                      1
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .black),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                          '${orders[i]['baskets'][j]['price'].toString()} тг'),
                                                      Spacer(),
                                                      Text(
                                                          'x${orders[i]['baskets'][j]['count'].toString()}'),
                                                      Spacer(),
                                                      Text(
                                                          '${orders[i]['baskets'][j]['all_price'].toString()} тг'),
                                                      Spacer(),
                                                    ],
                                                  ),
                                                )
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                          ),
                                        ),
                                      ),
                                    ],
                                    trailing: GestureDetector(
                                      onTap: () {
                                        showAlertDialog(BuildContext context) {
                                          // set up the buttons
                                          Widget cancelButton = TextButton(
                                            child: Text("Отмена"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          );
                                          Widget continueButton = TextButton(
                                            child: Text("Да"),
                                            onPressed: () {
                                              addProductsToBasket(i);
                                              Navigator.pop(context);
                                            },
                                          );

                                          // set up the AlertDialog
                                          AlertDialog alert = AlertDialog(
                                            title: Text("Внимание"),
                                            content: Text(
                                                "Вы хотите повторить заказ?"),
                                            actions: [
                                              cancelButton,
                                              continueButton,
                                            ],
                                          );

                                          // show the dialog
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            },
                                          );
                                        }

                                        showAlertDialog(context);
                                      },
                                      child: Icon(
                                        Icons.refresh,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                            padding: EdgeInsets.all(10),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void addProductsToBasket(int i) async {
    List<dynamic> basket = [];
    List<int> basketIDs = [];
    List<dynamic> basket_return = [];
    List<int> basketIDs_return = [];

    for (int j = 0; j < orders[i]['baskets'].length; j++) {
      for (int k = 0; k < products.length; k++) {
        if (orders[i]['baskets'][j]['product']['id'] == products[k]['id']) {
          if (orders[i]['baskets'][j]['type'] == 0) {
            basket.add({
              'product': products[k],
              'count':
                  double.parse(orders[i]['baskets'][j]['count'].toString()),
              'type': orders[i]['baskets'][j]['type']
            });
            basketIDs.add(orders[i]['baskets'][j]['product']['id']);
          } else {
            basket_return.add({
              'product': products[k],
              'count':
                  double.parse(orders[i]['baskets'][j]['count'].toString()),
              'type': orders[i]['baskets'][j]['type']
            });
            basketIDs_return.add(orders[i]['baskets'][j]['product']['id']);
          }
        }
      }
    }

    setState(() {
      AppConstants.basket = basket;
      AppConstants.basketIDs = basketIDs;
      AppConstants.basket_return = basket_return;
      AppConstants.basketIDs_return = basketIDs_return;
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Добавлено в корзину.", style: TextStyle(fontSize: 20)),
    ));
  }
}
