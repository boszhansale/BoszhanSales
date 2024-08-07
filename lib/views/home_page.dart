import 'dart:convert';

import 'package:boszhan_sales/components/global_data.dart';
import 'package:boszhan_sales/services/auth_api_provider.dart';
import 'package:boszhan_sales/services/sales_rep_api_provider.dart';
import 'package:boszhan_sales/views/analytics_page.dart';
import 'package:boszhan_sales/views/authorization/login_page.dart';
import 'package:boszhan_sales/views/catalog/catalog_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/const.dart';
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
  int thirdBrandPlan = 0;
  var analyticsData = null;

  bool newVersion = false;
  String appVersion = "";

  bool loadBool = true;

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initFunction() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      getProfile();
      checkVersion();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      getProfile();
      checkVersion();
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
                      // height: 620,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(50),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool("isBasketCompleted", true);
                                    prefs.remove('BasketData');
                                    prefs.remove('responsePhysicalOutlets');
                                    prefs.remove('responseLegalOutlets');
                                    prefs.remove('responseCounteragents');
                                    prefs.remove('responseBrends');
                                    prefs.remove('driver_phone');
                                    prefs.remove('driver_name');
                                    prefs.setBool("isLogedIn", false);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()));
                                  },
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.08,
                                    height: MediaQuery.of(context).size.width *
                                        0.08,
                                    child: const Icon(
                                      Icons.logout,
                                    ),
                                  ),
                                ),
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
                                      // backgroundColor: Colors.grey[200],
                                      textStyle: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                                const SizedBox(
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
                                      // backgroundColor: Colors.grey[200],
                                      textStyle: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            child: Text(
                                              'Плана до конца месяца: ',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          plan - completedPlan < 0
                                              ? Text(
                                                  '${completedPlan - plan} тг.',
                                                  style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: Colors.green),
                                                )
                                              : Text(
                                                  '${plan - completedPlan} тг.',
                                                  style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Первомайские деликатесы: ',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          thirdBrandPlan < 0
                                              ? Text(
                                                  '${thirdBrandPlan * -1} тг.',
                                                  style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                      fontSize: 14),
                                                )
                                              : Text(
                                                  '${thirdBrandPlan} тг.',
                                                  style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Народные колбасы: ',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          secondBrandPlan < 0
                                              ? Text(
                                                  '${secondBrandPlan * -1} тг.',
                                                  style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                      fontSize: 14),
                                                )
                                              : Text(
                                                  '${secondBrandPlan} тг.',
                                                  style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Boszhan: ',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          firstBrandPlan < 0
                                              ? Text(
                                                  '${firstBrandPlan * -1} тг.',
                                                  style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                      fontSize: 14),
                                                )
                                              : Text(
                                                  '${firstBrandPlan} тг.',
                                                  style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(right: 50),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.17,
                                    height: MediaQuery.of(context).size.width *
                                        0.08,
                                  )),
                              const Spacer(),
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        // color: Colors.yellow[700],
                                        borderRadius:
                                            BorderRadius.circular(130)),
                                    child: Image.asset(
                                      "assets/images/logo.png",
                                      width: 250,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const SizedBox(
                                    width: 400,
                                    child: Text(
                                      'Bız bar yqylasymyzben jäne tolyq jauapkerşılıgımızben kün saiyn adamdar tañdaityn önımderdı daiyndaimyz',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const SizedBox(
                                    width: 400,
                                    child: Text(
                                      'Мы с душой и полной ответственностью создаем продукты, которые каждый день выбирают люди',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              newVersion
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 50),
                                      child: Column(
                                        children: [
                                          const Text("Доступна новая версия!"),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.17,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.08,
                                            child: ElevatedButton(
                                              child: const Text(
                                                'Скачать',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Colors.black),
                                              ),
                                              onPressed: () {
                                                downloadNewVersion();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.yellow[700],
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.17,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.08,
                                    ),
                            ],
                          ),
                          const SizedBox(height: 30),
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
                                      // Text(
                                      //   'Удачных продаж!',
                                      //   style: TextStyle(
                                      //       fontStyle: FontStyle.italic,
                                      //       fontWeight: FontWeight.bold,
                                      //       fontSize: 16),
                                      // ),
                                      Text(
                                        'ТП: $name',
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        'Водитель: $driverName',
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      // Text(
                                      //   'Номер водителя: $driverPhone',
                                      //   style: const TextStyle(
                                      //       fontStyle: FontStyle.italic,
                                      //       fontWeight: FontWeight.bold,
                                      //       fontSize: 16),
                                      // ),
                                      Text(
                                        'Версия локально: ${AppConstants.appVersion}',
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        'Версия с сервера: $localSavedAppVersion',
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
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
                                      if (loadBool) getAllData();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.yellow[700],
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
                                      if (localSavedAppVersion ==
                                              AppConstants.appVersion ||
                                          localSavedAppVersion == '') {
                                        Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CatalogPage()))
                                            .whenComplete(() => checkVersion());
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Обновитесь до последней версии!",
                                              style: TextStyle(fontSize: 20)),
                                        ));
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.yellow[700],
                                      textStyle: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ));
  }

  void getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var profileInfo = await AuthProvider().getProfileInfo();

    setState(() {
      name = prefs.getString('full_name')!;
      name = profileInfo['name'] ?? prefs.getString('full_name');
      driverName = profileInfo['driver']['name'] ?? '';
      driverPhone = profileInfo['driver']['phone'] ?? '';
    });
  }

  void getAllData() async {
    loadBool = false;
    checkVersion();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var responseCounteragents = await SalesRepProvider().getCounteragents();
    var responseBrends = await SalesRepProvider().getBrends();
    var responseLegalOutlets = await SalesRepProvider().getLegalOutlets();
    var responsePhysicalOutlets = await SalesRepProvider().getPhysicalOutlets();
    var responseProducts = await SalesRepProvider().getProducts();
    var responseAnalytics = await SalesRepProvider().getAnalytics();
    var responseHistoryForReturns =
        await SalesRepProvider().getLastThreeOrders();

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
        if (responseAnalytics['brands'].length > 1) {
          secondBrandPlan = responseAnalytics['brands'][1]['plan'] -
              responseAnalytics['brands'][1]['completed'];
        }
        if (responseAnalytics['brands'].length > 2) {
          thirdBrandPlan = responseAnalytics['brands'][2]['plan'] -
              responseAnalytics['brands'][2]['completed'];
        }
      });
    } else {
      prefs.setString("responseAnalytics", 'Error');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong. (Analytics)",
            style: TextStyle(fontSize: 20)),
      ));
    }

    if (responseHistoryForReturns != 'Error') {
      prefs.setString(
          "responseHistoryForReturns", jsonEncode(responseHistoryForReturns));
    } else {
      prefs.setString("responseHistoryForReturns", 'Error');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong. (responseHistoryForReturns)",
            style: TextStyle(fontSize: 20)),
      ));
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Загружено!", style: TextStyle(fontSize: 20)),
    ));
    loadBool = true;
  }

  void downloadNewVersion() async {
    launch(AppConstants.baseUrl + 'api/mobile-app/download?type=1');
  }

  void checkVersion() async {
    var result = await AuthProvider().checkApplicationVersion();
    // print('-------------------- ${result}');

    if (result != 'Error') {
      if (result['version'] != AppConstants.appVersion) {
        setState(() {
          newVersion = true;
          appVersion = result['version'];
          localSavedAppVersion = result['version'];
        });
      } else {
        setState(() {
          newVersion = false;
          appVersion = result['version'];
          localSavedAppVersion = result['version'];
        });
      }
    } else {
      print('Error');
    }
  }
}
