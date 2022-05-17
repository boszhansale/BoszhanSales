import 'dart:convert';

import 'package:boszhan_sales/utils/const.dart';
import 'package:boszhan_sales/views/basket/basket_page.dart';
import 'package:boszhan_sales/views/order/product_info_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';

class ProductListPage extends StatefulWidget {
  ProductListPage(
      this.outletName,
      this.outletDiscount,
      this.outletId,
      this.counteragentID,
      this.counteragentName,
      this.counteragentDiscount,
      this.priceTypeId,
      this.debt);
  final String outletName;
  final int outletDiscount;
  final int outletId;
  final int counteragentID;
  final String counteragentName;
  final int counteragentDiscount;
  final int priceTypeId;
  final String debt;
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final searchController = TextEditingController();
  String name = '';
  List<Map<String, Object>> brands = [];

  List<dynamic> categories = [];
  List<dynamic> products = [];
  int selectedCategoryID = 1;
  int discount = 0;

  @override
  void initState() {
    getInfo();
    getProductsFromPrefs();
    setBasketData();
    if (widget.counteragentDiscount != 0) {
      discount = widget.counteragentDiscount;
    } else {
      if (widget.outletDiscount != 0) {
        discount = widget.outletDiscount;
      } else {
        discount = 0;
      }
    }
    print(discount);
    super.initState();
  }

  void setBasketData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool("isBasketCompleted", false);
    prefs.setString("outletName", widget.outletName);
    prefs.setInt("outletDiscount", widget.outletDiscount);
    prefs.setInt("outletId", widget.outletId);
    prefs.setInt("counteragentID", widget.counteragentID);
    prefs.setString("counteragentName", widget.counteragentName);
    prefs.setInt("counteragentDiscount", widget.counteragentDiscount);
    prefs.setInt("priceTypeId", widget.priceTypeId);
    prefs.setString("debt", widget.debt);
  }

  getInfo() async {
    categories = [];
    brands = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('full_name')!;
    });
    var data = prefs.getString("responseBrends")!;
    if (data != 'Error') {
      setState(() {
        List<dynamic> brandsData = List.from(jsonDecode(data));
        for (int i = 0; i < brandsData.length; i++) {
          brands
              .add({"id": brandsData[i]["id"], "title": brandsData[i]["name"]});
          List<dynamic> categoriesData = brandsData[i]["categories"]!;
          for (int j = 0; j < categoriesData.length; j++) {
            categories.add(categoriesData[j]);
          }
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong.", style: TextStyle(fontSize: 20)),
      ));
    }
  }

  getProductsFromPrefs() async {
    products = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("responseProducts")!;
    if (data != 'Error') {
      setState(() {
        List<dynamic> productsData = List.from(jsonDecode(data));
        for (int i = 0; i < productsData.length; i++) {
          if (productsData[i]['category_id'] == selectedCategoryID) {
            products.add(productsData[i]);
          }
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong.", style: TextStyle(fontSize: 20)),
      ));
    }
  }

  void searchAction() async {
    products = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("responseProducts")!;
    if (data != 'Error') {
      setState(() {
        List<dynamic> productsData = List.from(jsonDecode(data));
        for (int i = 0; i < productsData.length; i++) {
          if (productsData[i]['name'].contains(searchController.text)) {
            products.add(productsData[i]);
          }
        }
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
                        Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Row(
                                children: [
                                  // Text(
                                  //   'Сумма покупок: 15 000 тг',
                                  //   style: TextStyle(fontSize: 16),
                                  // ),
                                  // Spacer(),
                                  // Text(
                                  //   'Сумма возврата: 15 000 тг',
                                  //   style: TextStyle(fontSize: 16),
                                  // ),
                                  // Spacer(),
                                  // Text(
                                  //   'Итого к оплате: 15 000 тг',
                                  //   style: TextStyle(
                                  //       fontWeight: FontWeight.bold,
                                  //       fontSize: 16),
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 0,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                  color: Colors.yellow[700],
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height: 60,
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      Text(
                                          'Контрагент: ${widget.counteragentName}',
                                          style: TextStyle(fontSize: 16)),
                                      Spacer(),
                                      Text(
                                          'Торговая точка: ${widget.outletName}',
                                          style: TextStyle(fontSize: 16)),
                                      Spacer(),
                                      Text('Долг: ${widget.debt} тг',
                                          style: TextStyle(fontSize: 16)),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BasketPage(
                                                          widget.outletName,
                                                          widget.outletId,
                                                          widget.counteragentID,
                                                          widget
                                                              .counteragentName,
                                                          discount,
                                                          widget.priceTypeId,
                                                          widget.debt)));
                                        },
                                        child: Icon(
                                          Icons.shopping_cart_outlined,
                                          size: 40,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      )
                                    ],
                                  )),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
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
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                    Divider(
                      color: Colors.yellow[700],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.64,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: createListOfCategories(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.66,
                          height: MediaQuery.of(context).size.height * 0.68,
                          child: GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            children: [
                              for (int i = 0; i < products.length; i++)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductInfoPage(
                                                    widget.outletName,
                                                    widget.outletId,
                                                    widget.counteragentID,
                                                    widget.counteragentName,
                                                    widget.debt,
                                                    products[i],
                                                    discount != 0
                                                        ? discount
                                                        : products[i]
                                                            ['discount'],
                                                    widget.priceTypeId)));
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: SizedBox(
                                        height: 450,
                                        child: Column(
                                          children: [
                                            Stack(children: [
                                              Image.network(
                                                products[i]['images'].length > 0
                                                    ? products[i]['images'][0]
                                                        ['path']
                                                    : "https://xn--90aha1bhcc.xn--p1ai/img/placeholder.png",
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.19,
                                                fit: BoxFit.fitHeight,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (!AppConstants.basketIDs
                                                      .contains(
                                                          products[i]['id'])) {
                                                    AppConstants.basket.add({
                                                      'product': products[i],
                                                      'count': 1,
                                                      'type': 1
                                                    });
                                                    AppConstants.basketIDs
                                                        .add(products[i]['id']);
                                                  }
                                                },
                                                child: Text(
                                                  "Возврат",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.red),
                                              )
                                            ]),
                                            Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Text(
                                                products[i]['name'],
                                                style: TextStyle(fontSize: 16),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              "${discount != 0 ? products[i]['prices'].where((e) => e['price_type_id'] == widget.priceTypeId).toList()[0]['price'] * (100 - discount) / 100 : products[i]['prices'].where((e) => e['price_type_id'] == widget.priceTypeId).toList()[0]['price'] * (100 - products[i]['discount']) / 100} тг/шт",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                if (!AppConstants.basketIDs
                                                    .contains(
                                                        products[i]['id'])) {
                                                  AppConstants.basket.add({
                                                    'product': products[i],
                                                    'count': 1,
                                                    'type': 0
                                                  });
                                                  AppConstants.basketIDs
                                                      .add(products[i]['id']);
                                                }
                                              },
                                              label: Text(
                                                "В корзину",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              icon: Icon(
                                                Icons.shopping_cart_outlined,
                                                color: Colors.black,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.green[700],
                                                minimumSize:
                                                    const Size.fromHeight(
                                                        50), // NEW
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  List<Widget> createListOfCategories() {
    List<Widget> listOfWidgets = [];
    for (int i = 0; i < brands.length; i++) {
      listOfWidgets.add(Text(
        brands[i]["title"].toString(),
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ));
      listOfWidgets.add(Divider(
        color: Colors.yellow[700],
      ));

      for (int j = 0; j < categories.length; j++) {
        if (brands[i]["id"] == categories[j]["brand_id"]) {
          listOfWidgets.add(Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 5, 2),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                onPressed: () {
                  selectedCategoryID = categories[j]["id"];
                  getProductsFromPrefs();
                },
                style: ElevatedButton.styleFrom(primary: Colors.yellow[700]),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      categories[j]["name"].toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
            ),
          ));
        }
      }
      listOfWidgets.add(Divider(
        color: Colors.black,
      ));
    }

    return listOfWidgets;
  }
}
