import 'dart:convert';

import 'package:boszhan_sales/views/order/product_info_page.dart';
import 'package:boszhan_sales/views/order/store_orders_history.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/const.dart';
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
  List<TextEditingController> productsTextFieldControllers = [];

  final searchController = TextEditingController();
  final countDialogTextFieldController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  String name = '';
  List<Map<String, Object>> brands = [];

  List<dynamic> categories = [];
  List<dynamic> products = [];
  List<int> existingCategoriesId = [];
  int selectedCategoryID = 23;
  int discount = 0;
  String countValueText = '1';

  Object? _value = 1;
  TextEditingController commentController = TextEditingController();

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

  getProductsFromPrefs() async {
    products = [];
    existingCategoriesId = [];
    productsTextFieldControllers = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("responseProducts")!;
    if (data != 'Error') {
      setState(() {
        List<dynamic> productsData = List.from(jsonDecode(data));
        for (int i = 0; i < productsData.length; i++) {
          existingCategoriesId.add(productsData[i]['category_id']);
          if (productsData[i]['category_id'] == selectedCategoryID) {
            products.add(productsData[i]);
            final controller = TextEditingController();
            controller.text = '1.0';
            productsTextFieldControllers.add(controller);
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
          if (productsData[i]['name']
              .toLowerCase()
              .contains(searchController.text.toLowerCase())) {
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
                                      Spacer(),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: Text(
                                          'Контрагент: ${widget.counteragentName}',
                                          style: TextStyle(fontSize: 16),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Spacer(),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.33,
                                        child: Text(
                                          'Торговая точка: ${widget.outletName}',
                                          style: TextStyle(fontSize: 16),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Spacer(),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Text(
                                          'Долг: ${widget.debt} тг',
                                          style: TextStyle(fontSize: 16),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
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
                                                          widget.debt,
                                                          widget.outlet))).then(
                                              (_) => setState(() {}));
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
                          width: MediaQuery.of(context).size.width * 0.27,
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
                          width: MediaQuery.of(context).size.width * 0.7,
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
                                                        widget.priceTypeId,
                                                        products,
                                                        widget.outlet)))
                                        .then((_) => setState(() {}));
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: SizedBox(
                                        height: 450,
                                        child: Column(
                                          children: [
                                            Stack(children: [
                                              CachedNetworkImage(
                                                imageUrl: products[i]['images']
                                                            .length >
                                                        0
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
                                                    0.17,
                                                fit: BoxFit.fitHeight,
                                              ),
                                              Row(
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      // if (!AppConstants
                                                      //     .basketIDs_return
                                                      //     .contains(products[i]
                                                      //         ['id'])) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return StatefulBuilder(
                                                                builder: (context,
                                                                    setState) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Выберите причину возврата'),
                                                                content:
                                                                    SizedBox(
                                                                  height: 270,
                                                                  child: Column(
                                                                    children: [
                                                                      SizedBox(
                                                                          height:
                                                                              60,
                                                                          child: DropdownButtonFormField(
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
                                                                                  child: Text("Возврат конечного потребителя/скрытый брак"),
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
                                                                                  child: Text("Поломка оборудования покупателя/закрытие магазина Покупателя"),
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
                                                                                });
                                                                              },
                                                                              hint: const Text("Select item"))),
                                                                      _value ==
                                                                              10
                                                                          ? TextFormField(
                                                                              controller: commentController,
                                                                              decoration: const InputDecoration(hintText: "Причина"),
                                                                              maxLength: 100,
                                                                            )
                                                                          : Container(),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  FlatButton(
                                                                    color: Colors
                                                                        .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    child: const Text(
                                                                        'Отмена'),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      });
                                                                    },
                                                                  ),
                                                                  FlatButton(
                                                                    color: Colors
                                                                        .green,
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    child: const Text(
                                                                        'Сохранить'),
                                                                    onPressed:
                                                                        () async {
                                                                      if (_value !=
                                                                              10 ||
                                                                          commentController.text !=
                                                                              '') {
                                                                        setState(
                                                                            () {
                                                                          AppConstants
                                                                              .basket_return
                                                                              .add({
                                                                            'product':
                                                                                products[i],
                                                                            'count':
                                                                                double.parse(productsTextFieldControllers[i].text),
                                                                            'type':
                                                                                1,
                                                                            'causeId':
                                                                                _value,
                                                                            'causeComment':
                                                                                commentController.text,
                                                                          });
                                                                          AppConstants
                                                                              .basketIDs_return
                                                                              .add(products[i]['id']);
                                                                        });

                                                                        commentController.text =
                                                                            '';
                                                                        Navigator.pop(
                                                                            context);
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(const SnackBar(
                                                                          content: Text(
                                                                              "Возврат добавлен в корзину.",
                                                                              style: TextStyle(fontSize: 20)),
                                                                        ));
                                                                      } else {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(const SnackBar(
                                                                          content: Text(
                                                                              "Напишите причину.",
                                                                              style: TextStyle(fontSize: 20)),
                                                                        ));
                                                                      }
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                          });
                                                      // } else {
                                                      //   setState(() {
                                                      //     var ind = AppConstants
                                                      //         .basketIDs_return
                                                      //         .indexOf(
                                                      //             products[i]
                                                      //                 ['id']);
                                                      //     AppConstants
                                                      //         .basketIDs_return
                                                      //         .remove(
                                                      //             products[i]
                                                      //                 ['id']);
                                                      //     AppConstants
                                                      //         .basket_return
                                                      //         .removeAt(ind);
                                                      //   });
                                                      // }
                                                    },
                                                    child: Text(
                                                      "Возврат",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                        primary: AppConstants
                                                                .basketIDs_return
                                                                .contains(
                                                                    products[i]
                                                                        ['id'])
                                                            ? Colors.pink
                                                            : Colors.red),
                                                  ),
                                                  products[i]['hit'] == 1
                                                      ? SizedBox(
                                                          height: 40,
                                                          width: 50,
                                                          child: Image.asset(
                                                              'assets/images/sticker_hit.png'),
                                                        )
                                                      : SizedBox(),
                                                  products[i]['new'] == 1
                                                      ? SizedBox(
                                                          height: 40,
                                                          width: 50,
                                                          child: Image.asset(
                                                              'assets/images/sticker_new.png'),
                                                        )
                                                      : SizedBox(),
                                                  products[i]['action'] == 1
                                                      ? SizedBox(
                                                          height: 40,
                                                          width: 50,
                                                          child: Image.asset(
                                                              'assets/images/sticker_sale.png'),
                                                        )
                                                      : SizedBox(),
                                                  products[i]['discount_5'] == 1
                                                      ? SizedBox(
                                                          height: 40,
                                                          width: 50,
                                                          child: Image.asset(
                                                              'assets/images/sticker_5.png'),
                                                        )
                                                      : SizedBox(),
                                                  products[i]['discount_10'] ==
                                                          1
                                                      ? SizedBox(
                                                          height: 40,
                                                          width: 50,
                                                          child: Image.asset(
                                                              'assets/images/sticker_10.png'),
                                                        )
                                                      : SizedBox(),
                                                  products[i]['discount_15'] ==
                                                          1
                                                      ? SizedBox(
                                                          height: 40,
                                                          width: 50,
                                                          child: Image.asset(
                                                              'assets/images/sticker_15.png'),
                                                        )
                                                      : SizedBox(),
                                                  products[i]['discount_20'] ==
                                                          1
                                                      ? SizedBox(
                                                          height: 40,
                                                          width: 50,
                                                          child: Image.asset(
                                                              'assets/images/sticker_20.png'),
                                                        )
                                                      : SizedBox(),
                                                ],
                                              )
                                            ]),
                                            Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: SizedBox(
                                                height: 47,
                                                child: Text(
                                                  products[i]['name'],
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                  // overflow:
                                                  //     TextOverflow.visible,
                                                ),
                                              ),
                                            ),
                                            // products[i]['counteragent_prices'] !=
                                            //         null
                                            //     ? products[i]
                                            //             ['counteragent_prices']
                                            //         .any((element) {
                                            //         if (element.values.contains(
                                            //             widget.counteragentID))
                                            //           return Text(
                                            //               "${element['price']} тг/${products[i]['measure'] == 1 ? "шт" : "кг"}");
                                            //       })
                                            //     :

                                            Text(
                                              "${(discount != 0 ? products[i]['prices'].where((e) => e['price_type_id'] == widget.priceTypeId).toList()[0]['price'] * (100 - discount) / 100 : products[i]['prices'].where((e) => e['price_type_id'] == widget.priceTypeId).toList()[0]['price'] * (100 - products[i]['discount']) / 100)} тг/${products[i]['measure'] == 1 ? "шт" : "кг"}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 2),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (double.parse(
                                                                productsTextFieldControllers[
                                                                        i]
                                                                    .text) >
                                                            1) {
                                                          productsTextFieldControllers[
                                                                  i]
                                                              .text = (double.parse(
                                                                      productsTextFieldControllers[
                                                                              i]
                                                                          .text) -
                                                                  1)
                                                              .toString();
                                                        }
                                                      });
                                                    },
                                                    child: Icon(Icons.remove),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: Colors
                                                                .yellow[700]),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 40,
                                                  child: TextFormField(
                                                    onChanged: (text) {
                                                      setState(() {
                                                        try {} catch (e) {
                                                          print(e);
                                                        }
                                                      });
                                                    },
                                                    enabled: products[i]
                                                                ['measure'] ==
                                                            1
                                                        ? false
                                                        : true,
                                                    textAlign: TextAlign.center,
                                                    controller:
                                                        productsTextFieldControllers[
                                                            i],
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          UnderlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 2),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        productsTextFieldControllers[
                                                                i]
                                                            .text = (double.parse(
                                                                    productsTextFieldControllers[
                                                                            i]
                                                                        .text) +
                                                                1)
                                                            .toString();
                                                      });
                                                    },
                                                    child: Icon(Icons.add),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: Colors
                                                                .yellow[700]),
                                                  ),
                                                ),
                                                ElevatedButton.icon(
                                                  onPressed: () {
                                                    if (!AppConstants.basketIDs
                                                        .contains(products[i]
                                                            ['id'])) {
                                                      // showDialog(
                                                      //     context: context,
                                                      //     builder: (context) {
                                                      //       countDialogTextFieldController
                                                      //           .text = '';
                                                      //       return AlertDialog(
                                                      //         title: Text(
                                                      //             'Введите количество:'),
                                                      //         content:
                                                      //             TextField(
                                                      //           keyboardType:
                                                      //               TextInputType
                                                      //                   .number,
                                                      //           autofocus: true,
                                                      //           focusNode:
                                                      //               _focusNode,
                                                      //           onChanged:
                                                      //               (value) {
                                                      //             setState(() {
                                                      //               countValueText =
                                                      //                   value;
                                                      //             });
                                                      //           },
                                                      //           controller:
                                                      //               countDialogTextFieldController,
                                                      //           decoration:
                                                      //               InputDecoration(
                                                      //                   hintText:
                                                      //                       "Число"),
                                                      //         ),
                                                      //         actions: <Widget>[
                                                      //           FlatButton(
                                                      //             color: Colors
                                                      //                 .green,
                                                      //             textColor:
                                                      //                 Colors
                                                      //                     .white,
                                                      //             child: Text(
                                                      //                 'OK'),
                                                      //             onPressed:
                                                      //                 () {
                                                      //               setState(
                                                      //                   () {
                                                      //                 AppConstants
                                                      //                     .basket
                                                      //                     .add({
                                                      //                   'product':
                                                      //                       products[i],
                                                      //                   'count': double.parse(countValueText ==
                                                      //                           ''
                                                      //                       ? '1'
                                                      //                       : countValueText),
                                                      //                   'type':
                                                      //                       0
                                                      //                 });
                                                      //                 AppConstants
                                                      //                     .basketIDs
                                                      //                     .add(products[i]
                                                      //                         [
                                                      //                         'id']);
                                                      //               });
                                                      //
                                                      //               Navigator.pop(
                                                      //                   context);
                                                      //             },
                                                      //           ),
                                                      //         ],
                                                      //       );
                                                      //     });

                                                      setState(() {
                                                        AppConstants.basket
                                                            .add({
                                                          'product':
                                                              products[i],
                                                          'count': double.parse(
                                                              productsTextFieldControllers[
                                                                      i]
                                                                  .text),
                                                          'type': 0
                                                        });
                                                        AppConstants.basketIDs
                                                            .add(products[i]
                                                                ['id']);
                                                      });
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                        content: Text(
                                                            "Добавлено в корзину.",
                                                            style: TextStyle(
                                                                fontSize: 20)),
                                                      ));
                                                    } else {
                                                      setState(() {
                                                        var ind = AppConstants
                                                            .basketIDs
                                                            .indexOf(products[i]
                                                                ['id']);
                                                        AppConstants.basketIDs
                                                            .remove(products[i]
                                                                ['id']);
                                                        AppConstants.basket
                                                            .removeAt(ind);
                                                      });
                                                    }
                                                  },
                                                  label: Text(
                                                    "В корзину",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  icon: Icon(
                                                    Icons
                                                        .shopping_cart_outlined,
                                                    color: Colors.black,
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: AppConstants
                                                            .basketIDs
                                                            .contains(
                                                                products[i]
                                                                    ['id'])
                                                        ? Colors.grey
                                                        : Colors.green[700],
                                                  ),
                                                ),
                                              ],
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
      // listOfWidgets.add(Text(
      //   brands[i]["title"].toString(),
      //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      // ));
      // listOfWidgets.add(Divider(
      //   color: Colors.yellow[700],
      // ));

      listOfWidgets.add(Column(
        children: <Widget>[
          ExpansionTile(
            title: Text(
              brands[i]["title"].toString(),
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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

      // for (int j = 0; j < categories.length; j++) {
      //   if (brands[i]["id"] == categories[j]["brand_id"]) {
      //     if (existingCategoriesId.contains(categories[j]["id"])) {
      //       listOfWidgets.add(Padding(
      //         padding: const EdgeInsets.fromLTRB(20, 2, 5, 2),
      //         child: SizedBox(
      //           width: MediaQuery
      //               .of(context)
      //               .size
      //               .width * 0.3,
      //           child: ElevatedButton(
      //             onPressed: () {
      //               selectedCategoryID = categories[j]["id"];
      //               getProductsFromPrefs();
      //             },
      //             style: ElevatedButton.styleFrom(primary: Colors.yellow[700]),
      //             child: Padding(
      //               padding: const EdgeInsets.all(10),
      //               child: SizedBox(
      //                 width: MediaQuery
      //                     .of(context)
      //                     .size
      //                     .width * 0.3,
      //                 child: Text(
      //                   categories[j]["name"].toString(),
      //                   textAlign: TextAlign.left,
      //                   style: TextStyle(
      //                       color: Colors.black,
      //                       fontSize: 20,
      //                       fontWeight: FontWeight.normal),
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ));
      //     }
      //   }
      // }
      // listOfWidgets.add(Divider(
      //   color: Colors.black,
      // ));
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
                          decoration:
                              const InputDecoration(hintText: "Причина"),
                          keyboardType: TextInputType.phone,
                          maxLength: 100,
                        )
                      : Container(),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('Отмена'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('Сохранить'),
                onPressed: () async {},
              ),
            ],
          );
        });
  }
}
