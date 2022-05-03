import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';

class BasketPage extends StatefulWidget {
  BasketPage(this.outletName, this.outletId, this.counteragentID,
      this.counteragentName, this.debt);
  final String outletName;
  final int outletId;
  final int counteragentID;
  final String counteragentName;
  final String debt;
  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  List<dynamic> products = [];
  @override
  void initState() {
    getBasket();
    super.initState();
  }

  getBasket() async {
    products = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("BasketData") != null) {
      setState(() {
        products = jsonDecode(prefs.getString('BasketData')!);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Пусто.", style: TextStyle(fontSize: 20)),
      ));
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
                ]))),
          ],
        ));
  }

  Theme _createDataTable() {
    return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.yellow[700]),
        child: SizedBox(
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
    ];
  }

  List<DataRow> _createRows() {
    return [
      for (int i = 0; i < products.length; i++)
        DataRow(onSelectChanged: (newValue) {}, cells: [
          DataCell(Text(products[i]['name'])),
          DataCell(Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Icon(Icons.add),
                  style: ElevatedButton.styleFrom(primary: Colors.yellow[700]),
                ),
              ),
              Text(products[i]['name']),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Icon(Icons.add),
                  style: ElevatedButton.styleFrom(primary: Colors.yellow[700]),
                ),
              ),
            ],
          )),
          DataCell(Text(products[i]['name'])),
          DataCell(Text(products[i]['name'])),
        ]),
    ];
  }
}
