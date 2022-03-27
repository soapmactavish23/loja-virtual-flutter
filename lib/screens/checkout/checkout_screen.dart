import 'package:flutter/material.dart';
import 'package:loja_virtual/common/price_card.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/checkout_manager.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/screens/checkout/components/cpf_field.dart';
import 'package:loja_virtual/screens/checkout/components/credit_card_widget.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final CreditCard creditCard = CreditCard();

    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager!..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Pagamento'),
          centerTitle: true,
        ),
        body: Consumer<CheckoutManager>(
          builder: (_, checkoutManager, __) {
            if (checkoutManager.loading) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Processando seu pagamento...',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16),
                    )
                  ],
                ),
              );
            }
            return Form(
              key: formKey,
              child: ListView(
                children: [
                  CreditCardWidget(creditCard: creditCard),
                  const CpfField(),
                  PriceCard(
                    buttonText: 'Finalizar Pedido',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        checkoutManager.checkout(
                            creditCard: creditCard,
                            onStockFail: (e) {
                              Navigator.of(context).popUntil(
                                (route) => route.settings.name == '/cart',
                              );
                            },
                            onPayFail: (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                            onSuccess: (order) {
                              Navigator.of(context).popUntil(
                                (route) => route.settings.name == '/',
                              );
                              Navigator.pushNamed(
                                context,
                                '/confirmation',
                                arguments: order,
                              );
                            });
                      }
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
