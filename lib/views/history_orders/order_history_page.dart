import 'package:boszhan_sales/services/sales_rep_api_provider.dart';
import 'package:boszhan_sales/views/history_orders/history_counteragents_page.dart';
import 'package:boszhan_sales/views/history_orders/history_stores_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  @override
  int physCount = 0;
  double physSum = 0;
  int physCountReturn = 0;
  double physSumReturn = 0;

  int legCount = 0;
  double legSum = 0;
  int legCountReturn = 0;
  double legSumReturn = 0;

  String name = '';

  void initState() {
    getData();
    getName();
    super.initState();
  }

  void getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('full_name')!;
    });
  }

  void getData() async {
    var response = await SalesRepProvider().getOrdersReport();
    if (response != 'Error') {
      setState(() {
        physCount = response['individual_orders'];
        physSum = double.parse(response['individual_purchase'].toString());
        physCountReturn =
            int.parse(response['individual_return_count'].toString());
        physSumReturn = double.parse(response['individual_return'].toString());

        legCount = response['legal_entity_orders'];
        legSum = double.parse(response['legal_entity_purchase'].toString());
        legCountReturn =
            int.parse(response['legal_entity_count_return'].toString());
        legSumReturn = double.parse(response['legal_entity_return'].toString());
      });
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
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Container(
                              decoration: BoxDecoration(
                                  // color: Colors.yellow[700],
                                  borderRadius: BorderRadius.circular(130)),
                              child: Image.asset("assets/images/logo.png",
                                  width:
                                      MediaQuery.of(context).size.height * 0.5),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "?????????????? ??????????????".toUpperCase(),
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            Spacer(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.45,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Column(
                                children: [
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.12,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: ElevatedButton(
                                        child: const Text(
                                          '?????????????????????? ????????',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HistoryCounteragnetsPage()));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.yellow[700],
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.12,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: ElevatedButton(
                                        child: const Text(
                                          '???????????????????? ????????',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HistoryStoresPage()));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.yellow[700],
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.48,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 2),
                                              child: Text(
                                                '???? ????????',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2),
                                              child: Text(
                                                '???????????????????? ????????????: $legCount',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2),
                                              child: Text(
                                                '?????????? ????????????: $legSum',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2),
                                              child: Text(
                                                '???????????????????? ??????????????????: $legCountReturn',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2),
                                              child: Text(
                                                '?????????? ????????????????: $legSumReturn',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 2),
                                              child: Text(
                                                '?????? ????????',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2),
                                              child: Text(
                                                '???????????????????? ????????????: $physCount',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2),
                                              child: Text(
                                                '?????????? ????????????: $physSum',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2),
                                              child: Text(
                                                '???????????????????? ??????????????????: $physCountReturn',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2),
                                              child: Text(
                                                '?????????? ????????????????: $physSumReturn',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: ElevatedButton(
                                  child: const Text(
                                    '????????????????????',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black),
                                  ),
                                  onPressed: () async {
                                    String text =
                                        '$name \n ??????. ???????? \n???????????????????? ????????????: $physCount \n?????????? ????????????: $physSum \n???????????????????? ??????????????????: $physCountReturn \n?????????? ????????????????: $physSumReturn \n???? ???????? \n???????????????????? ????????????: $legCount \n?????????? ????????????: $legSum \n???????????????????? ??????????????????: $legCountReturn \n?????????? ????????????????: $legSumReturn';

                                    await FlutterShare.share(
                                      title: '???????????????????????? ????????????????????',
                                      text: text,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.yellow[700],
                                    textStyle: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                            Spacer()
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
