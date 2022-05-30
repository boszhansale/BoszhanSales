import 'dart:convert';

import 'package:boszhan_sales/components/app_bar.dart';
import 'package:boszhan_sales/services/sales_rep_api_provider.dart';
import 'package:boszhan_sales/views/order/product_list_page.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';

class AddNewOutlet extends StatefulWidget {
  const AddNewOutlet(this.counteragentId, this.counteragentDiscount,
      this.priceTypeId, this.debt);

  final int counteragentId;
  final int counteragentDiscount;
  final int priceTypeId;
  final String debt;

  @override
  _AddNewOutletState createState() => _AddNewOutletState();
}

class _AddNewOutletState extends State<AddNewOutlet> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController binController = TextEditingController();
  TextEditingController addressController = TextEditingController();

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
                        Text(
                          'Добавить торговую точку'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 34),
                        ),
                        Spacer(),
                      ],
                    ),
                    Divider(
                      color: Colors.yellow[700],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
                      child: TextFormField(
                        controller: nameController,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                        decoration: InputDecoration(
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 20),
                            fillColor: Colors.yellow[700],
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.yellow[700]!)),
                            hintText: 'Название',
                            labelText: 'Название',
                            labelStyle:
                                TextStyle(color: Colors.black87, fontSize: 20),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.yellow[700]!)),
                            prefixIcon: Icon(
                              Icons.info,
                              color: Colors.black87,
                            ),
                            prefixText: '',
                            suffixStyle:
                                TextStyle(color: Colors.black, fontSize: 20)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                      child: TextFormField(
                        controller: phoneController,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                        decoration: InputDecoration(
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 20),
                            fillColor: Colors.yellow[700],
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.yellow[700]!)),
                            hintText: 'Номер телефона',
                            labelText: 'Номер телефона',
                            labelStyle:
                                TextStyle(color: Colors.black87, fontSize: 20),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.yellow[700]!)),
                            prefixIcon: Icon(
                              Icons.info,
                              color: Colors.black87,
                            ),
                            prefixText: '',
                            suffixStyle:
                                TextStyle(color: Colors.black, fontSize: 20)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                      child: TextFormField(
                        controller: binController,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                        decoration: InputDecoration(
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 20),
                            fillColor: Colors.yellow[700],
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.yellow[700]!)),
                            hintText: 'БИН',
                            labelText: 'БИН',
                            labelStyle:
                                TextStyle(color: Colors.black87, fontSize: 20),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.yellow[700]!)),
                            prefixIcon: Icon(
                              Icons.info,
                              color: Colors.black87,
                            ),
                            prefixText: '',
                            suffixStyle:
                                TextStyle(color: Colors.black, fontSize: 20)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                      child: TextFormField(
                        controller: addressController,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                        decoration: InputDecoration(
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 20),
                            fillColor: Colors.yellow[700],
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.yellow[700]!)),
                            hintText: 'Адрес',
                            labelText: 'Адрес',
                            labelStyle:
                                TextStyle(color: Colors.black87, fontSize: 20),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.yellow[700]!)),
                            prefixIcon: Icon(
                              Icons.info,
                              color: Colors.black87,
                            ),
                            prefixText: '',
                            suffixStyle:
                                TextStyle(color: Colors.black, fontSize: 20)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.07,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.create, color: Colors.black),
                          label: const Text(
                            'СОЗДАТЬ',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            createOutletAction();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.yellow[700]!,
                            textStyle: const TextStyle(
                                color: Colors.black, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void createOutletAction() async {
    if (nameController.text.length > 1 &&
        phoneController.text.length > 1 &&
        binController.text.length > 1 &&
        addressController.text.length > 1) {
      Map<String, dynamic> response = {};
      SalesRepProvider()
          .createOutlet(widget.counteragentId, nameController.text,
              phoneController.text, binController.text, addressController.text)
          .then((value) => response = value)
          .whenComplete(() {
        print(response);
        if (response['status'] == "Success") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductListPage(
                      response['data']['name'],
                      response['data']['discount'],
                      response['data']['id'],
                      widget.counteragentId,
                      response['data']['salesrep']['name'],
                      widget.counteragentDiscount,
                      widget.priceTypeId,
                      widget.debt)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text("Something went wrong.", style: TextStyle(fontSize: 20)),
          ));
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Заполните все поля.", style: TextStyle(fontSize: 20)),
      ));
    }
  }
}
