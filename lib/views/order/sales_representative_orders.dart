import 'dart:convert';

import 'package:boszhan_sales/services/sales_rep_api_provider.dart';
import 'package:boszhan_sales/views/history_orders/history_local_products_list.dart';
import 'package:boszhan_sales/views/history_orders/order_history_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../history_orders/history_products_list.dart';
import '../home_page.dart';

class SalesRepresentativeOrders extends StatefulWidget {
  SalesRepresentativeOrders(this.salesRepName);

  final String salesRepName;

  @override
  _SalesRepresentativeOrdersState createState() =>
      _SalesRepresentativeOrdersState();
}

class _SalesRepresentativeOrdersState extends State<SalesRepresentativeOrders> {
  List<dynamic> orderHistory = [];
  List<dynamic> orderHistoryFromServer = [];

  bool localActive = true;
  bool onSending = false;

  @override
  void initState() {
    getOrderHistory();
    super.initState();
  }

  void getOrderHistoryFromServer() async {
    var result = await SalesRepProvider().getHistoryOrdersFromServer();
    if (result != 'Error') {
      setState(() {
        orderHistoryFromServer = result;
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
        orderHistory.sort((a, b) => a["mobileId"].compareTo(b["mobileId"]));
        orderHistory = orderHistory.reversed.toList();
      });
    }
  }

  void deleteLocalOrder(int ind) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      orderHistory.removeAt(ind);
      prefs.setString('OrderHistory', jsonEncode(orderHistory));
    });
  }

  void deleteOrder(int ind) async {
    var response =
        await SalesRepProvider().deleteOrder(orderHistoryFromServer[ind]['id']);
    if (response != 'Error') {
      getOrderHistoryFromServer();
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
                                      'Торговый представитель: ${widget.salesRepName}',
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
                  Row(
                    children: [
                      Spacer(),
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            getOrderHistory();
                            setState(() {
                              localActive = true;
                            });
                          },
                          label: Text(
                            "Локальные заказы",
                            style: TextStyle(color: Colors.black),
                          ),
                          icon: Icon(
                            Icons.list_alt,
                            color: Colors.black,
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: localActive ? Colors.red : Colors.grey,
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
                            getOrderHistoryFromServer();
                            setState(() {
                              localActive = false;
                            });
                          },
                          label: Text(
                            "Заказы с сервера",
                            style: TextStyle(color: Colors.black),
                          ),
                          icon: Icon(
                            Icons.list_alt,
                            color: Colors.black,
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: !localActive ? Colors.red : Colors.grey,
                            // NEW
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.58,
                      child: ListView(
                        children: [
                          for (int i = 0;
                              i <
                                  (localActive
                                      ? orderHistory.length
                                      : orderHistoryFromServer.length);
                              i++)
                            localActive
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HistoryLocalProductsList(
                                                      orderHistory[i])));
                                    },
                                    child: Card(
                                      child: ListTile(
                                        title: Text("ID магазина: " +
                                            orderHistory[i]['outletId']
                                                .toString()),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Магазин: " +
                                                orderHistory[i]['outletName']),
                                            Text("Mobile ID: " +
                                                orderHistory[i]['mobileId']),
                                            Text("Сумма покупки: " +
                                                orderHistory[i]['purchase_buy']
                                                    .toString() +
                                                " тг"),
                                            Text("Сумма возврата: " +
                                                orderHistory[i]
                                                        ['purchase_return']
                                                    .toString() +
                                                " тг"),
                                            Text("Статус: " +
                                                (orderHistory[i]['isSended']
                                                    ? " Отправлено"
                                                    : " Не отправлено")),
                                            Text("Дата: " +
                                                DateFormat('dd/MM/yyyy, HH:mm')
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            int.parse(orderHistory[
                                                                    i][
                                                                'mobileId'])))),
                                          ],
                                        ),
                                        trailing: GestureDetector(
                                          onTap: () {
                                            showAlertDialog(
                                                BuildContext context) {
                                              // set up the buttons
                                              Widget cancelButton = TextButton(
                                                child: Text("Отмена"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              );
                                              Widget continueButton =
                                                  TextButton(
                                                child: Text("Да"),
                                                onPressed: () {
                                                  deleteLocalOrder(i);
                                                  Navigator.pop(context);
                                                },
                                              );

                                              // set up the AlertDialog
                                              AlertDialog alert = AlertDialog(
                                                title: Text("Внимание"),
                                                content: Text(
                                                    "Вы точно хотите удалить заказ?"),
                                                actions: [
                                                  cancelButton,
                                                  continueButton,
                                                ],
                                              );

                                              // show the dialog
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return alert;
                                                },
                                              );
                                            }

                                            showAlertDialog(context);
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      color: orderHistory[i]['isSended']
                                          ? Colors.white
                                          : Colors.redAccent,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HistoryProductsList(
                                                      orderHistoryFromServer[
                                                          i])));
                                    },
                                    child: Card(
                                      child: ListTile(
                                        title: Text("ID заказа: " +
                                            orderHistoryFromServer[i]['id']
                                                .toString()),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("ID магазин: " +
                                                orderHistoryFromServer[i]
                                                        ['store_id']
                                                    .toString()),
                                            Text("Название: " +
                                                orderHistoryFromServer[i]
                                                    ['store']['name']),
                                            Text("Сумма покупки: " +
                                                orderHistoryFromServer[i]
                                                        ['purchase_price']
                                                    .toString() +
                                                " тг"),
                                          ],
                                        ),
                                        trailing: GestureDetector(
                                          onTap: () {
                                            showAlertDialog(
                                                BuildContext context) {
                                              // set up the buttons
                                              Widget cancelButton = TextButton(
                                                child: Text("Отмена"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              );
                                              Widget continueButton =
                                                  TextButton(
                                                child: Text("Да"),
                                                onPressed: () {
                                                  deleteOrder(i);
                                                  Navigator.pop(context);
                                                },
                                              );

                                              // set up the AlertDialog
                                              AlertDialog alert = AlertDialog(
                                                title: Text("Внимание"),
                                                content: Text(
                                                    "Вы точно хотите удалить заказ?"),
                                                actions: [
                                                  cancelButton,
                                                  continueButton,
                                                ],
                                              );

                                              // show the dialog
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return alert;
                                                },
                                              );
                                            }

                                            showAlertDialog(context);
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                        ],
                        padding: EdgeInsets.all(10),
                      )),
                  Row(
                    children: [
                      Spacer(),
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            sendDataToServer();
                          },
                          label: Text(
                            "Отправить на сервер",
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
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderHistoryPage()));
                          },
                          label: Text(
                            "История заказов",
                            style: TextStyle(color: Colors.black),
                          ),
                          icon: Icon(
                            Icons.list_alt,
                            color: Colors.black,
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.yellow[700],
                            // NEW
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ])
                    // child:
                    ),
              ),
            ],
          ),
        ));
  }

  void sendDataToServer() async {
    if (!onSending) {
      onSending = true;
      print(1);
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

              print('Succes, store ID: ' +
                  orderHistory[i]['outletId'].toString());
            } else {
              print(
                  'Error, store ID: ' + orderHistory[i]['outletId'].toString());
            }
          }
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text("Something went wrong.", style: TextStyle(fontSize: 20)),
          ));
        }

        if (i == orderHistory.length - 1) {
          onSending = false;
        }
      }
    } else {
      print(0);
    }
  }
}
