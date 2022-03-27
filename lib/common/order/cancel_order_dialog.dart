import 'package:flutter/material.dart';

import 'package:loja_virtual/models/order.dart';

class CancelOrderDialog extends StatefulWidget {
  final Order order;
  const CancelOrderDialog({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<CancelOrderDialog> createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends State<CancelOrderDialog> {
  bool loading = false;
  String error = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        title: Text('Cancelar ${widget.order.formattedId}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loading
                  ? 'Cancelando'
                  : 'Esta ação não poderá ser desfeita! deseja prosseguir?',
            ),
            if (error != "")
              Text(
                error,
                style: const TextStyle(
                  color: Colors.red,
                ),
              )
          ],
        ),
        actions: [
          TextButton(
            onPressed: !loading
                ? () {
                    Navigator.pop(context);
                  }
                : null,
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: !loading
                ? () async {
                    setState(() {
                      loading = true;
                    });
                    try {
                      await widget.order.cancel();
                      Navigator.pop(context);
                    } catch (e) {
                      setState(() {
                        loading = false;
                        error = e.toString();
                      });
                    }
                  }
                : null,
            child: const Text(
              'Cancelar Pedido',
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }
}
