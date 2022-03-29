import 'package:boszhan_sales/components/app_bar.dart';
import 'package:flutter/material.dart';

class JustPage extends StatefulWidget {
  // JustPage(this.product);
  // final Product product;

  @override
  _JustPageState createState() => _JustPageState();
}

class _JustPageState extends State<JustPage> {
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
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: buildAppBar('Авторизация')),
          body: Container(
              // child:
              ),
        ));
  }
}
