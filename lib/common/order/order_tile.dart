import 'package:flutter/material.dart';
import 'package:loja_virtual/common/order/cancel_order_dialog.dart';
import 'package:loja_virtual/common/order/export_address_dialog.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/screens/cart/components/order_product_tile.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    Key? key,
    required this.order,
    this.showControls = false,
  }) : super(key: key);
  final Order order;
  final bool showControls;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  order.formattedId,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                Text(
                  'R\$ ${order.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              order.statusText,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color:
                    order.status == Status.canceled ? Colors.red : primaryColor,
                fontSize: 14,
              ),
            )
          ],
        ),
        children: [
          Column(
            children: order.items.map((e) {
              return OrderProductTile(
                cartProduct: e,
              );
            }).toList(),
          ),
          Visibility(
            visible: showControls && order.status != Status.canceled,
            child: SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return CancelOrderDialog(
                            order: order,
                          );
                        },
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: order.back,
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Recuar',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: order.advance,
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Avançar',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ExportAddressDialog(
                            address: order.address,
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Endereço',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
