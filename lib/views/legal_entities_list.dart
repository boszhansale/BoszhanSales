import 'package:flutter/material.dart';

import 'home_page.dart';

class LegalEntitiesList extends StatefulWidget {
  @override
  _LegalEntitiesListState createState() => _LegalEntitiesListState();
}

class _LegalEntitiesListState extends State<LegalEntitiesList> {
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
        child: DataTable(
          showCheckboxColumn: false,
          columns: _createColumns(),
          rows: _createRows(),
          dataRowHeight: 80,
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
      DataRow(
          onSelectChanged: (newValue) {
            print('row 1 pressed');
          },
          cells: [
            DataCell(Text('')),
            DataCell(Text('Fast Meals and Goods TOO')),
            DataCell(Text('B+')),
            DataCell(Text('безнал')),
            DataCell(Text('56 742')),
            DataCell(Text('')),
          ]),
      DataRow(
          onSelectChanged: (newValue) {
            print('row 2 pressed');
          },
          cells: [
            DataCell(Text('Заблокирован')),
            DataCell(Text('JARDI KZ(ЖАРДИ КЗ) TOO')),
            DataCell(Text('A')),
            DataCell(Text('безнал')),
            DataCell(Text('1 156 742')),
            DataCell(Text('485 758')),
          ]),
    ];
  }
}
