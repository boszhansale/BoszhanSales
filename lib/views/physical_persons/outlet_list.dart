import 'dart:convert';

import 'package:boszhan_sales/components/global_data.dart';
import 'package:boszhan_sales/views/physical_persons/add_new_outlet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';
import '../order/product_list_page.dart';

class OutletListPage extends StatefulWidget {
  @override
  _OutletListPageState createState() => _OutletListPageState();
}

class _OutletListPageState extends State<OutletListPage> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void searchAction() async {
    List<dynamic> outletList = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("responsePhysicalOutlets")!;
    if (data != 'Error') {
      List<dynamic> responseList = jsonDecode(data);
      for (int i = 0; i < responseList.length; i++) {
        if (responseList[i]['name']
            .toLowerCase()
            .contains(searchController.text.toLowerCase())) {
          outletList.add(responseList[i]);
        }
      }
      setState(() {
        globalOutletList = outletList;
      });
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
                backgroundColor: Colors.transparent,
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
                          SizedBox(
                            width: 150,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddNewOutlet(0, 0, 1, "0")));
                              },
                              label: Text(
                                "Добавить",
                                style: TextStyle(color: Colors.black),
                              ),
                              icon: Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                minimumSize: const Size.fromHeight(50), // NEW
                              ),
                            ),
                          ),
                          Spacer()
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
          child: PaginatedDataTable(
            onRowsPerPageChanged: (perPage) {},
            rowsPerPage: 10,
            showCheckboxColumn: false,
            columns: _createColumns(),
            dataRowHeight: 80,
            source: MyData(context),
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
}

class MyData extends DataTableSource {
  MyData(this.context);

  final List<dynamic> _data = globalOutletList;
  final BuildContext context;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(
        onSelectChanged: (newValue) {
          if (_data[index]['enabled'] == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductListPage(
                        _data[index]['name'],
                        _data[index]['discount'],
                        _data[index]['id'],
                        0,
                        _data[index]['salesrep']['name'],
                        0,
                        1,
                        '0',
                        _data[index])));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Заблокирован!", style: TextStyle(fontSize: 20)),
            ));
          }
        },
        cells: [
          DataCell(Text(_data[index]['name'])),
          DataCell(Text(_data[index]['address'])),
          DataCell(Text(_data[index]['phone'])),
        ]);
  }
}
