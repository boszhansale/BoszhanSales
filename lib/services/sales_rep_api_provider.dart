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
      Uri.parse(API_URL + 'api/salesrep/store?counteragent=0'),
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
      Uri.parse(API_URL + 'api/salesrep/store?counteragent=1'),
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
      Uri.parse(API_URL + 'api/salesrep/counteragent'),
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

  Future<dynamic> getAnalytics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(API_URL + 'api/salesrep/plan'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result;
    } else {
      final result = 'Error';
      return result;
    }
  }

  Future<dynamic> getOrdersReport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(API_URL + 'api/salesrep/order/info'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result;
    } else {
      final result = 'Error';
      return result;
    }
  }

  Future<dynamic> createOrder(int storeId, String mobileId,
      List<dynamic> basket, String deliveryDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.post(
      Uri.parse(API_URL + 'api/salesrep/order'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
      body: jsonEncode(<String, dynamic>{
        "store_id": storeId,
        "mobile_id": mobileId,
        "baskets": basket,
        deliveryDate != '' ? "delivery_date" : deliveryDate: null
      }),
    );

    if (response.statusCode == 200) {
      return 'Success';
    } else {
      return 'Error';
    }
  }

  Future<dynamic> deleteOrder(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse(API_URL + 'api/salesrep/order/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      return 'Success';
    } else {
      return 'Error';
    }
  }

  Future<dynamic> createOutlet(
      int counteragentId, String name, String phone, String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map<String, dynamic> bodyText = {
      "name": name,
      "phone": phone,
      "address": address
    };

    if (counteragentId > 0) {
      bodyText["counteragent_id"] = counteragentId;
    }

    final response = await http.post(
      Uri.parse(API_URL + 'api/salesrep/store'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
      body: jsonEncode(bodyText),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      Map<String, dynamic> result_res = {"status": "Success", "data": result};
      return result_res;
    } else {
      return {"status": "Error"};
    }
  }

  Future<dynamic> getHistoryOrders(int storeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(API_URL + 'api/salesrep/order?store_id=$storeId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result;
    } else {
      final result = 'Error';
      return result;
    }
  }

  Future<dynamic> getHistoryOrdersFromServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(API_URL + 'api/salesrep/order'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result;
    } else {
      final result = 'Error';
      return result;
    }
  }
}
