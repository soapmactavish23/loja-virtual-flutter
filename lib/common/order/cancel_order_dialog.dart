import 'package:flutter/material.dart';

import 'package:loja_virtual/models/order.dart';

class CancelOrderDialog extends StatelessWidget {
  final Order order;
  const CancelOrderDialog({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancelar ${order.formattedId}?'),
      content:
          const Text('Esta ação não poderá ser desfeita! deseja prosseguir?'),
      actions: [
        TextButton(
          onPressed: () {
            order.cancel();
            Navigator.pop(context);
          },
          child: const Text(
            'Cancelar Pedido',
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    );
  }
}
