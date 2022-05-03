import 'dart:convert';

import 'package:boszhan_sales/views/order/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';

class LegalOutletListPage extends StatefulWidget {
  LegalOutletListPage(this.id, this.counteragentName, this.debt);
  final int id;
  final String debt;
  final String counteragentName;

  @override
  _LegalOutletListPageState createState() => _LegalOutletListPageState();
}

class _LegalOutletListPageState extends State<LegalOutletListPage> {
  List<dynamic> outletList = [];
  @override
  void initState() {
    getOutlets();
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
                        Text(
                          'Торговые точки'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 34),
                        ),
                        Spacer(),
                      ],
                    ),
                    Divider(
                      color: Colors.yellow[700],
                    ),
                    _createDataTable(),
                  ],
                ),
              ),
            ),
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
      DataColumn(label: Text('Адрес')),
      DataColumn(label: Text('Номер телефона')),
    ];
  }

  List<DataRow> _createRows() {
    return [
      for (int i = 0; i < outletList.length; i++)
        DataRow(
            onSelectChanged: (newValue) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductListPage(
                          outletList[i]['name'],
                          outletList[i]['id'],
                          widget.id,
                          widget.counteragentName,
                          widget.debt)));
            },
            cells: [
              DataCell(Text(outletList[i]['name'])),
              DataCell(Text(outletList[i]['address'])),
              DataCell(Text(outletList[i]['phone'])),
            ]),
    ];
  }

  void getOutlets() async {
    outletList = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("responseLegalOutlets")!;
    if (data != 'Error') {
      List<dynamic> responseList = jsonDecode(data);
      setState(() {
        for (int i = 0; i < responseList.length; i++) {
          if (responseList[i]['counteragent_id'] == widget.id) {
            outletList.add(responseList[i]);
          }
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong.", style: TextStyle(fontSize: 20)),
      ));
    }
  }
}
