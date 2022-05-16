import 'dart:convert';

import 'package:boszhan_sales/services/sales_rep_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  @override
  void initState() {
    getOrderHistory();
    super.initState();
  }

  void getOrderHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("OrderHistory") != 'Error' &&
        prefs.getString('OrderHistory') != null) {
      setState(() {
        var data = prefs.getString("OrderHistory")!;
        orderHistory = List.from(jsonDecode(data));
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
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "История заказов",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ListView(
                      children: [
                        for (int i = 0; i < orderHistory.length; i++)
                          Card(
                            child: ListTile(
                              title: Text("ID магазина: " +
                                  orderHistory[i]['outletId'].toString()),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Магазин: " +
                                      orderHistory[i]['outletName']),
                                  Text("Mobile ID: " +
                                      orderHistory[i]['mobileId']),
                                ],
                              ),
                            ),
                            color: orderHistory[i]['isSended']
                                ? Colors.white
                                : Colors.redAccent,
                          ),
                      ],
                      padding: EdgeInsets.all(10),
                    )),
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
              ])
                  // child:
                  ),
            ),
          ],
        ));
  }

  void sendDataToServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < orderHistory.length; i++) {
      try {
        if (orderHistory[i]['isSended'] == false) {
          var response = await SalesRepProvider().createOrder(
              orderHistory[i]['outletId'],
              orderHistory[i]['mobileId'],
              orderHistory[i]['basket']);

          if (response != 'Error') {
            setState(() {
              orderHistory[i]['isSended'] = true;
              prefs.setString("OrderHistory", jsonEncode(orderHistory));
            });

            print(
                'Succes, store ID: ' + orderHistory[i]['outletId'].toString());
          } else {
            print('Error, store ID: ' + orderHistory[i]['outletId'].toString());
          }
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("Something went wrong.", style: TextStyle(fontSize: 20)),
        ));
      }
    }
  }
}
