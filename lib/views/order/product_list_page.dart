import 'dart:convert';

import 'package:boszhan_sales/components/product_list_card.dart';
import 'package:boszhan_sales/views/order/product_info_page.dart';
import 'package:boszhan_sales/views/order/store_orders_history.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../basket/basket_page.dart';
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
      this.debt,
      this.outlet);

  final String outletName;
  final int outletDiscount;
  final int outletId;
  final int counteragentID;
  final String counteragentName;
  final int counteragentDiscount;
  final int priceTypeId;
  final String debt;
  final Map<String, dynamic> outlet;

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final searchController = TextEditingController();
  final countDialogTextFieldController = TextEditingController();
  String name = '';
  List<Map<String, Object>> brands = [];

  late List<dynamic> productsData;
  List<dynamic> categories = [];
  List<dynamic> products = [];
  List<int> existingCategoriesId = [];

  List<dynamic> historyForReturn = [];
  List<int> permittedProductIds = [];

  int selectedCategoryID = 23;
  int discount = 0;
  String countValueText = '1';

  Object? _value = 1;
  TextEditingController commentController = TextEditingController();

  List<double> productPrices = [];

  @override
  void initState() {
    super.initState();
    getInfo();
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

    loadDataFromSharedPreferences().then((data) {
      setState(() {
        productsData = data;
      });
      getProductsFromPrefs();
    });
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
    prefs.setString("savedOutlet", jsonEncode(widget.outlet));
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

  Future<List<dynamic>> loadDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("responseProducts");
    return data != null && data != 'Error' ? List.from(jsonDecode(data)) : [];
  }

  void processProductData(Map<String, dynamic> product) {
    double thisPrice = 0;
    if (product['counteragent_prices'] != null) {
      thisPrice = double.parse((discount != 0
              ? product['prices']
                      .where((e) => e['price_type_id'] == widget.priceTypeId)
                      .toList()[0]['price'] *
                  (100 - discount) /
                  100
              : product['prices']
                      .where((e) => e['price_type_id'] == widget.priceTypeId)
                      .toList()[0]['price'] *
                  (100 - product['discount']) /
                  100)
          .toString());

      for (int i = 0; i < product['counteragent_prices'].length; i++) {
        if (product['counteragent_prices'][i]['counteragent_id'] ==
            widget.counteragentID) {
          thisPrice = double.parse(
              product['counteragent_prices'][i]['price'].toString());
        }
      }
    } else {
      thisPrice = double.parse((discount != 0
              ? product['prices']
                      .where((e) => e['price_type_id'] == widget.priceTypeId)
                      .toList()[0]['price'] *
                  (100 - discount) /
                  100
              : product['prices']
                      .where((e) => e['price_type_id'] == widget.priceTypeId)
                      .toList()[0]['price'] *
                  (100 - product['discount']) /
                  100)
          .toString());
    }
    if (thisPrice != 0) {
      productPrices.add(thisPrice);
      products.add(product);
    }
  }

  void getProductsFromPrefs() {
    products = [];
    existingCategoriesId = [];
    productPrices = [];
    if (productsData.isNotEmpty) {
      for (int i = 0; i < productsData.length; i++) {
        existingCategoriesId.add(productsData[i]['category_id']);
        if (productsData[i]['category_id'] == selectedCategoryID) {
          if (widget.priceTypeId == 4) {
            if (productsData[i]['prices'][3]['price'] != 0) {
              processProductData(productsData[i]);
            }
          } else {
            processProductData(productsData[i]);
          }
        }
      }
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong.", style: TextStyle(fontSize: 20)),
      ));
    }
  }

  void searchAction() {
    products = [];
    productPrices = [];
    if (productsData.isNotEmpty) {
      for (int i = 0; i < productsData.length; i++) {
        if (productsData[i]['name']
            .toLowerCase()
            .contains(searchController.text.toLowerCase())) {
          processProductData(productsData[i]);
        }
      }
      setState(() {});
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
                          const Spacer(),
                          Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              StoreOrdersHistory(
                                                  widget.outletName,
                                                  widget.outletDiscount,
                                                  widget.outletId,
                                                  widget.counteragentID,
                                                  widget.counteragentName,
                                                  widget.counteragentDiscount,
                                                  widget.priceTypeId,
                                                  widget.debt,
                                                  widget.outlet,
                                                  discount)));
                                },
                                child: Container(
                                    color: Colors.yellow[700],
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: 60,
                                    child: Row(
                                      children: [
                                        const Spacer(),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: Text(
                                            'Контрагент: ${widget.counteragentName}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.33,
                                          child: Text(
                                            'Торговая точка: ${widget.outletName}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          child: Text(
                                            'Долг: ${widget.debt} тг',
                                            style:
                                                const TextStyle(fontSize: 16),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BasketPage(
                                                            widget.outletName,
                                                            widget.outletId,
                                                            widget
                                                                .counteragentID,
                                                            widget
                                                                .counteragentName,
                                                            discount,
                                                            widget.priceTypeId,
                                                            widget.debt,
                                                            widget
                                                                .outlet))).then(
                                                (_) => setState(() {}));
                                          },
                                          child: const Icon(
                                            Icons.shopping_cart_outlined,
                                            size: 40,
                                          ),
                                        ),
                                        const SizedBox(
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
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (searchController.text.length > 1) {
                                        searchAction();
                                      }
                                    },
                                    child: const Icon(
                                      Icons.search,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                      Divider(
                        color: Colors.yellow[700],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.27,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.64,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: createListOfCategories(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height * 0.72,
                            child: ListView.builder(
                              itemCount: products.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductInfoPage(
                                          widget.outletName,
                                          widget.outletId,
                                          widget.counteragentID,
                                          widget.counteragentName,
                                          widget.debt,
                                          products[index],
                                          discount != 0
                                              ? discount
                                              : products[index]['discount'],
                                          widget.priceTypeId,
                                          products,
                                          widget.outlet,
                                        ),
                                      ),
                                    ).then((_) => setState(() {}));
                                  },
                                  child: ProductListCard(
                                    products[index],
                                    widget.priceTypeId,
                                    discount,
                                    widget.counteragentID,
                                    productPrices[index],
                                    widget.outletId,
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  List<Widget> createListOfCategories() {
    List<Widget> listOfWidgets = [];

    for (int i = 0; i < brands.length; i++) {
      listOfWidgets.add(Column(
        children: <Widget>[
          ExpansionTile(
            title: Text(
              brands[i]["title"].toString(),
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              for (int j = 0; j < categories.length; j++)
                brands[i]["id"] == categories[j]["brand_id"]
                    ? existingCategoriesId.contains(categories[j]["id"])
                        ? ListTile(
                            onTap: () {
                              selectedCategoryID = categories[j]["id"];
                              getProductsFromPrefs();
                            },
                            title: Text(categories[j]["name"].toString()),
                          )
                        : Container()
                    : Container(),
            ],
          ),
        ],
      ));
    }

    return listOfWidgets;
  }

  Future<void> displayReturnCauseDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Выберите причину возврата'),
          content: SizedBox(
            height: 270,
            child: Column(
              children: [
                SizedBox(
                    height: 60,
                    child: DropdownButton(
                        value: _value,
                        items: const [
                          DropdownMenuItem(
                            child: Text("По сроку годности"),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text("По сроку годности более 10 дней"),
                            value: 2,
                          ),
                          DropdownMenuItem(
                            child: Text("Белая жидкость"),
                            value: 3,
                          ),
                          DropdownMenuItem(
                            child: Text("Блок продаж по решению ДР"),
                            value: 4,
                          ),
                          DropdownMenuItem(
                            child: Text(
                                "Возврат конечного потребителя/скрытый брак"),
                            value: 5,
                          ),
                          DropdownMenuItem(
                            child: Text("Низкие продажи"),
                            value: 6,
                          ),
                          DropdownMenuItem(
                            child: Text("Переход на договор (с ФЗ на ЮЛ)"),
                            value: 7,
                          ),
                          DropdownMenuItem(
                            child: Text(
                                "Поломка оборудования покупателя/закрытие магазина Покупателя"),
                            value: 8,
                          ),
                          DropdownMenuItem(
                            child: Text("Развакуум"),
                            value: 9,
                          ),
                          DropdownMenuItem(
                            child: Text("Прочее"),
                            value: 10,
                          )
                        ],
                        onChanged: (value) {
                          setState(() {
                            _value = value;
                            Navigator.pop(context);
                          });
                        },
                        hint: const Text("Select item"))),
                _value == 10
                    ? TextFormField(
                        controller: commentController,
                        decoration: const InputDecoration(hintText: "Причина"),
                        keyboardType: TextInputType.phone,
                        maxLength: 100,
                      )
                    : Container(),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                textStyle: const TextStyle(color: Colors.white),
              ),
              child: const Text('Отмена'),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: const TextStyle(color: Colors.white),
              ),
              child: const Text('Сохранить'),
              onPressed: () async {},
            ),
          ],
        );
      },
    );
  }

  // TODO: При необходимости нужно будет просто передать permittedProductIds и historyForReturn на ProductListCard
  void getHistoryForReturns() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('responseHistoryForReturns') != null) {
      historyForReturn =
          jsonDecode(prefs.getString('responseHistoryForReturns')!);

      for (int i = 0; i < historyForReturn.length; i++) {
        if (historyForReturn[i]['id'] == widget.outletId) {
          for (int k = 0; k < historyForReturn[i]['orders'].length; k++) {
            for (int j = 0;
                j < historyForReturn[i]['orders'][k]['baskets'].length;
                j++) {
              if (historyForReturn[i]['orders'][k]['baskets'][j]['type'] == 0) {
                permittedProductIds.add(historyForReturn[i]['orders'][k]
                    ['baskets'][j]['product_id']);
              }
            }
          }
        }
      }
    }
  }
}
