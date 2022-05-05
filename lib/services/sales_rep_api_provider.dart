import 'dart:convert';

import 'package:boszhan_sales/utils/const.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SalesRepProvider {
  String API_URL = AppConstants.baseUrl;

  Future<dynamic> getPhysicalOutlets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(API_URL + 'api/store?counteragent=0'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(response.body);

      return result;
    } else {
      final result = 'Error';
      return result;
    }
  }

  Future<dynamic> getLegalOutlets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(API_URL + 'api/store?counteragent=1'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(response.body);
      return result;
    } else {
      final result = 'Error';
      return result;
    }
  }

  Future<dynamic> getCounteragents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(API_URL + 'api/counteragent'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(response.body);
      return result;
    } else {
      final result = 'Error';
      return result;
    }
  }

  Future<dynamic> getBrends() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(API_URL + 'api/brand'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(response.body);
      return result;
    } else {
      final result = 'Error';
      return result;
    }
  }

  Future<dynamic> getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(API_URL + 'api/product'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(response.body);
      return result;
    } else {
      final result = 'Error';
      return result;
    }
  }

  Future<dynamic> createOrder(
      int storeId, String mobileId, List<dynamic> basket) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.post(
      Uri.parse(API_URL + 'api/order'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
      body: jsonEncode(<String, dynamic>{
        "store_id": storeId,
        "mobile_id": mobileId,
        "baskets": basket
      }),
    );

    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      return 'Success';
    } else {
      return 'Error';
    }
  }
}
