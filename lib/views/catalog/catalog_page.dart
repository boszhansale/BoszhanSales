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
                                color: Colors.yellow[700],
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
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width * 0.07,
                          child: ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: const Text(
                                'Продолжить заказ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Colors.black),
                              ),
                            ),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              if (prefs.getBool("isBasketCompleted") == false) {
                                var outletName = prefs.getString("outletName")!;
                                var outletDiscount =
                                    prefs.getInt("outletDiscount")!;
                                var outletId = prefs.getInt("outletId")!;
                                var counteragentID =
                                    prefs.getInt("counteragentID")!;
                                var counteragentName =
                                    prefs.getString("counteragentName")!;
                                var counteragentDiscount =
                                    prefs.getInt("counteragentDiscount")!;
                                var priceTypeId = prefs.getInt("priceTypeId")!;
                                var debt = prefs.getString("debt")!;

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductListPage(
                                            outletName,
                                            outletDiscount,
                                            outletId,
                                            counteragentID,
                                            counteragentName,
                                            counteragentDiscount,
                                            priceTypeId,
                                            debt)));
                              }
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
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width * 0.07,
                          child: ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: const Text(
                                'Новый заказ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Colors.black),
                              ),
                            ),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              if (prefs.getBool("isBasketCompleted") == false) {
                                showAlertDialog(BuildContext context) {
                                  // set up the buttons
                                  Widget cancelButton = TextButton(
                                    child: Text("Отмена"),
                                    onPressed: () {},
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
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewOrderPage()));
                              }
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
                ),
              ),
            ),
          ],
        ));
  }
}
