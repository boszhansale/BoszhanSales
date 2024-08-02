import 'dart:convert';

import 'package:boszhan_sales/views/order/new_order_page.dart';
import 'package:boszhan_sales/views/order/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';

class CatalogPage extends StatefulWidget {
  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  bool isBasketCompleted = true;

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  void getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getBool("isBasketCompleted") != null) {
        isBasketCompleted = prefs.getBool("isBasketCompleted")!;
      }
    });
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
                            "Каталог".toUpperCase(),
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                        isBasketCompleted == false
                            ? Padding(
                                padding: const EdgeInsets.all(10),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: ElevatedButton(
                                    child: const Text(
                                      'Продолжить заказ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black),
                                    ),
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      if (prefs.getBool("isBasketCompleted") ==
                                          false) {
                                        var outletName =
                                            prefs.getString("outletName")!;
                                        var outletDiscount =
                                            prefs.getInt("outletDiscount")!;
                                        var outletId =
                                            prefs.getInt("outletId")!;
                                        var counteragentID =
                                            prefs.getInt("counteragentID")!;
                                        var counteragentName = prefs
                                            .getString("counteragentName")!;
                                        var counteragentDiscount = prefs
                                            .getInt("counteragentDiscount")!;
                                        var priceTypeId =
                                            prefs.getInt("priceTypeId")!;
                                        var debt = prefs.getString("debt")!;
                                        var savedOutlet = jsonDecode(
                                            prefs.getString("savedOutlet")!);

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductListPage(
                                                        outletName,
                                                        outletDiscount,
                                                        outletId,
                                                        counteragentID,
                                                        counteragentName,
                                                        counteragentDiscount,
                                                        priceTypeId,
                                                        debt,
                                                        savedOutlet)));
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.yellow[700],
                                      textStyle: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 40,
                              ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: ElevatedButton(
                              child: const Text(
                                'Новый заказ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black),
                              ),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                if (prefs.getBool("isBasketCompleted") ==
                                    false) {
                                  showAlertDialog(BuildContext context) {
                                    // set up the buttons
                                    Widget cancelButton = TextButton(
                                      child: Text("Отмена"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    );
                                    Widget continueButton = TextButton(
                                      child: Text("Да"),
                                      onPressed: () {
                                        prefs.remove('isBasketCompleted');
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NewOrderPage()));
                                      },
                                    );

                                    // set up the AlertDialog
                                    AlertDialog alert = AlertDialog(
                                      title: Text("Внимание!"),
                                      content: Text(
                                          "У вас есть незаконченный заказ, обнулить заказ и создать новый?"),
                                      actions: [
                                        cancelButton,
                                        continueButton,
                                      ],
                                    );

                                    // show the dialog
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      },
                                    );
                                  }

                                  showAlertDialog(context);
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewOrderPage()));
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
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
