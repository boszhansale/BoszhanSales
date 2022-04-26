import 'package:flutter/material.dart';

import '../home_page.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
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
                        Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Row(
                                children: [
                                  Text(
                                    'Сумма покупок: 15 000 тг',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Spacer(),
                                  Text(
                                    'Сумма возврата: 15 000 тг',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Spacer(),
                                  Text(
                                    'Итого к оплате: 15 000 тг',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      print("Shopping!");
                                    },
                                    child: Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 40,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                color: Colors.yellow[700],
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 60,
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Text('Контрагент: Нияселение Сураншиев А.',
                                        style: TextStyle(fontSize: 16)),
                                    Spacer(),
                                    Text('Торговая точка: Нур',
                                        style: TextStyle(fontSize: 16)),
                                    Spacer(),
                                    Text('Долг: 15 000 тг',
                                        style: TextStyle(fontSize: 16)),
                                    Spacer(),
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
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
