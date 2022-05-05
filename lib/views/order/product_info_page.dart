import 'package:boszhan_sales/utils/const.dart';
import 'package:boszhan_sales/views/basket/basket_page.dart';
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
      this.priceTypeId);
  final String outletName;
  final int outletId;
  final int counteragentID;
  final String counteragentName;
  final String debt;
  final Map<String, dynamic> product;
  final int discount;
  final priceTypeId;
  @override
  _ProductInfoPageState createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  String mainImageURL = '';
  int indexOfImage = 0;
  @override
  void initState() {
    mainImageURL = widget.product['images'][indexOfImage]['path'];
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
                                Text('Контрагент: ${widget.counteragentName}',
                                    style: TextStyle(fontSize: 16)),
                                Spacer(),
                                Text('Торговая точка: ${widget.outletName}',
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
                                            builder: (context) => BasketPage(
                                                widget.outletName,
                                                widget.outletId,
                                                widget.counteragentID,
                                                widget.counteragentName,
                                                widget.discount,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (!AppConstants.basketIDs
                                      .contains(widget.product['id'])) {
                                    AppConstants.basket.add({
                                      'product': widget.product,
                                      'count': 1,
                                      'type': 0
                                    });
                                    AppConstants.basketIDs
                                        .add(widget.product['id']);
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
                                    primary: Colors.red),
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  widget.product['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Text(
                                    "${widget.product['prices'][widget.priceTypeId - 1]['price']} тг/шт",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Text(
                                    "${widget.product['prices'].where((e) => e['price_type_id'] == widget.priceTypeId).toList()[0]['price'] * (100 - widget.discount) / 100} тг/шт",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (!AppConstants.basketIDs
                                    .contains(widget.product['id'])) {
                                  AppConstants.basket.add(
                                      {'product': widget.product, 'count': 1});
                                  AppConstants.basketIDs
                                      .add(widget.product['id']);
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
                                primary: Colors.green[700],
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: MediaQuery.of(context).size.height * 0.68,
                        child: Image.network(
                          mainImageURL,
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.width * 0.19,
                          fit: BoxFit.fitHeight,
                        ),
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
                                      previousImage();
                                    },
                                    child: const Icon(
                                      Icons.arrow_left,
                                      color: Colors.black,
                                      size: 55,
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
                                      nextImage();
                                    },
                                    child: const Icon(
                                      Icons.arrow_right,
                                      color: Colors.black,
                                      size: 55,
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
        mainImageURL = widget.product['images'][indexOfImage]['path'];
      });
    }
  }

  void nextImage() {
    if (indexOfImage < widget.product['images'].length - 1) {
      setState(() {
        indexOfImage += 1;
        mainImageURL = widget.product['images'][indexOfImage]['path'];
      });
    }
  }
}