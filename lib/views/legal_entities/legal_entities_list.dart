import 'dart:convert';

import 'package:boszhan_sales/views/legal_entities/legal_outlet_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';

class LegalEntitiesList extends StatefulWidget {
  @override
  _LegalEntitiesListState createState() => _LegalEntitiesListState();
}

class _LegalEntitiesListState extends State<LegalEntitiesList> {
  List<dynamic> counteragents = [];
  @override
  void initState() {
    getCounteragents();
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
                          'Справочник юридических лиц'.toUpperCase(),
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
      DataColumn(label: Text('Статус')),
      DataColumn(label: Text('Наименование юридического лица')),
      DataColumn(label: Text('Прайс')),
      DataColumn(label: Text('Тип оплаты')),
      DataColumn(label: Text('Долг')),
      DataColumn(label: Text('Проср.')),
    ];
  }

  List<DataRow> _createRows() {
    return [
      for (int i = 0; i < counteragents.length; i++)
        DataRow(
            onSelectChanged: (newValue) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LegalOutletListPage(
                          counteragents[i]['id'],
                          counteragents[i]['name'],
                          counteragents[i]['discount'],
                          counteragents[i]['price_type']['id'],
                          counteragents[i]['debt'].toString())));
            },
            cells: [
              DataCell(
                  Text(counteragents[i]['enabled'] == 1 ? '' : 'заблокирован')),
              DataCell(Text(counteragents[i]['name'])),
              DataCell(Text(counteragents[i]['price_type']['name'])),
              DataCell(Text(counteragents[i]['payment_type']['name'])),
              DataCell(Text(counteragents[i]['debt'].toString())),
              DataCell(Text(counteragents[i]['delay'].toString())),
            ]),
    ];
  }

  void getCounteragents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("responseCounteragents")!;
    if (data != 'Error') {
      List<dynamic> responseList = jsonDecode(data);
      setState(() {
        counteragents = responseList;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong.", style: TextStyle(fontSize: 20)),
      ));
    }
  }
}
