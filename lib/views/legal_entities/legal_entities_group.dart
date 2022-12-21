import 'package:boszhan_sales/components/global_data.dart';
import 'package:boszhan_sales/views/legal_entities/legal_outlet_list.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';

final globalKey = GlobalKey<ScaffoldState>();

class LegalEntitiesGroup extends StatefulWidget {
  @override
  _LegalEntitiesGroupState createState() => _LegalEntitiesGroupState();
}

class _LegalEntitiesGroupState extends State<LegalEntitiesGroup> {
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
                key: globalKey,
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

  final List<dynamic> _data = globalGroup;
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
                globalKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => LegalOutletListPage(
                        _data[index]['id'],
                        _data[index]['name'],
                        _data[index]['discount'],
                        _data[index]['price_type']['id'],
                        _data[index]['debt'].toString())));
          } else {
            ScaffoldMessenger.of(globalKey.currentContext!)
                .showSnackBar(const SnackBar(
              content: Text("Заблокирован!", style: TextStyle(fontSize: 20)),
            ));
          }
        },
        cells: [
          DataCell(Text(_data[index]['enabled'] == 1 ? '' : 'заблокирован')),
          DataCell(Text(
            _data[index]['name'],
            overflow: TextOverflow.fade,
          )),
          DataCell(Text(_data[index]['price_type']['name'])),
          DataCell(Text(_data[index]['payment_type']['name'])),
          DataCell(Text(_data[index]['debt'].toString())),
          DataCell(Text(_data[index]['delay'].toString())),
        ]);
  }
}
