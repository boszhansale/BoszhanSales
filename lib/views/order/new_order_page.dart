import 'dart:convert';

import 'package:boszhan_sales/components/global_data.dart';
import 'package:boszhan_sales/views/physical_persons/outlet_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';
import '../legal_entities/legal_entities_list.dart';

class NewOrderPage extends StatefulWidget {
  @override
  _NewOrderPageState createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  @override
  void initState() {
    getCounteragents();
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
                            "новый заказ".toUpperCase(),
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80),
                          child: Row(
                            children: [
                              Column(
                                children: [
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
                                          'Юридические лица',
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
                                                      LegalEntitiesList()));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.yellow[700],
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
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
                                          'Физические лица',
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
                                                      OutletListPage()));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.yellow[700],
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.yellow[700],
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Image.asset(
                                          "assets/images/qr_code.png",
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.3,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.3),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
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

  void getCounteragents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("responseCounteragents")!;
    if (data != 'Error') {
      List<dynamic> responseList = jsonDecode(data);
      List<String> existGroups = [];
      List<dynamic> finishList = [];
      for (int j = 0; j < responseList.length; j++) {
        if (responseList[j]['group'] != null) {
          if (!existGroups.contains(responseList[j]['group'])) {
            existGroups.add(responseList[j]['group']);
            finishList.add(responseList[j]);
          }
        } else {
          finishList.add(responseList[j]);
        }
      }
      setState(() {
        globalCounteragents = finishList;
        globalAllCounteragents = responseList;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong.", style: TextStyle(fontSize: 20)),
      ));
    }
  }

  void getOutlets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("responsePhysicalOutlets")!;
    if (data != 'Error') {
      List<dynamic> responseList = jsonDecode(data);
      setState(() {
        globalOutletList = responseList;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong.", style: TextStyle(fontSize: 20)),
      ));
    }
  }
}
