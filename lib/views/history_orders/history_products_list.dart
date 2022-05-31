import 'package:boszhan_sales/components/app_bar.dart';
import 'package:boszhan_sales/services/sales_rep_api_provider.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';

class HistoryProductsList extends StatefulWidget {
  HistoryProductsList(this.order);

  final Map<String, dynamic> order;

  @override
  _HistoryProductsListState createState() => _HistoryProductsListState();
}

class _HistoryProductsListState extends State<HistoryProductsList> {
  @override
  void initState() {
    super.initState();
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
                                Text('Список продуктов',
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
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ListView(
                      children: [
                        for (int i = 0; i < widget.order['baskets'].length; i++)
                          Card(
                            child: ListTile(
                              title: Text("Название: " +
                                  widget.order['baskets'][i]['product']['name']
                                      .toString()),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Количество: " +
                                      widget.order['baskets'][i]['count']
                                          .toString()),
                                  Text("Сумма: " +
                                      widget.order['baskets'][i]['all_price']
                                          .toString()),
                                ],
                              ),
                            ),
                            color: widget.order['baskets'][i]['type'] == 1
                                ? Colors.red[200]
                                : Colors.white,
                          ),
                      ],
                      padding: EdgeInsets.all(10),
                    )),
              ])))
        ]));
  }
}
