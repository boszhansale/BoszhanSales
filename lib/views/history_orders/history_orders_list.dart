import 'package:boszhan_sales/components/app_bar.dart';
import 'package:boszhan_sales/services/sales_rep_api_provider.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';
import 'history_products_list.dart';

class HistoryOrdersList extends StatefulWidget {
  HistoryOrdersList(this.storeId, this.storeName);

  final int storeId;
  final String storeName;

  @override
  _HistoryOrdersListState createState() => _HistoryOrdersListState();
}

class _HistoryOrdersListState extends State<HistoryOrdersList> {
  List<dynamic> orders = [];


  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    var response = await SalesRepProvider().getHistoryOrders(widget.storeId);

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
        child: Stack(children: [
          Image.asset(
            "assets/images/bbq_bg.jpg",
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
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
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.2,
                            )),
                        Spacer(),
                        Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                                color: Colors.yellow[700],
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.8,
                                height: 60,
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Text('Торговая точка: ${widget.storeName}',
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
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.6,
                        child: ListView(
                          children: [
                            for (int i = 0; i < orders.length; i++)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HistoryProductsList(orders[i])));
                                },
                                child: Card(
                                  child: ListTile(
                                    title: Text(
                                        "ID заказа: " +
                                            orders[i]['id'].toString()),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text("ID магазин: " +
                                            orders[i]['store_id'].toString()),
                                        Text("Название: " +
                                            orders[i]['store']['name']),
                                        Text("Сумма покупки: " +
                                            orders[i]['purchase_price']
                                                .toString() +
                                            " тг"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                          padding: EdgeInsets.all(10),
                        )),
                  ])))
        ]));
  }
}
