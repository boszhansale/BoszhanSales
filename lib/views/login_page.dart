import 'package:boszhan_sales/components/app_bar.dart';
import 'package:boszhan_sales/services/auth_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    emailController.text = 'test@test.te';
    passwordController.text = '123456';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: buildAppBar('Авторизация')),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Image.asset("assets/images/logo.png",
                  width: MediaQuery.of(context).size.height * 0.5),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                child: TextFormField(
                  controller: emailController,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                      fillColor: Colors.yellow[700],
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow[700]!)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow[700]!)),
                      hintText: 'Введите логин',
                      helperText: 'Your login to enter the app.',
                      labelText: 'Логин',
                      labelStyle:
                          TextStyle(color: Colors.black87, fontSize: 20),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow[700]!)),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.black87,
                      ),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                      prefixText: ' ',
                      suffixStyle:
                          TextStyle(color: Colors.black, fontSize: 20)),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                child: TextFormField(
                  controller: passwordController,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                      fillColor: Colors.yellow[700],
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow[700]!)),
                      hintText: 'Пароль',
                      helperText: 'Your password to enter the app.',
                      labelText: 'Пароль',
                      labelStyle:
                          TextStyle(color: Colors.black87, fontSize: 20),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow[700]!)),
                      prefixIcon: Icon(
                        Icons.vpn_key,
                        color: Colors.black87,
                      ),
                      prefixText: '',
                      suffixStyle:
                          TextStyle(color: Colors.black, fontSize: 20)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.07,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.login, color: Colors.black),
                    label: const Text(
                      'ВОЙТИ',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      login();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.yellow[700]!,
                      textStyle:
                          const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ])));
  }

  void login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await AuthProvider()
        .login(emailController.text, passwordController.text);
    // TODO: Действие при авторизации пользователя...
    if (response != 'Error') {
      prefs.setString("token", response['token']);
      prefs.setInt("user_id", response['user']['id']);
      prefs.setString("full_name", response['user']['full_name']);
      // print(response['token']);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong.", style: TextStyle(fontSize: 20)),
      ));
    }
  }
}
