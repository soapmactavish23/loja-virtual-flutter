import 'dart:collection';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/models/user.dart';

class CieloPayment {
  final FirebaseFunctions functions = FirebaseFunctions.instance;

  Future<String> authorize(
      {required CreditCard creditCard,
      required num price,
      required String orderId,
      required UserModel user}) async {
    try {
      final Map<String, dynamic> dateSale = {
        'merchantOrderId': orderId,
        'amount': (price * 100).toInt(),
        'softDescriptor': 'Loja da SH',
        'installments': 1,
        'creditCard': creditCard.toMap(),
        'cpf': user.cpf.replaceAll(".", "").replaceAll("-", ""),
        'paymentType': 'CreditCard',
      };
      final response =
          await functions.httpsCallable('authorizeCreditCard').call(dateSale);

      final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

      if (data['success'] as bool) {
        return data['paymentId'] as String;
      } else {
        return Future.error(data['error']['message']);
      }
    } catch (e) {
      debugPrint('$e');
      return Future.error('Falha ao processar transação. Tente novamente');
    }
  }

  Future<void> capture(String payId) async {
    final Map<String, dynamic> captureData = {
      'payId': payId,
    };

    final HttpsCallable callable = functions.httpsCallable('captureCreditCard');

    final response = await callable.call(captureData);

    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

    if (data['success'] as bool) {
      debugPrint("Captura realizada com sucesso!");
    } else {
      return Future.error(data['error']['message']);
    }
  }

  Future<void> cancel(String payId) async {
    final Map<String, dynamic> cancelData = {
      'payId': payId,
    };

    final HttpsCallable callable = functions.httpsCallable('cancelCreditCard');

    final response = await callable.call(cancelData);

    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

    if (data['success'] as bool) {
      debugPrint("Cancelamento realizado com sucesso!");
    } else {
      return Future.error(data['error']['message']);
    }
  }
}
