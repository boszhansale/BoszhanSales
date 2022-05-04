import 'package:boszhan_sales/utils/const.dart';
import 'package:flutter/material.dart';

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
  List<dynamic> products = [];

  double sumBuy = 0;
  double sumReturn = 0;
  double sumAll = 0;

  @override
  void initState() {
    getBasket();
    super.initState();
  }

  getBasket() async {
    products = [];
    products = AppConstants.basket;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.getString("BasketData") != null) {
    //   setState(() {
    //     products = jsonDecode(prefs.getString('BasketData')!);
    //   });
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text("Пусто.", style: TextStyle(fontSize: 20)),
    //   ));
    // }
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
                          onPressed: () {},
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
                          onPressed: () {},
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
                      }
                    });
                  },
                  child: Icon(Icons.remove),
                  style: ElevatedButton.styleFrom(primary: Colors.yellow[700]),
                ),
              ),
              Text(products[i]['count'].toString()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      products[i]['count'] += 1;
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
                  (100 - widget.discount) /
                  100)
              .toString())),
          DataCell(Text((products[i]['count'] *
                  (products[i]['product']['prices']
                          .where(
                              (e) => e['price_type_id'] == widget.priceTypeId)
                          .toList()[0]['price'] *
                      (100 - widget.discount) /
                      100))
              .toString())),
          DataCell(GestureDetector(
            onTap: () {
              setState(() {
                AppConstants.basketIDs.remove(products[i]['product']['id']);
                AppConstants.basket.remove(products[i]);
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
