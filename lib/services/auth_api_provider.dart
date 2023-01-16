import 'dart:convert';

import 'package:boszhan_sales/utils/const.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider {
  String API_URL = AppConstants.baseUrl;

  Future<dynamic> login(String login, String password) async {
    final response = await http.post(
      Uri.parse(API_URL + 'api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{"login": login, "password": password}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      return result;
    } else {
      return 'Error';
    }
  }

  Future<String> sendDeviceToken(String deviceToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.post(
      Uri.parse(API_URL + 'api/device-token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token"
      },
      body: jsonEncode(<String, dynamic>{
        "device_token": deviceToken,
      }),
    );

    // print(response.body);

    if (response.statusCode == 200) {
      return 'Success';
    } else {
      return 'Error';
    }
  }

  Future<dynamic> getProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(API_URL + 'api/profile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      return result;
    } else {
      const result = 'Error';
      return result;
    }
  }

  Future<dynamic> checkApplicationVersion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(API_URL + 'api/mobile-app?type=1'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      return result;
    } else {
      var result = 'Error';
      return result;
    }
  }

  Future<String> sendLocation(double lat, double long) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.post(
      Uri.parse(API_URL + 'api/position'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token"
      },
      body: jsonEncode(<String, dynamic>{
        "lat": lat,
        "lng": long,
      }),
    );

    print(response.body);

    if (response.statusCode == 200) {
      return 'Success';
    } else {
      return 'Error';
    }
  }
}
