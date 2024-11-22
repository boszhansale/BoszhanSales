import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:boszhan_sales/services/sales_rep_api_provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderIsolateService {
  /// Функция для обработки истории заказов в изоляте
  static void sendOrderHistoryInBackground(List<dynamic> args) async {
    final SendPort mainSendPort = args[0];
    final RootIsolateToken token = args[1];

    // Инициализация BackgroundIsolateBinaryMessenger
    BackgroundIsolateBinaryMessenger.ensureInitialized(token);

    final receivePort = ReceivePort();
    mainSendPort.send(receivePort.sendPort);

    await for (var message in receivePort) {
      if (message is List && message.length == 2) {
        final SendPort replyPort = message[0];
        final List<dynamic> orderHistory = message[1];

        try {
          bool anythingSent = false;

          for (var order in orderHistory) {
            if (order['isSended'] == false) {
              var response = await SalesRepProvider().createOrder(
                order['outletId'],
                order['mobileId'],
                order['basket'],
                order['delivery_date'],
                order['payment_type'],
                order['payment_partial'],
                order['amount'],
              );

              if (response != 'Error') {
                order['isSended'] = true;
                anythingSent = true;
              }
            }
          }

          replyPort
              .send({'success': anythingSent, 'updatedOrders': orderHistory});
        } catch (e) {
          print('Error in sending order history: $e');
          replyPort.send({'success': false, 'updatedOrders': orderHistory});
        }
      }
    }
  }

  /// Запуск изолята для отправки истории заказов
  static Future<bool> runSendOrderHistoryIsolate(
      List<dynamic> orderHistory, RootIsolateToken token) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(token);

    final receivePort = ReceivePort();
    await Isolate.spawn(
        sendOrderHistoryInBackground, [receivePort.sendPort, token]);

    final sendPort = await receivePort.first as SendPort;
    final responsePort = ReceivePort();

    sendPort.send([responsePort.sendPort, orderHistory]);

    final result = await responsePort.first as Map<String, dynamic>;

    if (result['success']) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('OrderHistory', jsonEncode(result['updatedOrders']));
    }

    return result['success'];
  }
}
