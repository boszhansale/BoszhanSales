import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';
import 'history_legal_stores_page.dart';

class HistoryCounteragnetsPage extends StatefulWidget {
  @override
  _HistoryCounteragnetsPageState createState() =>
      _HistoryCounteragnetsPageState();
}

class _HistoryCounteragnetsPageState extends State<HistoryCounteragnetsPage> {
  final searchController = TextEditingController();
  List<dynamic> counteragents = [];

  @override
  void initState() {
    getCounteragents();
    super.initState();
  }

  void searchAction() async {
    counteragents = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("responseCounteragents")!;
    if (data != 'Error') {
      List<dynamic> responseList = jsonDecode(data);
      for (int i = 0; i < responseList.length; i++) {
        if (responseList[i]['name']
            .toLowerCase()
            .contains(searchController.text.toLowerCase())) {
          setState(() {
            counteragents.add(responseList[i]);
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong.", style: TextStyle(fontSize: 20)),
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
                      Row(
                        children: [
                          Spacer(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: searchController,
                              decoration: const InputDecoration(
                                hintText: "Поиск",
                                border: UnderlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              searchAction();
                            },
                            child: Icon(
                              Icons.search,
                              size: 40,
                            ),
                          ),
                          Spacer()
                        ],
                      ),
                      _createDataTable(),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
      DataColumn(label: Text('Тип опл.')),
      DataColumn(label: Text('Долг')),
      DataColumn(label: Text('Проср.')),
    ];
  }

  List<DataRow> _createRows() {
    return [
      for (int i = 0; i < counteragents.length; i++)
        DataRow(
            onSelectChanged: (newValue) {
              if (counteragents[i]['enabled'] == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HistoryLegalStoresPage(counteragents[i]['id'])));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:
                      Text("Заблокирован!", style: TextStyle(fontSize: 20)),
                ));
              }
            },
            cells: [
              DataCell(
                  Text(counteragents[i]['enabled'] == 1 ? '' : 'заблокирован')),
              DataCell(Text(
                counteragents[i]['name'],
                overflow: TextOverflow.fade,
              )),
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
