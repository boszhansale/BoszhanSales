import 'package:boszhan_sales/utils/const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductListCard extends StatefulWidget {
  const ProductListCard(this.product, this.priceTypeId, this.discount,
      this.counteragentId, this.price, this.outletId,
      {Key? key})
      : super(key: key);

  final Map<String, dynamic> product;
  final int priceTypeId;
  final int discount;
  final int counteragentId;
  final double price;
  final int outletId;

  @override
  _ProductListCardState createState() => _ProductListCardState();
}

class _ProductListCardState extends State<ProductListCard> {
  Object? _value = 1;
  TextEditingController commentController = TextEditingController();
  TextEditingController productTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productTextFieldController.text = '1.0';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            // height: 250,
            child: Row(
              children: [
                Stack(children: [
                  widget.product['images'].length > 0
                      ? CachedNetworkImage(
                          imageUrl: widget.product['images'][0]['path'],
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.width * 0.20,
                          fit: BoxFit.fitHeight,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                      : Image.asset(
                          'assets/images/placeholder.png',
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.width * 0.20,
                          fit: BoxFit.fitHeight,
                        ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: handleReturnButton,
                        child: const Text(
                          "Возврат",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.basketIDs_return
                                    .contains(widget.product['id'])
                                ? Colors.pink
                                : Colors.red,
                            side: BorderSide(
                                width: 3,
                                color: widget.product['return'] == 0
                                    ? Colors.blue
                                    : Colors.transparent)),
                      ),
                      _buildStickerImages(),
                    ],
                  )
                ]),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.32,
                        child: Text(
                          widget.product['name'],
                          style: const TextStyle(fontSize: 14),
                          // overflow:
                          //     TextOverflow.visible,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "${widget.price} тг/${widget.product['measure'] == 1 ? "шт" : "кг"}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (double.parse(
                                        productTextFieldController.text) >
                                    1) {
                                  productTextFieldController
                                      .text = (double.parse(
                                              productTextFieldController.text) -
                                          1)
                                      .toString();
                                }
                              });
                            },
                            child: const Icon(Icons.remove),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow[700]),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: TextFormField(
                            onChanged: (text) {},
                            enabled:
                                widget.product['measure'] == 1 ? false : true,
                            textAlign: TextAlign.center,
                            controller: productTextFieldController,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: SizedBox(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  productTextFieldController
                                      .text = (double.parse(
                                              productTextFieldController.text) +
                                          1)
                                      .toString();
                                });
                              },
                              child: const Icon(Icons.add),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow[700]),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: handleAddToCartButton,
                          child: const Text(
                            "В корзину",
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.basketIDs
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleAddToCartButton() {
    if (widget.product['purchase'] == 1) {
      if (!AppConstants.basketIDs.contains(widget.product['id'])) {
        setState(() {
          AppConstants.basket.add({
            'product': widget.product,
            'count': double.parse(productTextFieldController.text),
            'type': 0,
            'action': widget.product['action'],
          });
          AppConstants.basketIDs.add(widget.product['id']);
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Добавлено в корзину.", style: TextStyle(fontSize: 20)),
        ));
      } else {
        setState(() {
          var ind = AppConstants.basketIDs.indexOf(widget.product['id']);
          AppConstants.basketIDs.remove(widget.product['id']);
          AppConstants.basket.removeAt(ind);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Невозможно добавить в корзину.",
            style: TextStyle(fontSize: 20)),
      ));
    }
  }

  void handleReturnButton() {
    // TODO: PermitedProducts ---------------->
    // if (permittedProductIds
    //     .contains(widget.product['id'])) {
    if (widget.product['return'] == 1) {
      // if (!AppConstants
      //     .basketIDs_return
      //     .contains(products[i]
      //         ['id'])) {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: const Text('Выберите причину возврата'),
                content: SizedBox(
                  height: 270,
                  child: Column(
                    children: [
                      SizedBox(
                          height: 60,
                          child: DropdownButtonFormField(
                              value: _value,
                              items: const [
                                DropdownMenuItem(
                                  child: Text("По сроку годности"),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child:
                                      Text("По сроку годности более 10 дней"),
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
                                  child:
                                      Text("Переход на договор (с ФЗ на ЮЛ)"),
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
                                });
                              },
                              hint: const Text("Select item"))),
                      _value == 10
                          ? TextFormField(
                              controller: commentController,
                              decoration:
                                  const InputDecoration(hintText: "Причина"),
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
                      backgroundColor: Colors.red,
                      textStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    child: const Text('Сохранить'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_value != 10 || commentController.text != '') {
                        setState(() {
                          AppConstants.basket_return.add({
                            'product': widget.product,
                            'count':
                                double.parse(productTextFieldController.text),
                            'type': 1,
                            'causeId': _value,
                            'causeComment': commentController.text,
                          });
                          AppConstants.basketIDs_return
                              .add(widget.product['id']);
                        });

                        commentController.text = '';
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Возврат добавлен в корзину.",
                              style: TextStyle(fontSize: 20)),
                        ));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Напишите причину.",
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Невозможно добавить в корзину.",
            style: TextStyle(fontSize: 20)),
      ));
    }
    // } else {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(const SnackBar(
    //     content: Text(
    //         "Невозможно добавить в корзину так, как продукт отсутствует в истории заказов.",
    //         style: TextStyle(fontSize: 14)),
    //   ));
    // }
  }

  Widget _buildStickerImages() {
    return Row(
      children: [
        if (widget.product['hit'] == 1)
          _buildStickerImage('assets/images/sticker_hit.png'),
        if (widget.product['new'] == 1)
          _buildStickerImage('assets/images/sticker_new.png'),
        if (widget.product['action'] == 1)
          _buildStickerImage('assets/images/sticker_sale.png'),
        if (widget.product['discount_5'] == 1)
          _buildStickerImage('assets/images/sticker_5.png'),
        if (widget.product['discount_10'] == 1)
          _buildStickerImage('assets/images/sticker_10.png'),
        if (widget.product['discount_15'] == 1)
          _buildStickerImage('assets/images/sticker_15.png'),
        if (widget.product['discount_20'] == 1)
          _buildStickerImage('assets/images/sticker_20.png'),
      ],
    );
  }

  Widget _buildStickerImage(String imagePath) {
    return SizedBox(
      height: 40,
      width: 50,
      child: Image.asset(imagePath),
    );
  }
}
