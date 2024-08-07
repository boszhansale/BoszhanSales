import 'dart:async';
import 'dart:convert';

import 'package:boszhan_sales/components/app_bar.dart';
import 'package:boszhan_sales/services/auth_api_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // late Timer _timer;
  // int _start = 5;

  int id = 0;

  late IO.Socket socket;

  // void startTimer() {
  //   const oneSec = const Duration(seconds: 1);
  //   _timer = new Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (_start == 0) {
  //         socket.emit('position',
  //             jsonEncode({'id': 192, 'lat': 43.3077969, 'lng': 77.2193498}));
  //         print('Sended');
  //         setState(() {
  //           _start = 5;
  //         });
  //       } else {
  //         setState(() {
  //           _start--;
  //         });
  //       }
  //     },
  //   );
  // }

  Future<Position> getLocationByGeolocator() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  void getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getInt('user_id') ?? 1;
  }

  @override
  void initState() {
    checkLogIn();
    getUserId();
    setupBackgroundGeolocation();

    // emailController.text = 'sad@mail.ru';
    // passwordController.text = '123456';

    // startTimer();

    // socket = IO.io('http://boszhan.kz:3000', <String, dynamic>{
    //   'transports': ['websocket'],
    //   'autoConnect': true,
    // });
    // socket.onConnect((_) {
    //   print('connect');
    // });
    //
    // socket.on('position', (newMessage) async {
    //   Position position = await getLocationByGeolocator();
    //
    //   socket.emit(
    //       'position',
    //       jsonEncode({
    //         'id': id,
    //         'lat': position.latitude,
    //         'lng': position.longitude,
    //       }));
    // });

    // Timer.periodic(
    //   Duration(seconds: 10),
    //   (Timer timer) async {
    //     print();
    //   },
    // );

    super.initState();
  }

  void setupBackgroundGeolocation() async {
    // Инициализация настроек
    await bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 300,
      disableElasticity: true,
      stopOnTerminate: false,
      startOnBoot: true,
      debug: false,
      logLevel: bg.Config.LOG_LEVEL_VERBOSE,
    ));

    bg.BackgroundGeolocation.onLocation((bg.Location location) async {
      // print('[onLocation long] - ${location.coords.longitude}');
      // print('[onLocation lat] - ${location.coords.latitude}');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      // var id = prefs.getInt('user_id');

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.none) {
        await AuthProvider().sendLocation(
            location.coords.latitude, location.coords.longitude, []);

        if (prefs.getString("CoordsData") != null) {
          var list = jsonDecode(prefs.getString("CoordsData")!);

          var response = await AuthProvider().sendLocation(0, 0, list);

          if (response != "Error") {
            prefs.remove("CoordsData");
          }
        }
      } else {
        if (prefs.getString("CoordsData") != null) {
          var list = jsonDecode(prefs.getString("CoordsData")!);

          if (list.length > 1000) {
            list.removeAt(0);
            list.add({
              "lat": location.coords.latitude,
              "lng": location.coords.longitude,
              "created_at": DateTime.now().toString().substring(0, 19),
            });
          } else {
            list.add({
              "lat": location.coords.latitude,
              "lng": location.coords.longitude,
              "created_at": DateTime.now().toString().substring(0, 19),
            });
          }

          prefs.setString("CoordsData", jsonEncode(list));
        } else {
          var list = [];
          list.add({
            "lat": location.coords.latitude,
            "lng": location.coords.longitude,
            "created_at": DateTime.now().toString().substring(0, 19),
          });
          prefs.setString("CoordsData", jsonEncode(list));
        }
      }
    });

    bg.State state = await bg.BackgroundGeolocation.state;
    if (!state.enabled) {
      bg.BackgroundGeolocation.start();
    }
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          Image.asset(
            "assets/images/bbq_bg.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Scaffold(
              backgroundColor: Colors.transparent,
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
                            backgroundColor: Colors.yellow[700]!,
                            textStyle: const TextStyle(
                                color: Colors.black, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ]))),
        ],
      ),
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
