import 'package:boszhan_sales/utils/const.dart';
import 'package:boszhan_sales/views/basket/basket_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';

class ProductInfoPage extends StatefulWidget {
  const ProductInfoPage(
      this.outletName,
      this.outletId,
      this.counteragentID,
      this.counteragentName,
      this.debt,
      this.product,
      this.discount,
      this.priceTypeId,
      this.listProducts);

  final String outletName;
  final int outletId;
  final int counteragentID;
  final String counteragentName;
  final String debt;
  final Map<String, dynamic> product;
  final int discount;
  final priceTypeId;
  final List<dynamic> listProducts;

  @override
  _ProductInfoPageState createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  TransformationController controller = TransformationController();
  final countDialogTextFieldController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  String velocity = "VELOCITY";
  String mainImageURL = '';
  int indexOfImage = 0;
  Map<String, dynamic> thisProduct = {};
  int indexOfProduct = 0;
  String countValueText = '1';

  @override
  void initState() {
    mainImageURL = widget.product['images'].length > 0
        ? widget.product['images'][indexOfImage]['path']
        : "https://xn--90aha1bhcc.xn--p1ai/img/placeholder.png";
    thisProduct = widget.product;
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
                  child: Column(children: [
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
                        Container(
                            color: Colors.yellow[700],
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 60,
                            child: Row(
                              children: [
                                Spacer(),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: Text(
                                      'Контрагент: ${widget.counteragentName}',
                                      style: TextStyle(fontSize: 16)),
                                ),
                                Spacer(),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.33,
                                  child: Text(
                                      'Торговая точка: ${widget.outletName}',
                                      style: TextStyle(fontSize: 16)),
                                ),
                                Spacer(),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: Text('Долг: ${widget.debt} тг',
                                      style: TextStyle(fontSize: 16)),
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
                                                        widget.counteragentName,
                                                        widget.discount,
                                                        widget.priceTypeId,
                                                        widget.debt)))
                                        .whenComplete(() => setState(() {}));
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
                      ],
                    ),
                    Spacer(),
                  ],
                ),
                Divider(
                  color: Colors.yellow[700],
                ),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.64,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 0),
                                    child: Icon(
                                      Icons.menu,
                                      size: 44,
                                    ),
                                  ),
                                ),
                                widget.product['hit'] == 1
                                    ? SizedBox(
                                        width: 60,
                                        height: 45,
                                        child: Image.asset(
                                            'assets/images/sticker_hit.png'),
                                      )
                                    : SizedBox(),
                                widget.product['new'] == 1
                                    ? SizedBox(
                                        width: 60,
                                        height: 45,
                                        child: Image.asset(
                                            'assets/images/sticker_new.png'),
                                      )
                                    : SizedBox(),
                                widget.product['action'] == 1
                                    ? SizedBox(
                                        width: 60,
                                        height: 45,
                                        child: Image.asset(
                                            'assets/images/sticker_sale.png'),
                                      )
                                    : SizedBox(),
                                widget.product['discount_5'] == 1
                                    ? SizedBox(
                                        width: 60,
                                        height: 45,
                                        child: Image.asset(
                                            'assets/images/sticker_5.png'),
                                      )
                                    : SizedBox(),
                                widget.product['discount_10'] == 1
                                    ? SizedBox(
                                        width: 60,
                                        height: 45,
                                        child: Image.asset(
                                            'assets/images/sticker_10.png'),
                                      )
                                    : SizedBox(),
                                widget.product['discount_15'] == 1
                                    ? SizedBox(
                                        width: 60,
                                        height: 45,
                                        child: Image.asset(
                                            'assets/images/sticker_15.png'),
                                      )
                                    : SizedBox(),
                                widget.product['discount_20'] == 1
                                    ? SizedBox(
                                        width: 60,
                                        height: 45,
                                        child: Image.asset(
                                            'assets/images/sticker_20.png'),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (!AppConstants.basketIDs_return
                                      .contains(thisProduct['id'])) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          countDialogTextFieldController.text =
                                              '';
                                          return AlertDialog(
                                            title: Text('Введите количество:'),
                                            content: TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              focusNode: _focusNode,
                                              autofocus: true,
                                              onChanged: (value) {
                                                setState(() {
                                                  countValueText = value;
                                                });
                                              },
                                              controller:
                                                  countDialogTextFieldController,
                                              decoration: InputDecoration(
                                                  hintText: "Число"),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                color: Colors.green,
                                                textColor: Colors.white,
                                                child: Text('OK'),
                                                onPressed: () {
                                                  setState(() {
                                                    AppConstants.basket_return
                                                        .add({
                                                      'product': thisProduct,
                                                      'count': double.parse(
                                                          countValueText == ''
                                                              ? '1'
                                                              : countValueText),
                                                      'type': 1
                                                    });
                                                    AppConstants
                                                        .basketIDs_return
                                                        .add(thisProduct['id']);
                                                  });

                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  } else {
                                    setState(() {
                                      var ind = AppConstants.basketIDs_return
                                          .indexOf(thisProduct['id']);
                                      AppConstants.basketIDs_return
                                          .remove(thisProduct['id']);
                                      AppConstants.basket_return.removeAt(ind);
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "Возврат",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: AppConstants.basketIDs_return
                                            .contains(thisProduct['id'])
                                        ? Colors.grey
                                        : Colors.red),
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  thisProduct['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                widget.discount != 0
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Text(
                                          "${thisProduct['prices'][widget.priceTypeId - 1]['price']} тг/${thisProduct['measure'] == 1 ? "шт" : "кг"}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    : SizedBox(),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Text(
                                    "${thisProduct['prices'].where((e) => e['price_type_id'] == widget.priceTypeId).toList()[0]['price'] * (100 - widget.discount) / 100} тг/${thisProduct['measure'] == 1 ? "шт" : "кг"}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                widget.discount == 0 ? Spacer() : SizedBox(),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (!AppConstants.basketIDs
                                    .contains(thisProduct['id'])) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        countDialogTextFieldController.text =
                                            '';
                                        return AlertDialog(
                                          title: Text('Введите количество:'),
                                          content: TextField(
                                            keyboardType: TextInputType.number,
                                            focusNode: _focusNode,
                                            autofocus: true,
                                            onChanged: (value) {
                                              setState(() {
                                                countValueText = value;
                                              });
                                            },
                                            controller:
                                                countDialogTextFieldController,
                                            decoration: InputDecoration(
                                                hintText: "Число"),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              color: Colors.green,
                                              textColor: Colors.white,
                                              child: Text('OK'),
                                              onPressed: () {
                                                setState(() {
                                                  AppConstants.basket.add({
                                                    'product': thisProduct,
                                                    'count': double.parse(
                                                        countValueText == ''
                                                            ? '1'
                                                            : countValueText),
                                                    'type': 0
                                                  });
                                                  AppConstants.basketIDs
                                                      .add(thisProduct['id']);
                                                });

                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                } else {
                                  setState(() {
                                    var ind = AppConstants.basketIDs
                                        .indexOf(thisProduct['id']);
                                    AppConstants.basketIDs
                                        .remove(thisProduct['id']);
                                    AppConstants.basket.removeAt(ind);
                                  });
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
                                        .contains(thisProduct['id'])
                                    ? Colors.grey
                                    : Colors.green[700],
                                minimumSize: const Size.fromHeight(50), // NEW
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Stack(
                    children: [
                      InteractiveViewer(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.65,
                          height: MediaQuery.of(context).size.height * 0.68,
                          child: CachedNetworkImage(
                            imageUrl: mainImageURL,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.19,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        transformationController: controller,
                        boundaryMargin: EdgeInsets.all(5.0),
                        // onInteractionEnd: (ScaleEndDetails endDetails) {
                        //   // print(endDetails);
                        //   // print(endDetails.velocity);
                        //   controller.value = Matrix4.identity();
                        //   setState(() {
                        //     velocity = endDetails.velocity.toString();
                        //   });
                        // },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Row(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.64,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      previousProduct();
                                    },
                                    child: const Icon(
                                      Icons.arrow_left,
                                      color: Colors.black,
                                      size: 35,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.64,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      nextProduct();
                                    },
                                    child: const Icon(
                                      Icons.arrow_right,
                                      color: Colors.black,
                                      size: 35,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ])
              ])),
            ),
          ],
        ));
  }

  void previousImage() {
    if (indexOfImage > 0) {
      setState(() {
        indexOfImage -= 1;
        mainImageURL = thisProduct['images'][indexOfImage]['path'];
      });
    }
  }

  void nextImage() {
    if (indexOfImage < thisProduct['images'].length - 1) {
      setState(() {
        indexOfImage += 1;
        mainImageURL = thisProduct['images'][indexOfImage]['path'];
      });
    }
  }

  void previousProduct() {
    if (indexOfProduct > 0) {
      setState(() {
        indexOfProduct -= 1;
        thisProduct = widget.listProducts[indexOfProduct];
        indexOfImage = 0;

        mainImageURL = thisProduct['images'].length > 0
            ? thisProduct['images'][indexOfImage]['path']
            : "https://xn--90aha1bhcc.xn--p1ai/img/placeholder.png";
      });
    }
  }

  void nextProduct() {
    if (indexOfProduct < widget.listProducts.length - 1) {
      setState(() {
        indexOfProduct += 1;
        thisProduct = widget.listProducts[indexOfProduct];
        indexOfImage = 0;
        mainImageURL = thisProduct['images'].length > 0
            ? thisProduct['images'][indexOfImage]['path']
            : "https://xn--90aha1bhcc.xn--p1ai/img/placeholder.png";
      });
    }
  }
}
