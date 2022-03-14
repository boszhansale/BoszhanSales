import 'package:flutter/material.dart';

Widget buildAppBar(String title) {
  return PreferredSize(
      child: AppBar(
          elevation: 0,
          centerTitle: true,
          title:
              Text(title, style: TextStyle(color: Colors.black, fontSize: 20)),
          automaticallyImplyLeading: true,
          backgroundColor: Colors.yellow[700]!,
          shadowColor: Colors.white,
          bottomOpacity: 1,
          iconTheme: IconThemeData(color: Colors.black)),
      preferredSize: Size.fromHeight(60));
}
