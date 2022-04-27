import 'package:flutter/material.dart';

import '../home_page.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Map<String, Object>> brands = [
    {
      "id": 1,
      "title": "Возвраты",
    },
    {"id": 2, "title": "Первомайские деликатесы"},
    {"id": 3, "title": "Народные колбасы"},
  ];

  List<Map<String, Object>> categories = [
    {"id": 1, "brandId": 1, "title": "Колбаски гриль"},
    {"id": 2, "brandId": 1, "title": "Стейки"},
    {"id": 3, "brandId": 1, "title": "Фарши"},
    {"id": 4, "brandId": 1, "title": "Субпродукты"},
    {"id": 5, "brandId": 2, "title": "Варенные колбасы"},
    {"id": 6, "brandId": 2, "title": "Копченные колбасы"},
    {"id": 7, "brandId": 2, "title": "Ветчины"},
    {"id": 8, "brandId": 2, "title": "Сырокопченные колбасы"},
    {"id": 9, "brandId": 2, "title": "Субпродуктовые колбасы"},
    {"id": 10, "brandId": 2, "title": "Сосискиб сардельки"},
    {"id": 11, "brandId": 2, "title": "Деликатесы"},
    {"id": 12, "brandId": 2, "title": "Полуфабрикаты"},
    {"id": 13, "brandId": 3, "title": "Варенные колбасы"},
    {"id": 14, "brandId": 3, "title": "Копченные колбасы"},
    {"id": 15, "brandId": 3, "title": "Ветчины"},
    {"id": 16, "brandId": 3, "title": "Субпродуктовые колбасы"},
    {"id": 17, "brandId": 3, "title": "Сосиски, сардельки"},
    {"id": 18, "brandId": 3, "title": "Деликатесы"},
    {"id": 19, "brandId": 3, "title": "Полуфабрикаты"},
  ];

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
                              for (int i = 0; i < 12; i++)
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SizedBox(
                                      height: 450,
                                      child: Column(
                                        children: [
                                          Image.network(
                                            'https://arbuz.kz/image/f/254211-sosiski_pervomaiskie_delikatesy_delikatesnye_iz_govyadiny_460_g.jpg?w=260&h=260&_c=1649574980',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.19,
                                            fit: BoxFit.fitWidth,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Text(
                                              "Сосиски 'Тигренек'",
                                              style: TextStyle(fontSize: 16),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            "1250 тг/шт",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              print("Add to basket!");
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
    for (int i = 1; i < 4; i++) {
      if (i == brands[i - 1]["id"]) {
        listOfWidgets.add(Text(
          brands[i - 1]["title"].toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ));
        listOfWidgets.add(Divider(
          color: Colors.yellow[700],
        ));
      }
      for (int j = 0; j < 19; j++) {
        if (i == categories[j]["brandId"]) {
          listOfWidgets.add(Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 5, 2),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                onPressed: () {
                  print(categories[j]["id"]);
                },
                style: ElevatedButton.styleFrom(primary: Colors.yellow[700]),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      categories[j]["title"].toString(),
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
