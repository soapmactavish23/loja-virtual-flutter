import 'package:cloud_functions/cloud_functions.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/models/user.dart';

class CieloPayment {
  final FirebaseFunctions functions = FirebaseFunctions.instance;

  void authorize(
      {required CreditCard creditCard,
      required num price,
      required String orderId,
      required UserModel user}) async {
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

    final data = Map<String, dynamic>.from(response.data);
  }
}