import 'dart:convert';

import 'package:boszhan_sales/components/global_data.dart';
import 'package:boszhan_sales/views/legal_entities/legal_entities_group.dart';
import 'package:boszhan_sales/views/legal_entities/legal_outlet_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';

final globalKey1 = GlobalKey<ScaffoldState>();

class LegalEntitiesList extends StatefulWidget {
  @override
  _LegalEntitiesListState createState() => _LegalEntitiesListState();
}

class _LegalEntitiesListState extends State<LegalEntitiesList> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void searchAction() async {
    List<dynamic> counteragents = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("responseCounteragents")!;
    if (data != 'Error') {
      List<dynamic> responseList = jsonDecode(data);
      List<String> existGroups = [];
      for (int i = 0; i < responseList.length; i++) {
        if (responseList[i]['name']
            .toLowerCase()
            .contains(searchController.text.toLowerCase())) {
          if (responseList[i]['group'] != null) {
            if (!existGroups.contains(responseList[i]['group'])) {
              existGroups.add(responseList[i]['group']);
              counteragents.add(responseList[i]);
            }
          } else {
            counteragents.add(responseList[i]);
          }
        } else {
          if (responseList[i]['group'] != null) {
            if (responseList[i]['group']
                .toLowerCase()
                .contains(searchController.text.toLowerCase())) {
              if (responseList[i]['group'] != null) {
                if (!existGroups.contains(responseList[i]['group'])) {
                  existGroups.add(responseList[i]['group']);
                  counteragents.add(responseList[i]);
                }
              } else {
                counteragents.add(responseList[i]);
              }
            }
          }
        }
      }
      setState(() {
        globalCounteragents = counteragents;
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
                key: globalKey1,
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
      DataColumn(label: Text('Статус')),
      DataColumn(label: Text('Наименование юридического лица')),
      DataColumn(label: Text('Прайс')),
      DataColumn(label: Text('Тип опл.')),
      DataColumn(label: Text('Долг')),
      DataColumn(label: Text('Проср.')),
    ];
  }
}

class MyData extends DataTableSource {
  MyData(this.context);

  final List<dynamic> _data = globalCounteragents;
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
          if (_data[index]['group'] != null) {
            List<dynamic> counteragents = [];
            for (int i = 0; i < globalAllCounteragents.length; i++) {
              if (_data[index]['group'] == globalAllCounteragents[i]['group']) {
                counteragents.add(globalAllCounteragents[i]);
              }
            }
            globalGroup = counteragents;
            Navigator.push(
              globalKey1.currentContext!,
              MaterialPageRoute(
                builder: (context) => LegalEntitiesGroup(),
              ),
            );
          } else {
            if (_data[index]['enabled'] == 1) {
              Navigator.push(
                  globalKey1.currentContext!,
                  MaterialPageRoute(
                      builder: (context) => LegalOutletListPage(
                          _data[index]['id'],
                          _data[index]['name'],
                          _data[index]['discount'],
                          _data[index]['price_type']['id'],
                          _data[index]['debt'].toString())));
            } else {
              ScaffoldMessenger.of(globalKey1.currentContext!)
                  .showSnackBar(const SnackBar(
                content: Text("Заблокирован!", style: TextStyle(fontSize: 20)),
              ));
            }
          }
        },
        cells: [
          DataCell(Text(_data[index]['enabled'] == 1 ? '' : 'заблокирован')),
          DataCell(Text(
            _data[index]['group'] != null
                ? _data[index]['group']
                : _data[index]['name'],
            overflow: TextOverflow.fade,
          )),
          DataCell(Text(_data[index]['price_type']['name'])),
          DataCell(Text(_data[index]['payment_type']['name'])),
          DataCell(Text(_data[index]['debt'].toString())),
          DataCell(Text(_data[index]['delay'].toString())),
        ]);
  }
}
