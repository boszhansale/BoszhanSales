// import 'dart:convert';

import 'package:boszhan_sales/components/app_bar.dart';
import 'package:boszhan_sales/services/auth_api_provider.dart';
// import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';

//
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
//     as bg;

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
    // emailController.text = 'sad@mail.ru';
    // passwordController.text = '123456';

    // bg.BackgroundGeolocation.onMotionChange((bg.Location location) async {
    //   print('[motionchange long] - ${location.coords.longitude}');
    //   print('[motionchange lat] - ${location.coords.latitude}');
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   var connectivityResult = await (Connectivity().checkConnectivity());
    //   if (connectivityResult == ConnectivityResult.mobile) {
    //     AuthProvider()
    //         .sendLocation(location.coords.latitude, location.coords.longitude);
    //     if (prefs.getString("CoordsData") != null) {
    //       var list = jsonDecode(prefs.getString("CoordsData")!);
    //       for (int i = 0; i < list.length; i++) {
    //         if (list[i]["isSended"] == false) {
    //           var response =
    //               AuthProvider().sendLocation(list[i]['lat'], list[i]['long']);
    //           if (response != "Error") {
    //             list[i]["isSended"] = true;
    //           }
    //         }
    //       }
    //       prefs.setString("CoordsData", jsonEncode(list));
    //     }
    //   } else if (connectivityResult == ConnectivityResult.wifi) {
    //     AuthProvider()
    //         .sendLocation(location.coords.latitude, location.coords.longitude);
    //     if (prefs.getString("CoordsData") != null) {
    //       var list = jsonDecode(prefs.getString("CoordsData")!);
    //       for (int i = 0; i < list.length; i++) {
    //         if (list[i]["isSended"] == false) {
    //           var response =
    //               AuthProvider().sendLocation(list[i]['lat'], list[i]['long']);
    //           if (response != "Error") {
    //             list[i]["isSended"] = true;
    //           }
    //         }
    //       }
    //       prefs.setString("CoordsData", jsonEncode(list));
    //     }
    //   } else {
    //     if (prefs.getString("CoordsData") != null) {
    //       var list = jsonDecode(prefs.getString("CoordsData")!);
    //       if (list.length > 50) {
    //         list.removeAt(0);
    //         list.add({
    //           "lat": location.coords.latitude,
    //           "long": location.coords.longitude,
    //           "isSended": false
    //         });
    //       } else {
    //         list.add({
    //           "lat": location.coords.latitude,
    //           "long": location.coords.longitude,
    //           "isSended": false
    //         });
    //       }
    //       prefs.setString("CoordsData", jsonEncode(list));
    //     } else {
    //       var list = [];
    //       if (list.length > 50) {
    //         list.removeAt(0);
    //         list.add({
    //           "lat": location.coords.latitude,
    //           "long": location.coords.longitude,
    //           "isSended": false
    //         });
    //       } else {
    //         list.add({
    //           "lat": location.coords.latitude,
    //           "long": location.coords.longitude,
    //           "isSended": false
    //         });
    //       }
    //       prefs.setString("CoordsData", jsonEncode(list));
    //     }
    //   }
    // });
    //
    // bg.BackgroundGeolocation.ready(bg.Config(
    //         desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
    //         distanceFilter: 100.0,
    //         stopOnTerminate: false,
    //         startOnBoot: true,
    //         debug: false,
    //         logLevel: bg.Config.LOG_LEVEL_VERBOSE))
    //     .then((bg.State state) {
    //   if (!state.enabled) {
    //     ////
    //     // 3.  Start the plugin.
    //     //
    //     bg.BackgroundGeolocation.start();
    //   }
    // });

    checkLogIn();
    super.initState();
  }

  void checkLogIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLogedIn') == true) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/images/bbq_bg.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
            backgroundColor: Colors.white.withOpacity(0.85),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 10),
                    child: TextFormField(
                      controller: emailController,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      decoration: InputDecoration(
                          fillColor: Colors.yellow[700],
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.yellow[700]!)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.yellow[700]!)),
                          hintText: 'Введите логин',
                          helperText: 'Your login to enter the app.',
                          labelText: 'Логин',
                          labelStyle:
                              TextStyle(color: Colors.black87, fontSize: 20),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.yellow[700]!)),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black87,
                          ),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 20),
                          prefixText: ' ',
                          suffixStyle:
                              TextStyle(color: Colors.black, fontSize: 20)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 10),
                    child: TextFormField(
                      controller: passwordController,
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      decoration: InputDecoration(
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 20),
                          fillColor: Colors.yellow[700],
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.yellow[700]!)),
                          hintText: 'Пароль',
                          helperText: 'Your password to enter the app.',
                          labelText: 'Пароль',
                          labelStyle:
                              TextStyle(color: Colors.black87, fontSize: 20),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.yellow[700]!)),
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
                          textStyle: const TextStyle(
                              color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ]))),
      ],
    );
  }

  void login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await AuthProvider()
        .login(emailController.text, passwordController.text);
    // TODO: Действие при авторизации пользователя...
    if (response != 'Error') {
      prefs.setString("token", response['access_token']);
      prefs.setInt("user_id", response['user']['id']);
      prefs.setString("full_name", response['user']['name']);
      if (response['user']['phone'] != null) {
        prefs.setString("user_phone", response['user']['phone']);
      }

      prefs.setString("driver_name", response['user']['driver']['name']);
      if (response['user']['driver']['phone'] != null) {
        prefs.setString("driver_phone", response['user']['driver']['phone']);
      }
      prefs.setBool("isLogedIn", true);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Неправильный логин или пароль.",
            style: TextStyle(fontSize: 20)),
      ));
    }
  }
}
