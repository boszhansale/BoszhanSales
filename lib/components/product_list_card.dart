import 'dart:convert';

import 'package:boszhan_sales/utils/const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductListCard extends StatefulWidget {
  ProductListCard(this.product, this.priceTypeId, this.discount,
      this.counteragentId, this.page, this.price, this.outletId);

  final Map<String, dynamic> product;
  final int priceTypeId;
  final int discount;
  final int counteragentId;
  final Widget page;
  final double price;
  final int outletId;

  @override
  _ProductListCardState createState() => _ProductListCardState();
}

class _ProductListCardState extends State<ProductListCard> {
  Object? _value = 1;
  TextEditingController commentController = TextEditingController();
  TextEditingController productTextFieldController = TextEditingController();
  List<dynamic> historyForReturn = [];
  List<int> permittedProductIds = [];

  // double price = 0;

  @override
  void initState() {
    // getPrice();
    getHistoryForReturns();
    productTextFieldController.text = '1.0';
    super.initState();
  }

  getPrice() {
    setState(() {
      // if (widget.product['counteragent_prices'] != null) {
      //   price = widget.discount != 0
      //       ? widget.product['prices']
      //               .where((e) => e['price_type_id'] == widget.priceTypeId)
      //               .toList()[0]['price'] *
      //           (100 - widget.discount) /
      //           100
      //       : widget.product['prices']
      //               .where((e) => e['price_type_id'] == widget.priceTypeId)
      //               .toList()[0]['price'] *
      //           (100 - widget.product['discount']) /
      //           100;
      //
      //   for (int i = 0; i < widget.product['counteragent_prices'].length; i++) {
      //     if (widget.product['counteragent_prices'][i]['counteragent_id'] ==
      //         widget.counteragentId) {
      //       price = widget.product['counteragent_prices'][i]['price'];
      //     }
      //   }
      // } else {
      //   price = widget.discount != 0
      //       ? widget.product['prices']
      //               .where((e) => e['price_type_id'] == widget.priceTypeId)
      //               .toList()[0]['price'] *
      //           (100 - widget.discount) /
      //           100
      //       : widget.product['prices']
      //               .where((e) => e['price_type_id'] == widget.priceTypeId)
      //               .toList()[0]['price'] *
      //           (100 - widget.product['discount']) /
      //           100;
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => widget.page)).then(
          (_) => setState(() {}),
        );
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
                    imageUrl: widget.product['images'].length > 0
                        ? widget.product['images'][0]['path']
                        : "https://xn--90aha1bhcc.xn--p1ai/img/placeholder.png",
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.17,
                    fit: BoxFit.fitHeight,
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          print(permittedProductIds);
                          if (permittedProductIds
                              .contains(widget.product['id'])) {
                            if (widget.product['return'] == 1) {
                              // if (!AppConstants
                              //     .basketIDs_return
                              //     .contains(products[i]
                              //         ['id'])) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Выберите причину возврата'),
                                        content: SizedBox(
                                          height: 270,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                  height: 60,
                                                  child:
                                                      DropdownButtonFormField(
                                                          value: _value,
                                                          items: const [
                                                            DropdownMenuItem(
                                                              child: Text(
                                                                  "По сроку годности"),
                                                              value: 1,
                                                            ),
                                                            DropdownMenuItem(
                                                              child: Text(
                                                                  "По сроку годности более 10 дней"),
                                                              value: 2,
                                                            ),
                                                            DropdownMenuItem(
                                                              child: Text(
                                                                  "Белая жидкость"),
                                                              value: 3,
                                                            ),
                                                            DropdownMenuItem(
                                                              child: Text(
                                                                  "Блок продаж по решению ДР"),
                                                              value: 4,
                                                            ),
                                                            DropdownMenuItem(
                                                              child: Text(
                                                                  "Возврат конечного потребителя/скрытый брак"),
                                                              value: 5,
                                                            ),
                                                            DropdownMenuItem(
                                                              child: Text(
                                                                  "Низкие продажи"),
                                                              value: 6,
                                                            ),
                                                            DropdownMenuItem(
                                                              child: Text(
                                                                  "Переход на договор (с ФЗ на ЮЛ)"),
                                                              value: 7,
                                                            ),
                                                            DropdownMenuItem(
                                                              child: Text(
                                                                  "Поломка оборудования покупателя/закрытие магазина Покупателя"),
                                                              value: 8,
                                                            ),
                                                            DropdownMenuItem(
                                                              child: Text(
                                                                  "Развакуум"),
                                                              value: 9,
                                                            ),
                                                            DropdownMenuItem(
                                                              child: Text(
                                                                  "Прочее"),
                                                              value: 10,
                                                            )
                                                          ],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _value = value;
                                                            });
                                                          },
                                                          hint: const Text(
                                                              "Select item"))),
                                              _value == 10
                                                  ? TextFormField(
                                                      controller:
                                                          commentController,
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                                  "Причина"),
                                                      maxLength: 100,
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            child: const Text('Отмена'),
                                            onPressed: () {
                                              setState(() {
                                                Navigator.pop(context);
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red,
                                              textStyle: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          ElevatedButton(
                                            child: const Text('Сохранить'),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.green,
                                              textStyle: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () async {
                                              if (_value != 10 ||
                                                  commentController.text !=
                                                      '') {
                                                setState(() {
                                                  AppConstants.basket_return
                                                      .add({
                                                    'product': widget.product,
                                                    'count': double.parse(
                                                        productTextFieldController
                                                            .text),
                                                    'type': 1,
                                                    'causeId': _value,
                                                    'causeComment':
                                                        commentController.text,
                                                  });
                                                  AppConstants.basketIDs_return
                                                      .add(
                                                          widget.product['id']);
                                                });

                                                commentController.text = '';
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Text(
                                                      "Возврат добавлен в корзину.",
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                ));
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Text(
                                                      "Напишите причину.",
                                                      style: TextStyle(
                                                          fontSize: 20)),
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
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Невозможно добавить в корзину.",
                                    style: TextStyle(fontSize: 20)),
                              ));
                            }
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  "Невозможно добавить в корзину так, как продукт отсутствует в истории заказов.",
                                  style: TextStyle(fontSize: 14)),
                            ));
                          }
                        },
                        child: Text(
                          "Возврат",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: AppConstants.basketIDs_return
                                    .contains(widget.product['id'])
                                ? Colors.pink
                                : Colors.red,
                            side: BorderSide(
                                width: 3,
                                color: widget.product['return'] == 0
                                    ? Colors.blue
                                    : Colors.transparent)),
                      ),
                      widget.product['hit'] == 1
                          ? SizedBox(
                              height: 40,
                              width: 50,
                              child:
                                  Image.asset('assets/images/sticker_hit.png'),
                            )
                          : SizedBox(),
                      widget.product['new'] == 1
                          ? SizedBox(
                              height: 40,
                              width: 50,
                              child:
                                  Image.asset('assets/images/sticker_new.png'),
                            )
                          : SizedBox(),
                      widget.product['action'] == 1
                          ? SizedBox(
                              height: 40,
                              width: 50,
                              child:
                                  Image.asset('assets/images/sticker_sale.png'),
                            )
                          : SizedBox(),
                      widget.product['discount_5'] == 1
                          ? SizedBox(
                              height: 40,
                              width: 50,
                              child: Image.asset('assets/images/sticker_5.png'),
                            )
                          : SizedBox(),
                      widget.product['discount_10'] == 1
                          ? SizedBox(
                              height: 40,
                              width: 50,
                              child:
                                  Image.asset('assets/images/sticker_10.png'),
                            )
                          : SizedBox(),
                      widget.product['discount_15'] == 1
                          ? SizedBox(
                              height: 40,
                              width: 50,
                              child:
                                  Image.asset('assets/images/sticker_15.png'),
                            )
                          : SizedBox(),
                      widget.product['discount_20'] == 1
                          ? SizedBox(
                              height: 40,
                              width: 50,
                              child:
                                  Image.asset('assets/images/sticker_20.png'),
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
                      widget.product['name'],
                      style: TextStyle(fontSize: 14),
                      // overflow:
                      //     TextOverflow.visible,
                    ),
                  ),
                ),
                Text(
                  "${widget.price} тг/${widget.product['measure'] == 1 ? "шт" : "кг"}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (double.parse(productTextFieldController.text) >
                                1) {
                              productTextFieldController.text = (double.parse(
                                          productTextFieldController.text) -
                                      1)
                                  .toString();
                            }
                          });
                        },
                        child: Icon(Icons.remove),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.yellow[700]),
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
                        enabled: widget.product['measure'] == 1 ? false : true,
                        textAlign: TextAlign.center,
                        controller: productTextFieldController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            productTextFieldController.text =
                                (double.parse(productTextFieldController.text) +
                                        1)
                                    .toString();
                          });
                        },
                        child: Icon(Icons.add),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.yellow[700]),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (widget.product['purchase'] == 1) {
                          if (!AppConstants.basketIDs
                              .contains(widget.product['id'])) {
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
                              AppConstants.basket.add({
                                'product': widget.product,
                                'count': double.parse(
                                    productTextFieldController.text),
                                'type': 0
                              });
                              AppConstants.basketIDs.add(widget.product['id']);
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Добавлено в корзину.",
                                  style: TextStyle(fontSize: 20)),
                            ));
                          } else {
                            setState(() {
                              var ind = AppConstants.basketIDs
                                  .indexOf(widget.product['id']);
                              AppConstants.basketIDs
                                  .remove(widget.product['id']);
                              AppConstants.basket.removeAt(ind);
                            });
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Невозможно добавить в корзину.",
                                style: TextStyle(fontSize: 20)),
                          ));
                        }
                      },
                      label: Text(
                        "В корзину",
                        style: TextStyle(color: Colors.black),
                      ),
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black,
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: AppConstants.basketIDs
                                  .contains(widget.product['id'])
                              ? Colors.grey
                              : Colors.green[700],
                          side: BorderSide(
                              width: 3,
                              color: widget.product['purchase'] == 0
                                  ? Colors.red
                                  : Colors.transparent)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

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
