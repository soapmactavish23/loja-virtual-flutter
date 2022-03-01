import 'package:flutter/material.dart';
import 'package:loja_virtual/common/price_card.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/checkout_manager.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
            return ListView(children: [
              PriceCard(
                buttonText: 'Finalizar Pedido',
                onPressed: () {
                  checkoutManager.checkout(
                    onStockFail: (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('$e'),
                        backgroundColor: Colors.red,
                      ));
                      Navigator.popUntil(context, (route) => route.settings.name == '/cart');
                    },
                  );
                },
              )
            ]);
          },
        ),
      ),
    );
  }
}
