import 'dart:convert';

import 'package:boszhan_sales/services/sales_rep_api_provider.dart';
import 'package:boszhan_sales/views/analytics_page.dart';
import 'package:boszhan_sales/views/catalog/catalog_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'order/sales_representative_orders.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = "";
  String driverName = "";
  String driverPhone = "";
  int plan = 0;
  int completedPlan = 0;
  int firstBrandPlan = 0;
  int secondBrandPlan = 0;
  var analyticsData = null;

  @override
  void initState() {
    getProfile();
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
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.95,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(50),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.17,
                                  height:
                                      MediaQuery.of(context).size.width * 0.08,
                                  child: OutlinedButton(
                                    child: const Text(
                                      'Прочее',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black),
                                    ),
                                    onPressed: () {
                                      if (analyticsData != null) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AnalyticsPage(
                                                        analyticsData)));
                                      }
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          width: 4, color: Colors.yellow[700]!),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      // primary: Colors.grey[200],
                                      textStyle: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height:
                                      MediaQuery.of(context).size.width * 0.08,
                                  child: OutlinedButton(
                                    child: const Text(
                                      'Мои заказы',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SalesRepresentativeOrders(
                                                      name)));
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          width: 4, color: Colors.yellow[700]!),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      // primary: Colors.grey[200],
                                      textStyle: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'До выполнения плана до конца месяца вам осталось продать: ${plan - completedPlan} тг.',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        'Первомайские деликатесы: ${firstBrandPlan} тг.',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        'Народные колбасы: ${secondBrandPlan} тг.',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                // color: Colors.yellow[700],
                                borderRadius: BorderRadius.circular(130)),
                            child: Image.asset("assets/images/logo.png",
                                width:
                                    MediaQuery.of(context).size.height * 0.5),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 50),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Удачных продаж!',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        'ТП: $name',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        'Водитель: $driverName',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        'Номер водителя: $driverPhone',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 50),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.17,
                                  height:
                                      MediaQuery.of(context).size.width * 0.08,
                                  child: ElevatedButton(
                                    child: const Text(
                                      'Обновить',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black),
                                    ),
                                    onPressed: () {
                                      getAllData();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.yellow[700],
                                      textStyle: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 50),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.17,
                                  height:
                                      MediaQuery.of(context).size.width * 0.08,
                                  child: ElevatedButton(
                                    child: const Text(
                                      'Каталог',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CatalogPage()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.yellow[700],
                                      textStyle: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                )),
          ],
        ));
  }

  void getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('full_name')!;
      if (prefs.getString('driver_name') != null) {
        driverName = prefs.getString('driver_name')!;
      }
      if (prefs.getString('driver_phone') != null) {
        driverPhone = prefs.getString('driver_phone')!;
      }
    });
  }

  void getAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var responseCounteragents = await SalesRepProvider().getCounteragents();
    var responseBrends = await SalesRepProvider().getBrends();
    var responseLegalOutlets = await SalesRepProvider().getLegalOutlets();
    var responsePhysicalOutlets = await SalesRepProvider().getPhysicalOutlets();
    var responseProducts = await SalesRepProvider().getProducts();
    var responseAnalytics = await SalesRepProvider().getAnalytics();

    if (responseCounteragents != 'Error') {
      prefs.setString(
          "responseCounteragents", jsonEncode(responseCounteragents));
    } else {
      prefs.setString("responseCounteragents", 'Error');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong. (Counteragents)",
            style: TextStyle(fontSize: 20)),
      ));
    }

    if (responseBrends != 'Error') {
      prefs.setString("responseBrends", jsonEncode(responseBrends));
    } else {
      prefs.setString("responseBrends", 'Error');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong. (Brends)",
            style: TextStyle(fontSize: 20)),
      ));
    }

    if (responseLegalOutlets != 'Error') {
      prefs.setString("responseLegalOutlets", jsonEncode(responseLegalOutlets));
    } else {
      prefs.setString("responseLegalOutlets", 'Error');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong. (LegalOutlets)",
            style: TextStyle(fontSize: 20)),
      ));
    }

    if (responsePhysicalOutlets != 'Error') {
      prefs.setString(
          "responsePhysicalOutlets", jsonEncode(responsePhysicalOutlets));
    } else {
      prefs.setString("responsePhysicalOutlets", 'Error');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong. (PhysicalOutlets)",
            style: TextStyle(fontSize: 20)),
      ));
    }

    if (responseProducts != 'Error') {
      prefs.setString("responseProducts", jsonEncode(responseProducts));
    } else {
      prefs.setString("responseProducts", 'Error');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong. (Products)",
            style: TextStyle(fontSize: 20)),
      ));
    }

    if (responseAnalytics != 'Error') {
      prefs.setString("responseAnalytics", jsonEncode(responseAnalytics));
      analyticsData = responseAnalytics;

      setState(() {
        plan = responseAnalytics['plan'];
        completedPlan = responseAnalytics['completed'];
        if (responseAnalytics['brands'].length > 0) {
          firstBrandPlan = responseAnalytics['brands'][0]['plan'] -
              responseAnalytics['brands'][0]['completed'];
        }
        if (responseAnalytics['brands'].length > 2) {
          secondBrandPlan = responseAnalytics['brands'][1]['plan'] -
              responseAnalytics['brands'][1]['completed'];
        }
      });
    } else {
      prefs.setString("responseAnalytics", 'Error');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong. (Analytics)",
            style: TextStyle(fontSize: 20)),
      ));
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Загружено!", style: TextStyle(fontSize: 20)),
    ));
  }
}
